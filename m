From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Upgrading from RAID 5 to 6 or build native level 6?
Date: Sat, 19 Feb 2011 17:28:42 +0500
Message-ID: <20110219172842.5bc79f44@natsu>
References: <AANLkTik8XFxjKJ+GoPjmos6Qm_WKzFw4O29Rr2w8cnGJ@mail.gmail.com>
	<AANLkTikqytG1S1nU0NkZSjcEs08kyDFUUKpfgxGerQn7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/R+28nxhfxQ2XQ0H2HE+mDPF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikqytG1S1nU0NkZSjcEs08kyDFUUKpfgxGerQn7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Beolach <beolach@gmail.com>
Cc: Lasse Jensen <fafler@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/R+28nxhfxQ2XQ0H2HE+mDPF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Feb 2011 19:02:07 -0700
Beolach <beolach@gmail.com> wrote:

> That information is incomplete or out-of-date.  During a RAID 5 to
> RAID 6 reshape, there may be an intermediate step where all of the Q
> parity blocks are stored on one disk, but as the reshape continues, it
> will move all the Q parity blocks to a normal RAID 6 layout.  IIRC, in
> the very early stages of RAID 5 to RAID 6 reshape development, it
> would leave it in the abnormal layout, but that has not been the case
> for quite some time.  And I believe in some cases a RAID 5 to RAID 6
> reshape will not even use the intermediate step w/ the abnormal
> layout.  After the reshape fully completes, it is exactly the same as
> a RAID 6 array built from scratch.

See man mdadm --layout=3Dpreserve vs --layout=3Dnormalise.
I am not sure which one of these is the default, but it is definitely still
possible to convert RAID5 to RAID6 (while adding one disk) without restripi=
ng,
and to me this looks like a very useful feature, not something outdated.

--=20
With respect,
Roman

--Sig_/R+28nxhfxQ2XQ0H2HE+mDPF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1ft3sACgkQTLKSvz+PZwgyTACfYuPZMGraOimTSoUvw3ZIAKVk
wN4Anj9+l7SbOzyqQs6Ji7KpYoha7G34
=WYlt
-----END PGP SIGNATURE-----

--Sig_/R+28nxhfxQ2XQ0H2HE+mDPF--
