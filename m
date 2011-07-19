From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: data corruption after rebuild
Date: Tue, 19 Jul 2011 22:48:19 +0600
Message-ID: <20110719224819.7aa5582d@natsu>
References: <2073005.NH8LALaxuD@bloomfield>
	<20110719211240.2578bba6@natsu>
	<4879002.CX4iSyfhxZ@bloomfield>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WqFbqoATtx1lxEcDBU2twx3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4879002.CX4iSyfhxZ@bloomfield>
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Herrmann <morpheus.ibis@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WqFbqoATtx1lxEcDBU2twx3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Jul 2011 18:35:26 +0200
Pavel Herrmann <morpheus.ibis@gmail.com> wrote:

> On Tuesday 19 of July 2011 21:12:40 Roman Mamedov wrote:
> > > I do monthly scans, so the redundancy syndromes should have been
> > > up-to-date, the array is made of 8 disks, the setup is ext4 on lvm on
> > > mdraid
> >=20
> > Did you notice any nonzero mismatch_cnt during those scans?
>=20
> oh crap, the rebuild finished with
>=20
> Jul 19 09:41:24 Bloomfield mdadm[3996]: RebuildFinished event detected on=
 md device /dev/md0, component device  mismatches found: 3184
>=20
> this is really bad i presume?=20

Well, this basically tells you what you already know - a part of the data y=
ou have was corrupted. In this case I think it's 3184 512-byte sectors, whi=
ch is about 1.6MB total.
How it got there and how to prevent that from happening in the future - tha=
t's a whole different question.

--=20
With respect,
Roman

--Sig_/WqFbqoATtx1lxEcDBU2twx3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4ltVMACgkQTLKSvz+PZwj7wACfZrCVJ/nBUzg1ElhM1R+FEKtL
zgUAn0o8rPHOPmc9yULdD3XXduoujtLN
=+Qhk
-----END PGP SIGNATURE-----

--Sig_/WqFbqoATtx1lxEcDBU2twx3--
