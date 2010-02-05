From: Keld Simonsen <keld@keldix.com>
Subject: Re: recovering a mirrored arry.
Date: Fri, 5 Feb 2010 19:50:44 +0100
Message-ID: <20100205185043.GA6956@light.rap.dk>
References: <20100203025758.GA12925@light.rap.dk> <20100205011928.GA12630@light.rap.dk> <73e903671002050825j2ae06fabjc7ec2b1e8fb85135@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <73e903671002050825j2ae06fabjc7ec2b1e8fb85135@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kristleifur =?iso-8859-1?Q?Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 05, 2010 at 04:25:02PM +0000, Kristleifur Da=F0ason wrote:
> On Fri, Feb 5, 2010 at 1:19 AM, Keld Simonsen <keld@keldix.com> wrote=
:
> > On Wed, Feb 03, 2010 at 03:57:58AM +0100, Keld Simonsen wrote:
> > Hi
> >
> >
> > can anybody help me with this? I am stuck with recovering my system=
 here.
> > is it a sensible thing ro do?
> >
> > best regards
> > keld
> >
> >> Hi
> >>
> >> I got 2 arrays in error of the raid10 type.
> >>
> >> I think this is because my motherboard died, and then the fs were
> >> corrupted.
> >>
> >> My thoughts were that actually one of the copies could be correct.
> >> So I would like to try out the consistency of each part of the rai=
d10
> >> (it is 2-partition arrays), and then if I find one that is consist=
ent, then
> >> resync the faulty one with the good one.
> >>
> >> How do I do this?
> >>
> >> it seems that I cannot just assemble an array with a missing part.
> >> If I assemble the full array, is there then a risk of the bad one
> >> corrupting the good one? And can I declare one of the disks faulty
> >> then test the other one, then declare nbr 2 disk for faulty and
> >> declare the first one as good?
> >>
> >> I dont see anything on the wiki on this.
> >>
> >> best regards
> >> keld
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
>=20
> I wish I could help more, but check out this from the mdadm man page:
>=20
>        To create a "degraded" array in which some devices are missing=
,
> simply give
>        the word "missing" in place of a device name.  This  will
> cause  mdadm  to
>        leave  the  corresponding  slot  in  the array empty.  For a
> RAID4 or RAID5
>        array at most one slot can be "missing"; for a  RAID6  array
> at  most  two
>        slots.   For a RAID1 array, only one real device needs to be
> given.  All of
>        the others can be "missing".

I tried missing, but mdadm said that it could not find missing as a dev=
ice,
for assemble mode.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
