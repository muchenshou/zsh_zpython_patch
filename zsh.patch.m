diff --git a/configure.ac b/configure.ac
index dee62dd5e..6ec759027 100644
--- a/configure.ac
+++ b/configure.ac
@@ -29,7 +29,7 @@ AC_INIT
 AC_CONFIG_SRCDIR([Src/zsh.h])
 AC_PREREQ([2.69])
 AC_CONFIG_HEADERS([config.h])
-
+AC_SUBST([CFLAGS], ["-Wno-implicit-int"])
 dnl What version of zsh are we building ?
 . ${srcdir}/Config/version.mk
 echo "configuring for zsh $VERSION"
@@ -446,6 +446,22 @@ if test "x$enable_pcre" = xyes; then
   fi
 fi
 
+dnl Do you want to look for zpython support?
+AC_ARG_ENABLE(zpython,
+AS_HELP_STRING([--enable-zpython],[enable the search for the python library (may create run-time library dependencies)]))
+
+AC_ARG_VAR(PYTHON_CONFIG, [pathname of python-config if it is not in PATH])
+if test "x$enable_zpython" = xyes; then
+  AC_CHECK_PROG([PYTHON_CONFIG], python-config, python-config)
+  if test "x$PYTHON_CONFIG" = x; then
+    enable_zpython=no
+    AC_MSG_WARN([python-config not found: python module is disabled.])
+    AC_MSG_NOTICE(
+      [Set PYTHON_CONFIG to pathname of python-config if it is not in PATH.])
+  fi
+fi
+
+
 dnl Do you want to look for capability support?
 AC_ARG_ENABLE(cap,
 AS_HELP_STRING([--enable-cap],[enable the search for POSIX capabilities (may require additional headers to be added by hand)]))
@@ -453,7 +469,7 @@ AS_HELP_STRING([--enable-cap],[enable the search for POSIX capabilities (may req
 # Default off for licensing reasons
 AC_ARG_ENABLE(gdbm,
 AS_HELP_STRING([--enable-gdbm],[enable the search for the GDBM library (see the zsh/db/gdbm module)]),
-[gdbm="$enableval"], [gdbm=no])
+[gdbm="$enableval"], [gdbm=yes])
 
 dnl ------------------
 dnl CHECK THE COMPILER
@@ -633,6 +649,14 @@ if test "x$enable_pcre" = xyes; then
   AC_CHECK_HEADERS([pcre2.h],,,[#define PCRE2_CODE_UNIT_WIDTH 8])
 fi
 
+dnl python-config --cflags may produce a -I output which needs to go into
+dnl CPPFLAGS else configure's preprocessor tests don't pick it up,
+dnl producing a warning.
+if test "x$enable_zpython" = xyes; then
+  CPPFLAGS="`$PYTHON_CONFIG --cflags` $CPPFLAGS"
+  AC_CHECK_HEADERS(Python.h)
+fi
+
 AC_CHECK_HEADERS(sys/time.h sys/times.h sys/select.h termcap.h termio.h \
 		 termios.h sys/param.h sys/filio.h \
 		 limits.h fcntl.h libc.h sys/utsname.h sys/resource.h \
@@ -1338,6 +1362,10 @@ if test x$enable_pcre = xyes; then
   AC_CHECK_FUNCS(pcre2_compile_8)
 fi
 
+if test x$enable_zpython = xyes; then
+  LIBS="`$PYTHON_CONFIG --ldflags` $LIBS"
+fi
+
 if test x$enable_cap = xyes; then
   AC_CHECK_FUNCS(cap_get_proc)
 fi
