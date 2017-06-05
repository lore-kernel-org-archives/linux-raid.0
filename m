From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] Grow: set component size prior to array size
Date: Mon,  5 Jun 2017 16:09:44 +0200
Message-ID: <1496671784-1612-1-git-send-email-tomasz.majchrzak@intel.com>
References: <7964b1f5-5092-238b-403e-ed4fba584746@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7964b1f5-5092-238b-403e-ed4fba584746@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

It is a partial revert of commit 758b327cf5a7 ("Grow: Remove unnecessary
optimization"). For native metadata component size is set in kernel for
entire disk space. As external metadata supports multiple arrays within
one disk, the component size is set to array size. If component size is
not updated prior to array size update, the grow operation fails.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 Grow.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Grow.c b/Grow.c
index ecf5ca0..4ecb1d8 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1977,6 +1977,8 @@ int Grow_reshape(char *devname, int fd,
 		 */
 		min_csize = 0;
 		for (mdi = sra->devs; mdi; mdi = mdi->next) {
+			sysfs_set_num(sra, mdi, "size", s->size == MAX_SIZE ? 0
+				      : s->size);
 			if (array.not_persistent == 0 &&
 			    array.major_version == 0 &&
 			    get_linux_version() < 3001000) {
-- 
1.8.3.1

