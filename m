From: Nikita Kozlov <nikita@elyzion.net>
Subject: mdadm 3.2.3 segfault when trying to reassemble a device
Date: Tue, 14 Feb 2012 19:51:54 +0100
Message-ID: <4F3AAD4A.3060109@elyzion.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I think I have found a bug in mdadm 3.2.3 (not present in 3.2.2).
When I'm trying to assemble my raid0 device I'm having a segfault 
because the param char *devname is set to null and then used in fnmatch.
I have a small backtrace and I'm also attaching a small patch which 
solved my issue.

arrakis mdadm-3.2.3 # gdb ./mdadm
GNU gdb (Gentoo 7.4 p1) 7.4
[...]
Reading symbols from /tmp/mdadm/mdadm-3.2.3/mdadm...done.
(gdb) r  --assemble /dev/md3 /dev/sda4 /dev/sdb4
Starting program: /tmp/mdadm/mdadm-3.2.3/mdadm --assemble /dev/md3 /dev/sda4
/dev/sdb4

Program received signal SIGSEGV, Segmentation fault.
0x00007ffff7acd961 in __strlen_sse2 () from /lib64/libc.so.6
(gdb) bt
#0  0x00007ffff7acd961 in __strlen_sse2 () from /lib64/libc.so.6
#1  0x00007ffff7b0088d in fnmatch () from /lib64/libc.so.6
#2  0x000000000040a11d in match_oneof (devices=0x6983b9 ",/dev/sdb2",
devname=0x0) at config.c:958
#3  0x000000000040a4d3 in conf_match (st=0x6aba90, info=0x6ac930, devname=0x0,
verbose=0, rvp=0x0) at config.c:1049
#4  0x000000000046135b in RebuildMap () at mapfile.c:434
#5  0x0000000000460b08 in map_read (melp=0x7fffffffcdc8) at mapfile.c:201
#6  0x0000000000460cdb in map_update (mpp=0x0, devnum=3,
metadata=0x7fffffffd49c "1.2", uuid=0x7fffffffd3f8, path=0x7fffffffcf90
"/dev/md3") at mapfile.c:241
#7  0x000000000041912f in Assemble (st=0x698320, mddev=0x7fffffffcf90
"/dev/md3", ident=0x7fffffffdac0, devlist=0x698030, backup_file=0x0,
invalid_backup=0, readonly=0, runstop=0, update=0x0, homehost=0x7fffffffd9b0
"arrakis", require_homehost=1, verbose=0, force=0, freeze_reshape=0) at
Assemble.c:1230
#8  0x000000000040648b in main (argc=5, argv=0x7fffffffde88) at mdadm.c:1258



A simple but maybe not optimal patch could be (the test from 3.2.2):
diff --git a/config.c b/config.c
index 6027b2f..d8f48e1 100644
--- a/config.c
+++ b/config.c
@@ -1045,7 +1045,7 @@ struct mddev_ident *conf_match(struct supertype *st,
                                         array_list->devname);
                         continue;
                 }
-               if (array_list->devices &&
+               if (array_list->devices && devname &&
                     !match_oneof(array_list->devices, devname)) {
                         if (verbose >= 2 && array_list->devname)
                                 fprintf(stderr, Name


Regards,

Nikita
