From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: Re: remark and RFC
Date: Wed, 16 Aug 2006 21:01:54 +0200 (MET DST)
Message-ID: <200608161901.k7GJ1sv01583@inv.it.uc3m.es>
References: <62b0912f0608160728x5328c513t582ac560e8c0b681@mail.gmail.com>
Reply-To: ptb@inv.it.uc3m.es
Mime-Version: 1.0
Content-Type: text/plain; charset=UNKNOWN-8BIT
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0608160728x5328c513t582ac560e8c0b681@mail.gmail.com> from
 "Molle Bestefich" at "Aug 16, 2006 04:28:15 pm"
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Also sprach Molle Bestefich:"
[Charset ISO-8859-1 unsupported, filtering to ASCII...]
> Peter T. Breuer wrote:
> > > You want to hurt performance for every single MD user out there, =
just
> >
> > There's no performance drop!  Exponentially staged retries on failu=
re
> > are standard in all network protocols ...  it is the appropriate
> > reaction in general, since stuffing the pipe full of immediate retr=
ies
> > doesn't allow the would-be successful transactions to even get a lo=
ok in
> > against that competition.
>=20
> That's assuming that there even is a pipe,

"Pipe" refers to a channel of fixed bandwidth.  Every communication
channel is one.  The "pipe" for a local disk is composed of the bus,
disk architecture, controller, and also the kernel architecture layers.
=46or example, only 256 (or 1024, whatever) kernel requests can be
outstanding at a time per device [queue], so if 1024 retry requests are
in flight, no real work will get done (some kind of priority placement
may be done in each driver ..  in enbd I take care to replace retries
last in the existing queue, for example).

> which is something specific
> to ENBD / networked block devices, not something that the MD driver
> should in general care about.

See above. The problem is generic to fixed bandwidth transmission
channels, which, in the abstract, is "everything". As soon as one
does retransmits one has a kind of obligation to keep retransmissions
down to a fixed maximum percentage of the potential traffic, which
is generally accomplished via exponential backoff (a time-wise
solution, in other words, sdeliberately mearing retransmits out along
the time axis in order to prevent spikes).

The md layers now can generate retries by at least one mechanism that I
know of ..  a failed disk _read_ (maybe of existing data or parity data
as part of an exterior write attempt) will generate a disk _write_ of
the missed data (as reconstituted via redundancy info).

I believe failed disk _write_ may also generate a retry, but the above
is already enough, no?=20

Anyway, the problem is merely immediately visible over the net since
individual tcp packet delays of 10s are easy to observe under fairly
normal conditions, and I have seen evidence of 30s trips in other
people's reports. It's not _unique_ to the net, but sheeucks, if you
want to think of it that way, go ahead!

Such delays may in themselves cause timeouts in md - I don't know. My
RFC (maybe "RFD") is aimed at raising a flag saying that something is
going on here that needs better control.

> > > because things doesn't work optimally under enbd, which is after =
all a
> > > rather rare use case compared to using MD on top of real disks.
> >
> > Strawman.
>=20
> Quah?

Above.

> > > Besides, it seems a rather pointless exercise to try and hide the=
 fact
> > > from MD that the device is gone, since it *is* in fact missing.
> >
> > Well, we don't really know that for sure.  As you know, it is
> > impossible to tell in general if the net has gone awol or is simply
> > heavily overloaded (with retry requests).
>=20
> From MD's point of view, if we're unable to complete a request to the
> device, then it's either missing or faulty.  If a call to the device
> blocks, then it's just very slow.

The underlying device has to take a decision about what to tell the
upper (md) layer. I can tell you from experience that users just HATE
it if the underlying device always blocks until the other end of the
net connection comes back on line. C.f. nfs "hard" option. Try it and
hate it.

The alternative, reasonable in my opinion, is to tell the overlying md
device that a io request has failed after about 10-30s of hanging
around waiting for it. Unforrrrrrrtunately, the effect is BAAAAAD
at the moment, because (as I indicated above), this can lead to md
layer retries aimed at the same lower device, IMMMMMMEDIATELY, which ar=
e
going to fail for the same reason the first io request failed.

What the upper layer, md, ought to do is "back off".

  1) try again immediately - if that fails, then don't give up but ..
  2) wait a while before retrying again.

I _suspect_ that at the moment md is trying and retrying, and probably
retrying again, all immediately, causing an avalanch of (temporary)
failures, and expulsion from a raid array.

> I don't think it's wise to pollute these simple mechanics with a
> "maybe it's in a sort-of failing due to a network outage, which might
> just be a brownout" scenario.  Better to solve the problem in a more
> appropriate place, somewhere that knows about the fact that we're
> simulating a block device over a network connection.

