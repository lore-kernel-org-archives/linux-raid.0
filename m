From: Kerin Millar <kerframil@gmail.com>
Subject: raid10 make_request failure during iozone benchmark upon btrfs
Date: Mon, 02 Jul 2012 03:34:16 +0100
Message-ID: <4FF108A8.6090606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm running a 4-way RAID-10 array with the f2 layout scheme on a 3.5-rc5
kernel:

Personalities : [raid10] [raid6] [raid5] [raid4]
md0 : active raid10 sdb2[4] sdd2[3] sdc2[2] sda2[1]
       5860462592 blocks super 1.1 256K chunks 2 far-copies [4/4] [UUUU]

I am also using LVM, with md0 serving as the sole PV in a volume group
named vg0. The drives are brand new Hitachi Desktar 5K3000 drives and
they are known to be in good health. XFS is my filesystem of choice but
I recently created a volume so that I could benchmark btrfs with iozone
(just out of curiosity). The volume arrangement is as follows:

# lvs -o lv_name,lv_attr,lv_size,seg_pe_ranges
   LV     Attr   LSize   PE Ranges
   public -wi-ao   3.00t /dev/md0:25600-812031
   rootfs -wi-ao 100.00g /dev/md0:0-25599
   test   -wi-ao   2.00g /dev/md0:812032-812543

The btrfs filesystem was created as follows:

# mkfs.btrfs /dev/vg0/test
...
fs created label (null) on /dev/vg0/test
         nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00GB
Btrfs Btrfs v0.19

I'm not sure whether this is a bug in the raid10 code but I am
encountering a reproducible error while running iozone -a. It triggers
during the tests that read and write 2MiB with a 4KiB record length.
Here's the tail end of iozone's output:

2048  4  530020  473540  1660915  1655474  1427182  388846  1405465  558811  1394966  462500  520324

Error in file: Found ?101010101010101? Expecting ?6d6d6d6d6d6d6d6d? addr 7ff7c8700000
Error in file: Position 131072
Record # 32 Record size 4 kb
where 7ff7c8700000 loop 0

Note that the last two column's worth of figures are missing, implying
that the failure occurs when iozone is running the fread/freread tests.

Here are the error messages from the kernel ring buffer:

[  919.893454] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653500160 256
[  919.893465] btrfs: bdev /dev/mapper/vg0-test errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
[  919.894060] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653500672 256
[  919.894070] btrfs: bdev /dev/mapper/vg0-test errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
[  919.894634] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653501184 256
[  919.894643] btrfs: bdev /dev/mapper/vg0-test errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
[  919.895225] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653501696 256
[  919.895234] btrfs: bdev /dev/mapper/vg0-test errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
[  919.895801] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653502208 256
[  919.895811] btrfs: bdev /dev/mapper/vg0-test errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
[  919.896390] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653502720 256
[  919.896399] btrfs: bdev /dev/mapper/vg0-test errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
[  919.896981] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653503232 256
[  919.896990] btrfs: bdev /dev/mapper/vg0-test errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
[  920.029589] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653504256 256
[  920.029603] btrfs: bdev /dev/mapper/vg0-test errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
[  920.030208] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653504768 256
[  920.030222] btrfs: bdev /dev/mapper/vg0-test errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
[  920.030788] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653505280 256
[  920.030802] btrfs: bdev /dev/mapper/vg0-test errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
[  920.031385] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653505792 256
[  920.031957] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653506304 256
[  920.032551] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653506816 256
[  920.033135] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653507328 256
[  920.161304] btrfs no csum found for inode 328 start 131072
[  920.180249] btrfs csum failed ino 328 off 131072 csum 2259312665 private 0

I have no intention of using btrfs for anything other than
experimentation. Sill, my fear is that something could be amiss in
the guts of the raid10 code. I'd welcome any insights as to what is
happening here.

Cheers,

--Kerin
