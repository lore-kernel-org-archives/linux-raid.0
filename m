From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: Re: remark and RFC
Date: Wed, 16 Aug 2006 15:06:31 +0200 (MET DST)
Message-ID: <200608161306.k7GD6Vs29677@inv.it.uc3m.es>
References: <62b0912f0608160300g58bef34cj87300b32a83b17f0@mail.gmail.com>
Reply-To: ptb@inv.it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0608160300g58bef34cj87300b32a83b17f0@mail.gmail.com> from
 "Molle Bestefich" at "Aug 16, 2006 12:00:02 pm"
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Also sprach Molle Bestefich:"
[Charset ISO-8859-1 unsupported, filtering to ASCII...]
> Peter T. Breuer wrote:
> > 1) I would like raid request retries to be done with exponential
> >    delays, so that we get a chance to overcome network brownouts.
> >
> > I presume the former will either not be objectionable
> 
> You want to hurt performance for every single MD user out there, just

There's no performance drop!  Exponentially staged retries on failure
are standard in all network protocols ...  it is the appropriate
reaction in general, since stuffing the pipe full of immediate retries
doesn't allow the would-be successful transactions to even get a look in
against that competition.

> because things doesn't work optimally under enbd, which is after all a
> rather rare use case compared to using MD on top of real disks.

Strawman.

> Uuuuh..  yeah, no objections there.
> 
> Besides, it seems a rather pointless exercise to try and hide the fact
> from MD that the device is gone, since it *is* in fact missing.

Well, we don't really know that for sure.  As you know, it is
impossible to tell in general if the net has gone awol or is simply
heavily overloaded (with retry requests).

The retry on error is a good thing.  I am simply suggesting that if the
first retry also fails that we do some back off before trying again,
since it is now likely (lacking more knowledge) that the device is
having trouble and may well take some time to recover.  I would suspect
that an interval of 0 1 5 10 30 60s would be appropriate for retries.
One can cycle that twice for luck before giving up for good, if you
like.  The general idea in such backoff protocols is that it avoids
filling a fixed bandwidth channel with retries (the sum of a constant
times 1 + 1/2 + 1/4 + ..  is a finite proportion of the channel
bandwidth, but the sum of 1+1+1+1+1+...  is unbounded), but here also
there is an _additional_ assumption that the net is likely to have
brownouts and so we _ought_ to retry at intervals since retrying
immediately will definitely almost always do no good.

> Seems
> wrong at the least.

There is no effect on the normal request path, and the effect is
beneficial to successful requests by reducing the competing buildup of
failed requests, when they do occur.  In "normal " failures there is
zero delay anyway.  And further, the bitmap takes care of delayed
responses in the normal course of events.

> > 2) I would like some channel of communication to be available
> >    with raid that devices can use to say that they are
> >    OK and would they please be reinserted in the array.
> >
> > The latter is the RFC thing
> 
> It would be reasonable for MD to know the difference between
>  - "device has (temporarily, perhaps) gone missing" and
>  - "device has physical errors when reading/writing blocks",

I agree. The problem is that we can't really tell what's happening
(even in the lower level device) across a net that is not responding.
Enbd generally hides the problem for a short period of time, then gives
up and advises md (if only it could nowadays - I mean with the fr1
patch) that the device is down, and then tells md when the device comes
back, so that the bitmap can be discharged and the device be caught up.

The problem is that at the moment the md layer has no way of being told
that the device is OK again (and that it decides on its own account
that the device is bad when it sends umpteen retries within a short
period of time only to get them all rejected).

> because if MD knew that, then it would be trivial to automatically
> hot-add the missing device once available again.  Whereas the faulty
> one would need the administrator to get off his couch.

Yes. The idea is that across the net approximately ALL failures are
temporary ones, to a value of something like 99.99%.  The cleaning lady
is usually dusting the on-off switch on the router.

> This would help in other areas too, like when a disk controller dies,
> or a cable comes (completely) loose.
> 
> Even if the IDE drivers are not mature enough to tell us which kind of
> error it is, MD could still implement such a feature just to help
> enbd.
> 
> I don't think a comm-channel is the right answer, though.
> 
> I think the type=(missing/faulty) information should be embedded in
> the I/O error message from the block layer (enbd in your case)
> instead, to avoid race conditions and allow MD to take good decisions
> as early as possible.

That's a possibility. I certainly get two types of error back in the
enbd driver .. remote error or network error. Remote error is when
we get told by the other end that the disk has a problem. Network
error is when we hear nothing, and have a timeout.

