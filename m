From: NeilBrown <neilb@suse.com>
Subject: [PATCH] async_tx: use GFP_NOWAIT rather than GFP_IO
Date: Thu, 07 Jan 2016 11:02:34 +1100
Message-ID: <87k2nm9rz9.fsf@notabene.neil.brown.name>
References: <CAFskJNhmU-N5_odOZV54x10Ku=7SSDnaMz5EtCbKddye+AGReg@mail.gmail.com> <87twn928qv.fsf@notabene.neil.brown.name> <CAPcyv4im63odabZ_gMF_ESuv=iZ7fyBYqLzXJDPe4cBRwtdG4g@mail.gmail.com> <87d1tw23jk.fsf@notabene.neil.brown.name> <CAPcyv4g=HBHn3f75gW9JKNdjYEnjxNCYEp3vjJBa_fGm7e+hJw@mail.gmail.com> <CAFskJNg9_gJ3HRMqD4N6FSue2R2W3CSz+1KwiZw1Bp6==dOp5A@mail.gmail.com> <87wprqxh5f.fsf@notabene.neil.brown.name> <CAPcyv4g6ieqx29kPE8ak7Sh2F0ksXEuz-NaYC8tBMW3Ek7ei0Q@mail.gmail.com> <20160106090811.GO2940@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160106090811.GO2940@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Stanislav Samsonov <slava@annapurnalabs.com>, linux-raid <linux-raid@vger.kernel.org>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


These async_XX functions are called from md/raid5 in an atomic
section, between get_cpu() and put_cpu(), so they must not sleep.
So use GFP_NOWAIT rather than GFP_IO.

Dan Williams writes: Longer term async_tx needs to be merged into md
directly as we can allocate this unmap data statically per-stripe
rather than per request.

Fixed: 7476bd79fc01 ("async_pq: convert to dmaengine_unmap_data")
Cc: stable@vger.kernel.org (v3.13+)
Reported-and-tested-by: Stanislav Samsonov <slava@annapurnalabs.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--

Thanks for taking this Vinod.
It is currently in linux-next from my md tree, but I've just de-staged
it so the next linux-next won't have it from me.
NeilBrown

 crypto/async_tx/async_memcpy.c      | 2 +-
 crypto/async_tx/async_pq.c          | 4 ++--
 crypto/async_tx/async_raid6_recov.c | 4 ++--
 crypto/async_tx/async_xor.c         | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index f8c0b8dbeb75..88bc8e6b2a54 100644
