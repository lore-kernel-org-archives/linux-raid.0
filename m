From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/4] raid5-cache: use rcu api to access r5conf->log
Date: Wed, 06 Jan 2016 12:04:11 +1100
Message-ID: <87fuyby0vo.fsf@notabene.neil.brown.name>
References: <cover.1452028077.git.shli@fb.com> <b2e460b69224288a2b7dfc66f86672551cdb9319.1452028077.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b2e460b69224288a2b7dfc66f86672551cdb9319.1452028077.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Jan 06 2016, Shaohua Li wrote:

> If we add journal disk to an array which isn't created with journal, IO
> might be running in the array. We must be careful about the log checks
> to make sure log is fully initialized, which is the job of
> rcu_dereference(). Don't need rcu read lock protection here, as
> hotremove only happens when there is no write requests.

Very sensible, especially as conf->log is set using rcu_assign_ptr().

Applied, thanks
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWjGgLAAoJEDnsnt1WYoG5FOYP/AmLfb45fUAvCD9yVzAm1bnI
vg1adQVuLn6MLZ+NMW61d2auyXHIxtz7gyQRbIUUvWnYcgJ5gLEOEMCYHNn5z8qF
fzM+kjX73LhTbtCRNmo4m+bBwMmFUgoGb0Hn88Y+ii/YUi/LJ9aQMBoUzmL+vj86
1YaOOmvAGrO2tdHfMRxypQrQCMjV5CEb7fpIzUFKyJBM2TCY6J6Z01mDyI/VM8/S
w/dMKOuKdmqiZge6aEAod7XhmCNGpJsB2nIW6ssAzD1eOH9UFDpO2BQGIwCy+bfo
WEuWeLl4j4Y6dunL/ZYOhWHk9v5/yee5MmurVcf7QBG1ZU3r7FiGpOM/7R/PgFm/
iAADj5OY6wGvEwuh2kl+tm0CI96iPXPWA19mT1Pi3eL5nh0CjeHiViZmQaZm2GVR
5B45GLQpSrtDiPEYFDPgfd484A4LkDMOXCdSX8j9c1mdWmMkMfnLC1dfR8t+uCfA
qOSpke77mqfCPeX6srALmVQU8lxL2WI8f2lt1G55IUVAkUcYjW+TSevs1NbQMout
g08GHDFVT68S7OiRKO9m5vnCsD8iwWaxYPCqltJCiFn4FEb74gPhPOh18o+2/JqO
Lpb9PgaX7n8EFM0Ts6IcTBHH0SkG4D9XX9uKjX1kXfgXQqsaBfwurq5B0uTfhLz9
HaCH6UIJ1GLHqOS3oTE6
=AQQM
-----END PGP SIGNATURE-----
--=-=-=--
