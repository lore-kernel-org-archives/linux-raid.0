From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: extremely tiny race window in raid1
Date: Wed, 12 Jan 2005 01:57:24 +0100
Message-ID: <k89eb2-rnt.ln1@news.it.uc3m.es>
References: <mcndb2-6m8.ln1@news.it.uc3m.es> <16868.28347.248250.674152@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
> On Tuesday January 11, ptb@lab.it.uc3m.es wrote:
> >  From raid1.c in 2.6.8.1:
> > 
> >          * inc refcount on their rdev.  Record them by setting
> >          * bios[x] to bio
> >          */
> > -       disks = conf->raid_disks;
> >         spin_lock_irq(&conf->device_lock);
> > +       disks = conf->raid_disks;
> >         for (i = 0;  i < disks; i++) {
> >                 if (conf->mirrors[i].rdev &&
> >                     !conf->mirrors[i].rdev->faulty) {
> > 
> > (there are plenty of other places where small things like that happen,
> > and normally I say "shucks, he'll spot it and correct it, and it's no
> > biggie anyway", but my conscience is getting at me to report at least
> > some of them).
> 
> Patches are always welcome (preferably against the most recent kernel,
> and with headers that make it easy to apply) -- I'm sure I miss plenty
> of stuff.
> 
> This one, however, is not needed.  raid_disks simply cannot change at
> this point.

It's changed in "run"

         conf->raid_disks = mddev->raid_disks;

and I don't see anywhere else.  But that's not quite the whole point -
the device lock guards against changes in the device configuration, and
whether or not raid_disks is currently ever changed or not, the lock
ought to guard it with the rest of the configuration, as it is part of
the device configuration. It means one does not have to study the rest
of the code in order to discover if it is right or not - it would be
right by inspection.

I was going to suggest you add a "valid disk count" anyway, as that
would avoid all those points where one goes counting the number of valid
disks (under spinlock :).  The above code block is one such point (but
from the point of code transparancy and robustness I actually prefer
that you recount every time, even every request, as you do - the extra
count field would only be for efficiency).

Anyway, you are right that raid_disks is set essentially once, just
before i/o ever starts, so its not semantically possible to see it
change here, which is during i/o. 


> It is only changed by raid1_reshape,

Oh, I didn't see that, but it makes sense.  It would logically be
changed by anything that changes the device configuration, which is why
morally I feel it ought to be guarded by the device lock that protects
the device configuration.

> and that raises a barrier to
> new requests and then waits for all current requests to complete
> before changing raid_disks.

Let me put it another way - is there a good reason for leaving that
line outside the lock that immediately follows it?

Can you really guarrantee that there are no requests in flight when you
do a reshape? (I don't know, I just ask ...).

Peter

