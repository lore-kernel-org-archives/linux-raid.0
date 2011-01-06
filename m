From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Considering a complete rework of RAID on my home compute server
Date: Thu, 6 Jan 2011 05:47:54 +0500
Message-ID: <20110106054754.44e7fe1a@natsu>
References: <AANLkTinsQoPVaYVe4H9kMK7_-GFzHoKt_Zdf4nUKc+C2@mail.gmail.com>
 <87.68.02631.5E6052D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/J6S6MIEsDW7IHyo97NFZbNz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87.68.02631.5E6052D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Mark Knecht' <markknecht@gmail.com>, 'Linux-RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/J6S6MIEsDW7IHyo97NFZbNz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 5 Jan 2011 18:03:47 -0600
"Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

> 	RAID1 certainly offers the most robust solution, especially
> with more than 1 mirror.

> 	RAID1 is as safe as it gets

Are you sure about that? Considering that mdadm's handling of corrupt data =
on
RAID1 devices is pretty simplistic (obviously it does not have per-block
checksums anywhere, it does not do 'voting' on RAID1 with more than 2
devices), it basically has no way of knowing if a block of data is returned
differently by some of the component devices, which one has the 'correct'
data. From what I understand, RAID5 and especially RAID6 give a much better
protection in this situation.



--=20
With respect,
Roman

--Sig_/J6S6MIEsDW7IHyo97NFZbNz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0lEToACgkQTLKSvz+PZwggywCgkNypaMVg0D0ovbmIbCHgLLrW
cJwAnRKJv3rT6GvCBInpF2ur1i62CHj5
=Gdod
-----END PGP SIGNATURE-----

--Sig_/J6S6MIEsDW7IHyo97NFZbNz--
