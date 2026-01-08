zmodload zsh/zjson
name=some
key="key1"
value="value1"
zjson[$name]='{}'
zjson[$name.$key]="\"$value\""
echo $zjson[some]
# mapfile[some.aa.bb.cc]='{"a": "{\"b\":\"c\"}"}'
# echo $mapfile[some.aa.bb.cc.dd]
#mapfile[aa.a]='{"oo":"ll"}'
#echo $mapfile[aa]
# echo ${(kv)mapfile}
