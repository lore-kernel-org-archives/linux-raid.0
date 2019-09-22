From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 24/89] md/raid1: end bio when the device faulty
Date: Sun, 22 Sep 2019 14:56:12 -0400
Message-ID: <20190922185717.3412-24-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yufen Yu <yuyufen@huawei.com>, Song Liu <songliubraving@fb.com>, Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Yufen Yu <yuyufen@huawei.com>

[ Upstream commit eeba6809d8d58908b5ed1b5ceb5fcb09a98a7cad ]

When write bio return error, it would be added to conf->retry_list
and wait for raid1d thread to retry write and acknowledge badblocks.

In narrow_write_error(), the error bio will be split in the unit of
badblock shift (such as one sector) and raid1d thread issues them
one by one. Until all of the splited bio has finished, raid1d thread
can go on processing other things, which is time consuming.

But, there is a scene for error handling that is not necessary.
When the device has been set faulty, flush_bio_list() may end
bios in pending_bio_list with error status. Since these bios
has not been issued to the device actually, error handlding to
retry write and acknowledge badblocks make no sense.

Even without that scene, when the device is faulty, badblocks info
can not be written out to the device. Thus, we also no need to
handle the error IO.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 31c4391f6a62b..762d21c84774a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -435,19 +435,21 @@ static void raid1_end_write_request(struct bio *bio)
 		    /* We never try FailFast to WriteMostly devices */
 		    !test_bit(WriteMostly, &rdev->flags)) {
 			md_error(r1_bio->mddev, rdev);
-			if (!test_bit(Faulty, &rdev->flags))
-				/* This is the only remaining device,
-				 * We need to retry the write without
-				 * FailFast
-				 */
-				set_bit(R1BIO_WriteError, &r1_bio->state);
-			else {
-				/* Finished with this branch */
-				r1_bio->bios[mirror] = NULL;
-				to_put = bio;
-			}
-		} else
+		}
+
+		/*
+		 * When the device is faulty, it is not necessary to
+		 * handle write error.
+		 * For failfast, this is the only remaining device,
+		 * We need to retry the write without FailFast.
+		 */
+		if (!test_bit(Faulty, &rdev->flags))
 			set_bit(R1BIO_WriteError, &r1_bio->state);
+		else {
+			/* Finished with this branch */
+			r1_bio->bios[mirror] = NULL;
+			to_put = bio;
+		}
 	} else {
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that we
-- 
2.20.1
