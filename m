From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 03/22] Define dummy functions to mdmon.c
Date: Thu, 02 Jun 2011 16:48:34 +0200
Message-ID: <20110602144834.27355.36200.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

Definitions are necessary to compile mdmon.
Metadata specific source code is compiled to mdmon.
Functions used for reshape check pointing:
- restore_stripes()
- save_stripes
- abort_reshape
are not used in mdmon, but they are compiled in it.
To enable mdmon compilation, dummy functions are used.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 mdmon.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index a51a94f..d633cb0 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -527,3 +527,26 @@ int child_monitor(int afd, struct mdinfo *sra, struct reshape *reshape,
 {
 	return 0;
 }
+
+int restore_stripes(int *dest, unsigned long long *offsets,
+		    int raid_disks, int chunk_size, int level, int layout,
+		    int source, unsigned long long read_offset,
+		    unsigned long long start, unsigned long long length,
+		    char *src_buf)
+{
+	return 1;
+}
+
+void abort_reshape(struct mdinfo *sra)
+{
+	return;
+}
+
+int save_stripes(int *source, unsigned long long *offsets,
+		 int raid_disks, int chunk_size, int level, int layout,
+		 int nwrites, int *dest,
+		 unsigned long long start, unsigned long long length,
+		 char *buf)
+{
+	return 0;
+}

