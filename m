From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/4] FIX: Block monitor when starting array with reshape in
	progress
Date: Wed, 23 Feb 2011 14:51:56 +0100
Message-ID: <20110223135156.17074.75895.stgit@gklab-128-013.igk.intel.com>
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

To allow for array reconfiguration, mdmon cannot push array in to active
state. Assemble should block monitor for external metadata to allow
for reshape configuration and restart.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index bffbbf0..bdbe50a 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1518,6 +1518,12 @@ int assemble_container_content(struct supertype *st, int mdfd,
 			return 1;
 		}
 	content->reshape_active = reshape_active;
+	if (content->reshape_active) {
+		char buf[64];
+		sprintf(buf, "external:%s\n", content->text_version);
+		buf[9] = '-';
+		sysfs_set_str(sra, NULL, "metadata_version", buf);
+	}
 	if (sra)
 		sysfs_free(sra);
 

