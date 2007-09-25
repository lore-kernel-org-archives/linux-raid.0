From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Re: Help: very slow software RAID 5.
Date: Tue, 25 Sep 2007 16:50:16 -0700 (PDT)
Message-ID: <20070925235016.02F6E1023B9@medulla.enet.sharplabs.com>
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
	<20070925181618.82F47102162@medulla.enet.sharplabs.com> <87sl521kqh.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <87sl521kqh.fsf@informatik.uni-tuebingen.de> (message from Goswin
	von Brederlow on Tue, 25 Sep 2007 23:46:46 +0200)
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, brederlo@informatik.uni-tuebingen.de
List-Id: linux-raid.ids


Goswin von Brederlow writes:
: Dean Mesing writes:
: > Goswin von Brederlow writes:
: > : LVM is not the same as LVM. What I mean is that you still have ch=
oices
: > : left.
: >
: > Sorry, Goswin.  Even though you gave your meaning, I still don't
: > understand you here.  (I must be dense this morning.)
: > What does "LVM is not the same as LVM" mean?
:=20
: The ultimate risk and speed of lvm depends on the striping and
: distribution of LVs accross the disks.

Even w/o LV striping, I don't know enough about LV organisation to
try to recover from a serious disk crash.

: > :=20
: > : One thing you have to think about though. An lvm volume group wil=
l not
: > : start cleanly with a disk missing but you can force it to start
: > : anyway. So a lost disk does not mean all data is lost. But it doe=
s
: > : mean that any logical volume with data on the missing disk will h=
ave
: > : serious data corruption.
: >
: > If I am taking daily LVM snapshots will I not be able to reconstruc=
t
: > the file system as of the last snapshot?  That's all I require.
:=20
: A snapshot will only hold the differences between creation and now. S=
o
: Not at all.
:=20
: What you would have to do is have the original on USB and work in a
: snapshot. But then there is no lvm command to commit a snapshot back
: to the original device to store the changes.
:=20
: I'm afraid you need to rsync the data to another disk or volume to
: make a backup.

Ok. I think I understand. The snapshot could not be used to restore
to a master backup of the original since that backup in not in LV forma=
t.

If I'm using an ext3 filesystem (which I plan to do) would Full and
Incremental dumps to a cheap 'n big USB drive (using the dump/restore
suite) not work?

: > I have also discovered "smartctl" and have read that if the short s=
martctl
: > tests are run daily and the long test weekly that the chances of be=
ing
: > caught "with my pants down" are quite low, even in a two disk RAID-=
0
: > config.  What is your opinion?
:=20
: Smart is a big fat lier. I have a disk with failure iminent that's
: been running for 3 years now. I have disks with 345638756348756 ECC
: errors. A disk that runs at 130=B0 and gets warmer when I put a fan i=
n
: front of it. and on and on and on.

Ouch. Ok, I get the picture.

: Smart certainly is no replacement of a backup. Raid5 is also no
: replacement for a backup.=20

I did not mean to imply I would forego backups.  I've been using Unix
for too long (26 years) to be that foolish. I simply thought that
Smart would allow me to run RAID-0 or striped LV (and do backups!)
with reduced risk of having an actual disk failure since I would be
able to deal with a weak drive before it failed.  Thanks for
disabusing me of my fantasy.

: Imagine a faulty cable or a bug in your
: kernel that writes wrong data to the disks and corrupts your
: filesystem. The raid will be perfectly fine and could properly
: construct your data on a disk failure, the broken data. Big help.

Agreed, though RAID-0 or striped LV won't be able to reconstruct anythi=
ng
upon disk failure.

: Raid basicaly only protects you from the downtime of having to restor=
e
: the backup RIGHT NOW when a disk fails. Buys you the time to wait for
: the weekend to fix things or whatever.

Indeed.

: > : Also lvm can do raid0 itself. For each logical volume you create =
you
: > : can specify the number of stripes to use. So I would abandon all
: > : thoughts of raid0 and replace them with using lvm.
: > :=20
: > : Run one LV with 2 stripes on the first two disks and snapshot on =
the
: > : third.
: >
: > Good idea. I waw aware of striped LV but did not think it would run
: > nearly as fast as RAID-0. Do you think two LV stripes will equal
: > RAID-0 for all kinds of read/write disk use?  There would seem to b=
e
: > lots more than two RAID=3D0 stripes in the default case.  (I do kno=
w
: > enough to not run Striped LV with RAID-0 :-)
:=20
: They are conceptually identicall and all else being the same they
: should behave the same.

