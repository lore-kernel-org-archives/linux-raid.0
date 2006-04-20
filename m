From: majek <majekreiser@forest.one.pl>
Subject: raid 5 growing
Date: Thu, 20 Apr 2006 20:08:03 +0200
Message-ID: <4447CE03.6040403@forest.one.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.

I am testing adding device to raid5 and I have some questiones.

How can I intrepret this line from dmesg (after growing):
ioctl32(mdadm:3762): Unknown cmd fd(3) cmd(90000915){10} arg(ffffa758) on /dev/md0

What this means:
Filesystem "md0": Disabling barriers, not supported by the underlying device


And i have another question, not connected directly to raid.
When I run "xfs_growfs" I get this errors:
xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument
xfs_growfs: XFS_IOC_FSGEOMETRY xfsctl failed: Invalid argument
And in dmesg:
ioctl32(xfs_growfs:4024): Unknown cmd fd(3) cmd(806c5864){00} arg(ffffcb20) on /mnt/test

Thanks for help.

(custom kernel 2.6.17-rc2, mdadm 2.4.1, xfs_growfs 2.7.16, processor Athlon64 (x86_64) )

Thanks!

MM.

