From: Gabriele Tozzi <gabriele@tozzi.eu>
Subject: Kernel bug?
Date: Sat, 04 Apr 2009 17:07:40 +0200
Message-ID: <49D777BC.4090009@tozzi.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I guess I've found a kernel bug: I get an oops when rebuilding a raid1
array (/dev/md5) on an SMP system. The md5_resync process then hangs.

This is my current configuration:

transylvania:~# uname -a
Linux transylvania 2.6.29.1transylvania #1 SMP Sat Apr 4 04:08:40 CEST
2009 i686 GNU/Linux

transylvania:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md1 : active raid1 sdb2[1] sda2[0]
      1003968 blocks [2/2] [UU]

md2 : active raid1 sdb5[1] sda5[0]
      2008000 blocks [2/2] [UU]

md3 : active raid1 sdb6[1] sda6[0]
      1003904 blocks [2/2] [UU]

md4 : active raid1 sdb7[1] sda7[0]
      505920 blocks [2/2] [UU]

md6 : active linear sdb8[1] sda8[0]
      25719808 blocks 4k rounding

md5 : active raid1 sdd2[1] sdc2[3]
      97843776 blocks [3/1] [_U_]
      [===>.................]  recovery = 15.3% (15018752/97843776)
finish=35.2min speed=39182K/sec

md0 : active raid1 sdb1[1] sda1[0]
      40064 blocks [2/2] [UU]

unused devices: <none>

When the system hangs, i receive these messages:

transylvania:~#
Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel: Oops: 0000 [#1] SMP

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel: last sysfs file:
/sys/devices/pci0000:00/0000:00:04.2/usb2/2-2/2-2:1.0/host5/target5:0:0/5:0:0:0/type

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel: Process md5_resync (pid: 6969, ti=dcbba000
task=d59c72a0 task.ti=dcbba000)

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel: Stack:

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  df3e2080 0ba9f480 00011210 df3e209c c0163dfc 00000010
00000078 00000000

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  c019f38f 00000000 0ba9f480 00000000 0ba9f480 00000000
dcbbbe78 c04a29fd

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel: Call Trace:

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  [<c04a2753>] r1buf_pool_alloc+0x11c/0x164

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  [<c0163dfc>] mempool_alloc+0x27/0xcb

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  [<c019f38f>] bio_add_page+0x28/0x2e

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  [<c04a29fd>] sync_request+0x1fd/0x5f2

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  [<c01374ba>] __wake_up+0x29/0x39

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  [<c04b5028>] md_do_sync+0x6d4/0xb60

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  [<c013976d>] set_next_entity+0x29/0x51

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  [<c013b884>] try_to_wake_up+0x127/0x130

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  [<c04b58b0>] md_thread+0xdd/0xf4

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  [<c0137445>] complete+0x28/0x36

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  [<c04b57d3>] md_thread+0x0/0xf4

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  [<c014e857>] kthread+0x38/0x5d

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  [<c014e81f>] kthread+0x0/0x5d

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel:  [<c011d8a3>] kernel_thread_helper+0x7/0x10

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel: Code: 14 10 8b 02 89 4c 82 08 40 83 f8 0e 89 02 75 07
89 d0 e8 06 fe ff ff 89 d8 50 9d 90 8d b4 26 00 00 00 00 5b c3 55 57 56
53 89 c3 <8b> 00 f6 c4 60 74 23 f6 c4 40 74 03 8b 5b 0c 8d 43 04 f0 ff 08

Message from syslogd@localhost at Sat Apr  4 16:51:17 2009 ...
localhost kernel: EIP: [<c0168f1d>] put_page+0x6/0xdd SS:ESP 0068:dcbbbdd8

transylvania:~#

Please include my address in replies 'cause I'm not subscribed to this
list. Thank you.

Gabriele Tozzi
