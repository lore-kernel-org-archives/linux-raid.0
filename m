From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/4] FIX: Typo error in fprint command
Date: Thu, 12 Jan 2012 08:12:55 +0100
Message-ID: <20120112071255.5168.81664.stgit@gklab-128-013.igk.intel.com>
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

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index b52d34b..5dab37c 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2323,7 +2323,7 @@ started:
 		free(offsets);
 		sysfs_free(sra);
 		fprintf(stderr, Name ": Reshape has to be continued from"
-			" location %llu when root fileststem has been mounted\n",
+			" location %llu when root filesystem has been mounted.\n",
 			sra->reshape_progress);
 		return 1;
 	}

