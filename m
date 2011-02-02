From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID 5 - One drive dropped while replacing another
Date: Wed, 2 Feb 2011 11:25:57 -0600
Message-ID: <50.11.05134.7A3994D4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTi=XzwtUGYH_wz44LHTYpyQRqnSCk4MxWZiQqZ8Z@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=XzwtUGYH_wz44LHTYpyQRqnSCk4MxWZiQqZ8Z@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of hansbkk@gmail.com
> Sent: Wednesday, February 02, 2011 9:29 AM
> To: Roman Mamedov; Robin Hill
> Cc: Bryan Wintermute; linux-raid@vger.kernel.org
> Subject: Re: RAID 5 - One drive dropped while replacing another
>=20
> On Wed, Feb 2, 2011 at 9:28 PM, Roman Mamedov <rm@romanrm.ru> wrote:
>=20
> > Exactly, RAID6 would make an order of magnitude more sense.
> > A 15-drive RAID5 array is just one step (one drive failure) from
> becoming a
> > 14-drive RAID0 array (reliability-wise).
>=20
> > Would you also ask "what's wrong with having a 14-drive RAID0"?
>=20
> Thanks Roman, I just wanted to check that's what you meant.
>=20
>=20
> On Wed, Feb 2, 2011 at 9:47 PM, Robin Hill <robin@robinhill.me.uk> wr=
ote:
>=20
> >> Or is there an upper limit as to the number of drives that's advis=
able
> >> for any array?
> >>
> > I'm sure there's advice out there on this one - probably a recommen=
ded
> > minimum percentage of capacity used for redundancy.  I've not looke=
d
> > though - I tend to go with gut feeling & err on the side of caution=
=2E
> >
> >> If so, then what do people reckon a reasonable limit should be for=
 a
> >> RAID6 made up of 2TB drives?

	That depends on many factors.  The bottom line question is, "how
safe does the live system need to be?"  If taking the system down to re=
cover
from backups is not an unreasonable liability, then there is no hard li=
mit
to the number of drives.  For that matter, if being down for a long per=
iod
is not considered an unacceptable hardship, or if one is running high
availability mirrored systems, then a 20 disk RAID0 might be reasonable=
=2E

> > As the drive capacities go up, you need to be thinking more careful=
ly
> > about redundancy - with a 2TB drive, your rebuild time is probably =
over
> > a day.  Rebuild also tends to put more load on drives than normal, =
so is
> > more likely to cause a secondary (or even tertiary) failure.  I'd b=
e
> > looking at RAID6 regardless, and throwing in a hot spare if there's=
 more
> > than 5 data drives.  If there's more than 10 then I'd be going with
> > multiple arrays.
>=20
> Thanks for the detailed reply Robin. I'm also sure there's advice "ou=
t
> there", but I figure there's no more authoritative place to explore
> this topic than here; I hope people don't mind the tangent.
>=20
> So keeping the drive size fixed at 2TB for the sake of argument, do
> people agree with the following as a conservative rule of thumb?
> Obviously adjustable depending on financial resources available and
> the importance of keeping the data online, given the fact that
> restoring this much data from backups would take a loooong time. This
> example is for a money-poor environment that could live with a day or
> two of downtime if necessary.
>=20
> less than 6 drives =3D> RAID5
> 6-8 drives =3D=3D> RAID6
> 9-12 drives =3D=3D> RAID6+spare
> over 12 drives, start spanning multiple arrays (I use LVM in any case=
)

	That's pretty conservative, yes, for middle of the road
availability.  For a system whose necessary availability is not too hig=
h, it
is considerable overkill.  For a system whose availability is critical,=
 it's
not conservative enough.

> On Wed, Feb 2, 2011 at 9:29 PM, Mathias Bur=E9n <mathias.buren@gmail.=
com>
> wrote:
> > With 15 drives, where only 1 can fail (RAID5) without data loss.. i=
t's
> > a quite high risk that 2 (or more) drives will fail within a short
> > period of time. If you have less drives, this chance decreases. For
> > large amount of drives I recommend RAID10 personally (or RAID1+0,
> > whichever you prefer).
> >
> > RAID6 + 1 hot spare is also nice, and cheaper. (for ~10 drives)
>=20
> Mathias, RAID1+0 (not talking about "mdm RAID10" here) would only
> protect my data if the "right pair" of drives failed at the same time=
,

	That assumes the RAID1 array elements only have 2 members.  With 3
members, the reliability goes way up.  Of course, so does the cost.

> depending on luck, whereas RAID6 would allow **any** two (and
> RAID6+spare any *three*) drives to fail without my losing data. So I

	That's specious.  RAID6 + spare only allows two overlapping
failures.  If the failures don't overlap, the even RAID5 without a spar=
e can
tolerate an unlimited number of failures.  All the hot spare does is al=
low
for immediate instigation of the rebuild, reducing the probability of a
drive failure during the period of degradation.  It doesn't increase th=
e
resiliency of the array.

> thought I'd always prefer RAID6. Or were you perhaps thinking of
> something fancy using "spare pools" or whatever they're called to
> allow for multiple spares to fill in for any failures at the
> underlying RAID1 layer? Now that I think about it, that seems like a
> good idea if it could be made to work, as the simple mirrors do repai=
r
> much faster. But of course the greatly reduced usable disk space rati=
o
> make this pretty expensive. . .

	There are lots of strategies for increasing resiliency.  The
compromise is always a three-way competition between cost, speed, and
availability.

> > with a 2TB drive, your rebuild time is probably over a day.
>=20
> On my lower-end systems, a RAID6 over 2TB drives takes about 10-11
> hours per failed disk to rebuild, and that's using embedded bitmaps
> and with nothing else going on.

	I've never had one rebuild from a bare drive that fast.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
