From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: Help: very slow software RAID 5.
Date: Wed, 26 Sep 2007 03:45:15 +0200
Message-ID: <87k5qe19p0.fsf@informatik.uni-tuebingen.de>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>
	<Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>
	<20070919014919.DF19D10215F@medulla.enet.sharplabs.com>
	<Pine.LNX.4.64.0709190437050.4411@p34.internal.lan>
	<20070919174956.9497310209D@medulla.enet.sharplabs.com>
	<46F292E2.1090700@tmr.com>
	<20070920184738.441FD10208C@medulla.enet.sharplabs.com>
	<46F2E159.9030806@msgid.tls.msk.ru>
	<20070921005851.44E8910236D@medulla.enet.sharplabs.com>
	<87r6knay66.fsf@informatik.uni-tuebingen.de>
	<20070925181618.82F47102162@medulla.enet.sharplabs.com>
	<87sl521kqh.fsf@informatik.uni-tuebingen.de>
	<20070925235016.02F6E1023B9@medulla.enet.sharplabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070925235016.02F6E1023B9@medulla.enet.sharplabs.com> (Dean
	S. Messing's message of "Tue, 25 Sep 2007 16:50:16 -0700 (PDT)")
Sender: linux-raid-owner@vger.kernel.org
To: "Dean S. Messing" <deanm@sharplabs.com>
Cc: brederlo@informatik.uni-tuebingen.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Dean S. Messing" <deanm@sharplabs.com> writes:

> Goswin von Brederlow writes:
> : Dean Mesing writes:
> : > Goswin von Brederlow writes:
> : > : LVM is not the same as LVM. What I mean is that you still have choices
> : > : left.
> : >
> : > Sorry, Goswin.  Even though you gave your meaning, I still don't
> : > understand you here.  (I must be dense this morning.)
> : > What does "LVM is not the same as LVM" mean?
> : 
> : The ultimate risk and speed of lvm depends on the striping and
> : distribution of LVs accross the disks.
>
> Even w/o LV striping, I don't know enough about LV organisation to
> try to recover from a serious disk crash.

Even with out striping you can have 1GB data of an LV on disk1, then
1GB on disk2, then 1GB on disk3. When disk2 dies you loose 1GB in the
middle of the fs and that is rather damaging.

Now why would anyone split up an LV like that? Sounds seriously
stupid, right? Well. Thinking about what happens over longer time when
you resize LVs a few times. It will just use the next free space
unless the LV is flaged continious. Allocations will fragment unless
you take care not to (for example pvmove other LVs out of the way).

> : > : 
> : > : One thing you have to think about though. An lvm volume group will not
> : > : start cleanly with a disk missing but you can force it to start
> : > : anyway. So a lost disk does not mean all data is lost. But it does
> : > : mean that any logical volume with data on the missing disk will have
> : > : serious data corruption.
> : >
> : > If I am taking daily LVM snapshots will I not be able to reconstruct
> : > the file system as of the last snapshot?  That's all I require.
> : 
> : A snapshot will only hold the differences between creation and now. So
> : Not at all.
> : 
> : What you would have to do is have the original on USB and work in a
> : snapshot. But then there is no lvm command to commit a snapshot back
> : to the original device to store the changes.
> : 
> : I'm afraid you need to rsync the data to another disk or volume to
> : make a backup.
>
> Ok. I think I understand. The snapshot could not be used to restore
> to a master backup of the original since that backup in not in LV format.
>
> If I'm using an ext3 filesystem (which I plan to do) would Full and
> Incremental dumps to a cheap 'n big USB drive (using the dump/restore
> suite) not work?

Probably. But why not rsync? It will copy all changes and the data on
the USB disk will be accessible directly without restore. Very handy
if you only need one file.

> : Smart certainly is no replacement of a backup. Raid5 is also no
> : replacement for a backup. 
>
> I did not mean to imply I would forego backups.  I've been using Unix
> for too long (26 years) to be that foolish. I simply thought that
> Smart would allow me to run RAID-0 or striped LV (and do backups!)
> with reduced risk of having an actual disk failure since I would be
> able to deal with a weak drive before it failed.  Thanks for
> disabusing me of my fantasy.

