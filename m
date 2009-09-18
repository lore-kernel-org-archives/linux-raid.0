From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID 5 array recovery - two drives errors in external enclosure
Date: Fri, 18 Sep 2009 08:58:23 +0100
Message-ID: <20090918075823.GA22909@cthulhu.home.robinhill.me.uk>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
 <20090917212252.GC19611@cthulhu.home.robinhill.me.uk>
 <70ed7c3e0909171435u661eeccbte85f968e067709f9@mail.gmail.com>
 <2267211f0909171451q547355a7sd26d3f984fd0bccf@mail.gmail.com>
 <70ed7c3e0909171511j6403f51h722e54bb467792df@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70ed7c3e0909171511j6403f51h722e54bb467792df@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Sep 18, 2009 at 01:11:14AM +0300, Majed B. wrote:

> If you run mdadm --examine /dev/sda you'll be able to see the disks'
> order in the array (and the position of the disk you're
> querying/examining). The faulty one is previously known as sdf. You
> can find its new name by running --examine on all disks, and the one
> that shows that all disks are healthy, is sdf.
>=20
Ideally, yes, but having run --create already, the RAID metadata no
longer has any significance to the previous array configuration.

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
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqzPZ4ACgkQShxCyD40xBIMhQCfYyr+7cxVFXBMoCUPB6ZFBFsJ
5skAmwRYF8m5W3GZXUt5aXjWCv7Hg2MY
=aNbZ
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
