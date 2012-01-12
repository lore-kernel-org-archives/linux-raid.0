From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/4] FIX: mdmon check in reshape_container() can cause a
	problem
Date: Thu, 12 Jan 2012 08:12:47 +0100
Message-ID: <20120112071247.5168.52909.stgit@gklab-128-013.igk.intel.com>
References: <20120112070822.5168.97729.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120112070822.5168.97729.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When raid0 reshape is executed mdmon can dissappear due to raid level
takeover operation. If this happen before mdmon check, mdadm would treat
it as error condition. It is not true for this case.

Remove mdmon check from reshape_container() function.
Error condition check will remain using reshape_array() reentry test
for the same array (line 2577).

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/Grow.c b/Grow.c
index 061ddf1..b52d34b 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2608,12 +2608,6 @@ int reshape_container(char *container, char *devname,
 		restart = 0;
 		if (rv)
 			break;
-		rv = !mdmon_running(devname2devnum(container));
-		if (rv) {
-			printf(Name ": Mdmon is not found. "
-			       "Cannot continue container reshape.\n");
-			break;
-		}
 	}
 	if (!rv)
 		unfreeze(st);

