From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/2] imsm: FIX: Be more patient during loading matadata
Date: Tue, 12 Apr 2011 14:51:28 +0200
Message-ID: <20110412125128.7062.38008.stgit@gklab-128-013.igk.intel.com>
References: <20110412125116.7062.36275.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110412125116.7062.36275.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Sometimes occurs that metadata cannot be loaded e.g. wrong check sum
It can happen due to metadata update racing with mdmon condition.
If mpb loading is tried again, it is loaded successfully.
Try to load metadata again before really giving up.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index dc5e34e..d23267a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2773,8 +2773,14 @@ load_and_parse_mpb(int fd, struct intel_super *super, char *devname, int keep_fd
 	int err;
 
 	err = load_imsm_mpb(fd, super, devname);
-	if (err)
-		return err;
+	if (err) {
+		/* try to load mpb again,
+		 * in case of mdmon race we could have more luck...
+		 */
+		err = load_imsm_mpb(fd, super, devname);
+		if (err)
+			return err;
+	}
 	err = load_imsm_disk(fd, super, devname, keep_fd);
 	if (err)
 		return err;

