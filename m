From: "Hod Greeley" <hod-lrvko@greeley.org>
Subject: mdadm: /dev/sda1 is too small: 0K
Date: Sat, 13 Oct 2007 11:33:10 -0700 (PDT)
Message-ID: <63856.10.4.0.1.1192300390.squirrel@www.greeley.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I tried to create a raid device starting with

foo:~ 1032% mdadm --create -l1 -n2 /dev/md1 /dev/sda1 missing
mdadm: /dev/sda1 is too small: 0K
mdadm: create aborted

Others have seen this problem too.  People seemed to think it might be
related to the partition id, but I think the issue is something else.  On
a sata drive I have, ioctl calls to find the size of the first partition
seem to always return 0.  E.g.

foo:~ 1028% fdisk /dev/sda

...

Disk /dev/sda: 255 heads, 63 sectors, 38913 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/sda1             1     38000 305234968+  83  Linux
/dev/sda3         38001     38913   7333672+  82  Linux swap

foo:~ 1061% ./getsize /dev/sda
Number of bytes reported: 320072933376, number of blocks reported: 625142448.

foo:~ 1062% ./getsize /dev/sda1
Number of bytes reported: 0, number of blocks reported: 0.

foo:~ 1063% ./getsize /dev/sda3
Number of bytes reported: 7509680640, number of blocks reported: 14667345.

getsize is just a little utility to examine device sizes.  The important
guts are:

  fd = open(argv[1], O_RDONLY);
  ioctl(fd, BLKGETSIZE64, &nbytes);
  ioctl(fd, BLKGETSIZE, &nblocks);

So, oddly, it is only the size of the first partition that is reported
incorrectly (I tried several partitioning variations, and no, the ioctls
do not report any error).  I did find at least one report of someone
having this problem with a different partition number, though.  They
claimed changing the partition id fixed the mdadm results for them, but
this has not worked for me.

I also happen to have several IDE drives on the same system.  Sizes appear
to be correctly reported for partition 1 on all of them.

I'm running mdadm version 2.6.3 on kernel version 2.4.32.  The sata drive
is a Seagate.  I don't remember all the details of my sata controller, but
from my boot messages I have: sata_sil version 0.9.

Does anyone happen to know what's responsible for the failure?  (Yeah, I
know, that question really belongs somewhere else, but I'm posting here to
help with the raid issue it causes.)

Thanks,
Hod Greeley

