From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 4/5] imsm: display fd in error trace when when
 store_imsm_mpb failes
Date: Fri, 13 Jan 2012 11:20:22 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D4075DE1@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "neilb@suse.de" <neilb@suse.de>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Subject: [PATCH 4/5] imsm: display fd in error trace when when store_imsm_mpb failes

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 9b62f8a..51826bc 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5026,8 +5026,9 @@ static int write_super_imsm(struct supertype *st, int doclose)
 		if (d->index < 0 || is_failed(&d->disk))
 			continue;
 		if (store_imsm_mpb(d->fd, mpb))
-			fprintf(stderr, "%s: failed for device %d:%d %s\n",
-				__func__, d->major, d->minor, strerror(errno));
+			fprintf(stderr, "%s: failed for device %d:%d (fd: %d)%s\n",
+				__func__, d->major, d->minor, d->fd, strerror(errno));
+
 		if (clear_migration_record) {
 			unsigned long long dsize;
 
-- 
1.7.1

