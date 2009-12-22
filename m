From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 04/13] imsm: fix thunderdome segfault
Date: Tue, 22 Dec 2009 16:59:40 -0700
Message-ID: <20091222235939.31628.63374.stgit@dwillia2-linux.ch.intel.com>
References: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

disk_list_get() can return NULL if:
1/ A formerly missing disk is re-added
2/ The original array has not been rebuilt, so the family number of the
   missing disk still matches
3/ The metadata record of the in-sync disks are read before the missing
   disk

This will result in the missing disk not adding its own serial number to
the disk_list, only its truncated value will be present.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 39a2985..2d5796f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2429,7 +2429,7 @@ imsm_thunderdome(struct intel_super **super_list, int len)
 			struct intel_disk *idisk;
 
 			idisk = disk_list_get(dl->serial, disk_list);
-			if (is_spare(&idisk->disk) &&
+			if (idisk && is_spare(&idisk->disk) &&
 			    !is_failed(&idisk->disk) && !is_configured(&idisk->disk))
 				dl->index = -1;
 			else {

