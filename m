From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 5/7] FIX: Block monitor when starting array with reshape in
	progress
Date: Tue, 01 Mar 2011 15:57:23 +0100
Message-ID: <20110301145723.10678.64788.stgit@gklab-128-013.igk.intel.com>
References: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

To allow for array reconfiguration, mdmon cannot push array in to active
state. Assemble should block monitor for external metadata to allow
for reshape configuration and restart.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |    2 ++
 msg.h      |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index fa3a0a6..9d17a57 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1528,8 +1528,10 @@ int assemble_container_content(struct supertype *st, int mdfd,
 			 */
 			sysfs_set_num(content, NULL, "sync_max",
 				      content->reshape_progress);
+			block_subarray(content);
 		}
 	}
+
 	if (sra)
 		sysfs_free(sra);
 
diff --git a/msg.h b/msg.h
index 1f916de..090d3f6 100644
--- a/msg.h
+++ b/msg.h
@@ -27,6 +27,7 @@ extern int ack(int fd, int tmo);
 extern int wait_reply(int fd, int tmo);
 extern int connect_monitor(char *devname);
 extern int ping_monitor(char *devname);
+extern int block_subarray(struct mdinfo *sra);
 extern int block_monitor(char *container, const int freeze);
 extern void unblock_monitor(char *container, const int unfreeze);
 extern int fping_monitor(int sock);

