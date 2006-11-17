From: martin f krafft <madduck@madduck.net>
Subject: Re: RAID5/10 chunk size and ext2/3 stride parameter
Date: Fri, 17 Nov 2006 15:09:24 +0100
Message-ID: <20061117140924.GB21007@lapse.madduck.net>
References: <20061024160306.GA15393@lapse.madduck.net> <Pine.LNX.4.64.0611031103520.26057@twinlark.arctic.org> <20061104120049.GA16979@piper.madduck.net> <Pine.LNX.4.64.0611041852030.13706@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0611041852030.13706@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach dean gaudet <dean@arctic.org> [2006.11.05.0359 +0100]:
> they're different in that with f2 you get essentially 4 disk raid0
> read performance because the copies of each byte are half a disk
> away... so it looks like a raid0 on the first half of the disks,
> and another raid0 on the second half.
>=20
> in n2 the two copies are at the same offset... so it looks more
> like a 2 disk raid0 for reading and writing.

I don't know what difference that would make on the parameters of
the XFS filesystem, as determined by mkfs.

Also, I doubt you can get 4 disk RAID0 disk performance with two
disks, no matter what layout you choose. There are still only two
disks, so you can only ever read two blocks at once.

Thanks for the info.

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
"was aus liebe getan wird,
 geschieht immer jenseits von gut und b=F6se."
                                                 - friedrich nietzsche

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFXcKUIgvIgzMMSnURAjQGAJ9LfGV6GR5SWo+goconDHLY4p+q1gCeIrw7
9n0eiNVu0gxDM6aaLWbPwQI=
=rL8u
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
