From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: mismatch_cnt again
Date: Tue, 10 Nov 2009 20:52:22 +0100
Message-ID: <20091110195222.GA2777@lazy.lzy>
References: <4AF5268D.60900@eyal.emu.id.au> <4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com> <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com> <87iqdlaujb.fsf@frosties.localdomain> <4AF74B61.6000102@rabbit.us> <20091109185632.GA2723@lazy.lzy> <73ebdcee169f46611d411755f9aaca5b.squirrel@neil.brown.name> <20091109215443.GA4143@lazy.lzy> <d99ca9481d2471073484c5d43d493b4d.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d99ca9481d2471073484c5d43d493b4d.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Peter Rabbitson <rabbit+list@rabbit.us>, Goswin von Brederlow <goswin-v-b@web.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi again,

> It seems we might have been talking at cross-purposes.
> 
> When I wrote about the need for a threat model, it was in the
> context of automatically determining which block was most
> likely to be in error (e.g. voting with a 3-drive RAID1 or
> fancy arithmetic with RAID6).  I do not believe there is any
> value in doing that.  At least not automatically in the kernel
> with the aim of just repairing which block was decided to be
> most wrong.
> 
> You now seem to be talking about the ability to find out which
> blocks are inconsistent.  That is very different.  I do agree there
> is value in that.  Maybe it should appear in the kernel logs,
> or maybe we could store the information and report in via sysfs
> (the former would certainly be easier).

maybe there is a misunderstanding between us! :-)

Automatic repair *might* be a far end target, but I do
agree, this needs to be clarified deeply.

I see the thing similarly to a previous comment from a
fellow poster.
To do:
1) detect which MD block is inconsistent
2) detect, when possible, which device component is responsible
3) trigger a repair action

This would be done all under user control, i.e. the user
will get the mismatch count, maybe with some hint on which
device could be guilty (RAID-6 or RAID-1/10 with multiple
redundancy) and then he could decide what to do.

The user will have full control and full *responsability*
on the action, but it will also be fully informed on what
the situation is.

The system will tell: block ABC is inconsistent, maybe
device /dev/sdX is guilty, you could: do nothing, resync
the parity, try to repair.

> I would be very happy to accept a patch which logged this
> information - providing it was careful not to overly spam the logs if there
> were lots and lots of errors.  I may even write on myself.

I could try to have a look into it, time permitting.

[mismatch_cnt=256]
> I would probably run a 'repair' to fix the difference, but that
> isn't firm advice.  It is quite probably that the block is not
> actively in use and so the inconsistency will never be noticed.

Exactly, that's why having the knowledge of *where*
the issue is would help already a lot!
 
> check/repair is primarily about reading every block on every device,
> and being ready to cope with read errors by overwriting with the
> correct data.  This is known as scrubbing I believe.
> I would normally just 'repair' every month or so.  If there are
> discrepancies I would like them reported and fixed.  I they happen
> often on a non-swap partition, I would like to knoe about it, otherwise
> I would rather they were just fixed.
> 'check' largely exists because it was trivial to implement given
> that 'repair' was being implemented, and it could concievably be useful,
> e.g. you have assembled an array read-only as you aren't at all sure the
> disks should form an array.  You run a 'check' to increase your
> confidence that all is OK without risking any change to any data incase
> you put the array together badly.

As I mentioned some times ago, I built a RAID-6, where
one disk, due to a strange cabling problem, was sometimes
returning wrong data (one bit flip, actually).
And this without any errors reported, i.e. a bit was
sometimes flipped, at the very end it seems, and it
was undetected by ECC/CRC/whatever.

This was noticed by the "check", so I ran a "repair", which
was, of course, making more damage...

What I did was to run a check, with one device after the
other failed (and then re-added, of course) on a RO MD device.

I was able to find the guilty disk and to fix the array
for good!

Now, this was a really lengthy process, I would have
preferred to have it done automatically and then have
a report on which *could* be the resposible device.

I agree with you that an automatic repair would have
not been the right choice, without knowing first what
was going on.

> drivers/md/raid1.c for RAID1
> drivers/md/raid5.c for RAID4/RAID5/RAID6
> 
> Look for where the resync_mismatches field is updated.

Thanks, I'll try to have a look!
 
bye,

-- 

piergiorgio