I've already suggested a simple mechanism above .. "back off on the
retries, already". It does no harm to local disk devices.

If you like, the constant of backoff can be based on how long it took
the underlying device to signal the io request as failed. So a local=20
disk that replies "failed" immediately can get its range of retries run
through in a couple of hop skip and millijiffies. A network device that
took 10s to report a timeout can get its next retry back again in 10s.
That should give it time to recover.

> Not introducing network-block-device aware code in MD is a good way t=
o
> avoid wrong code paths and weird behaviour for real block device
> users.

Uh, the net is everywhere.  When you have 10PB of storage in your
intelligent house's video image file system, the parts of that array ar=
e
connected by networking room to room.  Supecomputers used to have simpl=
e
networking between each computing node.  Heck, clusters still do :).
Please keep your special case code out of the kernel :-).


> "Missing" vs. "Faulty" is OTOH a pretty simple interface, which maps
> fine to both real disks and NBDs.

It may well be a solution. I think we're still at the stage of
precisely trying to identify the problem too! At the moment, most
of what I can say is "definitely, there is something wrong with the
way the md layer reacts or can be controlled with respect to
networking brown-outs and NBDs".


> > The retry on error is a good thing.  I am simply suggesting that if=
 the
> > first retry also fails that we do some back off before trying again=
,
> > since it is now likely (lacking more knowledge) that the device is
> > having trouble and may well take some time to recover.  I would sus=
pect
> > that an interval of 0 1 5 10 30 60s would be appropriate for retrie=
s.
>=20
> Only for networked block devices.

Shrug. Make that 0, 1, 5, 10 TIMES the time it took the device to
report the request as errored.


> Not for real disks, there you are just causing unbearable delays for
> users for no good reason, in the event that this code path is taken.

We are discussing _error_ semantics.  There is no bad effect at all on
normal working!  The effect on normal working should even be _good_ whe=
n
errors occur, because now max bandwidth devoted to error retries is
limited, leaving more max bandwidth for normal requests.


> > One can cycle that twice for luck before giving up for good, if you
> > like.  The general idea in such backoff protocols is that it avoids
> > filling a fixed bandwidth channel with retries (the sum of a consta=
nt
> > times 1 + 1/2 + 1/4 + ..  is a finite proportion of the channel
> > bandwidth, but the sum of 1+1+1+1+1+...  is unbounded), but here al=
so
> > there is an _additional_ assumption that the net is likely to have
> > brownouts and so we _ought_ to retry at intervals since retrying
> > immediately will definitely almost always do no good.
>=20
> Since the knowledge that the block device is on a network resides in
> ENBD, I think the most reasonable thing to do would be to implement a
> backoff in ENBD?  Should be relatively simple to catch MD retries in
> ENBD and block for 0 1 5 10 30 60 seconds.

I can't tell which request is a retry.  You are allowed to write twice
to the same place in normal operation! The knowledge is in MD.


> That would keep the
> network backoff algorithm in a more right place, namely the place tha=
t
> knows the device is on a network.

See above.


> > In "normal " failures there is zero delay anyway.
>=20
> Since the first retry would succeed, or?

Yes.

> I'm not sure what this "normal" failure is, btw.

A simple read failure, followed by a successful (immediate) write
attempt. The local disk will take 0s to generate the read failure,
and the write (rewrite) attempt will be generated and accepted 0s
later.

In contrast, the net device will take 10-30s to generate a timeout for
the read attempt, followed by 0s to error the succeeding write request,
since the local driver of the net device will have taken the device
offline as it can't get a response in 30s. At that point all io to the
device will fail, all hell will break loose in the md device, and the
net device will be ejected from the array in a flurry of millions of
failed requests.

I merely ask for a little patience. Try again in 30s.


> > And further, the bitmap takes care of delayed
> > responses in the normal course of events.
>=20
> Mebbe.  Does it?

Yes.

> > > It would be reasonable for MD to know the difference between
> > >  - "device has (temporarily, perhaps) gone missing" and
> > >  - "device has physical errors when reading/writing blocks",
> >
> > I agree. The problem is that we can't really tell what's happening
> > (even in the lower level device) across a net that is not respondin=
g.
>=20
> In the case where requests can't be delivered over the network (or a
> SATA cable, whatever), it's a clear case of "missing device".

It's not so clear.  10-30s delays are perfectly visible in ordinary tcp
and mean nothing more than congestion.  How many times have you sat
there hitting the keys and waiting for something to move on the screen?


>=20
> > > The comm channel and "hey, I'm OK" message you propose doesn't se=
em
> > > that different from just hot-adding the disks from a shell script
> > > using 'mdadm'.
> >
> > [snip speculations on possible blocking calls]
>=20
> You could always try and see.
> Should be easy to simulate a network outage.

