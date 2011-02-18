From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Linux software RAID assistance
Date: Fri, 18 Feb 2011 09:38:04 +0000
Message-ID: <20110218093804.GA2405@cthulhu.home.robinhill.me.uk>
References: <4D540F6C.6050904@gmail.com>
 <20110215155315.55d35b8e@notabene.brown>
 <4D5A92F3.1090004@turmel.org>
 <4D5ACE4B.9040309@gmail.com>
 <4D5AD613.3040402@turmel.org>
 <20110216004524.67abe977@natsu>
 <AANLkTikLWmC1u3rMFktwULgSPh-zL+D-xgcyogcJfqnP@mail.gmail.com>
 <20110217204221.7a865364@natsu>
 <4D5E383D.9010608@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D5E383D.9010608@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon McNair <simonmcnair@gmail.com>
Cc: Roman Mamedov <rm@romanrm.ru>, Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Feb 18, 2011 at 09:13:33AM +0000, Simon McNair wrote:

> Hi Roman,
> Sorry to be so persistent on something that is not Linux raid specific,=
=20
> but I still can't get blkid to run, the message is:
>=20
> proxmox:~# ls -la /usr/lib/debug/sbin/blkid
> -rwx------ 1 root root 19887 2008-10-13 04:54 /usr/lib/debug/sbin/blkid
>=20
> proxmox:~# /usr/lib/debug/sbin/blkid --help
> -bash: /usr/lib/debug/sbin/blkid: cannot execute binary file
>=20
> If I can't run it directly I'm pretty sure symlinking it will not make=20
> any difference.  It's weird, normally when I apt-get things it modifies=
=20
> the path etc and does everything required to make it work, I would have=
=20
> thought if I installed a debug version of something it should add the=20
> debug path as well ?
>=20
I suspect that those are just the debug symbols - they're split off from
the binary so they can be automatically pulled in when needed, but don't
bloat the application itself.  From the package naming, the actual blkid
binary should be in the e2fsprogs package - do you have that installed?

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk1ePfkACgkQShxCyD40xBKB0gCg4FWbYa1tLrwhvWwc6vCunW1O
UvsAnj9K7vBAfri062hPqIKu7j1t2zAG
=Rwwt
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
