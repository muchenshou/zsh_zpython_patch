#!/bin/bash
src_dir="zsh-5.9"
[[ -f "$src_dir" ]] || [[ -d "$src_dir" ]] && read -p "yes or no:" r && [[ $r = y||Y* ]] && rm -rf "$src_dir"
git clone https://git.code.sf.net/p/zsh/code.git "$src_dir"
(cd "$src_dir" && git checkout 73d317384c9225e46d66444f93b46f0fbe7084ef)

# curl "https://www.zsh.org/pub/zsh-5.9.tar.xz" > zsh-5.9.tar.xz
# tar -xf zsh-5.9.tar.xz
# mv "zsh-5.9" "$src_dir"
(
    cd "$src_dir"
    git checkout .
    patch < ../zsh.patch.m
    patch < ../zsh.patch.n
    patch < ../zsh.patch.zjson
    if ! python-config --help; then
        echo "Not found python-config"
        exit -1
    fi
    brew_zsh=/usr/local/Cellar/zsh
    ./Util/preconfig
    ./configure \
    --prefix="${brew_zsh}"/5.9 \
    --enable-fndir="${brew_zsh}"/5.9/share/zsh/functions \
    --enable-scriptdir="${brew_zsh}"/5.9/share/zsh/scripts \
    --enable-runhelpdir="${brew_zsh}"/5.9/share/zsh/help \
    --enable-site-fndir=/usr/local/share/zsh/site-functions \
    --enable-site-scriptdir=/usr/local/share/zsh/site-scripts \
    --enable-etcdir=/etc \
    --enable-cap \
    --enable-maildir-support \
    --enable-multibyte \
    --enable-pcre \
    --enable-gdbm \
    --enable-zsh-secure-free \
    --enable-unicode9 \
    --with-tcsetpgrp \
    --enable-zpython \
    DL_EXT=so
    
    make install -j4
)