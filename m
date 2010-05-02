From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [md PATCH 00/28] md patches destined for -next and the next merge
	window
Date: Sun, 2 May 2010 10:59:02 -0700
Message-ID: <s2se9c3a7c21005021059l5f708347u8d1b936440161b1a@mail.gmail.com>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 14, 2010 at 11:21 PM, NeilBrown <neilb@suse.de> wrote:
> Hi all,
> =A0I thought it was time I posted my patch queue for review to be sur=
e
> =A0it would be ready for the next merge window.
>
> =A0Apart from sundry bug fixes and minor improvements there are two b=
ig
> =A0themes here
> =A01/ enhancements to level conversion so e.g. we can now convert RAI=
D0
> =A0 =A0to RAID5 or RAID10 (near-2 only) and back.
> =A02/ general refactoring of bits of md code - some functions
> =A0 =A0(e.g. do_md_stop) had become really big and were just a mess o=
f
> =A0 =A0stuff that all had to be done at much the same time. =A0It is =
now
> =A0 =A0broken into somewhat meaningful parts. =A0There is a deeper re=
ason
> =A0 =A0for doing this refactoring .... you'll find out soon. :-)
>
> =A0This is all available at
> =A0 =A0git://neil.brown.name/md for-next
> =A0and should be in linux-next in a day or two.
>
>
> =A0All review, testing, and comments most welcome.
>

A few fixes/enhancements while playing with the takeover code are avail=
able at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git for-neil

Dan Williams (3):
      md/raid4: permit raid0 takeover
      md: notify mdstat waiters of level change
      md: allow integers to be passed to md/level

 drivers/md/md.c    |   25 +++++++++++++++----------
 drivers/md/raid5.c |   32 +++++++++++++++++---------------
 2 files changed, 32 insertions(+), 25 deletions(-)

I'd like to get "raid6: fix recovery performance regression" in for
2.6.34.  I pushed it out to the url below, let me know if you just
want me to send it directly.

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git fixes

Dan Williams (1):
      raid6: fix recovery performance regression

 crypto/async_tx/async_raid6_recov.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

=46ull diff of these 4 patches below (whitespace damaged):

diff --git a/crypto/async_tx/async_raid6_recov.c
b/crypto/async_tx/async_raid6_recov.c
index 943f2ab..3df6746 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -324,6 +324,7 @@ struct dma_async_tx_descriptor *
 async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 			struct page **blocks, struct async_submit_ctl *submit)
 {
+	void *scribble =3D submit->scribble;
 	int non_zero_srcs, i;

 	BUG_ON(faila =3D=3D failb);
@@ -332,11 +333,13 @@ async_raid6_2data_recov(int disks, size_t bytes,
int faila, int failb,

 	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);

-	/* we need to preserve the contents of 'blocks' for the async
-	 * case, so punt to synchronous if a scribble buffer is not available
+	/* if a dma resource is not available or a scribble buffer is not
+	 * available punt to the synchronous path.  In the 'dma not
+	 * available' case be sure to use the scribble buffer to
+	 * preserve the content of 'blocks' as the caller intended.
 	 */
-	if (!submit->scribble) {
-		void **ptrs =3D (void **) blocks;
+	if (async_dma_find_channel(DMA_PQ) =3D=3D NULL || !scribble) {
+		void **ptrs =3D scribble ? scribble : (void **) blocks;

 		async_tx_quiesce(&submit->depend_tx);
 		for (i =3D 0; i < disks; i++)
@@ -406,11 +409,13 @@ async_raid6_datap_recov(int disks, size_t bytes,
int faila,

 	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);

-	/* we need to preserve the contents of 'blocks' for the async
-	 * case, so punt to synchronous if a scribble buffer is not available
+	/* if a dma resource is not available or a scribble buffer is not
+	 * available punt to the synchronous path.  In the 'dma not
+	 * available' case be sure to use the scribble buffer to
+	 * preserve the content of 'blocks' as the caller intended.
 	 */
-	if (!scribble) {
-		void **ptrs =3D (void **) blocks;
+	if (async_dma_find_channel(DMA_PQ) =3D=3D NULL || !scribble) {
+		void **ptrs =3D scribble ? scribble : (void **) blocks;

 		async_tx_quiesce(&submit->depend_tx);
 		for (i =3D 0; i < disks; i++)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f177de0..e3ec0fd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2935,9 +2935,10 @@ level_show(mddev_t *mddev, char *page)
 static ssize_t
 level_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	char level[16];
+	char clevel[16];
 	ssize_t rv =3D len;
 	struct mdk_personality *pers;
+	long level;
 	void *priv;
 	mdk_rdev_t *rdev;

@@ -2970,19 +2971,22 @@ level_store(mddev_t *mddev, const char *buf, si=
ze_t len)
 	}

 	/* Now find the new personality */
-	if (len =3D=3D 0 || len >=3D sizeof(level))
+	if (len =3D=3D 0 || len >=3D sizeof(clevel))
 		return -EINVAL;
-	strncpy(level, buf, len);
-	if (level[len-1] =3D=3D '\n')
+	strncpy(clevel, buf, len);
+	if (clevel[len-1] =3D=3D '\n')
 		len--;
-	level[len] =3D 0;
+	clevel[len] =3D 0;
+	if (strict_strtol(clevel, 10, &level))
+		level =3D LEVEL_NONE;

-	request_module("md-%s", level);
+	if (request_module("md-%s", clevel) !=3D 0)
+		request_module("md-level-%s", clevel);
 	spin_lock(&pers_lock);
-	pers =3D find_pers(LEVEL_NONE, level);
+	pers =3D find_pers(level, clevel);
 	if (!pers || !try_module_get(pers->owner)) {
 		spin_unlock(&pers_lock);
-		printk(KERN_WARNING "md: personality %s not loaded\n", level);
+		printk(KERN_WARNING "md: personality %s not loaded\n", clevel);
 		return -EINVAL;
 	}
 	spin_unlock(&pers_lock);
@@ -2995,7 +2999,7 @@ level_store(mddev_t *mddev, const char *buf, size=
_t len)
 	if (!pers->takeover) {
 		module_put(pers->owner);
 		printk(KERN_WARNING "md: %s: %s does not support personality takeove=
r\n",
-		       mdname(mddev), level);
+		       mdname(mddev), clevel);
 		return -EINVAL;
 	}

@@ -3011,7 +3015,7 @@ level_store(mddev_t *mddev, const char *buf, size=
_t len)
 		mddev->delta_disks =3D 0;
 		module_put(pers->owner);
 		printk(KERN_WARNING "md: %s: %s would not accept array\n",
-		       mdname(mddev), level);
+		       mdname(mddev), clevel);
 		return PTR_ERR(priv);
 	}

@@ -3075,6 +3079,7 @@ level_store(mddev_t *mddev, const char *buf, size=
_t len)
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 	sysfs_notify(&mddev->kobj, NULL, "level");
+	md_new_event(mddev);
 	return rv;
 }

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 042651b..d09c263 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5607,10 +5607,17 @@ static void raid5_quiesce(mddev_t *mddev, int s=
tate)
 }


