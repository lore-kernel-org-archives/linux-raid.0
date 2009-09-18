From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID 5 array recovery - two drives errors in external enclosure
Date: Fri, 18 Sep 2009 09:07:06 +0100
Message-ID: <20090918080706.GB22909@cthulhu.home.robinhill.me.uk>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
 <20090917212252.GC19611@cthulhu.home.robinhill.me.uk>
 <2267211f0909171611m4b4a0d02p81b80bc882a0855@mail.gmail.com>
 <70ed7c3e0909171628w4040ae5cydf4335adb51f2b7d@mail.gmail.com>
 <2267211f0909171654v766e658fn620b23268a2393a6@mail.gmail.com>
 <0F9F69CA6B3942B1A44BC0B2D00AE139@m5>
 <2267211f0909172119w6de04e46m5fcfc5e6d35c0382@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2267211f0909172119w6de04e46m5fcfc5e6d35c0382@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Sep 17, 2009 at 09:19:58PM -0700, Tim Bostrom wrote:

> This seemed to work, though I'm still working through the permutations
> of the drive letters.
>=20
> I noticed that mdadm think that partition sde1 is ext2 filesystem on
> it.  See below:
>=20
> [root@tera tbostrom]# mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sdb1
> /dev/sdd1 /dev/sdc1 /dev/sde1 missing
> mdadm: /dev/sdb1 appears to be part of a raid array:
>     level=3Draid5 devices=3D5 ctime=3DThu Sep 17 21:13:21 2009
> mdadm: /dev/sdd1 appears to be part of a raid array:
>     level=3Draid5 devices=3D5 ctime=3DThu Sep 17 21:13:21 2009
> mdadm: /dev/sdc1 appears to be part of a raid array:
>     level=3Draid5 devices=3D5 ctime=3DThu Sep 17 21:13:21 2009
> mdadm: /dev/sde1 appears to contain an ext2fs file system
>     size=3D396408836K  mtime=3DMon Sep 21 03:41:16 2026
> mdadm: /dev/sde1 appears to be part of a raid array:
>     level=3Draid5 devices=3D5 ctime=3DThu Sep 17 21:13:21 2009
> Continue creating array?
>=20
> What gives?  I tried popping sdf1 in there without creating the array
> - just to see what would happen and it thinks that sdf1 has ext2 as
> well.
>=20
That would suggest that sde1 is the first disk in the array (I think).

> Still at a loss here.  I haven't worked through all the drive
> permutations.  In the meantime, I'll try that.  Does it make sense to
> try sdf1 in the permutation since the drive letters may have changed
> since moving from the enclosure?  I thought I put them back in the
> same order as the enclosure.
>=20
Definitely not - we know sdf1 has been re-written when you did the
initial --create after moving the drives out of the enclosure.  This
means it _definitely_ has invalid data on it.

Unfortunately, without having the metadata information from the
_original_ array _after_ it has been moved from the enclosure, there's
no way of knowing what order the drives should be in.  I _think_ that
sde1 will be the first disk (as it shows up as an ext2 filesystem), but
you'll really have to try every possible combination of the 5 devices
(the 4 partitions and "missing").  You may be best scripting this (or
searching to see whether someone's already done that) - there's 120
possible combinations to try.

Cheers,
    Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqzP6kACgkQShxCyD40xBLBuACfZgNp+EID4n3UCh8pxDXYvx9B
7E0AoJcDj8ML02ipWa7BRwC0TAQiMtiX
=hiV5
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
