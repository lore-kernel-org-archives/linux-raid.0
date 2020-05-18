From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH V2 2/2] =?UTF-8?q?restripe:=20fix=20ignoring=20return=20va?= =?UTF-8?q?lue=20of=20=E2=80=98read=E2=80=99?=
Date: Mon, 18 May 2020 21:31:08 +0200
Message-ID: <20200518193108.26102-3-guoqing.jiang@cloud.ionos.com>
References: <20200518193108.26102-1-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200518193108.26102-1-guoqing.jiang@cloud.ionos.com>
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

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 restripe.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/restripe.c b/restripe.c
index 31b07e8..48c6506 100644
--- a/restripe.c
+++ b/restripe.c
@@ -867,7 +867,15 @@ int test_stripes(int *source, unsigned long long *offsets,
 
 		for (i = 0 ; i < raid_disks ; i++) {
 			lseek64(source[i], offsets[i]+start, 0);
-			read(source[i], stripes[i], chunk_size);
+			if (read(source[i], stripes[i], chunk_size) !=
+			    chunk_size) {
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
