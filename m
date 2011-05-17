From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Incompatibility of internal bitmap with ext4 barriers?
Date: Wed, 18 May 2011 01:00:20 +0600
Message-ID: <20110518010020.353e5865@natsu>
References: <BANLkTin9h+feRNWg1pWFq1t6dmBpn9keKw@mail.gmail.com>
	<20110517191746.556b10fa@natsu>
	<BANLkTikvZZYy9fm_sA8oAmkqim1tkbaC_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PKoTv=co9lF5vAs40NIAwag"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikvZZYy9fm_sA8oAmkqim1tkbaC_A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jason Tinker <jsntinker@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/PKoTv=co9lF5vAs40NIAwag
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 May 2011 22:43:48 +0400
Jason Tinker <jsntinker@gmail.com> wrote:

> Do you have RAID5 over RAID0's or an ordinary RAID5? On my box
> ordinary RAID5 works perfectly too.

Yes, I ran RAID5 of 4x2TB+(1+1TB RAID0)+(1.5+0.5TB RAID0), recently changed=
 to
RAID6 though, also replaced one of the RAID0s with another 2TB drive.

> If your configuration is also RAID5 over RAID0 and it works fine on
> 2.6.38 then I'll just wait for next ubuntu lts...

I am not saying you should just give up. The logs you posted seem like
they can be very helpful in tracking this down. But if it is indeed a kernel
issue, how do you fix or even debug it it without replacing/compiling a new
kernel, which is exactly what you do not want to do. And if you're already
replacing a kernel, why not try a 2.6.38 right away, to check if your issue=
 is
already solved in there (after all 2.6.32 vs 2.6.38 are eons apart BOTH
mdadm-wise and ext4-wise).

--=20
With respect,
Roman

--Sig_/PKoTv=co9lF5vAs40NIAwag
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3SxcQACgkQTLKSvz+PZwgwfwCaA5t3jd8QjLw4MGwNkV5SICrA
fU0AoJi2LOCl27EzZ9+356IA02abSF6X
=DZ/6
-----END PGP SIGNATURE-----

--Sig_/PKoTv=co9lF5vAs40NIAwag--
