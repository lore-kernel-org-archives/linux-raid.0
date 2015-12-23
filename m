From: NeilBrown <neilb@suse.com>
Subject: Re: raid5 async_xor: sleep in atomic
Date: Thu, 24 Dec 2015 09:39:11 +1100
Message-ID: <87d1tw23jk.fsf@notabene.neil.brown.name>
References: <CAFskJNhmU-N5_odOZV54x10Ku=7SSDnaMz5EtCbKddye+AGReg@mail.gmail.com> <87twn928qv.fsf@notabene.neil.brown.name> <CAPcyv4im63odabZ_gMF_ESuv=iZ7fyBYqLzXJDPe4cBRwtdG4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4im63odabZ_gMF_ESuv=iZ7fyBYqLzXJDPe4cBRwtdG4g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Stanislav Samsonov <slava@annapurnalabs.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 24 2015, Dan Williams wrote:
>> Changing the GFP_NOIO to GFP_ATOMIC in all the calls to
>> dmaengine_get_unmap_data() in crypto/async_tx/ would probably fix the
>> issue... or make it crash even worse :-)
>>
>> Dan: do you have any wisdom here?  The xor is using the percpu data in
>> raid5, so it cannot be sleep, but GFP_NOIO allows sleep.
>> Does the code handle failure to get_unmap_data() safely?  It looks like
>> it probably does.
>
> Those GFP_NOIO should move to GFP_NOWAIT.  We don't want GFP_ATOMIC
> allocations to consume emergency reserves for a performance
> optimization.  Longer term async_tx needs to be merged into md
> directly as we can allocate this unmap data statically per-stripe
> rather than per request. This asyntc_tx re-write has been on the todo
> list for years, but never seems to make it to the top.

So the following maybe?
If I could get an acked-by from you Dan, and a Tested-by: from you
Slava, I'll submit upstream.

Thanks,
NeilBrown

From: NeilBrown <neilb@suse.com>
Date: Thu, 24 Dec 2015 09:35:18 +1100
Subject: [PATCH] async_tx: use GFP_NOWAIT rather than GFP_IO

These async_XX functions are called from md/raid5 in an atomic
section, between get_cpu() and put_cpu(), so they must not sleep.
So use GFP_NOWAIT rather than GFP_IO.

Dan Williams writes: Longer term async_tx needs to be merged into md
directly as we can allocate this unmap data statically per-stripe
rather than per request.

Reported-by: Stanislav Samsonov <slava@annapurnalabs.com>
Signed-off-by: NeilBrown <neilb@suse.com>

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

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWeyKPAAoJEDnsnt1WYoG5LHgQAK/uT+Ms9v42YG7bzcbdT3sg
cc2z/cVLjEC1MK9/QoAhUVE5IueBk/00LTpRvQMh3ETM7f1p4InZ2yvbuu/Rw1ok
nTr9bMw7KffHERgqxj1/OCinr4Vbt2vmfzK7xOUdYV8m7JdT4V3wx8RH+OhqCLiq
xZa3667qVgsgY54+zdUulgTs+zvhD0li0ecybmzbvL6P0/4lB52xImYBZHG/hrL0
tH0U/98jIsZX/BCTWcD6Wob0BhUS9PBzekH9I3Nn4k9LKArDdO4a7iuEPzZiXtq8
tt2JInlIwmP6J0b/FdMy0yNlUYElo0TbZ2RA7i4ZbQ5N0euZU35qJNoUTUGeRDPx
TFq/LYVefMYkLNiVtvWCpae6wy+wpLP4BpAacf60CGDtjvbafZi4mGdnymdlbYY5
8WeEvHn5yophm8NOU9CWhpc/E8RBmTn6NYr4rilRsPrzzQPi8MwXKNIPrzefvqdc
ivO4J672xbzilzbhVXDXW9yl5+bRopzejfdEBIuxrpWhLYh+Kg2S20tjtxmz3p9j
XBl2GcNtNCLj9uXxT4Tk8KqWHdCn2EnJ2/Wlp9h2JiZ1LyO+MgBU+Vg2NDDSsBRe
JR4A5IgZe8D0JuPIVlpqRiHdp/drbAw2bUEOZlOmM9B07AaZ2JwBTLDTX8aa8w0U
PqRiA5P7U9dIzcHXo/ZL
=PeZu
-----END PGP SIGNATURE-----
--=-=-=--
