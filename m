From: Markus Hochholdinger <Markus@hochholdinger.net>
Subject: Re: non-fresh from initrd, all fine when assembling manually
Date: Mon, 5 May 2008 16:56:28 +0200
Message-ID: <200805051656.32276.Markus@hochholdinger.net>
References: <200805021446.32835.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2108803.tD7W3BOplI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200805021446.32835.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--nextPart2108803.tD7W3BOplI
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

hi,

Am Freitag, 2. Mai 2008 14:46 schrieb Dexter Filmore:
> My issues from the last few days all summed up in one, maybe someone knows
> what to do about it, I CC to the debian list as well:
[..]
> Upon reboot, the 5th disk that now sat on the PCI controller alone was
> kicked from the array for being non fresh. I suspected a shutdown problem,
> found one with 2.6.22 and the shutdown utility, fixed that and resynced.
> Next reboot: same story.

update your initrd with update-initramfs. A mdadm.conf is copied to the ini=
trd=20
when creating an initrd. This mdadm.conf ist not automatically updated when=
=20
the md changes.



=2D-=20
greetings

eMHa

--nextPart2108803.tD7W3BOplI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIHyAgXT3LE+AjWCsRAkqUAKC9G588N3woXvyhSxs9pyMDrh8gRACgoJSU
/iBYA6UcMLqTpaKD7ypS6rc=
=dxg8
-----END PGP SIGNATURE-----

--nextPart2108803.tD7W3BOplI--
