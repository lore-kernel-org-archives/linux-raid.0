From: =?ISO-8859-2?Q?Marcin_Miros=B3aw?= <marcin@mejor.pl>
Subject: mdadm-3.1.1 segfaults when mdadm -G -Z
Date: Sun, 10 Jan 2010 13:13:46 +0100
Message-ID: <4B49C47A.9060800@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I tried to grow array size (i resized /dev/sdc5-> resync->remove
/dev/sda6 -> resize /dev/sda6 -> resync-> curent situation )
and i got segfault:

# cat /proc/mdstat
md6 : active raid1 sdc5[1](W) sda7[0]
      125001664 blocks [2/2] [UU]
      bitmap: 16/239 pages [64KB], 256KB chunk

# gdb /sbin/mdadm
[...]
<http://bugs.gentoo.org/>...
Reading symbols from
/var/tmp/portage/sys-fs/mdadm-3.1.1/work/mdadm-3.1.1/mdadm...done.
(gdb) run  -G -Z /dev/md6
Starting program:
/var/tmp/portage/sys-fs/mdadm-3.1.1/work/mdadm-3.1.1/mdadm -G -Z /dev/md6

Program received signal SIGSEGV, Segmentation fault.
0xb7f067f8 in strcmp () from /lib/libc.so.6
(gdb) bt
#0  0xb7f067f8 in strcmp () from /lib/libc.so.6
#1  0x0804b70b in main (argc=4, argv=0xbffff3f4) at mdadm.c:408
(gdb)

$  uname -r
2.6.32-gentoo-r1

May i get any suggestions?
Regards
