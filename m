From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Re: Help: very slow software RAID 5.
Date: Tue, 25 Sep 2007 11:16:18 -0700 (PDT)
Message-ID: <20070925181618.82F47102162@medulla.enet.sharplabs.com>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>
	<Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>
	<20070919014919.DF19D10215F@medulla.enet.sharplabs.com>
	<Pine.LNX.4.64.0709190437050.4411@p34.internal.lan>
	<20070919174956.9497310209D@medulla.enet.sharplabs.com>
	<46F292E2.1090700@tmr.com>
	<20070920184738.441FD10208C@medulla.enet.sharplabs.com>
	<46F2E159.9030806@msgid.tls.msk.ru>
	<20070921005851.44E8910236D@medulla.enet.sharplabs.com> <87r6knay66.fsf@informatik.uni-tuebingen.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <87r6knay66.fsf@informatik.uni-tuebingen.de> (message from Goswin
	von Brederlow on Tue, 25 Sep 2007 11:31:45 +0200)
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: brederlo@informatik.uni-tuebingen.de
List-Id: linux-raid.ids


Goswin von Brederlow writes:
: Dean S. Messing  writes:
: > Michael Tokarev writes:
: > : Dean S. Messing wrote:
: > : []
: > : > []  That's what
: > : > attracted me to RAID 0 --- which seems to have no downside EXCEPT
: > : > safety :-).
: > : > 
: > : > So I'm not sure I'll ever figure out "the right" tuning.  I'm at the
: > : > point of abandoning RAID entirely and just putting the three disks
: > : > together as a big LV and being done with it.  (I don't have quite the
: > : > moxy to define a RAID 0 array underneath it. :-)
: > : 
: > : "Putting three disks together as a big LV" - that's exactly what
: > : "linear" md module.  
: > : It's almost as unsafe as raid0, but with
: > : linear read/write speed equal to speed of single drive...
: >
: > I understand I only get the speed of a single drive but I was not
: > aware of the safety factor.  I had intended to use snapshotting off
: > to a cheap USB drive each evening.  Will that not keep me safe within a
: > day's worth of data change?  I only learned about "snapshots" yesterday.
: > I'm utterly new to the disk array/LVM game.
: >
: > For that matter why not run a RAID-0 + LVM  across two of the three drives
: > and snapshot to the third?
: 
: LVM is not the same as LVM. What I mean is that you still have choices
: left.

Sorry, Goswin.  Even though you gave your meaning, I still don't
understand you here.  (I must be dense this morning.)
What does "LVM is not the same as LVM" mean?

: 
: One thing you have to think about though. An lvm volume group will not
: start cleanly with a disk missing but you can force it to start
: anyway. So a lost disk does not mean all data is lost. But it does
: mean that any logical volume with data on the missing disk will have
: serious data corruption.

If I am taking daily LVM snapshots will I not be able to reconstruct
the file system as of the last snapshot?  That's all I require.

I have also discovered "smartctl" and have read that if the short smartctl
tests are run daily and the long test weekly that the chances of being
caught "with my pants down" are quite low, even in a two disk RAID-0
config.  What is your opinion?

: Also lvm can do raid0 itself. For each logical volume you create you
: can specify the number of stripes to use. So I would abandon all
: thoughts of raid0 and replace them with using lvm.
: 
: Run one LV with 2 stripes on the first two disks and snapshot on the
: third.

Good idea. I waw aware of striped LV but did not think it would run
nearly as fast as RAID-0. Do you think two LV stripes will equal
RAID-0 for all kinds of read/write disk use?  There would seem to be
lots more than two RAID=0 stripes in the default case.  (I do know
enough to not run Striped LV with RAID-0 :-)

<snip>
: 
: I tested Raid10 and with far copies I got the full speed of all disks
: combined just like a raid0 would for reading and half speed for
: writing (as it has to write everything twice). I got pretty damn
: close to the theoretical limit it could get, which was surprising.

Very interesting! On three drives? When you said "half speed for
writes", did you mean "half the RAID-0 read speed" or "half the
physical device read speed"?

I hate the thought of half speed writes.  Some
of what I do requires more writing than reading---up-conversion of
Full HD video to 4Kx2K video, for example.  Given your test, I'll run
some tests with a three device RAID-10 with "far" copies.

But I would really like to know if I'm playing with fire putting my
whole system on a RAID-0/non-striped LVM device (or striped LVM device
w/o RAID) with daily snapshots, and good smartctl monitoring.

Dean
