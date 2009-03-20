From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH] relax checks to support 3disk raid6 arrays
Date: Fri, 20 Mar 2009 10:14:36 +0100
Message-ID: <20090320091436.GM17185@skl-net.de>
References: <20090318125324.GL17185@skl-net.de> <18882.57018.465098.201167@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gbLSGltGDiWAAjZc"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18882.57018.465098.201167@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--gbLSGltGDiWAAjZc
Content-Type: multipart/mixed; boundary="0MVPm7EaLRZfIY9d"
Content-Disposition: inline


--0MVPm7EaLRZfIY9d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:09, Neil Brown wrote:

> Have you tried a 3-disk raid6 yet?  Any conclusions?

Yes, I played around a bit and used the two attached patches that
relax some checks in the kernel and in mdadm. It appears to work fine,
but I did only minimal testing with small loop devices, so I would
not recommend it for production use yet :)

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--0MVPm7EaLRZfIY9d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="3disk-raid6-kernel.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index f375a27..2922e9f 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -395,7 +395,7 @@ async_pq_zero_sum(struct page **blocks, unsigned int of=
fset, int src_cnt,
 	struct dma_async_tx_descriptor *tx =3D NULL;
 	enum dma_ctrl_flags dma_flags =3D cb_fn ? DMA_PREP_INTERRUPT : 0;
=20
-	BUG_ON(src_cnt < 2);
+	BUG_ON(src_cnt < 1);
=20
 	if (device && src_cnt <=3D dma_maxpq(device, 0) - 2) {
 		dma_addr_t dma_src[src_cnt + 2];
@@ -486,7 +486,7 @@ async_syndrome_zero_sum(struct page **blocks, unsigned =
int offset, int src_cnt,
 	struct dma_async_tx_descriptor *tx =3D NULL;
 	enum dma_ctrl_flags dma_flags =3D cb_fn ? DMA_PREP_INTERRUPT : 0;
=20
-	BUG_ON(src_cnt < 2);
+	BUG_ON(src_cnt < 1);
=20
 	if (device && src_cnt <=3D dma_maxpq(device, 0) - 2) {
 		dma_addr_t dma_src[src_cnt + 2];
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 50cd370..70869bb 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -183,7 +183,7 @@ async_xor(struct page *dest, struct page **src_list, un=
signed int offset,
 	struct dma_chan *chan =3D async_tx_find_channel(depend_tx, DMA_XOR,
 						      &dest, 1, src_list,
 						      src_cnt, len);
-	BUG_ON(src_cnt <=3D 1);
+	BUG_ON(src_cnt < 1);
=20
 	if (chan) {
 		/* run the xor asynchronously */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a76ef52..5ce7090 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4357,8 +4357,8 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 		       mdname(mddev), mddev->new_layout);
 		return ERR_PTR(-EIO);
 	}
-	if (mddev->new_level =3D=3D 6 && mddev->raid_disks < 4) {
-		printk(KERN_ERR "raid6: not enough configured devices for %s (%d, minimu=
m 4)\n",
+	if (mddev->new_level =3D=3D 6 && mddev->raid_disks < 3) {
+		printk(KERN_ERR "raid6: not enough configured devices for %s (%d, minimu=
m 3)\n",
 		       mdname(mddev), mddev->raid_disks);
 		return ERR_PTR(-EINVAL);
 	}

--0MVPm7EaLRZfIY9d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="3disk-raid6-mdadm.patch"

diff --git a/Create.c b/Create.c
index 9e65d0a..bd79838 100644
--- a/Create.c
+++ b/Create.c
@@ -96,7 +96,7 @@ int Create(struct supertype *st, char *mddev, int mdfd,
 			Name ": a RAID level is needed to create an array.\n");
 		return 1;
 	}
-	if (raiddisks < 4 && level == 6) {
+	if (raiddisks < 3 && level == 6) {
 		fprintf(stderr,
 			Name ": at least 4 raid-devices needed for level 6\n");
 		return 1;

--0MVPm7EaLRZfIY9d--

--gbLSGltGDiWAAjZc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJw158Wto1QDEAkw8RAt2IAJwPkBBQbEAvMpiJzDYJ6dbEwwODJwCdGcs5
EnNAV+/4aOFGxi2KvJ5fgxo=
=3sXE
-----END PGP SIGNATURE-----

--gbLSGltGDiWAAjZc--
