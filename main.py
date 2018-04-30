import argparse
import sys
import os
from antlr4 import tree, FileStream, CommonTokenStream, ParseTreeWalker, error

from src.LLexer import LLexer
from src.LParser import LParser
from src.LParserListener import LParserListener


class ExitErrorListener(error.ErrorListener.ErrorListener):
    def syntaxError(self, recognizer, offendingSymbol, line, charPositionInLine, msg, exc):
        print('Syntax error at ({line}:{char}): {msg}'.format(line=line - 1,
                                                              char=charPositionInLine,
                                                              msg=msg))
        sys.exit(1)


class NamingTreeListener(LParserListener):
    def __init__(self):
        super().__init__()
        self.counter = 0

    def enterEveryRule(self, ctx):
        ctx.dot_name = "n" + str(self.counter)
        self.counter += 1


class DotTreeListener(LParserListener):
    def __init__(self):
        super().__init__()
        self.adjacency = dict()
        self.vert_labling = dict()

    def enterEveryRule(self, ctx):
        if ctx.stop is None:
            return

        self.adjacency[ctx.dot_name] = list()
        if ctx.parentCtx:
            self.adjacency[ctx.parentCtx.dot_name].append(ctx.dot_name)

        rule_name = tree.Trees.Trees.getNodeText(ctx, recog=ctx.parser)
        cls = ctx.__class__.__name__
        rule_name = '{} ({})'.format(rule_name, cls[:-len('Context')])

        start_idx = ctx.start.start
        stop_idx = ctx.stop.stop
        stream = ctx.start.getInputStream()
        original_program_text = stream.getText(start_idx, stop_idx)

        st_line, st_col = ctx.start.line - 1, ctx.start.column
        end_line, end_col = ctx.stop.line - 1, ctx.stop.column

        node_label = '{} [({}:{}), ({}:{})]'.format(rule_name, st_line, st_col, end_line, end_col)
        node_label += '\\n{}'.format(original_program_text.replace('\r', '\\n')
                                     .replace('\n', '\n')
                                     .replace('\\', '\\\\')
                                     .replace('"', '\\"'))

        self.vert_labling[ctx.dot_name] = '{} [ label = "{}" ]; \n'.format(ctx.dot_name, node_label)

    def write_to_dotfile(self, filename):
        with open(filename, 'w') as f:
            print("digraph g {", file=f)
            for node, node_lable in self.vert_labling.items():
                print(node_lable, file=f)

            for node, childs in self.adjacency.items():
                for child in childs:
                    print(node + " -> " + child + ";", file=f)
            print("}", file=f)


if __name__ == '__main__':
    argparser = argparse.ArgumentParser()
    argparser.add_argument('input_file', help='L-language file')
    args = argparser.parse_args()
    instream = FileStream(args.input_file)

    l_lexer = LLexer(instream)
    l_lexer.removeErrorListeners()
    l_lexer.addErrorListener(ExitErrorListener())

    com_token_stream = CommonTokenStream(l_lexer)
    l_parser = LParser(com_token_stream)
    l_parser.removeErrorListeners()
    l_parser.addErrorListener(ExitErrorListener())

    parse_tree = l_parser.program()

    walker = ParseTreeWalker()

    naming_listener = NamingTreeListener()
    walker.walk(naming_listener, parse_tree)

    dot_listener = DotTreeListener()
    walker.walk(dot_listener, parse_tree)

    out_file = "./out/" + os.path.basename(args.input_file).replace(".l", ".dot")
    dot_listener.write_to_dotfile(out_file)
