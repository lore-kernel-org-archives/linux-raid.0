From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: =?UTF-8?q?=5BPATCH=20V3=202/2=5D=20restripe=3A=20fix=20ignoring=20return=20value=20of=20=E2=80=98read=E2=80=99=20and=20lseek?=
Date: Mon, 18 May 2020 23:53:36 +0200
Message-ID: <20200518215336.29000-3-guoqing.jiang@cloud.ionos.com>
References: <20200518215336.29000-1-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200518215336.29000-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

Got below error when run "make everything".

restripe.c: In function ‘test_stripes’:
restripe.c:870:4: error: ignoring return value of ‘read’, declared with attribute warn_unused_result [-Werror=unused-result]
    read(source[i], stripes[i], chunk_size);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix it by check the return value of ‘read’, and free memory
in the failure case.

And check the return value of lseek as well per Jes's comment.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 restripe.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/restripe.c b/restripe.c
index 31b07e8..86e1d00 100644
--- a/restripe.c
+++ b/restripe.c
@@ -866,8 +866,16 @@ int test_stripes(int *source, unsigned long long *offsets,
 		int disk;
 
 		for (i = 0 ; i < raid_disks ; i++) {
-			lseek64(source[i], offsets[i]+start, 0);
-			read(source[i], stripes[i], chunk_size);
+			if ((lseek64(source[i], offsets[i]+start, 0) < 0) ||
+			    (read(source[i], stripes[i], chunk_size) !=
+			     chunk_size)) {
+				free(q);
+				free(p);
+				free(blocks);
+				free(stripes);
+				free(stripe_buf);
+				return -1;
+			}
 		}
 		for (i = 0 ; i < data_disks ; i++) {
 			int disk = geo_map(i, start/chunk_size, raid_disks,
-- 
2.17.1
