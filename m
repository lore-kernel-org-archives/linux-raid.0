From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 50/58] md: raid0/linear: fix dereference before null check on pointer mddev
Date: Sat,  8 Aug 2020 19:37:16 -0400
Message-ID: <20200808233724.3618168-50-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Colin Ian King <colin.king@canonical.com>, "Guilherme G . Piccoli" <gpiccoli@canonical.com>, Song Liu <songliubraving@fb.com>, Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 9a5a85972c073f720d81a7ebd08bfe278e6e16db ]

Pointer mddev is being dereferenced with a test_bit call before mddev
is being null checked, this may cause a null pointer dereference. Fix
this by moving the null pointer checks to sanity check mddev before
it is dereferenced.

Addresses-Coverity: ("Dereference before null check")
Fixes: 62f7b1989c02 ("md raid0/linear: Mark array as 'broken' and fail BIOs if a member is gone")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 41eead9cbee98..d5a5c18813985 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -469,17 +469,18 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 	struct mddev *mddev = q->queuedata;
 	unsigned int sectors;
 
-	if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw == WRITE)) {
+	if (mddev == NULL || mddev->pers == NULL) {
 		bio_io_error(bio);
 		return BLK_QC_T_NONE;
 	}
 
-	blk_queue_split(q, &bio);
-
-	if (mddev == NULL || mddev->pers == NULL) {
+	if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw == WRITE)) {
 		bio_io_error(bio);
 		return BLK_QC_T_NONE;
 	}
+
+	blk_queue_split(q, &bio);
+
 	if (mddev->ro == 1 && unlikely(rw == WRITE)) {
 		if (bio_sectors(bio) != 0)
 			bio->bi_status = BLK_STS_IOERR;
-- 
2.25.1