I should add that it's easy to simulate network outages just by lowerin=
g
the timeout in enbd.  At the 3s mark, and running continuous writes to
a file larger than memory sited on a fs on the remote device=B8 one see=
s
timeouts every minute or so - requests which took longer than 3s to go
across the local net, be carried out remotely, and be acked back. Even
with no other traffic on the net.  Here's a typical observation sequenc=
e
I commented in correspondence to the debian maintainer ...

   1 Jul 30 07:32:55 betty kernel: ENBD #1187[73]: enbd_rollback (0):
   error out too old (783) timedout (750) req c8da00bc!

   The request had a timeout of 3s (750 jiffies) and was in the kernel
   unserviced for just over 3s (783 jiffies) before the enbd driver
   errored it.  I lowered the base timeout to 3s (default is 10s) in
   order to provoke this kind of problem.

   2 Jul 30 07:32:55 betty kernel: ENBD #1115[73]: enbd_error error out
   req c8da00bc from slot 0!

   This is the notification of the enbd driver erroring the request.

   3 Jul 30 07:32:55 betty kernel: Buffer I/O error on device ndb,
   logical block 65 540

   This is the kernel noticing the request has been errored.

   4 Jul 30 07:32:55 betty kernel: lost page write due to I/O error on
   ndb

   Ditto.

   5 Jul 30 07:32:55 betty kernel: ENBD #1506[73]: enbd_ack (0): fatal:
   Bad handle c8da00bc !=3D 00000000!

   The request finally comes back from the enbd server, just a fraction
   of a second too late, just beyond the 3s limit.

   6 Jul 30 07:32:55 betty kernel: ENBD #1513[73]: enbd_ack (0):
   ignoring ack of req c8da00bc which slot lacks

   And the enbd driver ignores the late return - it already told the
   kernel it errored.

I've increased the default timeout in response to these observations,
but the real problem in my view is not that the network is sometimes
slow, but the way the md driver reacts to the situation in the absence
of further guidance. It needs better communications facilities with the
underlying devices. Their drivers need to be able to tell the md driver
about the state of the underlying device.


> > I am pretty sure that removal requests will be blocked when
> > requests are outstanding.
>=20
> That in particular should not be a big problem, since MD already kick=
s
> the device for you, right?  A script would only have to hot-add the
> device once it's available again.

I can aver from experience that one should not look to a script for
salvation.  There are too many deadlock opportunities - we will be out
of memory in a situation where writes are going full speed to a raid
device, which is writing to a device across the net, and the net is
congested or has a brownout (cleaning lady action with broom and cables=
).
Buffers will be full.  It is not clear that there will be memory for th=
e
tcp socket in order to build packets to allow the buffers to flush.

Really, in my experience, a real good thing to do is mark the device as
temporarily failed, clear all queued requests with error, thus making
memory available, yea, even for tcp sockets, and then let the device
reinsert itself in the MD array when contact is reestablished across th=
e
net.  At that point the MD bitmap can catch up the missed requests.

This is complicated by the MD device's current tendency to issue
retries (one way or the other .. does it? How?). It's interfering
with the simple strategy I just sggested.

> > Another problem is that enbd has to _know_ it is in a raid array, a=
nd
> > which one, in order to send the ioctl.  That leads one to more or l=
ess
> > require that the md array tell it.  One could build this into the m=
dadm
> > tool, but one can't guarantee that everyone uses that (same) mdadm =
tool,
> > so the md driver gets nominated as the best place for the code that
> > does that.
>=20
> It's already in mdadm.

One can't rely on mdadm - no user code is likely to work when we are ou=
t
of memory and in deep oxygen debt.

> You can only usefully query one way (array --> device):
> # mdadm -D /dev/md0 | grep -A100 -E '^    Number'
>=20
>     Number   Major   Minor   RaidDevice State
>        0     253        0        0      active sync   /dev/mapper/sda=
1
>        1     253        1        1      active sync   /dev/mapper/sdb=
1

I'm happy to use the ioctls that mdadm uses to get that info. If it
parses /proc/mdstat, then I give up :-).  The format is not regular.


> That should provide you with enough information though, since devices
> stay in that table even after they've gone missing.  (I'm not sure
> what happens when a spare takes over a place, though - test needed.)

That's exactly what I mean .. the /proc output is difficult to parse.

> The optimal thing would be to query the other way, of course.  ENBD
> should be able to tell a hotplug shell script (or whatever) about the

Please no shell scripts (I'm the world's biggest fan of shell scripts
otherwise) - they can't be relied on in these situations. Think of
a barebones installation with a root device mirrored over the net.
These generally run a single process in real time mode - a data farm,
processing info pouring out of, say, an atomic physics experiment, at
1GB/s.

