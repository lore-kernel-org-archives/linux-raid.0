From: Keld Simonsen <keld@keldix.com>
Subject: Re: recovering a mirrored arry.
Date: Fri, 5 Feb 2010 23:38:01 +0100
Message-ID: <20100205223801.GA7672@light.rap.dk>
References: <20100203025758.GA12925@light.rap.dk> <20100205011928.GA12630@light.rap.dk> <73e903671002050825j2ae06fabjc7ec2b1e8fb85135@mail.gmail.com> <20100205185043.GA6956@light.rap.dk> <73e903671002051406l5dd7b359w5c7fd540bb667d82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <73e903671002051406l5dd7b359w5c7fd540bb667d82@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kristleifur =?iso-8859-1?Q?Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 05, 2010 at 10:06:38PM +0000, Kristleifur Da=F0ason wrote:
> On Fri, Feb 5, 2010 at 6:50 PM, Keld Simonsen <keld@keldix.com> wrote=
:
> > On Fri, Feb 05, 2010 at 04:25:02PM +0000, Kristleifur Da=F0ason wro=
te:
> >> On Fri, Feb 5, 2010 at 1:19 AM, Keld Simonsen <keld@keldix.com> wr=
ote:
> >> > On Wed, Feb 03, 2010 at 03:57:58AM +0100, Keld Simonsen wrote:
> >> > Hi
> >> >
> >> >
> >> > can anybody help me with this? I am stuck with recovering my sys=
tem here.
> >> > is it a sensible thing ro do?
> >> >
> >> > best regards
> >> > keld
> >> >
> >> >> Hi
> >> >>
> >> >> I got 2 arrays in error of the raid10 type.
> >> >>
> >> >> I think this is because my motherboard died, and then the fs we=
re
> >> >> corrupted.
> >> >>
> >> >> My thoughts were that actually one of the copies could be corre=
ct.
> >> >> So I would like to try out the consistency of each part of the =
raid10
> >> >> (it is 2-partition arrays), and then if I find one that is cons=
istent, then
> >> >> resync the faulty one with the good one.
> >> >>
> >> >> How do I do this?
> >> >>
> >> >> it seems that I cannot just assemble an array with a missing pa=
rt.
> >> >> If I assemble the full array, is there then a risk of the bad o=
ne
> >> >> corrupting the good one? And can I declare one of the disks fau=
lty
> >> >> then test the other one, then declare nbr 2 disk for faulty and
> >> >> declare the first one as good?
> >> >>
> >> >> I dont see anything on the wiki on this.
> >> >>
> >> >> best regards
> >> >> keld
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-=
raid" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.=
html
> >> >
> >>
> >>
> >> I wish I could help more, but check out this from the mdadm man pa=
ge:
> >>
> >> =A0 =A0 =A0 =A0To create a "degraded" array in which some devices =
are missing,
> >> simply give
> >> =A0 =A0 =A0 =A0the word "missing" in place of a device name. =A0Th=
is =A0will
> >> cause =A0mdadm =A0to
> >> =A0 =A0 =A0 =A0leave =A0the =A0corresponding =A0slot =A0in =A0the =
array empty. =A0For a
> >> RAID4 or RAID5
> >> =A0 =A0 =A0 =A0array at most one slot can be "missing"; for a =A0R=
AID6 =A0array
> >> at =A0most =A0two
> >> =A0 =A0 =A0 =A0slots. =A0 For a RAID1 array, only one real device =
needs to be
> >> given. =A0All of
> >> =A0 =A0 =A0 =A0the others can be "missing".
> >
> > I tried missing, but mdadm said that it could not find missing as a=
 device,
> > for assemble mode.
> >
> > best regards
> > keld
> >
>=20
> Hmmm ... I guess your version of mdadm may be too old. Which version
> do you have?

v2.5.3

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
