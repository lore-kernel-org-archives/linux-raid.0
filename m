From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Multiple raids on one machine?
Date: Mon, 26 Jun 2006 09:05:41 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0606260847470.370@lion.drogon.net>
References: <449F100D.6030509@cjx.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449F100D.6030509@cjx.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Allen <chris@cjx.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 25 Jun 2006, Chris Allen wrote:

> Back to my 12 terabyte fileserver, I have decided to split the storage
> into four partitions
> each of 3TB. This way I can choose between XFS and EXT3 later on.
>
> So now, my options are between the following:
>
> 1. Single 12TB /dev/md0, partitioned into four 3TB partitions. But how do
> I do this? fdisk won't handle it. Can GNU Parted handle partitions this big?
>
> 2. Partition the raw disks into four partitions and make
> /dev/md0,md1,md2,md3.
> But am I heading for problems here? Is there going to be a big
> performance hit
> with four raid5 arrays on the same machine? Am I likely to have dataloss
> problems
> if my machine crashes?

I use option 2 (above) all the time, and I've never noticed any
performance issues. (not issues with recovery after a power failure) I'd
like to think that on a modern processor the CPU can handle the parity,
etc. calculations several orders of magnitude faster than the hardware can
chug data to & from the drives, so all it's really adding is a tiny bit of
latency...

Someone some time back on this list posted a hint that I've been using
though - you might find it handy - name the md? devices after the
partition number, if possible. So md1 would be made up from /dev/sda1,
/dev/sdb1, /dev/sdc1, etc. md2 made up from /dev/sda2, /dev/sdb2, etc. It
might just save any confusion when hot adding/removing drives, etc.

The down-side is that if you do have to remove a drive, you have to
manually 'fail' each other md device+partition for that drive, then
manually remove them before you can hot-remove the physical drive. (or
cold remove it/whatever)

So if you have /dev/md{1,2.3,4} and /dev/md3 (etc) is made from /dev/sda3,
/dev/sdb3, /dev/sdc3, and md3 (eg. /dev/sdc3) has a failure, then you need
to:

  mdadm --fail /dev/md1 /dev/sdc1
  mdadm --fail /dev/md2 /dev/sdc2
# mdadm --fail /dev/md3 /dev/sdc3	# already failed
  mdadm --fail /dev/md4 /dev/sdc4

Then repeat, s/fail/remove/ then you can echo the right runes to
/proc/scsi/scsi and hot-remove /dev/sdc and plug a new one in.

At least, thats what I do when I've done it 'hot'. Doing it cold doesn't
really matter as the server will boot with a blank partition table in the
replaced disk and just kick it out of the array - you can then
re-partition, and mdadm --add ... the partition back into each array.

I like to keep each partition identical, if I can - heres an example:

Personalities : [raid1] [raid6]
md1 : active raid1 sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
      248896 blocks [6/6] [UUUUUU]

md2 : active raid6 sdf2[5] sde2[4] sdd2[3] sdc2[2] sdb2[1] sda2[0]
      1991680 blocks level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]

md3 : active raid6 sdf3[5] sde3[4] sdd3[3] sdc3[2] sdb3[1] sda3[0]
      1991680 blocks level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]

md5 : active raid6 sdf5[5] sde5[4] sdd5[3] sdc5[2] sdb5[1] sda5[0]
      3983616 blocks level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]

md6 : active raid6 sdf6[5] sde6[4] sdd6[3] sdc6[2] sdb6[1] sda6[0]
      277345536 blocks level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]

md7 : active raid6 sdf7[5] sde7[4] sdd7[3] sdc7[2] sdb7[1] sda7[0]
      287177472 blocks level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]

Each drive is partitioned like:

Disk /dev/sda: 255 heads, 63 sectors, 17849 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/sda1   *         1        31    248976   fd  Linux raid autodetect
/dev/sda2            32        93    498015   fd  Linux raid autodetect
/dev/sda3            94       155    498015   fd  Linux raid autodetect
/dev/sda4           156     17849 142127055    5  Extended
/dev/sda5           156       279    995998+  fd  Linux raid autodetect
/dev/sda6           280      8911  69336508+  fd  Linux raid autodetect
/dev/sda7          8912     17849  71794453+  fd  Linux raid autodetect


(Yes, md1 is a RAID-1 striped over 6 drives! write performance might be
"sub optimal", but it's only the root partition and hardly ever written
to, and yes, swap /dev/md2 on this box is under R-6)

Gordon
