From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: remark and RFC
Date: Wed, 16 Aug 2006 23:19:23 +0200
Message-ID: <62b0912f0608161419k22253d3lfd82fba4ff14712a@mail.gmail.com>
References: <62b0912f0608160728x5328c513t582ac560e8c0b681@mail.gmail.com>
	 <200608161901.k7GJ1sv01583@inv.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200608161901.k7GJ1sv01583@inv.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: ptb@inv.it.uc3m.es
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> > > We can't do a HOT_REMOVE while requests are outstanding,
> > > as far as I know.
>
> Actually, I'm not quite sure which kind of requests you are
> talking about.
>
> Only one kind. Kernel requests :). They come in read and write
> flavours (let's forget about the third race for the moment).

I was wondering whether you were talking about requests from eg.
userspace to MD, or from MD to the raw device.  I guess it's not that
important really, that's why I asked you off-list.  Just getting in
too deep, and being curious.


> "Pipe" refers to a channel of fixed bandwidth.  Every communication
> channel is one.  The "pipe" for a local disk is composed of the bus,
> disk architecture, controller, and also the kernel architecture layers.

[snip]

> See above. The problem is generic to fixed bandwidth transmission
> channels, which, in the abstract, is "everything". As soon as one
> does retransmits one has a kind of obligation to keep retransmissions
> down to a fixed maximum percentage of the potential traffic, which
> is generally accomplished via exponential backoff (a time-wise
> solution, in other words, sdeliberately mearing retransmits out along
> the time axis in order to prevent spikes).

Right, so with the bandwidth to local disks being, say, 150MB/s, an
appropriate backoff would be 0 0 0 0 0 0.1 0.1 0.1 0.1 secs.  We can
agree on that pretty fast.. right? ;-).


> The md layers now can generate retries by at least one mechanism that I
> know of ..  a failed disk _read_ (maybe of existing data or parity data
> as part of an exterior write attempt) will generate a disk _write_ of
> the missed data (as reconstituted via redundancy info).
>
> I believe failed disk _write_ may also generate a retry,

Can't see any reason why MD would try to fix a failed write, since
it's not likely to be going to be successful anyway.


> Such delays may in themselves cause timeouts in md - I don't know. My
> RFC (maybe "RFD") is aimed at raising a flag saying that something is
> going on here that needs better control.

I'm still not convinced MD does retries at all..


> What the upper layer, md, ought to do is "back off".

I think it should just kick the disk.


> > I don't think it's wise to pollute these simple mechanics with a
> > "maybe it's in a sort-of failing due to a network outage, which might
> > just be a brownout" scenario.  Better to solve the problem in a more
> > appropriate place, somewhere that knows about the fact that we're
> > simulating a block device over a network connection.
>
> I've already suggested a simple mechanism above .. "back off on the
> retries, already". It does no harm to local disk devices.

Except if the code path gets taken, and the user has to wait
10+20+30+60s for each failed I/O request.


> If you like, the constant of backoff can be based on how long it took
> the underlying device to signal the io request as failed. So a local
> disk that replies "failed" immediately can get its range of retries run
> through in a couple of hop skip and millijiffies. A network device that
> took 10s to report a timeout can get its next retry back again in 10s.
> That should give it time to recover.

That sounds saner to me.


> > Not introducing network-block-device aware code in MD is a good way to
> > avoid wrong code paths and weird behaviour for real block device
> > users.
>
> Uh, the net is everywhere.  When you have 10PB of storage in your
> intelligent house's video image file system, the parts of that array are
> connected by networking room to room.  Supecomputers used to have simple
> networking between each computing node.  Heck, clusters still do :).
> Please keep your special case code out of the kernel :-).

Uhm.


> > "Missing" vs. "Faulty" is OTOH a pretty simple interface, which maps
> > fine to both real disks and NBDs.
>
> It may well be a solution. I think we're still at the stage of
> precisely trying to identify the problem too! At the moment, most
> of what I can say is "definitely, there is something wrong with the
> way the md layer reacts or can be controlled with respect to
> networking brown-outs and NBDs".

