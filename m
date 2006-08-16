From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: Re: remark and RFC
Date: Thu, 17 Aug 2006 00:19:36 +0200 (MET DST)
Message-ID: <200608162219.k7GMJaI23352@inv.it.uc3m.es>
References: <62b0912f0608161419k22253d3lfd82fba4ff14712a@mail.gmail.com>
Reply-To: ptb@inv.it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0608161419k22253d3lfd82fba4ff14712a@mail.gmail.com> from
 "Molle Bestefich" at "Aug 16, 2006 11:19:23 pm"
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Also sprach Molle Bestefich:"
> 
> > See above. The problem is generic to fixed bandwidth transmission
> > channels, which, in the abstract, is "everything". As soon as one
> > does retransmits one has a kind of obligation to keep retransmissions
> > down to a fixed maximum percentage of the potential traffic, which
> > is generally accomplished via exponential backoff (a time-wise
> > solution, in other words, sdeliberately mearing retransmits out along
> > the time axis in order to prevent spikes).
> 
> Right, so with the bandwidth to local disks being, say, 150MB/s, an
> appropriate backoff would be 0 0 0 0 0 0.1 0.1 0.1 0.1 secs.  We can
> agree on that pretty fast.. right? ;-).

Whatever .. the multiplying constant can be anything you like, and the
backoff can be statistical in nature, not deterministic.  It merely has
to backoff rather than pile in retries all at once and immediately.


> > The md layers now can generate retries by at least one mechanism that I
> > know of ..  a failed disk _read_ (maybe of existing data or parity data
> > as part of an exterior write attempt) will generate a disk _write_ of
> > the missed data (as reconstituted via redundancy info).
> >
> > I believe failed disk _write_ may also generate a retry,
> 
> Can't see any reason why MD would try to fix a failed write, since
> it's not likely to be going to be successful anyway.

Maybe.


> > Such delays may in themselves cause timeouts in md - I don't know. My
> > RFC (maybe "RFD") is aimed at raising a flag saying that something is
> > going on here that needs better control.
> 
> I'm still not convinced MD does retries at all..

It certainly attempts a rewrite after a failed read. Neil can say if
anything else is tried.  Bitmaps can be used  to allow writes to fail
first time and then to be synced up later.

> > What the upper layer, md, ought to do is "back off".
> 
> I think it should just kick the disk.

That forces us to put it back in when the net comes back to life, which 
is complicated. Life would be less complicated if it were less prone
to being kicked out in the first place.


> > We are discussing _error_ semantics.  There is no bad effect at all on
> > normal working!
> 
> In the past, I've had MD run a box to a grinding halt more times than
> I like.  It always results in one thing: The user pushing the big red
> switch.

I agree that the error path in md probably contains some deadlock. My
observation also. That's why I prefer to react to a net brownout by
taking the lower device offline and erroring outstanding requests,
PROVIDED we can put it back in again sanely.  That ain't the case at the
moment, so I'd prefer if MD would not be quite so trigger-happy on the
expulsions, which I _believe_ occurs because the lower level device
errors too many requests all at once.

> That's not acceptable for a RAID solution.  It should keep working,
> without blocking all I/O from userspace for 5 minutes just because it
> thinks it's a good idea to hold up all I/O requests to underlying
> disks for 60s each, waiting to retry them.

You miscalculate here ... holding up ONE request for a retry does not
hold up ALL requests.  Everything else goes through. And I proposed
that we only backoff after trying again immediately.

Heck, that's probably wrong, mathematically - that can double the
bandwidth occupation per timeslice, meaning that we need to reserve 50%
bandwidth for errors ..  ecch.  Nope - one _needs_ some finite minimal
backoff.  One jiffy is enough.  That moves reries into the next time
slice...  umm, and we need to randomly space them out a few more jiffies
too, in a poisson distribution, in order to avoid filling the next
timeslice to capacity with errors. Yep, I'm convinced .. need
exponential statistical backoff. Each retry needs to be delayed
by an amount of time that comes from a poisson distribution
(exponential decay). The average backoff can be a jiffy.


> > The effect on normal working should even be _good_ when errors
> > occur, because now max bandwidth devoted to error retries is
> > limited, leaving more max bandwidth for normal requests.
> 
> Assuming you use your RAID component device as a regular device also,