I will surely test it.
 =20
: Beware though that lvm does not set the read ahead correctly (only th=
e
: default size) while raid will set the read ahead to the sum of the
: disks read ahead (-1 or -2 disks for raid4/5/6). So by default all is
: not the same. So set the readahead to the same if you want to compare
: the two.

Ok, good to know. However I'm not so sure RAID-4,5,6 actually sets
the readahead "correctly".  My whole dilemma started when I saw
how slowly RAID-5 was running on three drives---slower than the physica=
l
device speed of two of the three drives.

Justin Piszcz suggested tweeking the parameters (in particular,
readahead). Indeed, increasing read-ahead did increase seq. read
speeds, but at a cost to random reads.  And writes were still slow.

=46or RAID-0, everything is faster, which makes the whole system snappy=
=2E

: > <snip>
: > :=20
: > : I tested Raid10 and with far copies I got the full speed of all d=
isks
: > : combined just like a raid0 would for reading and half speed for
: > : writing (as it has to write everything twice). I got pretty damn
: > : close to the theoretical limit it could get, which was surprising=
=2E
: >
: > Very interesting! On three drives? When you said "half speed for
: > writes", did you mean "half the RAID-0 read speed" or "half the
: > physical device read speed"?
:=20
: Both. The raid10 has to physically write every data block twice so th=
e
: throughput of what you get as user is half of that the hardware has t=
o
: do. So naturally you only get 50% of the disk/raid0 speed.
:
: With raid10 and writing large blocks of data at a time I got like 48%
: of the combined disks speed on write, meaning they managed 96% of the
: combine speed.
:
:
: > I hate the thought of half speed writes.  Some
: > of what I do requires more writing than reading---up-conversion of
: > Full HD video to 4Kx2K video, for example.  Given your test, I'll r=
un
: > some tests with a three device RAID-10 with "far" copies.
:=20
: For writes you get 50% of 300% (slowest) disk speed. So you sill have
: 150% speed total with raid10. With raid5 you have 200% (slowest) disk
: speed for continious writes and maybe 50% (slowest) disk speed for
: fragments.

I don't get anywhere near 200% disk speed for writes for
3 disk sequential writes in RAID-5. I barely get 100%
of the slowest drive in the array.

Here are my numbers (again):=20

Three drives: one is 55 MB/s, one is  71 MB/s and one is 75 MB/s.

In RAID-5 with no parameter tweeking:

Seq. reads:    63767 MB/s
random reads:  61410 MB/s

Seq. writes:   56970 MB/s
random writes: 53688 MB/s

Increasing the read-ahead from 512 to 32768:

Seq. reads:    113852 MB/s
random reads:   54175 MB/s

Seq. writes:    56337 MB/s
random writes:  53743 MB/s

=46or 2 disk RAID-0 on the two faster disks:

Seq. reads:    139973 MB/s
random reads:   63233 MB/s

Seq. writes:   114407 MB/s
random writes:  59745 MB/s

Plus random file creation and reading
doubles with RAID-0 vis-a-vis RAID-5.

: And for reads you get 300% (slowest) disk speed with raid10 but only
: 200% for raid5.

Again, I don't get these speeds. Seq. reads are about
170% of the average of my three physical drives if I turn up
the look-ahead.  Then random access reads drops to slightly less
than my slowest drive.

: Theoretically that is. But as I said the raid10 tests I did showed it
: being damn close to theoretical speed. But all such tests are highly
: dependend on the usage pattern. So don't believe the bonnie output or
: worse hdparm. Run the application you will be using and see if that
: gets faster or slower.

The "application" is all my daily work---which is quite varied.
I'm trying to build the snappiest system I can given my limitations.

: > But I would really like to know if I'm playing with fire putting my
: > whole system on a RAID-0/non-striped LVM device (or striped LVM dev=
ice
: > w/o RAID) with daily snapshots, and good smartctl monitoring.
:=20
: You are. A disk might fail at any time and the snapshot only protects
: you from filesystem corruption and/or accidental deletions, not disk
: failure.

I got it.

: Also don't forget that snapshots will slow you down. Every first time
: a block gets written after the snapshot it first has to read the old
: block, write it to the snapshot and only then can write the new data.

I did not understand this.  So what you are sayig is that a snapshot
is "living".  That is, you don't just make it in an instant of time.
Every time something not included in the snapshot changes the original
gets written to the snapshot?  That's quite different than what I thoug=
ht.

So I won't be using snapshots for backing up, I see.  Dump and Restore?

Dean
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