> name of the device that's just come back.
>=20
> And you *can* in fact query the other way too, but you won't get a
> useful Array UUID or device-name-of-assembled-array out of it:

It's all too wishy-washy. I'm sorry, but direct ioctl or similar is the
only practical way.

> > Only one of two devices in a two-device mirror is generally network=
ed.
>=20
> Makes sense.
>=20
> > The standard scenario is two local disks per network node.  One is =
a
> > mirror half for a remote raid,
>=20
> A local cache of sorts?

Just a local mirror half. When the node goes down, its data state will
still be available on the remote half of the mirror, and processing can
continue there.


> > the other is the mirror half for a local raid
> > (which has a remote other half on the remote node).
>=20
> A remote backup of sorts?

Just the remote half of the mirror.


> > The problem is that if I take ten seconds for each one when the
> > net is down memory will fill with backed up requests.  The first
> > one that is failed (after 10s) then triggers an immediate retry
> > from md, which also gets held for 10s.  We'll simply get
> > huge pulses of failures of entire backed up memory spaced at 10s.
> > I'm pretty sure from reports that md would error the device
> > offline after a pulse like that.
>=20
> I don't see where these "huge pulses" come into the picture.

Because if we are writing full tilt to the network device when the net
goes down, 10s later all those requests in flight at the time (1024 off=
)
will time out simultaneously, all together, at the same time, in unison=
=2E

> If you block one MD request for 10 seconds, surely there won't be
> another before you return an answer to that one?

See above. We will block 1024 requests for 10s, if the request pools
are fully utilized at the time (and if 1024 is the default block
device queue limit .. it's either that or 256, I forget which)


> > If it doesn't, then anyway enbd would decide after 30s or so that
> > the remote end was down and take itself offline.
> > One or the other would cause md to expell it from the array.  I cou=
ld
> > try hot-add from enbd when the other end comes back, but we need to=
 know
> > we are in an array (and which) in order to do that.
>=20
> I think that's possible using mdadm at least.

One would have to duplicate the ioctl calls that mdadm uses, from kerne=
l
space.  It's not  advisable to call out _under pressure_ to a user
process to do something else in kernel.

> I guess what will work is either:
>=20
> A)
>=20
> Network outage -->
>  ENBD fails disk -->
>  MD drops disk -->
>  Network comes back -->
>  ENBD brings disk back up -->

This is what used to happen with the FR1/5 patch.  Most of that
functionality is now in the kernel code, but there is still "missing"
the communication layer that allowed enbd to bring the disk back up
and back into the MD array.

>  Something kicks off /etc/hotplug.d/block-hotplug script -->
>  Script queries all RAID devices and find where the disk fits -->
>  Script hot-adds the disk

Not first choice in a hole - simpler is what I had in the FR1/5 patches=
:

    1) MD advises enbd it's in an array, or not
    2) enbd tells MD to pull it in and out of that array as
       it senses the condition of the network connection

The first required MD to use a special ioctl to each device in an
array.

The second required enbd to use the MD HOT_ADD and HOT_REMOVE ioctl
commands, being careful also to kill any requests in flight so that
the remove or add would not be blocked in md or the other block device
layers.  (In fact, I think I needed to add HOT_REPAIR as a special extr=
a
command, but don't quote me on that).

That communications layer would work if it were restored.=20

> Or:
>=20
> B)
>=20
> Network outage -->
>  ENBD fails disk, I/O error type "link error" -->

We can do that.

>  MD sets disk status to "temporarily missing" -->

Well, this is merely the kernel level communication I am looking for!
You seem to want MD _not_ to drop the device, however, merely to set it
inactive. I am happy with that too.

>  Network comes back -->
>  ENBD brings disk back up -->
>  MD sees a block device arrival, reintegrates the disk into array

We need to tell MD that we're OK.

I will go along with that.

> I think the latter is better, because:
>  * Noone has to maintain husky shell scripts
>  * It sends a nice message to the SATA/PATA/SCSI people that MD would
> really like to know whether it's a disk or a link problem.

I agree totally. It's the kind of "solution" I had before, so I am
happy.



> But then again, shell scripts _is_ the preferred Linux solution to...
> Everything.

It can't be relied upon here. Imagine if the entire file system is
mirrored. Hic.

> MD should be fixed so HOT_REMOVE won't fail but will just kick the
> disk, even if it happens to be blocking on I/O calls.
>=20
> (If there really is a reason not to kick it, then at least a
> HOT_REMOVE_FORCE should be added..)

So .. are we settling on a solution? I like the idea that we can advise
MD that we are merely temporarily out of action.  Can we take it from
there?  (Neil?)

Peter

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
