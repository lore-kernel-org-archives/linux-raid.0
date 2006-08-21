From: Neil Brown <neilb@suse.de>
Subject: Re: remark and RFC
Date: Mon, 21 Aug 2006 11:21:29 +1000
Message-ID: <17641.2713.82918.859664@cse.unsw.edu.au>
References: <17635.49745.179198.975962@cse.unsw.edu.au>
	<200608170628.k7H6S7W11745@inv.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Thursday August 17
Sender: linux-raid-owner@vger.kernel.org
To: ptb@inv.it.uc3m.es
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday August 17, ptb@inv.it.uc3m.es wrote:
> HI Neil ..
> 
> "Also sprach Neil Brown:"
> > On Wednesday August 16, ptb@inv.it.uc3m.es wrote:
> > > 1) I would like raid request retries to be done with exponential
> > >    delays, so that we get a chance to overcome network brownouts.
> > > 
> > > 2) I would like some channel of communication to be available
> > >    with raid that devices can use to say that they are
> > >    OK and would they please be reinserted in the array.
> > > 
> > > The latter is the RFC thing (I presume the former will either not
> > > be objectionable or Neil will say "there's no need since you're wrong
> > > about the way raid does retries anyway").
> > 
> > There's no need since you're ..... you know the rest :-)
> > Well, sort of.
> 
> OK, let's see ...
> 
> > When md/raid1 gets a read error it immediately retries the request in
> > small (page size) chunks to find out exactly where the error is (it
> > does this even if the original read request is only one page).
> 
> OK.  I didn't know that.  But do you mean a read request to the RAID
> device, or a read request to the underlying disk device?  The latter
> might form part of the implementation of a write request to the RAID
> device.

We retry the read requests to the underlying devices.
I was thinking of raid1 particularly.
For raid5 we don't retry the read as all requests are sent down from
raid5 a 4K in size so refining the location of an error is not an
issue.
For raid5 we don't retry the read.  We read from all other devices and
then send a write.  If that works, good.  If it fails we kick the
device.

> 
> (has the MD blocksize moved up to 4K then? It was at 1KB for years)
> 

A 0.90 superblock has always been 4K.


> > I'm not interested in putting any delays in there.  It is simply the
> > wrong place to put them.  If network brownouts might be a problem,
> > then the network driver gets to care about that.
> 
> I think you might want to reconsider (not that I know the answer).  
> 
> 1) if the network disk device has decided to shut down wholesale
>    (temporarily) because of lack of contact over the net, then
>    retries and writes are _bound_ to fail for a while, so there
>    is no point in sending them now.  You'd really do infinitely
>    better to wait a while.

Tell that to the network block device.  md has no knowledge of the
device under it.  It sends requests.  They succeed or they fail.  md
acts accordingly.

> 
> 2) if the network device just blocks individual requests for say 10s
>    while waiting for an ack, then times them out, there is more chance
>    of everything continuing to work since the 10s might be long enough
>    for the net to recover in, but occasionally a single timeout will
>    occur and you will boot the device from the array (whereas waiting a
>    bit longer would have been the right thing to do, if only we had
>    known).  Change 10s to any reasonable length of time.  
> 
>    You think the device has become unreliable because write failed, but
>    it hasn't ... that's just the net. Try again later! If you like
>    we can set the req error count to -ETIMEDOUT to signal it. Real
>    remote write breakage can be signalled with -EIO or something.
>    Only boot the device on -EIO.

For read requests, I might be happy to treat -ETIMEOUT differently.  I
get the data from elsewhere and leave the original disk alone.
But for writes, what can I do?  If the write fails I have to evict the
drive, otherwise the array becomes inconsistent. 
If you want to implement some extra timeout and retry for writes, do
that in user-space utilising the bitmap stuff.
If you keep you monitor app small and have it mlocked, it should
continue to work find under high memory pressure.

> 
> 3) if the network device blocks essentially forever, waiting for a
>    reconnect, experience says that users hate that. I believe the
>    md array gets stuck somewhere here (from reports), possibly in trying
>    to read the superblock of the blocked device.

So what do you expect us to do in this case?  You want the app to keep
working even though the network connection to the storage isn't
working?  Doesn't make sense to me.


> 
> 4) what the network device driver wants to do is be able to identify
>    the difference between primary requests and retries, and delay 
>    retries (or repeat them internally) with some reasonable backoff
>    scheme to give them more chance of working in the face of a
>    brownout, but it has no way of doing that.  You can make the problem
>    go away by delaying retries yourself (is there a timedue field in
>    requests, as well as a timeout field?  If so, maybe that can be used
>    to signal what kind of a request it is and how to treat it).
> 
> 
> > Point 2 should be done in user-space.  
> 
> It's not reliable - we will be under memory pressure at this point, with
> all that implies; the raid device might be the very device on which the
> file system sits, etc. Pick your poison!

mlockall

> 
> >   - notice device have been ejected from array
> >   - discover why. act accordingly.
> >   - if/when it seems to be working again, add it back into the array. 
> > 
> > I don't see any need for this to be done in the kernel.
> 
> Because there might not be any userspace (embedded device) and
> userspace might be blocked via subtle or not-so-subtle deadlocks.

Even an embedded device can have userspace.
Fix the deadlocks.

> There's no harm in making it easy! /proc/mdstat is presently too hard
> to parse reliably, I am afraid. Minor differences in presentation
> arise in it for reasons I don't understand!

There is harm in putting code in the kernel to handle a very special
case.  

NeilBrown


> 
> > > The way the old FR1/5 code worked was to make available a couple of
> > > ioctls.
> > > 
> > > When a device got inserted in an array, the raid code told the device
> > > via a special ioctl it assumed the device had that it was now in an
> > > array (this triggers special behaviours, such as deliberately becoming
> > > more error-prone and less blocky, on the assumption that we have got
> > > good comms with raid and can manage our own raid state). Ditto
> > > removal.
> > 
> > A bit like BIO_RW_FASTFAIL?  Possibly md could make more use of that.
> 
> It was a different one, but yes, that would have done. The FR1/5
> code needed  to be told also in WHICH array it was, so that it
> could send ioctls (HOT_REPAIR, or such) to the right md device
> later when it felt well again. And it needed to be told when it
> was ejected from the array, so as not to do that next time ...
> 
> > I haven't given it any serious thought yet.  I don't even know what
> > low level devices recognise it or what they do in response.
> 
> As far as I am concerned, any signal is useful. Any one which
> tells me which array I am in is especially useful. And I need
> to be told when I leave.
> 
> Essentially I want some kernel communication channel here. Ioctls
> are fine (there is a subtle kernel deadlock involved in calling an ioctl
> on a device above you from within, but I got round that once, and I can
> do it again).
> 
> 
> Thanks for the replies!
> 
> Peter
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
