From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid 1 errors then I failed and removed the drive. now cant tell
 which one it was?
Date: Tue, 16 Apr 2013 08:46:01 +0100
Message-ID: <20130416074601.GA25795@cthulhu.home.robinhill.me.uk>
References: <20130416042742.GA12964@earthlink.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130416042742.GA12964@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@post.harvard.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Apr 16, 2013 at 12:27:42AM -0400, Mitchell Laks wrote:

> Hi,
>=20
> I store lots of data on a raid1 created with mdadm on debian sid  using k=
ernel=20
> Linux  3.2.0-2-amd64 #1 SMP Fri Apr 6 05:01:55 UTC 2012 x86_64 GNU/Linux.
>=20
> Now I was backing up the data from the raid to another external drive
> and the errors began
>=20
> [730636.445918] ata1.00: error: { UNC }
> [730636.464576] ata1.00: configured for UDMA/33
> [730636.464584] ata1: EH complete
> [730638.110558] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [730638.115052] ata1.00: port_status 0x20200000
> [730638.119441] ata1.00: failed command: READ DMA
> [730638.123848] ata1.00: cmd c8/00:08:ef:9f:90/00:00:00:00:00/e1 tag 0 dm=
a 4096 in
> [730638.123850]          res 51/40:00:f4:9f:90/40:00:01:00:00/e1 Emask 0x=
9 (media error)
> [730638.132821] ata1.00: status: { DRDY ERR }
> [730638.137305] ata1.00: error: { UNC }
> [730638.157256] ata1.00: configured for UDMA/33
> [730638.157262] ata1: EH complete
> [730639.802239] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [730639.806730] ata1.00: port_status 0x20200000
> [730639.811111] ata1.00: failed command: READ DMA
> [730639.815511] ata1.00: cmd c8/00:08:ef:9f:90/00:00:00:00:00/e1 tag 0 dm=
a 4096 in
> [730639.815513]          res 51/40:00:f4:9f:90/40:00:01:00:00/e1 Emask 0x=
9 (media error)
> [730639.824457] ata1.00: status: { DRDY ERR }
> [730639.828930] ata1.00: error: { UNC }
> [730639.848936] ata1.00: configured for UDMA/33
>=20
> they seemed to be coming from drive /dev/sda1 of the raid while
> /dev/sdb1 was ok
> so i did
> mdadm /dev/md0 -f /dev/sda1=20
> mdadm /dev/md0 -r /dev/sda1
>=20
> then I rsynced from the remaining drive to /dev/sdd1 an external
> drive. No more errors.
>=20
> However I forgot to label the usable drive by creating a file on it or
> editing a file on it.=20
>=20
> But now I shut down and unplug one of the two drives, then run=20
> mdadm -E /dev/sda1
> it seems to be the good (unfailed) drive
>=20
> But similarly when  I unplug the other drive and put this one back
> i still get it listed as an unfailed drive
>=20
> how can i figure out which is the failed drive and which is the
> remaining one????
>=20
Normally, the event count and update time will indicate which was
failed, but if you've restarted with each drive in separately then this
may have updated both. The obvious way to check in this case would be to
do a read test of the drive (dd if=3D/dev/sda1 of=3D/dev/null bs=3D1M) or a
SMART test - if you get errors then it's the failed one.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlFtAbgACgkQShxCyD40xBIQ0wCgqUb9qc20GGKJ3k7mlR6cAXon
D9MAoIlzWZ7j7I1vUU2tJ36QRgKmjZnN
=YEic
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
