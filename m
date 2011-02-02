From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID 5 - One drive dropped while replacing another
Date: Wed, 2 Feb 2011 14:56:53 -0600
Message-ID: <63.D6.19545.715C94D4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTinjP3Gw-C+Ee_1YC-+Zo-5UZ53U9EJHDYqr3mbZ@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinjP3Gw-C+Ee_1YC-+Zo-5UZ53U9EJHDYqr3mbZ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > =A0 =A0 =A0 =A0That's pretty conservative, yes, for middle of the r=
oad
> > availability. =A0For a system whose necessary availability is not t=
oo
> high, it
> > is considerable overkill. =A0For a system whose availability is cri=
tical,
> it's
> > not conservative enough.
>=20
> So maybe for my "money-poor environment that could live with a day or
> two of downtime" I'll add a drive or two as my own personal rule of
> thumb. Thanks for the feedback.

	Yeah, as long as you have good backups for all critical data and you
can live with the thought of being at least partially down for an exten=
ded
period while the data restores from your backups, then whatever level o=
f
redundancy you can afford should be fine.  If it is critical you be abl=
e to
have some portion of the data immediately available at all times, then =
a
more aggressive (and probably expensive) solution is in order.  You mig=
ht
also have to give up some performance for greater reliability.

> > =A0 =A0 =A0 =A0That assumes the RAID1 array elements only have 2 me=
mbers. =A0With
> 3
> > members, the reliability goes way up. =A0Of course, so does the cos=
t.
>=20
> Prohibitively so for my situation, at least for the large storage
> volumes.

	I can relate.

> My OS boot partitions are replicated on every drive, so some
> of them have 20+ members, but at 10GB per 2TB, not expensive  8-)

	That really sounds like overkill.  I'm a big fan of keeping my data
storage completely separate from my boot media.  Indeed, the boot drive=
s are
internal to the servers, while the data drives reside in RAID chassis.
Small drives are really cheap (in my case, free), so I simply chunked a
couple of old drives into each server chassis, partitioned them into ro=
ot,
boot, and swap partitions, and bound them into three RAID1 arrays.  Eve=
ry
few days, I back up the files on the / and /boot arrays onto the data a=
rray
using tar.  Rsync would also be a good candidate.  The space utilizatio=
n, as
you say, is pretty trivial, as is the drain on the server resources.

> >> depending on luck, whereas RAID6 would allow **any** two (and
> >> RAID6+spare any *three*) drives to fail without my losing data. So=
 I
> >
> > =A0 =A0 =A0 =A0That's specious. =A0RAID6 + spare only allows two ov=
erlapping
> failures.
>=20
> Well yes, but my environment doesn't have pager notification to a
> "hot-spare sysadmin" standing by ready to jump in. In fact the
> replacement hardware would need to be requested/purchase-ordered etc,
> so in that case the spare does make a difference to resilience doesn'=
t
> it.

	It improves availability, not really resilience.  It also of course
impacts reliability.

> If I had the replacement drive handy I'd just make it a hot spare
> rather than keeping it on the shelf anyway.

	Oh, yeah, I'm not disparaging the hot spare.  It's just if two
members suffer overlapping failures, then the array is without any
redundancy until the resync is complete.

> >> On my lower-end systems, a RAID6 over 2TB drives takes about 10-11
> >> hours per failed disk to rebuild, and that's using embedded bitmap=
s
> >> and with nothing else going on.
> >
> > =A0 =A0 =A0 =A0I've never had one rebuild from a bare drive that fa=
st.
>=20
> This wasn't a bare drive, but a re-add after I'd been doing some grub=
2
> and maintenance work on another array from SystemRescueCD, not sure
> why the member failed.

	That's a very different matter.  A re-add of a failed member can be
very brief.  When the system has to read every last byte of data from t=
he
live array, calculate parity, and then write the calculated data back t=
o the
blank drive, it can easily take close to or even more than a day per TB=
,
depending on the system load.

> It's not a particularly fast platform, consumer
> SATA2 Hitachi drives attached to mobo Intel controller, ICH7 I
> believe. cat /proc/mdstat was showing around 60k, while the RAID1s
> rebuild at around double that.
>=20
> Would the fact that it was at less than 30% capacity make a differenc=
e?

	That, I'm not sure.  I'm not certain of the mechanics of mdadm, and
I have never done a drive replacement on a system that lightly filled.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
