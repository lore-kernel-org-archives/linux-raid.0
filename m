From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: status of raid 4/5 disk reduce
Date: Tue, 9 Dec 2008 21:51:50 +0000
Message-ID: <20081209215149.GA21523@cthulhu.home.robinhill.me.uk>
References: <493D8A95.2020700@mikebrancato.com> <493EDF02.5090500@redwax.co.uk> <A20315AE59B5C34585629E258D76A97C02F476F7@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A20315AE59B5C34585629E258D76A97C02F476F7@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Dec 09, 2008 at 03:33:17PM -0600, David Lethe wrote:

> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Alex Lilley
> > Sent: Tuesday, December 09, 2008 3:12 PM
> > To: Michael Brancato
> > Cc: linux-raid@vger.kernel.org
> > Subject: Re: status of raid 4/5 disk reduce
> >=20
> > Hi Michael
> >=20
> > I posed this a few weeks back but haven't seen any activity on it yet
> > or
> > any suggestion as to when this might be possible.
> >=20
> > For reference, my thread started here:
> > http://marc.info/?l=3Dlinux-raid&m=3D122753511309332&w=3D2
> >=20
> > Cross fingers for this because I think it is a real killer feature.
> >=20
> > Regards
> >=20
> > Alex
> >=20
> > Michael Brancato wrote:
> > > I'm curious as to the status of the ability to reduce the number of
> > > disks in a RAID 4/5 array.  I would like the ability to reshape a 4
> > > disk raid4/5 to a 3 disk raid4/5 for flexibility.
> > >
> > > here is what I want to do....
> > > $ sudo mdadm /dev/md0 --fail /dev/disk4 --remove /dev/disk4
> > > mdadm: set /dev/disk4 faulty in /dev/md0
> > > mdadm: hot removed /dev/disk4
> > > $ sudo mdadm --grow /dev/md0 -n3
> > > mdadm: /dev/md0: Cannot reduce number of data disks (yet).
> > >
> > > I know this capability is missing in the md driver.  What is needed to
> > > make it work and is anyone currently working on it?
> > >
> > > Regards,
> > >
>=20
> This is a lot to ask for in terms of development, and creates extreme
> risk of data loss.
> First, you degrade /dev/md0, so any bad blocks or drive failures will
> cause catastrophic
> data loss, unless /dev/disk4 is used for mirroring in the interim.
>=20
> Secondly, by removing that disk (for sake of argument, say each disk is
> 1TB. You go from 3TB usable data
> to 2TB.  Most likely, you need to resize the file system in place so it
> fits into 2TB.  You're probably booted
> onto md0 also, which makes it difficult.  Resizing a hot filesystem
> without scratch space??  If your file system
> can't be dynamically reduced, then no point worrying about md raid.=20
>=20
> I don't see it happening .. ever.  Even if somebody wrote the logic, I
> can't imagine the code being tested enough
> to be safe for live data. =20
>=20
I'd agree that, as described here, it's not too likely.

However, if you start with the requirement that the capacity of the
final array is the same or larger than the capacity of the current array
(e.g. replace the drives, one at a time, with larger drives first) so
that no filesystem resizing is required, you should be able to do the
reshape without having to go degraded at all.  I'm not sure this process
would be fundamentally more complex (or more risky) than the current
growing process.

Having said that, I'm not aware of any current work going on on this.
Things like RAID1 -> RAID5 and RAID5 -> RAID6 reshaping seem to be more
in demand than shrinking as well.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkk+6HUACgkQShxCyD40xBKIaACfX9/biETuGtcIr7mWjsVR/YQ4
QRQAoL+hgKQszJUnGswrOCNEGBPOwvAQ
=06Ws
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