If it works right, and the numbers are probably obviously wrong if
not, you can see the number of bad blocks. If that starts rising then
you know the disk won't last long anymore. But when was the last time
one of your disks died by bad blocks apearing? Mine always sieze up
and won't spin up anymore or the heads won't seek anymore or the
electronic dies. Never had a disk where the magnetization failed and
more and more bad blocks appeared.

> : Beware though that lvm does not set the read ahead correctly (only the
> : default size) while raid will set the read ahead to the sum of the
> : disks read ahead (-1 or -2 disks for raid4/5/6). So by default all is
> : not the same. So set the readahead to the same if you want to compare
> : the two.
>
> Ok, good to know. However I'm not so sure RAID-4,5,6 actually sets
> the readahead "correctly".  My whole dilemma started when I saw
> how slowly RAID-5 was running on three drives---slower than the physical
> device speed of two of the three drives.
>
> Justin Piszcz suggested tweeking the parameters (in particular,
> readahead). Indeed, increasing read-ahead did increase seq. read
> speeds, but at a cost to random reads.  And writes were still slow.
>
> For RAID-0, everything is faster, which makes the whole system snappy.

Untuned I have this:

# cat /proc/mdstat         
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
md1 : active raid5 sdd2[3] sdc2[2] sdb2[1] sda2[0]
      583062912 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
# blockdev --getra /dev/sda
256
# blockdev --getra /dev/md1
768
# blockdev --getra /dev/r/home
256

You see that the disk and LV is at the default of 256 blocks read
ahead. But the raid it at (4-1)*256 == 768 blocks.

You usualy can still raise those number a good bit. Esspecialy if you
are working with large files and streaming access, like movies. :)

> : For writes you get 50% of 300% (slowest) disk speed. So you sill have
> : 150% speed total with raid10. With raid5 you have 200% (slowest) disk
> : speed for continious writes and maybe 50% (slowest) disk speed for
> : fragments.
>
> I don't get anywhere near 200% disk speed for writes for
> 3 disk sequential writes in RAID-5. I barely get 100%
> of the slowest drive in the array.

As I said below: theoretically.

> : > But I would really like to know if I'm playing with fire putting my
> : > whole system on a RAID-0/non-striped LVM device (or striped LVM device
> : > w/o RAID) with daily snapshots, and good smartctl monitoring.
> : 
> : You are. A disk might fail at any time and the snapshot only protects
> : you from filesystem corruption and/or accidental deletions, not disk
> : failure.
>
> I got it.

I hope you are sufficiently scared now to consider all the
consequences. You seem to plan doing regular backups. That is
good. That means what you actualy risk with raid0 (or imho preferably
striped lv) is loosing yesterdays work and todays time to restore the
backup. Now you can gamble that you won't have a disk failure too
often, maybe not for years and the speedup of plain raid0 will save
you more time commulative than you loose in those 2 days.

I probably will. But due to Murphys law the failure will happen at the
worst time and obviously you will be mad as hell at that time. For a
single person and a single raid it all comes down to luck in the end.

At work we just got a job of building a storage cluster with ~1000
disks. At that size the luck becomes statistics. A "the disk will
probably not fail for years" becomes "10 disks will die". So my
outlook at raid saftey might be a bit bleak.

> : Also don't forget that snapshots will slow you down. Every first time
> : a block gets written after the snapshot it first has to read the old
> : block, write it to the snapshot and only then can write the new data.
>
> I did not understand this.  So what you are sayig is that a snapshot
> is "living".  That is, you don't just make it in an instant of time.
> Every time something not included in the snapshot changes the original
> gets written to the snapshot?  That's quite different than what I thought.

Yes. That is actualy the beauty of the snapshot. You only need enough
space to safe changes. You don't make a full copy. A snapshot is like
an incremental backup. Without the full backup it depends on it is
worthless. But it is incremental with the time reversed. It is all the
changes from fluid now to a fixed point in time.

> So I won't be using snapshots for backing up, I see.  Dump and Restore?

Actualy you should but not in the way you imagined. Make a snapshot of
the filesystem to fix the contents of a fixed point in time. Then you
can run your dump, rsync, tar, whatever software you use to backup on
the snapshot. The normal FS can be used and changed meanwhile without
risking races with the backup process. The backup will be from exactly
the point in time when you made the snapshot even if it takes hours to
do.

> Dean

MfG
        Goswin
