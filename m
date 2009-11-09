From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: mismatch_cnt again
Date: Mon, 9 Nov 2009 22:54:43 +0100
Message-ID: <20091109215443.GA4143@lazy.lzy>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com> <4AF5268D.60900@eyal.emu.id.au> <4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com> <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com> <87iqdlaujb.fsf@frosties.localdomain> <4AF74B61.6000102@rabbit.us> <20091109185632.GA2723@lazy.lzy> <73ebdcee169f46611d411755f9aaca5b.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <73ebdcee169f46611d411755f9aaca5b.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Peter Rabbitson <rabbit+list@rabbit.us>, Goswin von Brederlow <goswin-v-b@web.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Well...

> Is this an offer to submit a patch ?? :-)

almost, I was looking into RAID-6 for this, but unfortunately
it seems I'll need external manpower too... :-)

> I disagree.  You do need a model.  The particular features of the
> model would be the weight and wind-resistance of the person so that
> you can estimate what extra wind resistance is needed to reduce terminal
> velocity such that the impact will be something that the person's
> legs can absorb.  So you also need the model to describe the legs
> in enough detail so that a suitable target terminal velocity can
> be determined.

Well, sorry, but IMHO this is needed only when you design
the parachute, not when you jump out of the plane.

It seems that here some people, including me, would have
found useful such a feature.
For example I've a RAID-10 which shows a mismatch_cnt of
256, but everything seems to work fine.
The disks are new, no SMART errors or else.
Where the mismatch belong I do not know.
What should I do? Try to fill up the MD device and then
see if the mismatch is still there?
It would be much better to know which file, if any, is
affected and then take the proper countermeasures.

At the moment, since everything runs fine, I do not dare
to start a resync, since it will not be better than
leaving the things like they're right now.
I'm in the hope that some file creation or similar will fix
the mismatch.
Or do you have a better option?

> If we proactively hand out parachutes that can just barely land a
> small dog safely, then we aren't doing any people any favours,
> and probably are making their situation less safe because they are
> more likely to take a risk in the belief that their parachute
> will protect them - which it might not.

Do not over stretch the example.
The parachute, in the MD case, will not remove any risk,
it will simply help people to manage a damage, that might
occure for any reasons, including SW bugs, better.

I mean, will you swear that the actual RAID software will
never cause, by its own, a mismatch between disks?
I guess not.
So, why not to give a mechanism to enable user to look
further into mismatches and be able to take a proper action?

> Certainly manpower is an issue - and it is pointless spending it
> on something that you think sounds nice, but have no evidence that it
> will actually address a real need.

It seems some people, here, have this need.
So, it is real.

I see not only myself asking for such features like returning
the block address of the mismatch count or trigger a *proper*
repair instead of a random one.

Frankly speaking, the whole resync/repair concept is, at the
moment, a waste of manpower (when it was done), since repairing
or not a RAID does not change the underlayining situation.
It just sets the mismatch_cnt to zero, but if an error is
present there are good chances it will still be there.
And this is the problem: after the resync people will *feel*
secure, people *feel* safe (because there is a "repair"),
but in the end the risk is simply increased (as per your
example about dog-parachute).

Again, manpower is always an issue and priorities are needed,
of course, but what if we vote, here, for such a feauture and
then it turns out it is "most wanted"?

Written that, since complaining alone does not help, how to
proceed in the case I would like to print the MD block address
of a mismatch? Which source code file would be more sensible
to look into?

Thanks for you attention and sorry for the rant,

P.S.: I like very much the MD thing, that's the reason
why I would like to see it improved.

bye,

-- 

piergiorgio
