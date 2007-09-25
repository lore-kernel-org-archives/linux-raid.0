From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: Help: very slow software RAID 5.
Date: Tue, 25 Sep 2007 23:46:46 +0200
Message-ID: <87sl521kqh.fsf@informatik.uni-tuebingen.de>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070925181618.82F47102162@medulla.enet.sharplabs.com> (Dean
	S. Messing's message of "Tue, 25 Sep 2007 11:16:18 -0700 (PDT)")
Sender: linux-raid-owner@vger.kernel.org
To: "Dean S. Messing" <deanm@sharplabs.com>
Cc: linux-raid@vger.kernel.org, brederlo@informatik.uni-tuebingen.de
List-Id: linux-raid.ids

"Dean S. Messing" <deanm@sharplabs.com> writes:

> Goswin von Brederlow writes:
> : Dean S. Messing  writes:
> : > Michael Tokarev writes:
> : > : Dean S. Messing wrote:
> : > : []
> : > : > []  That's what
> : > : > attracted me to RAID 0 --- which seems to have no downside EX=
CEPT
> : > : > safety :-).
> : > : >=20
> : > : > So I'm not sure I'll ever figure out "the right" tuning.  I'm=
 at the
> : > : > point of abandoning RAID entirely and just putting the three =
disks
> : > : > together as a big LV and being done with it.  (I don't have q=
uite the
> : > : > moxy to define a RAID 0 array underneath it. :-)
> : > :=20
> : > : "Putting three disks together as a big LV" - that's exactly wha=
t
> : > : "linear" md module. =20
> : > : It's almost as unsafe as raid0, but with
> : > : linear read/write speed equal to speed of single drive...
> : >
> : > I understand I only get the speed of a single drive but I was not
> : > aware of the safety factor.  I had intended to use snapshotting o=
ff
> : > to a cheap USB drive each evening.  Will that not keep me safe wi=
thin a
> : > day's worth of data change?  I only learned about "snapshots" yes=
terday.
> : > I'm utterly new to the disk array/LVM game.
> : >
> : > For that matter why not run a RAID-0 + LVM  across two of the thr=
ee drives
> : > and snapshot to the third?
> :=20
> : LVM is not the same as LVM. What I mean is that you still have choi=
ces
> : left.
>
> Sorry, Goswin.  Even though you gave your meaning, I still don't
> understand you here.  (I must be dense this morning.)
> What does "LVM is not the same as LVM" mean?

The ultimate risk and speed of lvm depends on the striping and
distribution of LVs accross the disks.

> :=20
> : One thing you have to think about though. An lvm volume group will =
not
> : start cleanly with a disk missing but you can force it to start
> : anyway. So a lost disk does not mean all data is lost. But it does
> : mean that any logical volume with data on the missing disk will hav=
e
> : serious data corruption.
>
> If I am taking daily LVM snapshots will I not be able to reconstruct
> the file system as of the last snapshot?  That's all I require.

A snapshot will only hold the differences between creation and now. So
Not at all.

What you would have to do is have the original on USB and work in a
snapshot. But then there is no lvm command to commit a snapshot back
to the original device to store the changes.

I'm afraid you need to rsync the data to another disk or volume to
make a backup.

> I have also discovered "smartctl" and have read that if the short sma=
rtctl
> tests are run daily and the long test weekly that the chances of bein=
g
> caught "with my pants down" are quite low, even in a two disk RAID-0
> config.  What is your opinion?

Smart is a big fat lier. I have a disk with failure iminent that's
been running for 3 years now. I have disks with 345638756348756 ECC
errors. A disk that runs at 130=B0 and gets warmer when I put a fan in
front of it. and on and on and on.

Smart certainly is no replacement of a backup. Raid5 is also no
replacement for a backup. Imagine a faulty cable or a bug in your
kernel that writes wrong data to the disks and corrupts your
filesystem. The raid will be perfectly fine and could properly
construct your data on a disk failure, the broken data. Big help.

Raid basicaly only protects you from the downtime of having to restore
the backup RIGHT NOW when a disk fails. Buys you the time to wait for
the weekend to fix things or whatever.

> : Also lvm can do raid0 itself. For each logical volume you create yo=
u
> : can specify the number of stripes to use. So I would abandon all
> : thoughts of raid0 and replace them with using lvm.
> :=20
> : Run one LV with 2 stripes on the first two disks and snapshot on th=
e
> : third.
>
> Good idea. I waw aware of striped LV but did not think it would run
> nearly as fast as RAID-0. Do you think two LV stripes will equal
> RAID-0 for all kinds of read/write disk use?  There would seem to be
> lots more than two RAID=3D0 stripes in the default case.  (I do know
> enough to not run Striped LV with RAID-0 :-)

They are conceptually identicall and all else being the same they
should behave the same.

Beware though that lvm does not set the read ahead correctly (only the
default size) while raid will set the read ahead to the sum of the
disks read ahead (-1 or -2 disks for raid4/5/6). So by default all is
not the same. So set the readahead to the same if you want to compare
the two.

> <snip>
> :=20
> : I tested Raid10 and with far copies I got the full speed of all dis=
ks
> : combined just like a raid0 would for reading and half speed for
> : writing (as it has to write everything twice). I got pretty damn
> : close to the theoretical limit it could get, which was surprising.
>
> Very interesting! On three drives? When you said "half speed for
> writes", did you mean "half the RAID-0 read speed" or "half the
> physical device read speed"?

Both. The raid10 has to physically write every data block twice so the
throughput of what you get as user is half of that the hardware has to
do. So naturally you only get 50% of the disk/raid0 speed.

With raid10 and writing large blocks of data at a time I got like 48%
of the combined disks speed on write, meaning they managed 96% of the
combine speed.

> I hate the thought of half speed writes.  Some
> of what I do requires more writing than reading---up-conversion of
> Full HD video to 4Kx2K video, for example.  Given your test, I'll run
> some tests with a three device RAID-10 with "far" copies.

=46or writes you get 50% of 300% (slowest) disk speed. So you sill have
150% speed total with raid10. With raid5 you have 200% (slowest) disk
speed for continious writes and maybe 50% (slowest) disk speed for
fragments.

And for reads you get 300% (slowest) disk speed with raid10 but only
200% for raid5.

Theoretically that is. But as I said the raid10 tests I did showed it
being damn close to theoretical speed. But all such tests are highly
dependend on the usage pattern. So don't believe the bonnie output or
worse hdparm. Run the application you will be using and see if that
gets faster or slower.

> But I would really like to know if I'm playing with fire putting my
> whole system on a RAID-0/non-striped LVM device (or striped LVM devic=
e
> w/o RAID) with daily snapshots, and good smartctl monitoring.

You are. A disk might fail at any time and the snapshot only protects
you from filesystem corruption and/or accidental deletions, not disk
failure.

Also don't forget that snapshots will slow you down. Every first time
a block gets written after the snapshot it first has to read the old
block, write it to the snapshot and only then can write the new data.

> Dean

MfG
        Goswin
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