?? Oh .. you are thinking of the channel to the device. I was
thinking of the kernel itself.  It has to spend time and memory on this.
Allowing it to concentrate on other io that will work without having to
cope with a sharp spike of errors at the temporarily incapacitated low
level device speeds up _other_ devices.

> and that the underlying device is not able to satisfy the requests as
> fast as you shove them at it.  Far out ;-).

See above.

> > > Since the knowledge that the block device is on a network resides in
> > > ENBD, I think the most reasonable thing to do would be to implement a
> > > backoff in ENBD?  Should be relatively simple to catch MD retries in
> > > ENBD and block for 0 1 5 10 30 60 seconds.
> >
> > I can't tell which request is a retry.  You are allowed to write twice
> > to the same place in normal operation! The knowledge is in MD.
> 
> I don't think you need to either - if ENBD only blocks 10 seconds
> total, and fail all requests after that period of time has lapsed
> once, then that could have the same effect.

When the net fails, all writes to the low level device will block for
10s, then fail all at once.  Md reacts by tossing the disk out.  It
probably does that because it sees failed writes (even if well intended
correction attempts provoked by a failed read).  It could instead wait a
while and retry.  That would succeed, since the net would decongest
meanwhile. That would make the problem disappear.

The alternative is that the low level device tries to insert itself
back in the array once the net comes back up. For that to happen it has
to know it was in one, has been tolssed out, and needs to get back. All
complicated.


> > In contrast, the net device will take 10-30s to generate a timeout for
> > the read attempt, followed by 0s to error the succeeding write request,
> > since the local driver of the net device will have taken the device
> > offline as it can't get a response in 30s.
> 
> > At that point all io to the device will fail, all hell will break
> > loose in the md device,
> 
> Really?

Well, zillions of requests will have been errored out all at once. At
least the 256-1024 backed up in the device queue.

> > and the net device will be ejected from the array
> 
> Fair nuff..
> 
> > in a flurry of millions of failed requests.
> 
> Millions?  Really?

Hundreds. 

> > > In the case where requests can't be delivered over the network (or a
> > > SATA cable, whatever), it's a clear case of "missing device".
> >
> > It's not so clear.
> 
> Yes it is.  If the device is not faulty, but there's a link problem,
> then the device is just... missing :-).  Whether you actually tell MD
> that it's missing or not, is another story.

We agree that not telling it simply leads to blocking behaviour when 
the net is really out forever, which is not acceptable. Telling it
after 30s results in us occasionally having to say "oops, no, I'm
sorry, we're OK again" and try and reinsert ourselves in the array,
which we currently can't do easily. I would prefer we don't tell md
until a good long time has passed, and it do retries with exp backoff
meanwhile. The array performance should not be impacted. There
will be another disk there still working.

> > 10-30s delays are perfectly visible in ordinary tcp and mean nothing
> > more than congestion.  How many times have you sat there hitting the
> > keys and waiting for something to move on the screen?
> 
> I get your point, I think.
> 
> There's no reason to induce the overhead of a MD sync-via-bitmap, if
> increasing the network timeout in ENBD will prevent the component
> device from being kicked in the first place.  As long as the timeout

There's no sensible point to set a timeout. Try an ssh session .. you
can reconnect to it an hour after cutting the cable.

> doesn't cause too much grief for the end user.
> 
> OTOH, a bitmap sync can happen in the background, so as long as the
> disk is not _constantly_ being removed/added, it should be fine to
> kick it real fast from the array.

Bun complicated to implement, as things are, since there is no special
comms channel available with the md driver.

> > simpler is what I had in the FR1/5 patches:
> >
> >     1) MD advises enbd it's in an array, or not
> >     2) enbd tells MD to pull it in and out of that array as
> >        it senses the condition of the network connection
> >
> > The first required MD to use a special ioctl to each device in an
> > array.
> >
> > The second required enbd to use the MD HOT_ADD and HOT_REMOVE ioctl
> > commands, being careful also to kill any requests in flight so that
> > the remove or add would not be blocked in md or the other block device
> > layers.  (In fact, I think I needed to add HOT_REPAIR as a special extra
> > command, but don't quote me on that).
> >
> > That communications layer would work if it were restored.
> 
> > So .. are we settling on a solution?
> 
> I'm just proposing counter-arguments.
> Talk to the Neil :-).

He readeth the list!

> > I like the idea that we can advise MD that we are merely
> > temporarily out of action.  Can we take it from there?  (Neil?)

Peter

