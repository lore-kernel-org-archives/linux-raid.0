From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: remark and RFC
Date: Wed, 16 Aug 2006 16:28:15 +0200
Message-ID: <62b0912f0608160728x5328c513t582ac560e8c0b681@mail.gmail.com>
References: <62b0912f0608160300g58bef34cj87300b32a83b17f0@mail.gmail.com>
	 <200608161306.k7GD6Vs29677@inv.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200608161306.k7GD6Vs29677@inv.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: ptb@inv.it.uc3m.es
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> > You want to hurt performance for every single MD user out there, just
>
> There's no performance drop!  Exponentially staged retries on failure
> are standard in all network protocols ...  it is the appropriate
> reaction in general, since stuffing the pipe full of immediate retries
> doesn't allow the would-be successful transactions to even get a look in
> against that competition.

That's assuming that there even is a pipe, which is something specific
to ENBD / networked block devices, not something that the MD driver
should in general care about.


> > because things doesn't work optimally under enbd, which is after all a
> > rather rare use case compared to using MD on top of real disks.
>
> Strawman.

Quah?


> > Besides, it seems a rather pointless exercise to try and hide the fact
> > from MD that the device is gone, since it *is* in fact missing.
>
> Well, we don't really know that for sure.  As you know, it is
> impossible to tell in general if the net has gone awol or is simply
> heavily overloaded (with retry requests).

From MD's point of view, if we're unable to complete a request to the
device, then it's either missing or faulty.  If a call to the device
blocks, then it's just very slow.

I don't think it's wise to pollute these simple mechanics with a
"maybe it's in a sort-of failing due to a network outage, which might
just be a brownout" scenario.  Better to solve the problem in a more
appropriate place, somewhere that knows about the fact that we're
simulating a block device over a network connection.

Not introducing network-block-device aware code in MD is a good way to
avoid wrong code paths and weird behaviour for real block device
users.

"Missing" vs. "Faulty" is OTOH a pretty simple interface, which maps
fine to both real disks and NBDs.


> The retry on error is a good thing.  I am simply suggesting that if the
> first retry also fails that we do some back off before trying again,
> since it is now likely (lacking more knowledge) that the device is
> having trouble and may well take some time to recover.  I would suspect
> that an interval of 0 1 5 10 30 60s would be appropriate for retries.

Only for networked block devices.

Not for real disks, there you are just causing unbearable delays for
users for no good reason, in the event that this code path is taken.


> One can cycle that twice for luck before giving up for good, if you
> like.  The general idea in such backoff protocols is that it avoids
> filling a fixed bandwidth channel with retries (the sum of a constant
> times 1 + 1/2 + 1/4 + ..  is a finite proportion of the channel
> bandwidth, but the sum of 1+1+1+1+1+...  is unbounded), but here also
> there is an _additional_ assumption that the net is likely to have
> brownouts and so we _ought_ to retry at intervals since retrying
> immediately will definitely almost always do no good.

Since the knowledge that the block device is on a network resides in
ENBD, I think the most reasonable thing to do would be to implement a
backoff in ENBD?  Should be relatively simple to catch MD retries in
ENBD and block for 0 1 5 10 30 60 seconds.  That would keep the
network backoff algorithm in a more right place, namely the place that
knows the device is on a network.


> In "normal " failures there is zero delay anyway.

Since the first retry would succeed, or?
I'm not sure what this "normal" failure is, btw.

> And further, the bitmap takes care of delayed
> responses in the normal course of events.

Mebbe.  Does it?


> > It would be reasonable for MD to know the difference between
> >  - "device has (temporarily, perhaps) gone missing" and
> >  - "device has physical errors when reading/writing blocks",
>
> I agree. The problem is that we can't really tell what's happening
> (even in the lower level device) across a net that is not responding.

In the case where requests can't be delivered over the network (or a
SATA cable, whatever), it's a clear case of "missing device".


> > because if MD knew that, then it would be trivial to automatically
> > hot-add the missing device once available again.  Whereas the faulty
> > one would need the administrator to get off his couch.
>
> Yes. The idea is that across the net approximately ALL failures are
> temporary ones, to a value of something like 99.99%.  The cleaning lady
> is usually dusting the on-off switch on the router.
>
> > This would help in other areas too, like when a disk controller dies,
> > or a cable comes (completely) loose.
> >
> > Even if the IDE drivers are not mature enough to tell us which kind of
> > error it is, MD could still implement such a feature just to help
> > enbd.
> >
> > I don't think a comm-channel is the right answer, though.
> >
> > I think the type=(missing/faulty) information should be embedded in
> > the I/O error message from the block layer (enbd in your case)
> > instead, to avoid race conditions and allow MD to take good decisions
> > as early as possible.
>
> That's a possibility. I certainly get two types of error back in the
> enbd driver .. remote error or network error. Remote error is when
> we get told by the other end that the disk has a problem. Network
> error is when we hear nothing, and have a timeout.
>
> I can certainly pass that on. Any suggestions?

Let's hear from Neil what he thinks.


> > The comm channel and "hey, I'm OK" message you propose doesn't seem
> > that different from just hot-adding the disks from a shell script
> > using 'mdadm'.
>
> [snip speculations on possible blocking calls]

You could always try and see.
Should be easy to simulate a network outage.

> I am pretty sure that removal requests will be blocked when
> requests are outstanding.

That in particular should not be a big problem, since MD already kicks
the device for you, right?  A script would only have to hot-add the
device once it's available again.


