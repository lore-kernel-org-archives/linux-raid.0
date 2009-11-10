From: "NeilBrown" <neilb@suse.de>
Subject: Re: mismatch_cnt again
Date: Tue, 10 Nov 2009 11:17:59 +1100
Message-ID: <d99ca9481d2471073484c5d43d493b4d.squirrel@neil.brown.name>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>
    <4AF5268D.60900@eyal.emu.id.au>
    <4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>
    <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com>
    <87iqdlaujb.fsf@frosties.localdomain> <4AF74B61.6000102@rabbit.us>
    <20091109185632.GA2723@lazy.lzy>
    <73ebdcee169f46611d411755f9aaca5b.squirrel@neil.brown.name>
    <20091109215443.GA4143@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091109215443.GA4143@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Peter Rabbitson <rabbit+list@rabbit.us>, Goswin von Brederlow <goswin-v-b@web.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, November 10, 2009 8:54 am, Piergiorgio Sartor wrote:
> Well...
>
>> Is this an offer to submit a patch ?? :-)
>
> almost, I was looking into RAID-6 for this, but unfortunately
> it seems I'll need external manpower too... :-)
>
>> I disagree.  You do need a model.  The particular features of the
>> model would be the weight and wind-resistance of the person so that
>> you can estimate what extra wind resistance is needed to reduce terminal
>> velocity such that the impact will be something that the person's
>> legs can absorb.  So you also need the model to describe the legs
>> in enough detail so that a suitable target terminal velocity can
>> be determined.
>
> Well, sorry, but IMHO this is needed only when you design
> the parachute, not when you jump out of the plane.
>
> It seems that here some people, including me, would have
> found useful such a feature.
> For example I've a RAID-10 which shows a mismatch_cnt of
> 256, but everything seems to work fine.
> The disks are new, no SMART errors or else.
> Where the mismatch belong I do not know.
> What should I do? Try to fill up the MD device and then
> see if the mismatch is still there?
> It would be much better to know which file, if any, is
> affected and then take the proper countermeasures.
>


It seems we might have been talking at cross-purposes.

When I wrote about the need for a threat model, it was in the
context of automatically determining which block was most
likely to be in error (e.g. voting with a 3-drive RAID1 or
fancy arithmetic with RAID6).  I do not believe there is any
value in doing that.  At least not automatically in the kernel
with the aim of just repairing which block was decided to be
most wrong.

You now seem to be talking about the ability to find out which
blocks are inconsistent.  That is very different.  I do agree there
is value in that.  Maybe it should appear in the kernel logs,
or maybe we could store the information and report in via sysfs
(the former would certainly be easier).

I would be very happy to accept a patch which logged this
information - providing it was careful not to overly spam the logs if there
were lots and lots of errors.  I may even write on myself.




> At the moment, since everything runs fine, I do not dare
> to start a resync, since it will not be better than
> leaving the things like they're right now.
> I'm in the hope that some file creation or similar will fix
> the mismatch.
> Or do you have a better option?

It is possible that a resync will could improve
the situation.  Having a block that will sometimes read with
one value and sometimes with a different value could easily
confuse something - particularly a filesystem.

I would probably run a 'repair' to fix the difference, but that
isn't firm advice.  It is quite probably that the block is not
actively in use and so the inconsistency will never be noticed.


>
>> If we proactively hand out parachutes that can just barely land a
>> small dog safely, then we aren't doing any people any favours,
>> and probably are making their situation less safe because they are
>> more likely to take a risk in the belief that their parachute
>> will protect them - which it might not.
>
> Do not over stretch the example.
> The parachute, in the MD case, will not remove any risk,
> it will simply help people to manage a damage, that might
> occure for any reasons, including SW bugs, better.
>
> I mean, will you swear that the actual RAID software will
> never cause, by its own, a mismatch between disks?
> I guess not.
> So, why not to give a mechanism to enable user to look
> further into mismatches and be able to take a proper action?
>
>> Certainly manpower is an issue - and it is pointless spending it
>> on something that you think sounds nice, but have no evidence that it
>> will actually address a real need.
>
> It seems some people, here, have this need.
> So, it is real.
>
> I see not only myself asking for such features like returning
> the block address of the mismatch count or trigger a *proper*
> repair instead of a random one.
>
> Frankly speaking, the whole resync/repair concept is, at the
> moment, a waste of manpower (when it was done), since repairing
> or not a RAID does not change the underlayining situation.
> It just sets the mismatch_cnt to zero, but if an error is
> present there are good chances it will still be there.
> And this is the problem: after the resync people will *feel*
> secure, people *feel* safe (because there is a "repair"),
> but in the end the risk is simply increased (as per your
> example about dog-parachute).

check/repair is primarily about reading every block on every device,
and being ready to cope with read errors by overwriting with the
correct data.  This is known as scrubbing I believe.
I would normally just 'repair' every month or so.  If there are
discrepancies I would like them reported and fixed.  I they happen
often on a non-swap partition, I would like to knoe about it, otherwise
I would rather they were just fixed.
'check' largely exists because it was trivial to implement given
that 'repair' was being implemented, and it could concievably be useful,
e.g. you have assembled an array read-only as you aren't at all sure the
disks should form an array.  You run a 'check' to increase your
confidence that all is OK without risking any change to any data incase
you put the array together badly.


>
> Again, manpower is always an issue and priorities are needed,
> of course, but what if we vote, here, for such a feauture and
> then it turns out it is "most wanted"?
>
> Written that, since complaining alone does not help, how to
> proceed in the case I would like to print the MD block address
> of a mismatch? Which source code file would be more sensible
> to look into?

drivers/md/raid1.c for RAID1
drivers/md/raid5.c for RAID4/RAID5/RAID6

Look for where the resync_mismatches field is updated.


>
> Thanks for you attention and sorry for the rant,
>
> P.S.: I like very much the MD thing, that's the reason
> why I would like to see it improved.
>

Thanks for your interest!

NeilBrown

