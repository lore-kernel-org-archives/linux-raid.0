From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/8] raid5-cache fixes
Date: Wed, 30 Sep 2015 15:36:43 +1000
Message-ID: <87y4folb84.fsf@notabene.neil.brown.name>
References: <cover.1441221530.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1441221530.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> Fix some bugs, improve performance and add trim/resync support.
>
> Thanks,
> Shaohua
>
> Christoph Hellwig (1):
>   raid5-cache: move functionality out of __r5l_set_io_unit_state
>
> Shaohua Li (7):
>   md: fix feature map check
>   raid5: fix build error
>   raid5-cache: switching to state machine for log disk cache flush
>   raid5-cache: fix a user-after-free bug
>   raid5-cache: optimize FLUSH IO with log enabled
>   md: skip resync for raid array with journal
>   raid5-cache: add trim support for log
>
>  drivers/md/md.c          |   6 +-
>  drivers/md/md.h          |   1 +
>  drivers/md/raid5-cache.c | 254 ++++++++++++++++++++++++++++-------------=
------
>  drivers/md/raid5.c       |  17 +++-
>  drivers/md/raid5.h       |   1 +
>  5 files changed, 175 insertions(+), 104 deletions(-)
>
> --=20
> 1.8.1

Thanks.
I have applied all except
>   raid5-cache: add trim support for log
which I have replied to separately.
I have also applied the other two patches you sent separately.

I've made a number of white-space fixes throughout the series,
and I've merged Christoph's "port to 4.3-rc" patch into various places
in the series.

This is all in the 'devel' branch of git://neil.brown.name/md/

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWC3TrAAoJEDnsnt1WYoG523wP/38DSkLhLpy6iO4Jc/uwM/1a
sevvqcn3TZjgukMQy4pr2D7UR556upFFwESurKXWGB1uo4iGWxmCBJ4rEnii8amj
FEX+cW4DoWy8iw4aPuiSNeR0ptf4v2Urm/duiLEp8pYxhvFAmaIoziJMBZaW9/g8
37f9ZTgmfOtDlNiADg60Icc+TdfaS5YMfZwPfkAExDD/lYte+uSP5+hZnqlADQRB
kJPbLQOGh2vcLRTJayxZ9+WSPdReXQZiPNEYxgkyWE8D7UCnO2KA7h4W+aEgVrnQ
W68299Lk4yjUuYEj2kJOwzDu1K2UaKSW0QsAph7/zz36ckc0hTy1gg/PqIescTZc
y092qPQh6Lwi/vejG5YwsqFeXYuRhsJpUYcZeHImvhlueXigr2URwmbjPl8axSEm
CqOxCBzm16UPI40N/oOtcKCfuO/AVhfHt7OW9gI8lxCW6P9kbfQN9/owsc/zRJrH
+aHMmsmeV4UlROqT5EznANfcoAqBN/JCFGXPNbzdsaJkFtjyvtpBDetLbyagZkEo
eZjAAkIPoVkOTivIVCI/CGRTuN7vLjItgyP+AlU48jEcYb104flTSirbslqNvXQB
trVrGBG7GILF383ma/7lKej0J906YoZw/CkjJgcCpXLtDXEoDPVWbDjcEoXiQrf/
zZVUWrMc+uUg2vrUv8Ov
=Kpt3
-----END PGP SIGNATURE-----
--=-=-=--
