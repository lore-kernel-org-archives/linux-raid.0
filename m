From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/4] TBD: continue reshape after assembling array
Date: Wed, 23 Feb 2011 14:52:04 +0100
Message-ID: <20110223135204.17074.719.stgit@gklab-128-013.igk.intel.com>
References: <20110223133557.17074.9671.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110223133557.17074.9671.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Shows direction of next patches for reshape continuation
when array is assembled.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index bdbe50a..0aafdaf 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -696,8 +696,15 @@ int Assemble(struct supertype *st, char *mddev,
 #ifndef MDASSEMBLE
 	if (content != &info) {
 		/* This is a member of a container.  Try starting the array. */
-		return assemble_container_content(st, mdfd, content, runstop,
-					   chosen_name, verbose);
+		int rv = assemble_container_content(st, mdfd, content, runstop,
+						    chosen_name, verbose);
+		dprintf(Name ": assemble_container_content() "
+			"returns status = %i\n", rv);
+		if (rv || content->reshape_active == 0)
+			return rv;
+		dprintf(Name ": Continue reshape after assemblation ...\n");
+		/* tbd: call Grow_restart() here */
+		return rv;
 	}
 #endif
 	/* Ok, no bad inconsistancy, we can try updating etc */

