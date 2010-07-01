From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: Write-intent bitmap decreases or increase performance of RAID5?
Date: Fri, 2 Jul 2010 02:49:27 +0600
Message-ID: <20100702024927.21c4f814@natsu>
References: <20100629201153.GA13018@localhost>
	<20100630111854.006ec4d0@natsu>
	<alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se>
	<20100701064044.GB6058@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/n=H9OjXWbleMEIS.1pvMi.G"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100701064044.GB6058@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Shaochun Wang <scwang@ios.ac.cn>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/n=H9OjXWbleMEIS.1pvMi.G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Jul 2010 14:40:44 +0800
Shaochun Wang <scwang@ios.ac.cn> wrote:

> 	-bash-4.1$ sudo dd if=3D/dev/zero of=3Dtest.dd bs=3D1M count=3D5000
> conv=3Dfdatasync,notrunc Password:
> 	5000+0 records in
> 	5000+0 records out
> 	5242880000 bytes (5.2 GB) copied, 63.497 s, 82.6 MB/s
>=20
> 	-bash-4.1$ sudo dd if=3D/dev/zero of=3Dtest.dd bs=3D1M count=3D5000
> conv=3Dfdatasync,notrunc 5000+0 records in
> 	5000+0 records out
> 	5242880000 bytes (5.2 GB) copied, 18.1033 s, 290 MB/s
> =09
> I don't know why the second dd becomes 290MB/s and the first 82.6MB/s.

That's because the first time the filesystem had to increase the file's size
5000 times by allocating additional 1 MB, and the second time it was just
writing to an already allocated file. If you see such a big difference here,
run that test 3 or more times, and discard the first run's results.


--=20
With respect,
Roman

--Sig_/n=H9OjXWbleMEIS.1pvMi.G
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkws/1cACgkQTLKSvz+PZwiZUQCfSda6ruOIjNHbmAqJqCFDsTB6
AtYAn0u72Wb6+U+SaidO1Y0/VZfQyDwe
=C0MF
-----END PGP SIGNATURE-----

--Sig_/n=H9OjXWbleMEIS.1pvMi.G--
