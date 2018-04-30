#!/usr/bin/env bash
cd /usr/local/lib
wget http://www.antlr.org/download/antlr-4.6-complete.jar
export CLASSPATH=".:/usr/local/lib/antlr-4.6-complete.jar:$CLASSPATH"
cd -
pip3 install -r requirements.txt
cd ./src
java -jar /usr/local/lib/antlr-4.6-complete.jar -Dlanguage=Python3 LLexer.g4 LParser.g4

# CORRECT

# python main.py ./tests/correct/prog.l
# dot -Tps out/prog.dot -o out/prog.ps

# python main.py ./tests/correct/arithm.l
# dot -Tps out/arithm.dot -o out/arithm.ps

# python main.py ./tests/correct/arithm2.l
# dot -Tps out/arithm2.dot -o out/arithm2.ps

# python main.py ./tests/correct/funcs.l
# dot -Tps out/funcs.dot -o out/funcs.ps

# INCORRECT

# python main.py ./tests/incorrect/empty.l

# python main.py ./tests/incorrect/open_paren.l

# python main.py ./tests/incorrect/read_without_paren.l


