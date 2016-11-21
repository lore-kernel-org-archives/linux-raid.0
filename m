From: NeilBrown <neilb@suse.com>
Subject: [PATCH - v2] block: call trace_block_split() from bio_split()
Date: Mon, 21 Nov 2016 14:33:50 +1100
Message-ID: <87inrhecbl.fsf@notabene.neil.brown.name>
References: <87vavlfsar.fsf@notabene.neil.brown.name> <20161118125533.GA27741@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161118125533.GA27741@infradead.org>
Sender: linux-block-owner@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
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
bio_split(), and particularly not for md.

This patch moves the trace_block_split() call from blk_queue_split()
to bio_split().
As blk_queue_split() calls bio_split() (via various helper functions)
the same events that were traced before will still be traced.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--

Thanks Christoph.
This adds the wrap and the reviewed-by.

NeilBrown


 block/bio.c       | 2 ++
 block/blk-merge.c | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index db85c5753a76..0aa755abd10b 100644
=2D-- a/block/bio.c
+++ b/block/bio.c
@@ -1804,6 +1804,8 @@ struct bio *bio_split(struct bio *bio, int sectors,
 		bio_integrity_trim(split, 0, sectors);
=20
 	bio_advance(bio, split->bi_iter.bi_size);
+	trace_block_split(bdev_get_queue(bio->bi_bdev), split,
+			  bio->bi_iter.bi_sector);
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

iQIcBAEBCAAGBQJYMmseAAoJEDnsnt1WYoG5blgQALmgtDJWu0vlpKjBNUwtkJV3
GIAhXpeKgsmJXh3hpiXfDj9eeL4gLEzoFCuDa5OBJaOksPko3HBufLFAG3uHpNbz
0u+/rgv20WE3nHKHFo/B31HSOHvLhbekHjRm3JE0VaIwicEfMuTYB/5IZurpzQ4j
UTbbo9lfZemXyQvvFnGnrr5Jj2zNQ3P+xVzN68BcQwdmHrcoU5RPXaIH/13XaHp5
P5z+UqznRTdbq1jg3sHqB2wSpALw2RaeNgE94hpD5s1HK+U8Gwc+5zVdipybJIHO
/hCfwZeMhMKMvvUpdaKU2Yr2CcnxSykVnd75Pj30lLYx+8931kxY4mY6nHbCyclz
SKgjlPPPJSxTM9eeNfGmFfDm7tqWhUvs72JuRd0s7kPxliPSKIy4LKWIXOTiToro
WKuAekzbpA2VbTf4dcaIRaFfvo6qmwvx600zDOWvxUaX/vpImgXcRpjX7+WvogVz
4sUQB+YYe0wlPLvidtaxoa1AVsDYHSO0NMcu6dHp4+wDLWi3mNG4A6IQtfEGR9fx
bcfLu+yya1wz0SJO25Iw8z5bKDkSgFDg4MmmIS4gG3VbNL7nyI9u2l2ZQ0vpEkSK
7MZWdxXt+5hmiWr0ZLJx7IKJkZuxyn6QBJXGuDL1z1F3LimHk7Z6TN/oIzaj4bZp
5g9hSC5pWsy46Zt3jCQ+
=Ow5q
-----END PGP SIGNATURE-----
--=-=-=--
