From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Incompatibility of internal bitmap with ext4 barriers?
Date: Tue, 17 May 2011 19:17:46 +0600
Message-ID: <20110517191746.556b10fa@natsu>
References: <BANLkTin9h+feRNWg1pWFq1t6dmBpn9keKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j1n8U28U/d.OmUcMHuE8LS0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTin9h+feRNWg1pWFq1t6dmBpn9keKw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jason Tinker <jsntinker@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/j1n8U28U/d.OmUcMHuE8LS0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 May 2011 16:10:07 +0400
Jason Tinker <jsntinker@gmail.com> wrote:

> I have encountered a weird bug when trying to use ext4 partition on
> top of mdadm RAID5 array. Mdadm array has internal bitmap, and ext4 is
> mounted with default options - which means that barriers are enabled.

The same combination works perfectly for me on 2.6.38.

> When trying to write large enough amount of files system just locks up
> indefinitely, only hard reset helps. This seems to happen at random
> times, yet consistently after several minutes of usage.
> I tried different configuration options and it seems to happen only
> when both barriers on ext4 and mdadm's internal bitmaps are enabled.
> After disabling ext4 barriers for good (it seemed like a lesser evil)
> no lock ups happened for 3 months.
> Mdadm is version 3.1.3, kernel is 2.6.32 (rhel6)

How about a newer kernel, maybe?

--=20
With respect,
Roman

--Sig_/j1n8U28U/d.OmUcMHuE8LS0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3SdXoACgkQTLKSvz+PZwgdKwCfWYCsrDZtxPK0PN3+BNEvJNi5
oi0AnjFs1MMPrUo9T8pStCvXlSFa+3oL
=wXhE
-----END PGP SIGNATURE-----

--Sig_/j1n8U28U/d.OmUcMHuE8LS0--
