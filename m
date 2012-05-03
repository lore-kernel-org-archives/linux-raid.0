From: NeilBrown <neilb@suse.de>
Subject: Re: [BISECT] Kernel panic, RIP bitmap_create
Date: Thu, 3 May 2012 16:50:30 +1000
Message-ID: <20120503165030.7e45c25b@notabene.brown>
References: <CAOOwNtJhFa67EFTs5AdgSHzFseBr9xJGTsaEOyYnaYYNCeUMAQ@mail.gmail.com>
	<CAOOwNt+wjMU9+Dzrr3+d3dwML2_Q_CgT4X5OgiKvPA_bBoTYcg@mail.gmail.com>
	<20120503155850.2900067d@notabene.brown>
	<CAOOwNtK0xKg9E=gS46GR8uDVvjPqqL7+FbufY2d7iuW7yZgVwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kQ0s4aes2Ef3_2W5uN6Ina9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOOwNtK0xKg9E=gS46GR8uDVvjPqqL7+FbufY2d7iuW7yZgVwQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Karl Newman <siliconfiend@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kQ0s4aes2Ef3_2W5uN6Ina9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


I've managed to find a bug, but it is fairly minor and I cannot see how
it would cause a crash.

The calculation of bitmap->chunks is wrong and will usually be 1 too small.

Does it make a difference for you?  I tend to doubt it.

Thanks,
NeilBrown


diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 97e73e5..17e2b47 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1727,8 +1727,7 @@ int bitmap_create(struct mddev *mddev)
 	bitmap->chunkshift =3D (ffz(~mddev->bitmap_info.chunksize)
 			      - BITMAP_BLOCK_SHIFT);
=20
-	/* now that chunksize and chunkshift are set, we can use these macros */
-	chunks =3D (blocks + bitmap->chunkshift - 1) >>
+	chunks =3D (blocks + (1 << bitmap->chunkshift) - 1) >>
 			bitmap->chunkshift;
 	pages =3D (chunks + PAGE_COUNTER_RATIO - 1) / PAGE_COUNTER_RATIO;
=20
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 55ca5ae..b44b0aba 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -101,9 +101,6 @@ typedef __u16 bitmap_counter_t;
=20
 #define BITMAP_BLOCK_SHIFT 9
=20
-/* how many blocks per chunk? (this is variable) */
-#define CHUNK_BLOCK_RATIO(bitmap) ((bitmap)->mddev->bitmap_info.chunksize =
>> BITMAP_BLOCK_SHIFT)
-
 #endif
=20
 /*

--Sig_/kQ0s4aes2Ef3_2W5uN6Ina9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6Iqtjnsnt1WYoG5AQJASA//SiDTCXRmAXp6Q4eEpXaloHjWRw+7HN98
htcN4FJ4qhPJrthE5JlK2D02ZzgBcJsTc1EwcbmIvGtVIr/PdJqnO8d9aDglCUNV
vcv0l4GlpM44Fsg1ywxMwAHBe5UQ+bu1Mk48pJqYwIq9N/4x6rRoGuoZNXpvVlhh
5zhqkBxaXl4c/IpxQQhMGTVXUbTeWlFQIm6/5pEEO1CYI/hjfkiUhEPhFunISJzE
9dvDIof/8k6xzjtI9/XFpxL3kOpIaw88uoCtruJbIZrek9YiKTgcBhOflATb2MqH
OhXNNPd7DhUVIBWb00t6xen00OY/aHDxQwvN0C4NlSDjHHClpwJ2ZeZI28IQX/Q/
M1yB3WgKHS5h138LBjraiylAf4pz+oWEhOPOz46NpV+PvlyeUH2j7WLSlXielBwT
5mRsZhNDS9l0tmWjxnp2SM/vFb61YIAdOSmFg58vwCVNzJJoccGbHOZRGEyR+gdZ
r8qutK2nLRwq8Q3qq9IO34oaUjxm7hYyYUkLmIIOILdq4v6Cl90CSOc6/kbHipsG
+3qfHStK20HadLOKBOFc8vNHcGewm+eNs9NXPzLz6IEjeZ3R7BeSDb7zA91rtLOQ
e+fOFj9EsficmYV6PEtdhFoba4+DFdMIPmj/Nz4NPPIjk33L8bf3FvHdas8nf34B
YgzFLPEWS/Y=
=nOwg
-----END PGP SIGNATURE-----

--Sig_/kQ0s4aes2Ef3_2W5uN6Ina9--
