From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 4 Feb 2011 16:22:12 +0000
Message-ID: <20110204162212.GA21779@cthulhu.home.robinhill.me.uk>
References: <20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
 <AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
 <AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>
 <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
 <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
 <4D470F96.40409@cfl.rr.com>
 <4D471A41.1090706@hardwarefreak.com>
 <4D4730C0.8080900@cfl.rr.com>
 <20110201092007.GA7860@cthulhu.home.robinhill.me.uk>
 <4D4C2352.9000407@cfl.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D4C2352.9000407@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Feb 04, 2011 at 11:03:30AM -0500, Phillip Susi wrote:

> FYI, you should get in the habit of using your mail client's reply to
> all function.  I did not see this until now because you did not send me
> a copy.
>=20
I'll make an exception in this case, but I generally reply to messages
on mailing lists to the list only, and I have no plans to change this.

> On 2/1/2011 4:20 AM, Robin Hill wrote:
> > No, it's RAID 10 or RAID 1+0. RAID 0+1 would be 2 mirrored pairs of
> > 5-disk RAID 0 arrays, in which case you could only lose 5 disks if
>=20
> In English we read from left to right and top to bottom, so 0+1 means
> stripe on top of mirror.
>=20
The vast majority of online sources would disagree with you.  See:
    http://en.wikipedia.org/wiki/Nested_RAID_levels
    http://www.aput.net/~jheiss/raid10/
    http://decipherinfosys.wordpress.com/2008/01/15/difference-between-raid=
-01-vs-raid-10/
    http://www.raid.com/04_01_0_1.html
    http://www.pcguide.com/ref/hdd/perf/raid/levels/multLevel01-c.html
    http://www.adrc.com/raid-01.html

The order it's written is the order of creation.  RAID0+1 =3D  RAID 0,
then RAID 1 (mirrored stripes) and RAID1+0 =3D RAID 1, then RAID 0
(striped mirrors).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk1MJ7MACgkQShxCyD40xBLu9gCg0bcz3kiUFnZqWJHSJ4itQMXg
WsIAoJLvipPAYYBZA9m/4DhOVj6ZzIg+
=TBDz
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
