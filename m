From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Does Linux support Intel Smart Response Technology?
Date: Wed, 5 Oct 2011 10:22:03 +0600
Message-ID: <20111005102203.27b61a20@natsu>
References: <08c701cc830b$91ed7900$b5c86b00$@Watkins-home.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AjR9FFEnq39BKf=G_ScTs4o"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <08c701cc830b$91ed7900$b5c86b00$@Watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <Guy@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/AjR9FFEnq39BKf=G_ScTs4o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 04 Oct 2011 23:04:55 -0400
"Guy Watkins" <Guy@watkins-home.com> wrote:

> Does Linux support the Intel Smart Response Technology?

Why not start with a brief summary of WTF is "Intel Smart Response Technolo=
gy".

> I am building a new computer and will have two 2TB disks and a 64 or 120 =
GB
> SSD.  I am hoping to use the SSD cache feature.  I think I would configur=
e a
> bios RAID with 1 disk and the SSD as a cache, then use Linux to mirror th=
at
> with the second 2TB disk using the write mostly feature of MD.  But would=
 it
> be better to create a bios RAID1 with both disks and the ssd cache?

If you are looking to use SSD as a cache to HDDs, check out bcache
http://bcache.evilpiepirate.org/

--=20
With respect,
Roman

--Sig_/AjR9FFEnq39BKf=G_ScTs4o
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6L22sACgkQTLKSvz+PZwgDuACff93byCqoHSRsV7EuQtp91Q35
RqwAmwdjl6yJ7aomD1057aIqh8RGzjCz
=dCRq
-----END PGP SIGNATURE-----

--Sig_/AjR9FFEnq39BKf=G_ScTs4o--
