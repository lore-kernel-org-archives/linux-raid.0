From: V <viswesh.vichu@gmail.com>
Subject: Resync issue in RAID1
Date: Fri, 21 Oct 2016 08:53:50 -0700
Message-ID: <CAF9xHmRCKzBXE5_tdqNY9BJJn7LyC8bOv8OaFXpxc1BvGUTCeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am facing an issue during RAID1 resync. I have an ubuntu
4.4.0-31-generic running with raid1 configured with 2 disks as active
and 2 as spares. On the first powercycle, after installing RAID, i see
the following messages in kern.log


My disks are configured with 4K sector size (both logical and
physical) (sda and sdb are active disks for this raid)


===========
Oct 18 03:52:56  kernel: [   52.869113] md: using 128k window, over a
total of 51167104k.
Oct 18 03:52:56  kernel: [   52.869114] md: resuming resync of md2
from checkpoint.
Oct 18 03:52:56  kernel: [   52.869378] sd 0:0:0:0: [sda] Bad block
number requested
Oct 18 03:52:56  kernel: [   52.869414] sd 0:0:0:0: [sda] Bad block
number requested
Oct 18 03:52:56  kernel: [   52.869436] sd 0:0:0:0: [sda] Bad block
number requested
Oct 18 03:52:56  kernel: [   52.869465] sd 0:0:0:0: [sda] Bad block
number requested
Oct 18 03:52:56  kernel: [   52.869503] sd 0:0:1:0: [sdb] Bad block
number requested
Oct 18 03:52:56  kernel: [   52.869536] md/raid1:md2: sda:
unrecoverable I/O read error for block 3
Oct 18 03:52:56  kernel: [   52.869581] md: md2: resync interrupted.
Oct 18 03:52:56  kernel: [   52.869584] sd 0:0:0:0: [sda] Bad block
number requested
Oct 18 03:52:56  kernel: [   52.869609] sd 0:0:0:0: [sda] Bad block
number requested
Oct 18 03:52:56  kernel: [   52.869633] sd 0:0:1:0: [sdb] Bad block
number requested
Oct 18 03:52:56  kernel: [   52.869692] md/raid1:md2: sda:
unrecoverable I/O read error for block 131
Oct 18 03:52:56  kernel: [   52.869735] sd 0:0:0:0: [sda] Bad block
number requested
Oct 18 03:52:56  kernel: [   52.869808] sd 0:0:1:0: [sdb] Bad block
number requested
Oct 18 03:52:56  kernel: [   52.869837] md/raid1:md2: sda:
unrecoverable I/O read error for block 259
Oct 18 03:52:56  kernel: [   52.869908] sd 0:0:0:0: [sda] Bad block
number requested
Oct 18 03:52:56  kernel: [   52.869958] sd 0:0:1:0: [sdb] Bad block
number requested
Oct 18 03:52:56  kernel: [   52.870022] md/raid1:md2: sda:
unrecoverable I/O read error for block 387

===========


Seems to be an unaligned access from mdraid1 during resync. Do you
have any idea, why we are seeing it. How do i debug this issue.


I was looking at the following patch (
http://marc.info/?l=linux-raid&m=142405887609959&w=2 ), by Nate in the
function narrow_write_error(), where the alignment was made correctly
to disk sector size. Do you think, similar roundups are required in
resync path as well.

More info:

1) We have checks for previous raid configurations present in device
partitions ( we do mdadm --examine and if present, we zero out
superblocks)
2) Each device is partitioned into 4 and used for 4 different raid devices.
3) Say sda is partitioned into 4 (sda1,sda2,sda3,sda4) and each
partition is part of one raid device.
4) Raid1 create command.
     /sbin/mdadm --quiet --create /dev/md1 --force --level=1
--metadata=default --raid-devices=2 /dev/sda1 /dev/sdb1
--spare-devices=2 /dev/sdc1/dev/sdd1


Thanks in advance,
Viswesh
