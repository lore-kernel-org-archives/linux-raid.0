From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/4] FIX: Prevent reshape auto start during assembly for
	external metadata
Date: Wed, 23 Feb 2011 14:51:48 +0100
Message-ID: <20110223135148.17074.37037.stgit@gklab-128-013.igk.intel.com>
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

When md starts array and reshape position is set, md continues reshape
automatically. To prevent doing this for external metadata to allow
for later reshape configuration, clear temporary reshape_active flag
this causes that reshape parameters will not be set to array and md
will not start reshape.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 4d41081..bffbbf0 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1506,15 +1506,18 @@ int assemble_container_content(struct supertype *st, int mdfd,
 	int working = 0, preexist = 0;
 	int expansion = 0;
 	struct map_ent *map = NULL;
+	int reshape_active;
 
 	sysfs_init(content, mdfd, 0);
-
+	reshape_active = content->reshape_active;
+	content->reshape_active = 0;
 	sra = sysfs_read(mdfd, 0, GET_VERSION);
 	if (sra == NULL || strcmp(sra->text_version, content->text_version) != 0)
 		if (sysfs_set_array(content, md_get_version(mdfd)) != 0) {
 			close(mdfd);
 			return 1;
 		}
+	content->reshape_active = reshape_active;
 	if (sra)
 		sysfs_free(sra);
 

