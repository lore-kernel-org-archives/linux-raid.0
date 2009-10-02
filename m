From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Fri, 2 Oct 2009 18:01:56 +0100
Message-ID: <20091002170156.GA21401@cthulhu.home.robinhill.me.uk>
References: <babafd2f0910012046i46f77e82lc1a75bbee3b1a6d8@mail.gmail.com>
 <887103.5263.qm@web38801.mail.mud.yahoo.com>
 <babafd2f0910020754i4818043aw3d4a15e91eec9eb8@mail.gmail.com>
 <20091002151504.GA22207@cthulhu.home.robinhill.me.uk>
 <babafd2f0910020846o22e7dd30l4a7be554770d0904@mail.gmail.com>
 <20091002155919.GB22207@cthulhu.home.robinhill.me.uk>
 <babafd2f0910020931i5b38316dpc6351d5d6ed5211@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <babafd2f0910020931i5b38316dpc6351d5d6ed5211@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Oct 02, 2009 at 09:31:07AM -0700, Ben DJ wrote:

> Hi,
>=20
> On Fri, Oct 2, 2009 at 8:59 AM, Robin Hill <robin@robinhill.me.uk> wrote:
> > For a boot partition I'd stick with RAID-1, then use RAID-10,f2 for
> > other partitions.
>=20
> f2 is clear for read-mostly space, like most of /root.  But for /var?
> /home? other /data?
>=20
> I'm learning there a 'subtleties' to all this.
>=20
Depends really - far isn't much slower on writes (the I/O elevator and
filesystem buffering help).  If you know /var will be write-mostly (it's
often the default location for MySQL data files as well) then a near
layout may be better though.

> > There's no real advantage in using RAID-10,n4 over
> > RAID-1 (it's a different code-path so there may be slight differences
> > one way or the other, but nothing that will matter for a boot
> > partition anyway), and just makes the setup more unusual.
>=20
> I thought that RAID-10's disk failure survivability is n-2, for n >=3D4
> drives.  RAID-1 over 4 drives can also survive 2-drive failure?
>=20
RAID-1 over N disks can survive N-1 drive failures.  Each disk holds a
full copy of the data.

> > It's up to you though - RAID-10,n4 and a four-way RAID-1 will have the
> > same on-disk layout, so either will work fine. =A0Oh - one other thing =
is
> > that RAID-1 is expandable (you can add other partitions later) whereas
> > RAID-10 is not currently.
>=20
> Athough needing to expand /boot is hardly a requirement, I did NOT
> realize that RAID-10 is not expandable.  Partitions ARE certainly
> add-able within the LVM that spans the RAID-10, but I thoguth that
> spindles, and new partition could be added after initial creation.
> Need to read some more.
>=20
Currently only RAID-1,4,5 and 6 support growing arrays (by either adding
spindles or increasing the capacity of each spindle).  There are plans
to add this capability to other RAID levels but I'm not sure where this
sits on the priority list.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrGMgIACgkQShxCyD40xBLREgCdHzfnweQyi3Zpg1gIzFK0jSf/
XnIAoK1BEQXSAD8c1KMJu1skDhg7o1ap
=JDQ8
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
