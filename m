From: Neil Brown <neilb@suse.de>
Subject: Re: Swapping a disk without degrading an array
Date: Fri, 29 Jan 2010 22:19:04 +1100
Message-ID: <20100129221904.439e2afe@notabene>
References: <1264421475.30742.49.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264421475.30742.49.camel@test.apertos.eu>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgg==?= Sawicz <michal@sawicz.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 25 Jan 2010 13:11:15 +0100
Micha=C5=82 Sawicz <michal@sawicz.net> wrote:

> Hi list,
>=20
> This is something I've discussed on IRC and we achieved a conclusion
> that this might be useful, but somewhat limited use-case count might =
not
> warrant the effort to be implemented.
>=20
> What I have in mind is allowing a member of an array to be paired wit=
h a
> spare while the array is on-line. The spare disk would then be filled
> with exactly the same data and would, in the end, replace the active
> member. The replaced disk could then be hot-removed without the array
> ever going into degraded mode.
>=20
> I wanted to start a discussion whether this at all makes sense, what =
can
> be the use cases etc.
>=20

As has been noted, this is a really good idea.  It just doesn't seem to=
 get
priority.  Volunteers ???

So time to start:  with a little design work.

1/ The start of the array *must* be recorded in the metadata.  It we tr=
y to
   create a transparent whole-device copy then we could get confused la=
ter.
   So let's (For now) decide not to support 0.90 metadata, and support =
this
   in 1.x metadata with:
     - a new feature_flag saying that live spares are present
     - the high bit set in dev_roles[] means that this device is a live=
 spare
       and is only in_sync up to 'recovery_offset'

2/ in sysfs we currently identify devices with a symlink
     md/rd$N -> dev-$X
   for live-spare devices, this would be
     md/ls$N -> dev-$X

3/ We create a live spare by writing 'live-spare' to md/dev-$X/state
   and an appropriate value to md/dev-$X/recovery_start before setting
   md/dev-$X/slot

4/ When a device is failed, if there was a live spare is instantly take=
s
   the place of the failed device.

5/ This needs to be implemented separately in raid10 and raid456.
   raid1 doesn't really need live spares  but I wouldn't be totally aga=
inst
   implementing them if it seemed helpful.

6/ There is no dynamic read balancing between a device and its live-spa=
re.
   If the live spare is in-sync up to the end of the read, we read from=
 the
   live-spare, else from the main device.

7/ writes transparently go to both the device and the live-spare, wheth=
er they
   are normal data writes or resync writes or whatever.

8/ In raid5.h struct r5dev needs a second 'struct bio' and a second
   'struct bio_vec'.
   'struct disk_info' needs a second mdk_rdev_t.

9/ in raid10.h mirror_info needs another mdk_rdev_t and the anon struct=
 in=20
   r10bio_s needs another 'struct bio *'.

10/ Both struct r5dev and r10bio_s need some counter or flag so we can =
know
    when both writes have completed.

11/ For both r5 and r10, the 'recover' process need to be enhanced to j=
ust
    read from the main device when a live-spare is being built.
    Obviously if this fail there needs to be a fall-back to read from
    elsewhere.

Probably lots more details, but that might be enough to get me (or some=
one)
started one day.

There would be lots of work to do in mdadm too of course to report on t=
hese
extensions and to assemble arrays with live-spares..

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
