From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] raid5: fix incorrectly counter of conf->empty_inactive_list_nr
Date: Thu, 04 Aug 2016 08:44:03 +1000
Message-ID: <87bn19pj64.fsf@notabene.neil.brown.name>
References: <tencent_6BA8E587713443DB1CBA0A47@qq.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <tencent_6BA8E587713443DB1CBA0A47@qq.com>
Sender: linux-kernel-owner@vger.kernel.org
To: liuzhengyuan <liuzhengyuan@kylinos.cn>
Cc: shli <shli@kernel.org>, liuzhengyuang521 <liuzhengyuang521@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Aug 03 2016, liuzhengyuan wrote:

> Thanks for you replay.
> I think it may be on the temp inactive list. An active sh was handled
> and put to temp inactive list firstly, then moved to inactive list.
> If sh is on the temp inactive list,  sh->count is zero too.

Hmmm... yes, you are probably right.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXonOzAAoJEDnsnt1WYoG5Ab0P/R3JHjdT37LVOTuU4OM9k/tj
9/Y/LQhcG6P0wACEEE6TGs0oSNIKOiq3P9TZY8xLs8RamU/h4LsSIGszPeMjOvSj
g/COwxWn51+JoAjbfscb6QKfuGchy1ojg6oMAYVuZKD//0Krj5WGBvDl2n3607Bw
HUNNVOrMx0K0lQ4qwXF3GiE8vgPdkCkxbYSoXux1FsUdAx8ImE7m6z1t1kKAkHSU
Qm8aAqu7x5kS1axrxRRUFg/LfRTo+/PwOZCC321rEBd4AAhT284LToRLJ8l/Kxfk
5MV09P1p2ltMpqP75rzQlFJldVBUV/104mMhcN+NgxgH4VQOAZyHN25cVNA4fIkK
j95YwyEhUrNgdMAXlyL+XibsZIjidtdl0v+1Fdl1oQNCk6rzkjHQbaeNvnxfS5Hw
/9O/Ld952s57zjUemDAF4EKhYsiBGw36dQc8T3rcUGEIuEiYJEXUFVDi3hnsGhUM
PUuLroRtKy3S0BgmrXKepeH9soJgjH6OWqi3+Y0u7EPV374aZPxgg8V7dUC5SHGa
7C3zmMyxvnu+KUmYiZ/SJ35WoR6XYFI2jioq11PcDNWn6fh9SAgDDGYyV1wDpJWw
g+VDCDgkZYuHnKyK2DmDDqhuCZvBlvV0w26oyYk1Hjo/KKQSILyJeq6zFR8TZrpx
EArGHUfOs+ZTq4YlwTry
=swVt
-----END PGP SIGNATURE-----
--=-=-=--
