From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: md RAID1 passes I/O errors to the filesystem despite having
 alive mirrors?
Date: Fri, 15 Mar 2013 17:21:35 +0600
Message-ID: <20130315172135.779185b5@natsu>
References: <20130315041054.79eb5dcc@natsu>
	<32050581.8.1363345666963.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RtENIRQZuzR0.aHbuQrLzK4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <32050581.8.1363345666963.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/RtENIRQZuzR0.aHbuQrLzK4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Mar 2013 12:07:47 +0100 (CET)
Roy Sigurd Karlsbakk <roy@karlsbakk.net> wrote:

> > What happened was:
> > - a device (sdg1) was added as a write-mostly member to a degraded
> > two-member RAID1 (md3) and started recovering;
>=20
> May I be so frank as to guessing you found an old drive and added as writ=
e-mostly? sdg is the bad drive here=E2=80=A6

This is correct, but I should note that I did not add it as write-mostly ju=
st
because it's an older drive, but because it is my normal set-up for md3:
a RAID1 mirror of a fast SSD (sdf) and a write-mostly HDD (sdg in this case=
).

--=20
With respect,
Roman

--Sig_/RtENIRQZuzR0.aHbuQrLzK4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFDBD8ACgkQTLKSvz+PZwhe9gCfeJiSfcQOKD7EvR+lWFX3EuKR
mM4AnRtBZXlp/mjvOmunk0SqShiqTFyN
=DNIq
-----END PGP SIGNATURE-----

--Sig_/RtENIRQZuzR0.aHbuQrLzK4--
