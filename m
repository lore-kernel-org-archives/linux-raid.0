From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Sun, 2 Mar 2008 22:19:02 +0100
Message-ID: <bb145bd20803021319o28df011sab954aa58a1c01be@mail.gmail.com>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
	 <47CAC5BF.6060600@msgid.tls.msk.ru>
	 <bb145bd20803020832x744c2674nd0a6a30e445b5453@mail.gmail.com>
	 <47CAF30F.7040502@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47CAF30F.7040502@msgid.tls.msk.ru>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-raid.ids

>  So the responsibility problem is solved here, right?

It is? I'm not sure yet.

>  I mean, if there's no resync going on (the case with --assume-clean), the rest of the system works as expected, right?

Yes, but the array itself is still dog slow and resync shouldn't have
that much impact on performance. What's more

mdadm --create /dev/md0 -l5 -n4 /dev/sd[bcde] -e 1.0

leaves room for tuning but is basically fine, whereas the original case

mdadm --create /dev/md0 --verbose --metadata=1.0 --homehost=jesus -n4
-c1024 -l5 --bitmap=internal --name tb-storage -ayes /dev/sd[bcde]

is all but unusable, which leaves two prime suspects

- the bitmap
- the chunk size

Could it be that some cache or other somewhere in the I/O stack
(probaby the controller itself) is too small for the 1MB chunks and
the disks are forced to work serially? The Promise has no RAM of
course but maybe it does have small send / receive buffers.
On the host side the I/O schedulers are set to cfq which is said to
play well with md-raid but I can experiment with that as well.

>  Note that mkfs now has to do 3x more work, too - since the device is 3x (for 4-drive raid5) larger.

Yes, but that just means there's more inode tables to write. It takes
longer, but the speed shouldn't change much.

>  Ok.  For now I don't see a problem (over than that there IS a problem
>  somewhere - obviously).  Interrupts are ok.  System time (10.1%) in
>  second case doesn't look right, but it was 8.1% before...

Too high? Too low?

>  Only 2 guesses left.

I'm fine with guesses, thank you :-) Of course a deus-ex-machina
solution (deus == Neil) is nice, too :)

>  First, try to disable bitmaps on the raid array

Maybe I did that by accident for the various vmstat data for different
RAID levels I posted previously. At least I forgot to explicitely
specify a bitmap for those tests (see above).

It's my understanding that the bitmap is a raid chunk level journal to
speed up recovery, correct? Doing that reduces the window during which
a second disk can die with catastrophic consequences -> bitmaps are a
good thing, especially on an array where a full rebuild takes hours.
Seeing as the primary purpose of the raid5 is fault tolerance I could
live with a performance penalty but why is it *that* slow?

If I put the bitmap on an external drive it will be a lot faster - but
what happens, when the bitmap "goes away" (because that disk fails,
isn't accessible, etc)?
Is it goodbye array or is the worst case a full resync? How well is
the external bitmap supported?
(That same consideration kept me from using external journals for ext3.)

>  And second, the whole thing looks pretty much like a more general
>  problem discussed here and elsewhere last few days.  I mean handling
>  of parallel reads and writes - when single write may stall reads
>  for quite some time and vise versa.

Any thread names to recommend?

>  I see it every day on disks without NCQ/TCQ [...] your disks
>  and/or controllers (or the combination) don't even support NCQ

The old IDE disks on mixed noname controllers array does well enough
and NCQ / ncq doesn't even show up in dmesg. Definitely something to
consider but probably not the root cause.

Back to testing ...

C.
