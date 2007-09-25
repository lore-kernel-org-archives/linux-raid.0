From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: Help: very slow software RAID 5.
Date: Tue, 25 Sep 2007 11:31:45 +0200
Message-ID: <87r6knay66.fsf@informatik.uni-tuebingen.de>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>
	<Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>
	<20070919014919.DF19D10215F@medulla.enet.sharplabs.com>
	<Pine.LNX.4.64.0709190437050.4411@p34.internal.lan>
	<20070919174956.9497310209D@medulla.enet.sharplabs.com>
	<46F292E2.1090700@tmr.com>
	<20070920184738.441FD10208C@medulla.enet.sharplabs.com>
	<46F2E159.9030806@msgid.tls.msk.ru>
	<20070921005851.44E8910236D@medulla.enet.sharplabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070921005851.44E8910236D@medulla.enet.sharplabs.com> (Dean
	S. Messing's message of "Thu, 20 Sep 2007 17:58:51 -0700 (PDT)")
Sender: linux-raid-owner@vger.kernel.org
To: "Dean S. Messing" <deanm@sharplabs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Dean S. Messing" <deanm@sharplabs.com> writes:

> Michael Tokarev writes:
> : Dean S. Messing wrote:
> : []
> : > []  That's what
> : > attracted me to RAID 0 --- which seems to have no downside EXCEPT
> : > safety :-).
> : > 
> : > So I'm not sure I'll ever figure out "the right" tuning.  I'm at the
> : > point of abandoning RAID entirely and just putting the three disks
> : > together as a big LV and being done with it.  (I don't have quite the
> : > moxy to define a RAID 0 array underneath it. :-)
> : 
> : "Putting three disks together as a big LV" - that's exactly what
> : "linear" md module.  
> : It's almost as unsafe as raid0, but with
> : linear read/write speed equal to speed of single drive...
>
> I understand I only get the speed of a single drive was I was not
> aware of the safety factor.  I had intended to use snapshotting off
> to a cheap USB drive each evening.  Will that not keep me safe within a
> day's worth of data change?  I only learned about "snapshots" yesterday.
> I'm utterly new to the disk array/LVM game.
>
> For that matter why not run a RAID-0 + LVM  across two of the three drives
> and snapshot to the third?

LVM is not the same as LVM. What I mean is that you still have choices
left.

One thing you have to think about though. An lvm volume group will not
start cleanly with a disk missing but you can force it to start
anyway. So a lost disk does not mean all data is lost. But it does
mean that any logical volume with data on the missing disk will have
serious data corruption.

Also lvm can do raid0 itself. For each logical volume you create you
can specify the number of stripes to use. So I would abandon all
thoughts of raid0 and replace them with using lvm.

Run one LV with 2 stripes on the first two disks and snapshot on the
third.

> : Note also that the more drives you add to raid0-like config,
> : the more chances of failure you'll have - because raid0 fails
> : when ANY drive fails.  Ditto - for certain extent - for linear
> : md module and for "one big LV" which is basically the same thing.
>
> I understand the probability increases for additional drives.
>
> : By the way, before abandoming "R" in "RAID", I'd check whenever
> : the resulting speed with raid5 (after at least read-ahead tuning)
> : is acceptable, and use that if yes.
>
> My problem is not quite knowing what "acceptable" is.  I bought a Dell
> Precision 490 with two relatively fast SATA II drives. With RAID 0 I
> attain speeds of nearly 140 MB/s (using 2 drives) for reads and writes
> and the system is very snappy for everything, from processing 4Kx2K
> video to building a 'locate' datebase, to searching my very large mail
> archives for technical info.
>
> When I see the speed loss of software RAID 5 (writes are at 55MB/s and
> random reads are at 54 MB/s) for everything but seq. reads (and that
> only if I increase read-ahead from 512 to 16384 to get read speeds of
> about 110 MB/s I lose heart, esp. since I don't know the other
> consequences of increasing read-ahead by so much.
>
> : If no, maybe raid10 over
> : the same 3 drives will give better results.
>
> Does RAID10 work on three drives?  I though one needed 4 drives,
> with striping across a pair of mirrored pairs.

I tested Raid10 and with far copies I got the full speed of all disks
combined just like a raid0 would for reading and half speed for
writing (as it has to write everything twice). I got pretty damn
close to the theoretical limit it could get, which was surprising.

> Dean

MfG
        Goswin
