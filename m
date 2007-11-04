From: Doug Ledford <dledford@redhat.com>
Subject: Re: stride / stripe alignment on LVM ?
Date: Sat, 03 Nov 2007 21:02:07 -0400
Message-ID: <1194138127.25553.62.camel@firewall.xsintricity.com>
References: <20071101101037.63b523f8@absurd>
	 <18218.24819.569744.141171@notabene.brown> <472B1F91.8000208@tmr.com>
	 <20071102231605.7add5154@absurd>
	 <1194115248.25553.59.camel@firewall.xsintricity.com>
	 <20071103212118.5fd4c770@absurd>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7p5SDk65cEOjh9Uh5+hu"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071103212118.5fd4c770@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-7p5SDk65cEOjh9Uh5+hu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-11-03 at 21:21 +0100, Janek Kozicki wrote:

> > If you run mdadm -D /dev/md1 it will tell you the data offset
> > (in sectors IIRC).
>=20
> Uh, I don't see it:

Sorry, it's part of mdadm -E instead:

[root@firewall ~]# mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : c746e4f5:b015ffac:7216dbbd:48d973a7
           Name : firewall:home:2
  Creation Time : Mon May 28 20:47:07 2007
     Raid Level : raid1
   Raid Devices : 2

  Used Dev Size : 625137018 (298.09 GiB 320.07 GB)
     Array Size : 625137018 (298.09 GiB 320.07 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 7efd05d5:dd921536:1d1a1750:6ba49303

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Nov  3 21:01:24 2007
       Checksum : 27b3958f - correct
         Events : 2


    Array Slot : 0 (0, 1)
   Array State : Uu
[root@firewall ~]#=20

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-7p5SDk65cEOjh9Uh5+hu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHLRoPTzP9PM7pjw8RAjriAJ9hamPsMBEycAb5Nxj9xRKOHJoE1gCeK0FC
xusDFgOJfpXEwaB/Rqxehuo=
=OiL8
-----END PGP SIGNATURE-----

--=-7p5SDk65cEOjh9Uh5+hu--