I can certainly pass that on. Any suggestions?


> The comm channel and "hey, I'm OK" message you propose doesn't seem
> that different from just hot-adding the disks from a shell script
> using 'mdadm'.

Talking through userspace has subtle deadlock problems.  I wouldn't rely
on it in this kind of situation.  Blocking a device can lead to a file
system being blocked and processes getting stalled for all kinds of
peripheral reasons, for example.  I have seen file descriptor closes
getting blocked, to name the bizarre. I am pretty sure that removal
requests will be blocked when requests are outstanding.

Another problem is that enbd has to _know_ it is in a raid array, and
which one, in order to send the ioctl.  That leads one to more or less
require that the md array tell it.  One could build this into the mdadm
tool, but one can't guarantee that everyone uses that (same) mdadm tool,
so the md driver gets nominated as the best place for the code that
does that.

> > When the device felt good (or ill) it notified the raid arrays it
> > knew it was in via another ioctl (really just hot-add or hot-remove),
> > and the raid layer would do the appropriate catchup (or start
> > bitmapping for it).
> 
> No point in bitmapping.  Since with the network down and all the
> devices underlying the RAID missing, there's nowhere to store data.
> Right?

Only one of two devices in a two-device mirror is generally networked.
The standard scenario is two local disks per network node.  One is a
mirror half for a remote raid, the other is the mirror half for a local
raid (which has a remote other half on the remote node).

More complicated setups can also be built - there are entire grids of
such nodes arranged in a torus, with local redundancy arranged in
groups of three neighbours, each with two local devices and one remote
device. Etc.

> Some more factual data about your setup would maybe be good..

It's not my setup! Invent your own :-).

> > all I can do is make the enbd device block on network timeouts.
> > But that's totally unsatisfactory, since real network outages then
> > cause permanent blocks on anything touching a file system
> > mounted remotely.  People don't like that.
> 
> If it's just this that you want to fix, you could write a DM module
> which returns I/O error if the request to the underlying device takes
> more than 10 seconds.

I'm not sure that another layer helps. I can timeout requests myself in
10s within enbd if I want to.  The problem is that if I take ten seconds
for each one when the net is down memory will fill with backed up
requests.  The first one that is failed (after 10s) then triggers an
immediate retry from md, which also gets held for 10s.  We'll simply get
huge pulses of failures of entire backed up memory spaced at 10s.  :-o

I'm pretty sure from reports that md would error the device offline
after a pulse like that.  If it doesn't, then anyway enbd would decide
after 30s or so that the remote end was down and take itself offline.
One or the other would cause md to expell it from the array.  I could
try hot-add from enbd when the other end comes back, but we need to know
we are in an array (and which) in order to do that.

> Layer that module on top of the RAID, and make your enbd device block
> on network timeouts.

It shifts the problem to no avail, as far as I understand you, and my
understanding is likely faulty.  Can you be more specific about how this
attacks the problem?

> Now the RAID array doesn't see missing disks on network outages, and

It wouldn't see them anyway when enbd is in normal mode - it blocks.
The problem is that that behaviour is really bad for user satisfaction!

Enbd used instead to tell the md device that it was feeling ill, error
all requests, allowing md to chuck it out of the array. Then enbd would
tell the md device when it was feeling well again, and make md
reinsert it in the array. Md would catch up using the bitmap.

Right now, we can't really tell md we're feeling ill (that would be a
HOT_ARRRGH, but md doesn't have that). If we could, then md could
decide on its own to murder all outstanding requests for us and
chuck us out, with the implicit understanding that we will come back
again soon and then the bitbap can catcj us up.

We can't do a HOT_REMOVE while requests are outstanding, as far as I
know. 

> users get near-instant errors when the array isn't responsive due to a
> network outage.

I agree that the lower level device should report errors quickly up to
md. The problem is that that leads to it being chucked out
unceremonially, for ever and a day ..

  1) md shouldn't chuck us out for a few errors - nets are like that
  2) we should be able to chuck ourselves out when we feel the net is
     weak
  3) we should be able to chuck ourselves back in when we feel better
  4) for that to happen, we need to have been told by md when we are
    in an array and which

I simply proposed that (1) has the easy solution of md doing retries with
exponential backoff for a while, instead of chucking us out.

The rest needs discussion. Maybe it can be done in userspace, but be
advised that I think that is remarkably tricky! In particular, it's
almost impossible to test adequately ... which alone would make
me aim for an embedded solution (i.e. driver code).

Peter

