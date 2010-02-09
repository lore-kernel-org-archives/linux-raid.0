From: Keld Simonsen <keld@keldix.com>
Subject: Re: recovering a mirrored arry.
Date: Tue, 9 Feb 2010 12:52:28 +0100
Message-ID: <20100209115228.GA20363@light.rap.dk>
References: <20100203025758.GA12925@light.rap.dk> <20100205011928.GA12630@light.rap.dk> <73e903671002050825j2ae06fabjc7ec2b1e8fb85135@mail.gmail.com> <20100205185043.GA6956@light.rap.dk> <20100205224225.GA8099@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100205224225.GA8099@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 05, 2010 at 10:42:25PM +0000, Robin Hill wrote:
> On Fri Feb 05, 2010 at 07:50:44PM +0100, Keld Simonsen wrote:
>=20
> > On Fri, Feb 05, 2010 at 04:25:02PM +0000, Kristleifur Da=F0ason wro=
te:
> > > On Fri, Feb 5, 2010 at 1:19 AM, Keld Simonsen <keld@keldix.com> w=
rote:
> > > > On Wed, Feb 03, 2010 at 03:57:58AM +0100, Keld Simonsen wrote:
> > > > Hi
> > > >
> > > >
> > > > can anybody help me with this? I am stuck with recovering my sy=
stem here.
> > > > is it a sensible thing ro do?
> > > >
> > > > best regards
> > > > keld
> > > >
> > > >> Hi
> > > >>
> > > >> I got 2 arrays in error of the raid10 type.
> > > >>
> > > >> I think this is because my motherboard died, and then the fs w=
ere
> > > >> corrupted.
> > > >>
> > > >> My thoughts were that actually one of the copies could be corr=
ect.
> > > >> So I would like to try out the consistency of each part of the=
 raid10
> > > >> (it is 2-partition arrays), and then if I find one that is con=
sistent, then
> > > >> resync the faulty one with the good one.
> > > >>
> > > >> How do I do this?
> > > >>
> > > >> it seems that I cannot just assemble an array with a missing p=
art.
> > > >> If I assemble the full array, is there then a risk of the bad =
one
> > > >> corrupting the good one? And can I declare one of the disks fa=
ulty
> > > >> then test the other one, then declare nbr 2 disk for faulty an=
d
> > > >> declare the first one as good?
> > > >>
> > > >> I dont see anything on the wiki on this.
> > > >>
> > > >> best regards
> > > >> keld
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux=
-raid" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at =A0http://vger.kernel.org/majordomo-info=
=2Ehtml
> > > >
> > >=20
> > >=20
> > > I wish I could help more, but check out this from the mdadm man p=
age:
> > >=20
> > >        To create a "degraded" array in which some devices are mis=
sing,
> > > simply give
> > >        the word "missing" in place of a device name.  This  will
> > > cause  mdadm  to
> > >        leave  the  corresponding  slot  in  the array empty.  For=
 a
> > > RAID4 or RAID5
> > >        array at most one slot can be "missing"; for a  RAID6  arr=
ay
> > > at  most  two
> > >        slots.   For a RAID1 array, only one real device needs to =
be
> > > given.  All of
> > >        the others can be "missing".
> >=20
> > I tried missing, but mdadm said that it could not find missing as a=
 device,
> > for assemble mode.
> >=20
> No, as the manual page says, "missing" is only used for creating an
> array, not for assembling.
>=20
> If you only give a single device in the assemble command then mdadm
> _ought_ to only use that to assemble the array.  I'm not 100% sure th=
at
> it does it though - probably worth testing with loopback devices firs=
t.
>=20
> The other option would be to use "create" to create new degraded arra=
ys
> containing only the single disks.  You'd need to make sure you used t=
he
> same settings as for the old array though.
>=20
> Alternately, physically disconnect the drives in turn and assemble th=
e
> array with the single drive.
>=20
> Cheers,
>     Robin
> --=20
>      ___       =20
>     ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>    / / )      | Little Jim says ....                            |
>   // !!       |      "He fallen in de water !!"                 |


I tried a number of ways to trick mdadm to assemble the raid with only
one partition. It seems like mdadm -A neither accepts a "missing"
argument nor just a single device. But the following worked.

I changed the "DEVICES" entry in mdadm.conf . to not list the device
that I wanted to exclude. I could then assemble and fsck each of the
parts of the mirrored array (changing mdadm DEVICES to exclude the
appropiate device).

And with good result! One of the devices were badly damaged, while the
other was intact! So long, so good.

Is this sufficiently interesting to warrant an entry on the wiki?

Best regards
keld

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
