From: NeilBrown <neilb@suse.com>
Subject: [PATCH] block: call trace_block_split() from bio_split()
Date: Fri, 18 Nov 2016 13:14:20 +1100
Message-ID: <87vavlfsar.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



Somewhere around
Commit: 20d0189b1012 ("block: Introduce new bio_split()")
and
Commit: 4b1faf931650 ("block: Kill bio_pair_split()")

in 3.14 we lost the call to trace_block_split() from bio_split().

Commit: cda22646adaa ("block: add call to split trace point")

in 4.5 added it back for blk_queue_split(), but not for other users of
bio_split(), and particularly not for md/raid.

This patch moves the trace_block_split() call from blk_queue_split()
to bio_split().
As blk_queue_split() calls bio_split() (via various helper functions)
the same events that were traced before will still be traced.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 block/bio.c       | 1 +
 block/blk-merge.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index db85c5753a76..212ea95a7401 100644
=2D-- a/block/bio.c
+++ b/block/bio.c
@@ -1804,6 +1804,7 @@ struct bio *bio_split(struct bio *bio, int sectors,
 		bio_integrity_trim(split, 0, sectors);
=20
 	bio_advance(bio, split->bi_iter.bi_size);
+	trace_block_split(bdev_get_queue(bio->bi_bdev), split, bio->bi_iter.bi_se=
ctor);
=20
 	return split;
 }
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2642e5fc8b69..82cdd35a9f07 100644
=2D-- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -217,7 +217,6 @@ void blk_queue_split(struct request_queue *q, struct bi=
o **bio,
 		split->bi_opf |=3D REQ_NOMERGE;
=20
 		bio_chain(split, *bio);
=2D		trace_block_split(q, split, (*bio)->bi_iter.bi_sector);
 		generic_make_request(*bio);
 		*bio =3D split;
 	}
=2D-=20
2.10.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLmP8AAoJEDnsnt1WYoG5VO0P/19yp1KHtbwbCmgVLzYcV6zA
XjH6FMD4Y4aWol8fL4uZS4o4/WiIoyjgTpRiUu8d1Gnxc0tQsxSFDiW4/KzrHfFI
/R02IJ0+H6cVv6a0+h2JqXU5O7J+NSGy/brHCPaB8OACh6v29h/p+XRp7r3YcN0A
nIXNQkcoPPj9Ko7HtKFgDrZ+adX4Bwf6o4YvQmHFHFnTHVtRYwvgNwC7bs4iqVt0
AFJrueOyWz7JZ9UXCJ4IlYO4u0YYDujpCdMx1xR2gR0YoN9+uekSHK8+lmasuh02
ym7xqeD0w5FisTi8P1Pmj/6UvahEzZV/i38F+kkrbZu+BQT02efjWRaXAOW0zm8N
avhLemq4KZZjL/i9ah8tm7GGtCpTMWcyVSL+IFRKVfJ68u5ntqQZu+psB8N7U4dZ
4SlLbKssGgFwXx/GJRsiqDD2RflXmb/IL4FVbkaUQzJ3xA3yUpHAJx1sE8700J/v
vNcIMm2HkK02AHRRpOmW5bGyHHaM13YXDddSrJf6o6jjcX7lEuB3y5lbHfGByEgT
2P4yUzkbSDb64UpXIHuZeGiQBV3cBhENdOyq5YfqelD35gSqZzGFNFwC+/+bfQhO
bx9lHnWcrVcRGrEzi+5ddBLB7YYC5oR9c+qUS3uCV5qjbQSPIP9kOg1/1GbP2C04
Fo3c7+eSYl7vV89/jcl9
=B6gP
-----END PGP SIGNATURE-----
--=-=-=--
