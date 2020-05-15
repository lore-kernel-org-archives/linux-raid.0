From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 2/2] =?UTF-8?q?restripe:=20fix=20ignoring=20return=20value?= =?UTF-8?q?=20of=20=E2=80=98read=E2=80=99?=
Date: Fri, 15 May 2020 15:40:26 +0200
Message-ID: <20200515134026.8084-3-guoqing.jiang@cloud.ionos.com>
References: <20200515134026.8084-1-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200515134026.8084-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

Got below error when run "make everything".

restripe.c: In function ‘test_stripes’:
restripe.c:870:4: error: ignoring return value of ‘read’, declared with attribute warn_unused_result [-Werror=unused-result]
    read(source[i], stripes[i], chunk_size);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix it by set the return value of ‘read’ to diskP, which should be
harmless since diskP will be set again before it is used.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 restripe.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/restripe.c b/restripe.c
index 31b07e8..21c90f5 100644
--- a/restripe.c
+++ b/restripe.c
@@ -867,7 +867,11 @@ int test_stripes(int *source, unsigned long long *offsets,
 
 		for (i = 0 ; i < raid_disks ; i++) {
 			lseek64(source[i], offsets[i]+start, 0);
-			read(source[i], stripes[i], chunk_size);
+			/*
+			 * To resolve "ignoring return value of ‘read’", it
+			 * should be harmless since diskP will be again later.
+			 */
+			diskP = read(source[i], stripes[i], chunk_size);
 		}
 		for (i = 0 ; i < data_disks ; i++) {
 			int disk = geo_map(i, start/chunk_size, raid_disks,
-- 
2.17.1