-static void *raid5_takeover_raid0(mddev_t *mddev)
+static void *raid45_takeover_raid0(mddev_t *mddev, int level)
 {
+	struct raid0_private_data *raid0_priv =3D mddev->private;

-	mddev->new_level =3D 5;
+	/* for raid0 takeover only one zone is supported */
+	if (raid0_priv->nr_strip_zones > 1) {
+		printk(KERN_ERR "md: cannot takeover raid0 with more than one zone.\=
n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	mddev->new_level =3D level;
 	mddev->new_layout =3D ALGORITHM_PARITY_N;
 	mddev->new_chunk_sectors =3D mddev->chunk_sectors;
 	mddev->raid_disks +=3D 1;
@@ -5746,22 +5753,13 @@ static int raid6_check_reshape(mddev_t *mddev)
 static void *raid5_takeover(mddev_t *mddev)
 {
 	/* raid5 can take over:
-	 *  raid0 - if all devices are the same - make it a raid4 layout
+	 *  raid0 - if there is only one strip zone - make it a raid4 layout
 	 *  raid1 - if there are two drives.  We need to know the chunk size
 	 *  raid4 - trivial - just use a raid4 layout.
 	 *  raid6 - Providing it is a *_6 layout
 	 */
-	if (mddev->level =3D=3D 0) {
-		/* for raid0 takeover only one zone is supported */
-		struct raid0_private_data *raid0_priv
-			=3D mddev->private;
-		if (raid0_priv->nr_strip_zones > 1) {
-			printk(KERN_ERR "md: cannot takeover raid 0 with more than one zone=
=2E\n");
-			return ERR_PTR(-EINVAL);
-		}
-		return raid5_takeover_raid0(mddev);
-	}
-
+	if (mddev->level =3D=3D 0)
+		return raid45_takeover_raid0(mddev, 5);
 	if (mddev->level =3D=3D 1)
 		return raid5_takeover_raid1(mddev);
 	if (mddev->level =3D=3D 4) {
@@ -5777,8 +5775,12 @@ static void *raid5_takeover(mddev_t *mddev)

 static void *raid4_takeover(mddev_t *mddev)
 {
-	/* raid4 can take over raid5 if layout is right.
+	/* raid4 can take over:
+	 *  raid0 - if there is only one strip zone
+	 *  raid5 - if layout is right
 	 */
+	if (mddev->level =3D=3D 0)
+		return raid45_takeover_raid0(mddev, 4);
 	if (mddev->level =3D=3D 5 &&
 	    mddev->layout =3D=3D ALGORITHM_PARITY_N) {
 		mddev->new_layout =3D 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
