From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/2] mdadm: improve the safeguard for change cluster raid's sb
Date: Thu, 17 Dec 2015 09:53:56 +1100
Message-ID: <877fke9f97.fsf@notabene.neil.brown.name>
References: <1450288466-21168-1-git-send-email-gqjiang@suse.com> <1450288466-21168-2-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450288466-21168-2-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Dec 17 2015, Guoqing Jiang wrote:

> This commit does the following jobs:
>
> 1. rename is_clustered to dlm_funs_ready since it match the
>    function better.
> 2. st->cluster_name can't be use to identify the raid is a
>    clustered or not, we should check the bitmap's version to
>    perform the identification.
> 3. for cluster_get_dlmlock/cluster_release_dlmlock funcs, both
>    of them just need the lockid as parameter since the cluster
>    name can get by get_cluster_name().
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

This and other patch applied, thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWceuEAAoJEDnsnt1WYoG50HEQALKFlYHK5TNDabPbhaS9DwUl
c/s7sg2lO1BO69JIz21yDlLrZK37ifp0fPnMb3V4OFwAh9ASVXvAjju0PYs4zIe5
7k17EWBYdTsd5iCOQ0pebva7CPWOFzO5i/LsmlBpOM03TAfsA5shxnCFENIACBYL
x7zcb3Q5m7s0byP/GHTHidIfos7a7HffleqO7cGj302p3y74vFJJvExJme9fDG0V
+sMNHpaCw+dnhLw4GKmiV7rNF0GykrKnoQGhfzo0cJo46RCiBnPscsff2Fc0hAzl
zbQaJTMxo3UdmMt/dJnkgO/Aaa0KDVEBcuaborxdwfa22KLnYVOUra39Ps4T9Bvz
5wZxA8ThM6K4Czw/45HYk+ZzAs5t/Y9R7SFpcr7uMvQZWbAoR9nAbNtqYhzsxqGy
4RRFaDjT/AErHIwIHbcHG5tUZSSZusdJHSa/9AY4wuYq2NBO+dHZqUFZG7eSRVV9
FfvxGDCssJK9Ag3qV0oMz0NKtIY3DGkzBKlidi21C+UuHRh9m2Q+s8wE5F3EPfs3
vEO/82/hurzcrK1g1mATKULHS+ziB0SoGPRwKmqSlQ7DuUrriokWOX7UnVpahyUn
QYCZfHevOlaI3LadmHL8X30FQfvo+N1T85zhhv0do3kFV3nn5fxc8ptCqycY7/4O
YUHwyj9SYLYZT3QVQIA9
=DthR
-----END PGP SIGNATURE-----
--=-=-=--
