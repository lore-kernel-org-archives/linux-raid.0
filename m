From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Remote NAS
Date: Tue, 22 Sep 2009 21:09:12 +0100
Message-ID: <20090922200912.GA28999@cthulhu.home.robinhill.me.uk>
References: <484423.6825.qm@web38807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <484423.6825.qm@web38807.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Sep 22, 2009 at 12:38:37PM -0700, adfas asd wrote:

> > Right now I'm RAIDing two 2TB drives in RAID10offset2. Need
> > to add some drives and maybe I'll remote them using NAS (GB
> > ethernet), for fire and theft protection.
> > =20
> > So could the BIOS actually boot this if 2 drives are in the
> > machine and 2 are in the garage? Is there a way to specify
> > in mdadm that the two in the garage are mirrored from the
> > two in the system?
> >=20
The BIOS boots from a single drive, and won't boot from RAID10, so
presumably you already have a non-RAID (or RAID-1) boot partition.
Certainly I don't see why mdadm can't start up an array set up like this
though.  As for setting up how they're mirrored, it sounds like you want
a RAID-1 mirror over the top of a pair of RAID10 arrays.

> > Is GB ethernet NAS noticably slower than eSATA?  Is it
> > reliable?
> > =20
It's technically slower, certainly - eSATA could be 3Gb compared to the
1Gb on ethernet.  On top of that you'll have added latency, so I'd be
surprised if you didn't notice the speed difference.  As for reliability
- I don't see why it shouldn't be (providing you're using decent
cabling).

> > What if I use the mobo's e-SATA port to add 5 external
> > drives locally. This would require a port multiplier. I
> > presume it would not be bootable, since a port multiplier
> > needs OS support? Or would something go in initrd.img?=20
> > Or would I need an individual boot drive to get things up?
> > =20
Depends on exactly how the BIOS sees is - some seem to see a single
drive off the multiplier, so can boot off that one, whereas others won't
see anything.  The initrd question is immaterial, as this is only read
after the BIOS has called the boot loader, but certainly you could load
any necessary drivers at that point.

> > Using the array to store MythTV recordings (very large
> > files), but when it does commercial flagging (lots of
> > writes) the array is so busy that GUI response is very
> > slow.  I've set readahead cache to optimal (4096, after
> > testing most sizes), so read should be OK.  I know far
> > is optimized for read, so I chose offset in hopes it would
> > bring up write speed.  Is there a way to speed up
> > writes?
> >=20
I'm not sure offset is really noticeably faster than far for writes.
Commercial flagging shouldn't be writing to the recordings drive though
- it's just inserting database metadata.  If your MythTV database is on
the same array/drives then you'll certainly get a big gain from moving
it to a separate disk.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq5LucACgkQShxCyD40xBL6oACbBntfuZrUznkUI1zqmUXwB6YA
cmgAn2xh+y3pa2zABBUHrnir1UkKmApO
=1Jye
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
