From: Mike Hardy <mhardy@h3c.com>
Subject: mdadm source rpm build error + command-line parsing error + resync
 reporting problem
Date: Thu, 08 Dec 2005 21:11:59 -0800
Message-ID: <4399121F.9060906@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I got this when I attempted to rpmbuild -ba mdadm.spec:
------------------------

In file included from super0.c:31:
/usr/include/asm/byteorder.h:6:2: error: #warning using private kernel
header; include <endian.h> instead!
make: *** [super0.o] Error 1
error: Bad exit status from /var/tmp/rpm-tmp.64960 (%build)


RPM build errors:
    Bad exit status from /var/tmp/rpm-tmp.64960 (%build)
[root@istanbul ~]# uname -a
Linux istanbul.tacitknowledge.com 2.6.14-1.1644_FC4smp #1 SMP Sun Nov 27
03:39:31 EST 2005 i686 i686 i386 GNU/Linux
[root@istanbul ~]# cat /etc/redhat-release
Fedora Core release 4 (Stentz)

--------------------------

This occurs for the files super0.c, super1.c, and bitmap.c.

If you remove the -Werror flag from the Makefile, it works though it
still generates warnings.

I installed the new version of mdadm in the hopes that it would improve
the situation with the grow mode commandline parsing, which was broken
in the 1.11 that FC4 ships. Alas, it did not:

[root@istanbul redhat]# mdadm -G /dev/md1
mdadm: no changes to --grow
[root@istanbul redhat]# mdadm -G /dev/md1 --size
mdadm: option `--size' requires an argument

The man page indicates that if I don't set the size, it will grow to
fill the smallest device in the array. It's definitely not doing that...

I read mdadm.c, and see that 'max' is the argument that mdadm is looking
for, but the man page isn't mentioning.

Finally, and I think was reported once before, but I don't recall a
resolution for it, I got this once I specified that it grow to maximum size:

[root@istanbul mdadm-2.1]# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 sdb1[0] sda1[1]
      98176 blocks [2/2] [UU]

md1 : active raid1 sdb3[0] sda3[1]
      70573440 blocks [2/2] [UU]
      [=========>...........]  resync = 49.9% (35220224/70573440)
finish=0.2min speed=2515730K/sec

md0 : active raid1 sdb2[0] sda2[1]
      977856 blocks [2/2] [UU]

unused devices: <none>

This is a dual Xeon (so it looks like a 4-CPU machine). Not sure what's
causing that though...

-Mike
