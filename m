From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Converting system to raid
Date: Fri, 10 Apr 2009 20:53:03 +0100
Message-ID: <20090410195303.GB21242@cthulhu.home.robinhill.me.uk>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49DF0D06.8030705@musmo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Apr 10, 2009 at 11:10:30AM +0200, KwangErn Liew wrote:

>
> Timothy D. Lenz wrote:
>> Ended with warning: unable to open an initial console. I was able to=20
>> scroll back and didn't really see any errors. Don't know if I
>> missed a change to some config file or something else that should be bui=
lt=20
>> into the kernel. I have gone over a lot of "guides" and
>> don't see what is missing.
>
> FYI, I've never been successful in booting RAID without initrd even thoug=
h=20
> all necessary modules are built-in. I guess mdadm.conf requires initrd to=
=20
> kick start?
>
There's no problems booting RAID without initrd - you'll need to make
sure that you're using partitions (rather than whole disks) with type
0xFD, and that the array itself is using version 0.9 superblocks
(otherwise the kernel auto-assembly will fail).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAknfo54ACgkQShxCyD40xBITcwCgqLRiqsajw6SzQl9ZQrvVxbCr
SwMAoLi2V0+P72MYWMJjxRAczhdlit8J
=XROI
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