=2D-- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -53,7 +53,7 @@ async_memcpy(struct page *dest, struct page *src, unsigne=
d int dest_offset,
 	struct dmaengine_unmap_data *unmap =3D NULL;
=20
 	if (device)
=2D		unmap =3D dmaengine_get_unmap_data(device->dev, 2, GFP_NOIO);
+		unmap =3D dmaengine_get_unmap_data(device->dev, 2, GFP_NOWAIT);
=20
 	if (unmap && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
 		unsigned long dma_prep_flags =3D 0;
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 5d355e0c2633..c0748bbd4c08 100644
=2D-- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -188,7 +188,7 @@ async_gen_syndrome(struct page **blocks, unsigned int o=
ffset, int disks,
 	BUG_ON(disks > 255 || !(P(blocks, disks) || Q(blocks, disks)));
=20
 	if (device)
=2D		unmap =3D dmaengine_get_unmap_data(device->dev, disks, GFP_NOIO);
+		unmap =3D dmaengine_get_unmap_data(device->dev, disks, GFP_NOWAIT);
=20
 	/* XORing P/Q is only implemented in software */
 	if (unmap && !(submit->flags & ASYNC_TX_PQ_XOR_DST) &&
@@ -307,7 +307,7 @@ async_syndrome_val(struct page **blocks, unsigned int o=
ffset, int disks,
 	BUG_ON(disks < 4);
=20
 	if (device)
=2D		unmap =3D dmaengine_get_unmap_data(device->dev, disks, GFP_NOIO);
+		unmap =3D dmaengine_get_unmap_data(device->dev, disks, GFP_NOWAIT);
=20
 	if (unmap && disks <=3D dma_maxpq(device, 0) &&
 	    is_dma_pq_aligned(device, offset, 0, len)) {
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_ra=
id6_recov.c
index 934a84981495..8fab6275ea1f 100644
=2D-- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -41,7 +41,7 @@ async_sum_product(struct page *dest, struct page **srcs, =
unsigned char *coef,
 	u8 *a, *b, *c;
=20
 	if (dma)
=2D		unmap =3D dmaengine_get_unmap_data(dma->dev, 3, GFP_NOIO);
+		unmap =3D dmaengine_get_unmap_data(dma->dev, 3, GFP_NOWAIT);
=20
 	if (unmap) {
 		struct device *dev =3D dma->dev;
@@ -105,7 +105,7 @@ async_mult(struct page *dest, struct page *src, u8 coef=
, size_t len,
 	u8 *d, *s;
=20
 	if (dma)
=2D		unmap =3D dmaengine_get_unmap_data(dma->dev, 3, GFP_NOIO);
+		unmap =3D dmaengine_get_unmap_data(dma->dev, 3, GFP_NOWAIT);
=20
 	if (unmap) {
 		dma_addr_t dma_dest[2];
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index e1bce26cd4f9..da75777f2b3f 100644
=2D-- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -182,7 +182,7 @@ async_xor(struct page *dest, struct page **src_list, un=
signed int offset,
 	BUG_ON(src_cnt <=3D 1);
=20
 	if (device)
=2D		unmap =3D dmaengine_get_unmap_data(device->dev, src_cnt+1, GFP_NOIO);
+		unmap =3D dmaengine_get_unmap_data(device->dev, src_cnt+1, GFP_NOWAIT);
=20
 	if (unmap && is_dma_xor_aligned(device, offset, 0, len)) {
 		struct dma_async_tx_descriptor *tx;
@@ -278,7 +278,7 @@ async_xor_val(struct page *dest, struct page **src_list=
, unsigned int offset,
 	BUG_ON(src_cnt <=3D 1);
=20
 	if (device)
=2D		unmap =3D dmaengine_get_unmap_data(device->dev, src_cnt, GFP_NOIO);
+		unmap =3D dmaengine_get_unmap_data(device->dev, src_cnt, GFP_NOWAIT);
=20
 	if (unmap && src_cnt <=3D device->max_xor &&
 	    is_dma_xor_aligned(device, offset, 0, len)) {
=2D-=20
2.6.4


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWjasaAAoJEDnsnt1WYoG5RcIQAJGJiy17UkM7sC7ejNbT6sVq
7J9KMKaY3ci5VXuuun5HdS/Fuy8gS4E+JiIlccJuQSrlaIH4TgskdH32NQRlXP9t
blvHQry7e8kqucvyHhplpY4OslSwxRUtyBIZbDeIjugUZt302siRqaSr1RYoABh1
YWQIvFG1l9al8mQjeVXjAX0byN7RrCi5fM4ABhU2Iah7W1rD1q2P52LH82G8xJan
ovcnyhErgRTiBK5QZKxmmhllz943KjLLr5E8+D23WTTlqSB1ITc2VYkOyIDyjgzQ
CLmKZx2tdaXaD/U366vQR/604o2El/0cXbjwWHB54acIyChrLhg3IljbHOGCjt6P
PJVUnYBCUMJ5YhhUJEU8CIzUPTGz4HkTTk41dGbOOlf2FidjHGThYQO0aOo0TFeW
ht76MgTX3/qagb88gdtYCLaQHgYJZvhaftXAS5pRxoaTl9qOFKOBH8lFiEdf7gFH
/7UJpZ0M/9pvnonRnQXORtp+8KPRS00ycng5u7a8wmUcG5QemQS9mWZglniIj1m9
T2R4GitxekYDDdbpp3xNaTIQqSca4D5Foqu8L1gSv0UjaWTBFZIDYa2R/lG7/jFv
NVNPAgvEvqT5TAe4u4XPFvYFOwBupt3FBcZTDxH63dGVvnSwl7Olsl423pHd7Fjh
gaDmtkVoIFcwVVSCdIE4
=I2oH
-----END PGP SIGNATURE-----
--=-=-=--