> > Not for real disks, there you are just causing unbearable delays for
> > users for no good reason, in the event that this code path is taken.
>
> We are discussing _error_ semantics.  There is no bad effect at all on
> normal working!

In the past, I've had MD run a box to a grinding halt more times than
I like.  It always results in one thing: The user pushing the big red
switch.

That's not acceptable for a RAID solution.  It should keep working,
without blocking all I/O from userspace for 5 minutes just because it
thinks it's a good idea to hold up all I/O requests to underlying
disks for 60s each, waiting to retry them.


> The effect on normal working should even be _good_ when errors
> occur, because now max bandwidth devoted to error retries is
> limited, leaving more max bandwidth for normal requests.

Assuming you use your RAID component device as a regular device also,
and that the underlying device is not able to satisfy the requests as
fast as you shove them at it.  Far out ;-).


> > Since the knowledge that the block device is on a network resides in
> > ENBD, I think the most reasonable thing to do would be to implement a
> > backoff in ENBD?  Should be relatively simple to catch MD retries in
> > ENBD and block for 0 1 5 10 30 60 seconds.
>
> I can't tell which request is a retry.  You are allowed to write twice
> to the same place in normal operation! The knowledge is in MD.

I don't think you need to either - if ENBD only blocks 10 seconds
total, and fail all requests after that period of time has lapsed
once, then that could have the same effect.


> In contrast, the net device will take 10-30s to generate a timeout for
> the read attempt, followed by 0s to error the succeeding write request,
> since the local driver of the net device will have taken the device
> offline as it can't get a response in 30s.

> At that point all io to the device will fail, all hell will break
> loose in the md device,

Really?

> and the net device will be ejected from the array

Fair nuff..

> in a flurry of millions of failed requests.

Millions?  Really?


> > In the case where requests can't be delivered over the network (or a
> > SATA cable, whatever), it's a clear case of "missing device".
>
> It's not so clear.

Yes it is.  If the device is not faulty, but there's a link problem,
then the device is just... missing :-).  Whether you actually tell MD
that it's missing or not, is another story.

> 10-30s delays are perfectly visible in ordinary tcp and mean nothing
> more than congestion.  How many times have you sat there hitting the
> keys and waiting for something to move on the screen?

I get your point, I think.

There's no reason to induce the overhead of a MD sync-via-bitmap, if
increasing the network timeout in ENBD will prevent the component
device from being kicked in the first place.  As long as the timeout
doesn't cause too much grief for the end user.

OTOH, a bitmap sync can happen in the background, so as long as the
disk is not _constantly_ being removed/added, it should be fine to
kick it real fast from the array.


> Really, in my experience, a real good thing to do is mark the device as
> temporarily failed, clear all queued requests with error, thus making
> memory available, yea, even for tcp sockets, and then let the device
> reinsert itself in the MD array when contact is reestablished across the
> net.  At that point the MD bitmap can catch up the missed requests.
>
> This is complicated by the MD device's current tendency to issue
> retries (one way or the other .. does it? How?). It's interfering
> with the simple strategy I just sggested.

There was a patch floating around at one time in which MD would ignore
a certain amount of errors from a component device.  I think.  Can't
remember the details nor the reasoning for it.  Sounded stupid to me
at the time, I remember :-).


> simpler is what I had in the FR1/5 patches:
>
>     1) MD advises enbd it's in an array, or not
>     2) enbd tells MD to pull it in and out of that array as
>        it senses the condition of the network connection
>
> The first required MD to use a special ioctl to each device in an
> array.
>
> The second required enbd to use the MD HOT_ADD and HOT_REMOVE ioctl
> commands, being careful also to kill any requests in flight so that
> the remove or add would not be blocked in md or the other block device
> layers.  (In fact, I think I needed to add HOT_REPAIR as a special extra
> command, but don't quote me on that).
>
> That communications layer would work if it were restored.

> So .. are we settling on a solution?

I'm just proposing counter-arguments.
Talk to the Neil :-).

> I like the idea that we can advise MD that we are merely
> temporarily out of action.  Can we take it from there?  (Neil?)
