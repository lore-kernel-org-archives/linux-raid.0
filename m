From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Re: Help: very slow software RAID 5.
Date: Wed, 26 Sep 2007 23:23:17 -0700 (PDT)
Message-ID: <20070927062317.3CCAB1023E0@medulla.enet.sharplabs.com>
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
	<20070925235016.02F6E1023B9@medulla.enet.sharplabs.com> <87k5qe19p0.fsf@informatik.uni-tuebingen.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <87k5qe19p0.fsf@informatik.uni-tuebingen.de> (message from Goswin
	von Brederlow on Wed, 26 Sep 2007 03:45:15 +0200)
Sender: linux-raid-owner@vger.kernel.org
To: brederlo@informatik.uni-tuebingen.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Goswin von Brederlow writes:
: > Dean Mesing writes:
: > If I'm using an ext3 filesystem (which I plan to do) would Full and
: > Incremental dumps to a cheap 'n big USB drive (using the dump/restore
: > suite) not work?
:  
:  Probably. But why not rsync? It will copy all changes and the data on
:  the USB disk will be accessible directly without restore. Very handy
:  if you only need one file.

I don't see how one would do incrementals.  My backup system uses
currently does a monthly full backup,   a weekly level  3  (which
saves everything that has changed since the last level 3 a week ago) and
daily level 5's (which save everything that changed today).

I keep 3 months worth of these.  So basically if a file existed for
more than 24 hours w/in the last three months I've got it somewhere in
my backup partition.  If I accidently delete a file and don't notice
it for 10 days, no problem.  I'm not sure rsync can do this.  (I
already use rsync to keep various directories on my 5 machines in
sync).

: If it works right, and the numbers are probably obviously wrong if
: not, you can see the number of bad blocks. If that starts rising then
: you know the disk won't last long anymore. But when was the last time
: one of your disks died by bad blocks apearing? Mine always sieze up
: and won't spin up anymore or the heads won't seek anymore or the
: electronic dies. Never had a disk where the magnetization failed and
: more and more bad blocks appeared.

Actually I've never had a disk stop spinning.  It's always other
stuff where it stops doing I/O or gives corrupt data.

: Untuned I have this:
: 
: # cat /proc/mdstat         
: Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
: md1 : active raid5 sdd2[3] sdc2[2] sdb2[1] sda2[0]
:       583062912 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
: # blockdev --getra /dev/sda
: 256
: # blockdev --getra /dev/md1
: 768
: # blockdev --getra /dev/r/home
: 256
: 
: You see that the disk and LV is at the default of 256 blocks read
: ahead. But the raid it at (4-1)*256 == 768 blocks.
: 
: You usualy can still raise those number a good bit. Esspecialy if you
: are working with large files and streaming access, like movies. :)

Someone on the Fedora list who is running 4 50 MB/s drives in RAID 5 array
was getting read speeds of 120 MB/s or so.  Not 300% but not to bad.
He also had an untuned md device readahead of 768.  With 3 devices
I have an un-tuned one of 512, but going to 768 makes little difference.
I must go up to 16384 to see any decent read improvement.
I wonder why four drives works so much better than three.

<snip>
: I hope you are sufficiently scared now to consider all the
: consequences. You seem to plan doing regular backups. That is
: good. That means what you actualy risk with raid0 (or imho preferably
: striped lv) is loosing yesterdays work and todays time to restore the
: backup. Now you can gamble that you won't have a disk failure too
: often, maybe not for years and the speedup of plain raid0 will save
: you more time commulative than you loose in those 2 days.

I'm not sure if I could quantify the time savings quite so
pragmatically.  But using a very snappy machine is simply a pleasure.
That counts for something.  I'm not afraid of restoring if I need to.

: I probably will. But due to Murphys law the failure will happen at the
: worst time and obviously you will be mad as hell at that time. For a
: single person and a single raid it all comes down to luck in the end.

Agreed.  The other option, if I can swing it with my boss, is to purchase
a 3ware true hardware RAID-5 card that presents the disks as one
device.  They are about $450 and the RAID-5 runs (from what I hear)
quite fast for both read and writes (uses write-back with battery
backup to get write speeds up).

But you've given me some things to explore regarding RAID-10
and LV striping.  Thanks.

: At work we just got a job of building a storage cluster with ~1000
: disks. At that size the luck becomes statistics. A "the disk will
: probably not fail for years" becomes "10 disks will die". So my
: outlook at raid saftey might be a bit bleak.

With that many disks, one is sure to fail every month or so unless
they are top quality drives.

Thanks again.

Dean
