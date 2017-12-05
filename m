From: James Puthukattukaran <james.puthukattukaran@oracle.com>
Subject: [PATCH] mdadm: Uninitialized variable rdev
Date: Tue, 05 Dec 2017 16:20:26 -0500
Message-ID: <5A270D9A.9030304@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm: Uninitialized variable rdev

rdev is not initialized properly causing compiler complaint.

Signed-off-by: James Puthukattukaran <james.puthukattukaran@oracle.com>

diff --git a/super-ddf.c b/super-ddf.c
index 9c82f4f..ac14017 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3526,7 +3526,7 @@ static int validate_geometry_ddf_bvd(
struct supertype *st,
                  return 1;
          }
          /* This device must be a member of the set */
-       if (!stat_is_blkdev(dev, NULL))
+       if (!stat_is_blkdev(dev, &rdev))
                  return 0;
          for (dl = ddf->dlist ; dl ; dl = dl->next) {
                  if (dl->major == (int)major(rdev) &&
