BASE=$(pwd)
(
    cd zsh-5.9
    # ./Util/preconfig
    # ./configure
    cd Src && make modules
)
(

    cd zsh-5.9/Src/Modules
    DEPS=$(pkg-config --cflags --libs --static json-c)
    gcc -c $DEPS -I. -I../../Src -I../../Src -I../../Src/Zle -I. -I/Users/szt/.pyenv/versions/2.7.18/include/python2.7 -I/Users/szt/.pyenv/versions/2.7.18/include/python2.7 -I/usr/local/Cellar/json-c/0.18/include -I/usr/local/Cellar/json-c/0.18/include/json-c -fno-strict-aliasing -I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include -DNDEBUG -g -fwrapv -O3 -Wall -Wstrict-prototypes  -I/usr/local/Cellar/pcre/8.45/include -DHAVE_CONFIG_H -DMODULE -Wno-implicit-int -fno-common -o zjson..o zjson.c
    gcc -Wl,-x  -bundle -flat_namespace -undefined suppress -o zjson.so   zjson..o  ${DEPS}  -L/Users/szt/.pyenv/versions/2.7.18/lib/python2.7/config -L/usr/local/Cellar/json-c/0.18/lib -ljson-c -lpython2.7 -lintl -framework CoreFoundation -u _PyMac_Error -lgdbm -L/usr/local/Cellar/pcre/8.45/lib -lpcre -liconv -ldl -lncurses -lm  -lc
    cp ./zjson.so /usr/local/Cellar/zsh/5.9/lib/zsh/5.9/zsh/zjson.so
    zsh $BASE/test_zjson.sh
)