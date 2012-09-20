From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/2]MD: raid5 trim support
Date: Thu, 20 Sep 2012 13:59:14 +1000
Message-ID: <20120920135914.63bf9ff4@notabene.brown>
References: <20120918082511.GA6298@kernel.org>
	<20120920111517.54d05380@notabene.brown>
	<20120920013642.GA6798@kernel.org>
	<20120920114740.7e2c2d1f@notabene.brown>
	<20120920022717.GD6798@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HueGsBFLzI8tueK9NxhWvzd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120920022717.GD6798@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/HueGsBFLzI8tueK9NxhWvzd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Sep 2012 10:27:17 +0800 Shaohua Li <shli@kernel.org> wrote:

in which wrong sectors were trimmed....
>=20
> Ok, just confirmed, delete raid5_compute_sector is ok if I adjust
> logical_sector calculation. Here is the new patch.
>=20

Thanks.  That looks better.  I've applied it with some minor formatting
changes.

I then went to look at the follow-up page and .....
I count 11 separate places where you test the new flag and possibly memset a
page to zero.  This doesn't seem like an improvement to me.

Why don't we just mark the page as not up-to-date when we discard it?  That
would avoid storing inconsistent data, and would avoid needing to zero page=
s.

NeilBrown

--Sig_/HueGsBFLzI8tueK9NxhWvzd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFqUkjnsnt1WYoG5AQL/BhAAgh7sQ0kaKLX6NwSq6JmpfdL1rcPJh+1/
gSkhm8UwBpjZpK2x84wP4qM9jNc5vPdnQcWaOG0QKXtMZwu5zJagwBv2P3sgtbDR
58SywtzKVahfUIV6e/m0HVQW8q/GAiQwnjmpeg92tSPuXC8YEgq3Wq9tAMkj7lQw
ETASSrySFy2juuedohgeRlYbPYxBCMB0yk3dW8dZcUquLrjw0SpnXNrAnhUB2pCr
bjN7n4Ohi+szc4eDDzgKMQ4qvoEDpriCb5IG7r7q5MZxOXeAKSmLuNu16VQKeQmm
zrYGQ7BaZFDVTj5YyFfRcSUNXigskYRPNp183EjqVnAofJrLdOO8BAsVL4u/lHri
NStCMh0c+/GJkrh9VHhPYod1Cx1CgQgF57TGXn42CAWRiMLzAKV5DzW2Ngbce8GD
MrFD+yc7p0IIxc8jOYiYQ7/OHQnpv/793y9EixulrLBf/yiWKx3zEKoJsifuW+vl
fzd8tzvoCbcapAEEThkynBSi87UI3ZW9t3GvSGfHTbOL/QztdUVO44vfJ1c3e0cI
Jt7IF41XqTThUmDesbvS8zMhqVUkqFkXSTS7LCX5OeIIDttLslzGwQuCbT5znHyz
NGpax9n7qIkxEUsrxpLm+sNx5xTUR5DOE0+/dpqOFUDxLa3qNQnsaScUU4eTWMsI
uir7yhzmRKI=
=4oKC
-----END PGP SIGNATURE-----

--Sig_/HueGsBFLzI8tueK9NxhWvzd--
