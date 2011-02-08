From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/6] imsm: FIX: Wrong output string format
Date: Tue, 08 Feb 2011 14:30:37 +0100
Message-ID: <20110208133037.8787.72478.stgit@gklab-128-013.igk.intel.com>
References: <20110208131046.8787.1777.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110208131046.8787.1777.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On wrong starting container reshape conditions, mdadm returns information on console:
mdadmimsm: Operation is not allowed on this container

it is changed to:
mdadm: (imsm) Operation is not allowed on this container

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 59356e0..6a21b26 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7097,8 +7097,8 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 				free(u);
 
 		} else {
-			fprintf(stderr, Name "imsm: Operation is not allowed "
-				"on this container\n");
+			fprintf(stderr, Name ": (imsm) Operation "
+				"is not allowed on this container\n");
 		}
 	} else {
 		/* On volume level we support following operations

