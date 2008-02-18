From: Andre Noll <maan@systemlinux.org>
Subject: Re: RAID5 to RAID6 reshape?
Date: Mon, 18 Feb 2008 13:46:48 +0100
Message-ID: <20080218124648.GA29895@skl-net.de>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com> <20080217143122.36413814@szpak> <Pine.LNX.4.64.0802171727250.27728@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802171727250.27728@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17:40, Mark Hahn wrote:
> >Question to other people here - what is the maximum partition size
> >that ext3 can handle, am I correct it 4 TB ?
>=20
> 8 TB.  people who want to push this are probably using ext4 already.

ext3 supports up to 16T for quite some time. It works fine for me:

root@ume:~ # mount |grep sda; df /dev/sda; uname -a; uptime
/dev/sda on /media/bia type ext3 (rw)
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda               15T  7.8T  7.0T  53% /media/bia
Linux ume 2.6.20.12 #3 SMP Tue Jun 5 14:33:44 CEST 2007 x86_64 GNU/Linux
 13:44:29 up 236 days, 15:12,  9 users,  load average: 10.47, 10.28, 10.17

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHuX44Wto1QDEAkw8RAg8qAJ9zd79vnFfiv+f+BV0EUzh2niI53gCeJJ1g
UHbcUg6LxLrcyohGv1jv6VI=
=VlxP
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
