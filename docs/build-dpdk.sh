cd dpdk-git
make config T=x86_64-native-linuxapp-gcc
make install T=x86_64-native-linuxapp-gcc


# for odp-dpdk

sudo apt-get install libpcap-dev


This has to be done only once:
    cd <dpdk-dir>
    make config T=x86_64-native-linuxapp-gcc O=x86_64-native-linuxapp-gcc

Set CONFIG_RTE_BUILD_COMBINE_LIBS=y and CONFIG_RTE_BUILD_SHARED_LIB=n in
./x86_64-native-linuxapp-gcc/.config file:
    cd <dpdk-dir>/x86_64-native-linuxapp-gcc
    sed -ri 's,(CONFIG_RTE_BUILD_COMBINE_LIBS=).*,\1y,' .config

Note: dynamic linking does not work with DPDK v1.7.1, there is a workaround
though but until then it's better to disable shared libs:
    sed -ri 's,(CONFIG_RTE_BUILD_SHARED_LIB=).*,\1n,' .config

Note: to use odp-dpdk without DPDK supported NIC's enable pcap pmd:
    sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_PCAP=).*,\1y,' .config

Note: if non-intel SFP's are used in IXGBE, then:
    sed -ri 's,(CONFIG_RTE_LIBRTE_IXGBE_ALLOW_UNSUPPORTED_SFP=).*,\1y,' .config

Now return to parent directory and build DPDK
    cd ..

make install T=x86_64-native-linuxapp-gcc EXTRA_CFLAGS="-fPIC"

# build odp-dpdk
./configure --with-platform=linux-dpdk --with-sdk-install-path=/home/os/chy/dpdk-git/x86_64-native-linuxapp-gcc --prefix=/home/os/chy/odp-dpdk/install
make
make install

# some problem
# build odp-dpdk/test/performance
Change Makefile 
LDADD = $(PRE_LDADD) $(LIB)/libodphelper-dpdk.la $(LIB)/libodp-dpdk.la /home/os/chy/dpdk-git/lib/libdune/lib/libdune.a


os@os-1 ~/chy/odp-dpdk (dpdk-2.2*) $ git status        
On branch dpdk-2.2
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   example/Makefile.inc
	modified:   helper/test/Makefile.am
	modified:   test/Makefile.inc




# for ofp
修改了configure.ac

diff --git a/configure.ac b/configure.ac
index ebd98ac..51cb50b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -142,26 +142,27 @@ CPPFLAGS="$AM_CPPFLAGS $CPPFLAGS"
 
 function check_odp {
         AC_CHECK_LIB(odp, odp_packet_alloc, [],
-            [AC_MSG_ERROR(["This package needs OpenDataPlane (libodp.a) installed"])])
+            [AC_MSG_ERROR(["This package needs OpenDataPlane (libodp-dpdk.a) installed"])])
         AC_CHECK_HEADERS([odp.h], [],
             [AC_MSG_FAILURE(["Can't find ODP headers"])])
 }
 
-PKG_CHECK_MODULES([ODP], [libodp >= 1.7], [ODP_VERSION=107],
-    [PKG_CHECK_MODULES([ODP], [libodp >= 1.6], [ODP_VERSION=106],
-    [PKG_CHECK_MODULES([ODP], [libodp >= 1.5], [ODP_VERSION=105],
-    [PKG_CHECK_MODULES([ODP], [libodp >= 1.4], [ODP_VERSION=104],
-    [PKG_CHECK_MODULES([ODP], [libodp >= 1.3], [ODP_VERSION=103],
-    [PKG_CHECK_MODULES([ODP], [libodp >= 1.2], [ODP_VERSION=102],
-    [PKG_CHECK_MODULES([ODP], [libodp >= 1.1], [ODP_VERSION=101],
-    [PKG_CHECK_MODULES([ODP], [libodp >= 1.0], [ODP_VERSION=100],
-    check_odp)])])])])])])])
+PKG_CHECK_MODULES([ODP], [libodp-dpdk >= 1.8], [ODP_VERSION=108],
+    [PKG_CHECK_MODULES([ODP], [libodp-dpdk >= 1.7], [ODP_VERSION=107],
+    [PKG_CHECK_MODULES([ODP], [libodp-dpdk >= 1.6], [ODP_VERSION=106],
+    [PKG_CHECK_MODULES([ODP], [libodp-dpdk >= 1.5], [ODP_VERSION=105],
+    [PKG_CHECK_MODULES([ODP], [libodp-dpdk >= 1.4], [ODP_VERSION=104],
+    [PKG_CHECK_MODULES([ODP], [libodp-dpdk >= 1.3], [ODP_VERSION=103],
+    [PKG_CHECK_MODULES([ODP], [libodp-dpdk >= 1.2], [ODP_VERSION=102],
+    [PKG_CHECK_MODULES([ODP], [libodp-dpdk >= 1.1], [ODP_VERSION=101],
+    [PKG_CHECK_MODULES([ODP], [libodp-dpdk >= 1.0], [ODP_VERSION=100],
+    check_odp)])])])])])])])])
 
 # prepending lib to the files to link
 if [[ "${ODP_VERSION}" -gt 101 ]]; then
-LIBS="-lodp -lodphelper $LIBS -ldl"
+LIBS="-lodp-dpdk -lodphelper-dpdk $LIBS /home/os/chy/dpdk-git/lib/libdune/lib/libdune.a -ldl"
 else
-LIBS="-lodp $LIBS -ldl"
+LIBS="-lodp-dpdk $LIBS -ldl"