> Another problem is that enbd has to _know_ it is in a raid array, and
> which one, in order to send the ioctl.  That leads one to more or less
> require that the md array tell it.  One could build this into the mdadm
> tool, but one can't guarantee that everyone uses that (same) mdadm tool,
> so the md driver gets nominated as the best place for the code that
> does that.

It's already in mdadm.

You can only usefully query one way (array --> device):
# mdadm -D /dev/md0 | grep -A100 -E '^    Number'

    Number   Major   Minor   RaidDevice State
       0     253        0        0      active sync   /dev/mapper/sda1
       1     253        1        1      active sync   /dev/mapper/sdb1

That should provide you with enough information though, since devices
stay in that table even after they've gone missing.  (I'm not sure
what happens when a spare takes over a place, though - test needed.)

The optimal thing would be to query the other way, of course.  ENBD
should be able to tell a hotplug shell script (or whatever) about the
name of the device that's just come back.

And you *can* in fact query the other way too, but you won't get a
useful Array UUID or device-name-of-assembled-array out of it:

# mdadm -E /dev/mapper/sda2
[snip blah, no array information :-(]

Expanding -E output to include the Array UUID would be a good feature
in any case.

Expanding -E output to include which array device is currently
mounted, having the corresponding Array UUID would be neat, but I'm
sure that most users would probably misunderstand what this means :-).


> Only one of two devices in a two-device mirror is generally networked.

Makes sense.

> The standard scenario is two local disks per network node.  One is a
> mirror half for a remote raid,

A local cache of sorts?

> the other is the mirror half for a local raid
> (which has a remote other half on the remote node).

A remote backup of sorts?

> More complicated setups can also be built - there are entire grids of
> such nodes arranged in a torus, with local redundancy arranged in
> groups of three neighbours, each with two local devices and one remote
> device. Etc.

Neat ;-).


> > > all I can do is make the enbd device block on network timeouts.
> > > But that's totally unsatisfactory, since real network outages then
> > > cause permanent blocks on anything touching a file system
> > > mounted remotely.  People don't like that.
> >
> > If it's just this that you want to fix, you could write a DM module
> > which returns I/O error if the request to the underlying device takes
> > more than 10 seconds.
>
> I'm not sure that another layer helps. I can timeout requests myself in
> 10s within enbd if I want to.

Yeah, okay.
I suggested that further up, but I guess you thought of it before I did :-).


> The problem is that if I take ten seconds for each one when the
> net is down memory will fill with backed up requests.  The first
> one that is failed (after 10s) then triggers an immediate retry
> from md, which also gets held for 10s.  We'll simply get
> huge pulses of failures of entire backed up memory spaced at 10s.
> I'm pretty sure from reports that md would error the device
> offline after a pulse like that.

I don't see where these "huge pulses" come into the picture.

If you block one MD request for 10 seconds, surely there won't be
another before you return an answer to that one?

> If it doesn't, then anyway enbd would decide after 30s or so that
> the remote end was down and take itself offline.
> One or the other would cause md to expell it from the array.  I could
> try hot-add from enbd when the other end comes back, but we need to know
> we are in an array (and which) in order to do that.

I think that's possible using mdadm at least.


> > Layer that module on top of the RAID, and make your enbd
> > device block on network timeouts.
>
> It shifts the problem to no avail, as far as I understand you, and my
> understanding is likely faulty.  Can you be more specific about how this
> attacks the problem?

Never was much of a good explainer...

I was of the impression that you wanted an error message to be
propagated quickly to userspace / users, but the MD array to just be
silently paused, whenever a network outage occurred.

Since you've mentioned that there's actually local disk components in
the RAID arrays, I imagine you would want the array to NOT be paused,
since it could reasonably continue operation on one device.  So just
forget about that proposal, it won't work in this situation :-).

I guess what will work is either:

A)

Network outage -->
 ENBD fails disk -->
 MD drops disk -->
 Network comes back -->
 ENBD brings disk back up -->
 Something kicks off /etc/hotplug.d/block-hotplug script -->
 Script queries all RAID devices and find where the disk fits -->
 Script hot-adds the disk

Or:

B)

Network outage -->
 ENBD fails disk, I/O error type "link error" -->
 MD sets disk status to "temporarily missing" -->
 Network comes back -->
 ENBD brings disk back up -->
 MD sees a block device arrival, reintegrates the disk into array


I think the latter is better, because:
 * Noone has to maintain husky shell scripts
 * It sends a nice message to the SATA/PATA/SCSI people that MD would
really like to know whether it's a disk or a link problem.

But then again, shell scripts _is_ the preferred Linux solution to...
Everything.


> Enbd used instead to tell the md device that it was feeling ill, error
> all requests, allowing md to chuck it out of the array. Then enbd would
> tell the md device when it was feeling well again, and make md
> reinsert it in the array. Md would catch up using the bitmap.
>
> Right now, we can't really tell md we're feeling ill (that would be a
> HOT_ARRRGH, but md doesn't have that). If we could, then md could
> decide on its own to murder all outstanding requests for us and
> chuck us out, with the implicit understanding that we will come back
> again soon and then the bitbap can catcj us up.
>
> We can't do a HOT_REMOVE while requests are outstanding, as far as I
> know.

MD should be fixed so HOT_REMOVE won't fail but will just kick the
disk, even if it happens to be blocking on I/O calls.

(If there really is a reason not to kick it, then at least a
HOT_REMOVE_FORCE should be added..)
