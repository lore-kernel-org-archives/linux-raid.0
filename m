From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 7/7] FIX: start_reshape status should be checked
Date: Wed, 26 Jan 2011 16:04:06 +0100
Message-ID: <20110126150406.20454.70549.stgit@gklab-128-013.igk.intel.com>
References: <20110126145632.20454.20432.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110126145632.20454.20432.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

mdadm should verify if reshape is started before it goes
in to check-pointing machine.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index dae1b32..a60129a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1934,7 +1934,12 @@ started:
 		}
 	}
 
-	start_reshape(sra);
+	err = start_reshape(sra);
+	if (err) {
+		fprintf(stderr, Name ": Cannot start reshape for %s\n",
+			devname);
+		goto release;
+	}
 	if (restart)
 		sysfs_set_str(sra, NULL, "array_state", "active");
 

