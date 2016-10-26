From: Nick Black <dankamongmen@gmail.com>
Subject: Re: data loss+inode recovery using RAID6 write journal
Date: Wed, 26 Oct 2016 14:51:33 -0400
Message-ID: <20161026185133.thjrnsrtzlagegen@schwarzgerat.orthanc>
References: <20161024235505.rb4fucq24ybbn5aq@schwarzgerat.orthanc>
 <20161026184359.u7pwbxzz7i5mcbfm@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pp6y3ye3frkpsr5v"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161026184359.u7pwbxzz7i5mcbfm@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--pp6y3ye3frkpsr5v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Shaohua Li left as an exercise for the reader:
> Thanks for the testing. We can't improve the quality of the new feature if
> nobody tests it. Yep, the write journal isn't mature yet, but I can't ima=
gine
> the data loss. With write journal, data is written to the ssd first, then=
 to
> raid disks and IO is finished at that time. So if IO is finished, the data
> should be in raid disks. The only possible way to data loss is the recove=
ry.
> But it's also possible filesystem/writeback hasn't flushed data to disk y=
et.
> I'm wondering if you can reproduce it with/without journal, so we can nar=
row
> down it a bit.

I doubt it can be replaced without the journal -- like I said, I've been
using mdadm RAID[56] for over a decade, and never seen such a problem.

I'll attempt to reproduce with the journal enabled. Assuming I can, I can
try to reproduce without, but I doubt it'll be fruitful. Are there any
debugging options / flags I should enable prior reproducing in order to get
a more complete report? Some state I should dump from my array and
filesystems? Feel free to be technical.

I owe a lot to Linux MD RAID, and am happy to put some effort into running
this down.

I'll report whether I can at least reproduce ASAP.

--nick

--=20
nick black -=3D- http://www.nick-black.com
to make an apple pie from scratch, you need first invent a universe.

--pp6y3ye3frkpsr5v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iEYEABECAAYFAlgQ+yIACgkQzjCRTpolKGsN+ACffsIKu0ZDHTqGwAF3PTM8WIoC
ovIAniRDx8lxVpqHj0/uNwQ6nFH2GETy
=4gjl
-----END PGP SIGNATURE-----

--pp6y3ye3frkpsr5v--
