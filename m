From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 06/34] imsm: FIX: display error message
Date: Tue, 04 Jan 2011 15:36:25 +0100
Message-ID: <20110104143625.6697.79388.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When container operation is not allowed user has to get proper information on console about it
Currently this information was displayed as debug info only.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 35a3769..ffbf741 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6455,7 +6455,7 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 				dprintf("imsm: Cannot prepare "\
 					"update\n");
 		} else
-			dprintf("imsm: Operation is not allowed "\
+			fprintf(stderr, Name "imsm: Operation is not allowed "\
 				"on this container\n");
 	} else
 		dprintf("imsm: not a container operation\n");

