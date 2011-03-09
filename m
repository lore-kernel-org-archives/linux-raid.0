From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/9] FIX: Block reshaped array monitoring
Date: Wed, 09 Mar 2011 14:45:45 +0100
Message-ID: <20110309134545.8939.53720.stgit@gklab-128-013.igk.intel.com>
References: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When array under reshape is is assembled it has be disabled from monitoring
as soon as possible. It can accrue that this is i.e second array in container
and mdmon is loaded already.
Lack of blocking monitoring can cause change array state to active,
and reshape continuation will be not possible.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 20c27eb..fe917b2 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1519,6 +1519,9 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		if (sysfs_set_array(content, md_get_version(mdfd)) != 0)
 			return 1;
 
+	if (content->reshape_active)
+		block_subarray(content);
+
 	if (sra)
 		sysfs_free(sra);
 

