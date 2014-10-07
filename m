From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Bad sequential performance of RAID5 with a lot of disk seeks
Date: Tue, 7 Oct 2014 12:05:26 +0100
Message-ID: <20141007110526.GD18786@cthulhu.home.robinhill.me.uk>
References: <54336FC1.6080306@gautschi.net>
 <20141007074347.GA18786@cthulhu.home.robinhill.me.uk>
 <20141007095422.Horde.3l6BckPhfY5U8dchaOdLNA1@webmail.gautschi.net>
 <20141007092548.GC18786@cthulhu.home.robinhill.me.uk>
 <20141007123619.Horde.tC2-gMUttC5BYOoaKogzlw9@webmail.gautschi.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mSxgbZZZvrAyzONB"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141007123619.Horde.tC2-gMUttC5BYOoaKogzlw9@webmail.gautschi.net>
Sender: linux-raid-owner@vger.kernel.org
To: "P. Gautschi" <linuxlist@gautschi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--mSxgbZZZvrAyzONB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Oct 07, 2014 at 12:36:19PM +0200, P. Gautschi wrote:

> > What does the SMART info show for the drives - are there any reallocated
> > blocks? A large number of those scattered over the disk would certainly
> > cause seeking for both reads and writes.
>=20
> I will check the SMART this evening but I don't think that this is causing
> the seek. The sound is very constant and for the whole time of syncing =
=20
> the array.
> I will also run a dd on the disk to compare.
>=20
> > It's also worth checking whether there's anything else that would be
> > accessing the disks in the background (monitoring/indexing/etc).
>=20
> Unlikely because I have not yet created a filesystem after setting up =20
> the RAID4.
>=20
> > I can't think of anything else that would be causing reads to seek - SMR
> > disks or write-intent bitmaps would only affect writes.
>=20
> Exactly
>=20
> Is there any way or tool to monitor all disk read/write commands - not on=
ly
> the count or amount but every access with LBA and length?
>=20
You can do:
    echo 1 > /proc/sys/vm/block_dump

That will write out all disk IO to the kernel log (process ID,
read/write and block offset only though). It can be very verbose,
especially if you have a lot of other things running on the system, but
you should be able to grep out the necessary lines. Echoing 0 will
switch it back off again.

Otherwise there's probably ways to get more specific results via the
kernel auditing system, but that's nothing I've played with.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--mSxgbZZZvrAyzONB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlQzyPUACgkQShxCyD40xBIesACgvSorNRMKmVhOW75xaj05ryzd
EioAn1a5D39MRMN4BhAaGzjwz7jn5Pdb
=bx3o
-----END PGP SIGNATURE-----

--mSxgbZZZvrAyzONB--
