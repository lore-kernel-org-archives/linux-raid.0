From: NeilBrown <neilb@suse.de>
Subject: re: dm: raid456 basic support
Date: Fri, 08 Jul 2016 09:57:15 +1000
Message-ID: <87mvltf1d0.fsf@notabene.neil.brown.name>
References: <20160617091405.GA25609@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160617091405.GA25609@mwanda>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 17 2016, Dan Carpenter wrote:

> [ No idea why it's only just now complaining about issues from 2011... ]
>
> Hello NeilBrown,

Hello ... sorry for the delay in replying.


>
> The patch 9d09e663d550: "dm: raid456 basic support" from Jan 13,
> 2011, leads to the following static checker warning:
>
> 	drivers/md/dm-raid.c:1217 parse_raid_params()
> 	warn: no lower bound on 'value'
>
> drivers/md/dm-raid.c
>   1211                                  return -EINVAL;
>   1212                          }
>   1213                          if (!value || (value > MAX_SCHEDULE_TIMEO=
UT)) {
>
> value is an int.  MAX_SCHEDULE_TIMEOUT is LONG_MAX.  Should it be
> INT_MAX?  What about negatives?

% $ git show 9d09e663d550 | grep 'value;' | head -n1
+	unsigned long value;


I think value is unsigned long.
It is set on two occasions with:
  strict_strtoul(argv[0], 10, &value)

and we bail out if that fails.

The first time we assign it to an int ({new_,}chunk_sectors) without
range checking, which is bad.

We cast it to an int for calling raid5_set_cache_size() without first
range checking, which is bad.

Might either of these be the cause of the rather peculiar warning?

The following patch (against mainline) should fix those issues.
Do they silence your warning?

Thanks,
NeilBrown

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 52532745a50f..670d237a26a9 100644
=2D-- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -520,6 +520,9 @@ static int parse_raid_params(struct raid_set *rs, char =
**argv,
 	} else if (value < 8) {
 		rs->ti->error =3D "Chunk size value is too small";
 		return -EINVAL;
+	} else if (value > INT_MAX) {
+		rs->ti->error =3D "Chunk size value is too large";
+		return -EINVAL;
 	}
=20
 	rs->md.new_chunk_sectors =3D rs->md.chunk_sectors =3D value;
@@ -650,7 +653,8 @@ static int parse_raid_params(struct raid_set *rs, char =
**argv,
 				rs->ti->error =3D "Inappropriate argument: stripe_cache";
 				return -EINVAL;
 			}
=2D			if (raid5_set_cache_size(&rs->md, (int)value)) {
+			if (value > INT_MAX ||
+			    raid5_set_cache_size(&rs->md, (int)value)) {
 				rs->ti->error =3D "Bad stripe_cache size";
 				return -EINVAL;
 			}

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXfuxbAAoJEDnsnt1WYoG5HKQQAKU2xPNIlpXqq+sEkjxsUCch
6GqeFxBzCkt1iujaWQ8IOISheE/TEGnfLpeF55a4IAmvXe9wB8aVUcbOThZPKpS9
X/D+EAdqYFiT1CI3I9u+ItlTC4bC7oQcUdHdMzEfp6GWb41LvtPCiKaYzi0ZrFQh
U/shpLw2rRbGe5K+euAOhXFPfSH8eeEp6EuG2rIvVDQjdOBfiF9Ie1ODW36O+3om
GPqbEwVDnkHdwoTJ/YOP1Kb3EbDetzTlMVBV4cPBv9sfQkTgtoFo4LRStkWfoVWC
AjIUxW8LxNra/DAsPv+4JZBfwtRyO1CvWbcwyMg8euasyuiPEmTOu7u9INlhu6Iv
8JV6uC2ZQidyR3iC2/StZVPqD1f44S3T9JFekEyACkwHP6JZlgMOZnCro+n8Q87R
NUbxMO+6CGrz+MTp9IAawkRqTP1RjaQRPOVT3UIuZZHfy20/4aFTcp6y4aTvJShQ
IgVHkBcMxS2ryDFCXxMj+DhuPnTH7que92zSbzWr2/OZoYZfOX2Pvphs53GxZJU5
k7BuBTfIbk0qzPxRBvibNG9JYcBkFS4wZM6vbcHFo96ZxSY2T3Fmq2paDxcHEpkv
0+w+31bSR02oUAC5CzlbZmyCPRTSPddYZvcbrPA/jRD1MeBY8+dnNzdGltJSalSd
RYkThQ+pY96VCE6WE1I3
=fzDW
-----END PGP SIGNATURE-----
--=-=-=--
