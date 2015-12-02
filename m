From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 04/17] fix variable offset when ':' is present in the device name
Date: Tue, 1 Dec 2015 16:25:20 -0800
Message-ID: <1449015933-255689-5-git-send-email-songliubraving@fb.com>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, Dan Williams <djbw@fb.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

From: Dan Williams <djbw@fb.com>

Stopping at the first ':' precludes using device names like
/dev/disk/by-path/pci-0000:04:00.0-sas-0x500605b005846060:1:0-0x5000cca01a7c5605:10

so, check that the name is not ambiguous before chopping off the offset at the end

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Create.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Create.c b/Create.c
index 21d1374..2642b36 100644
--- a/Create.c
+++ b/Create.c
@@ -306,7 +306,13 @@ int Create(struct supertype *st, char *mddev,
 			continue;
 		}
 		if (data_offset == VARIABLE_OFFSET) {
-			doff = strchr(dname, ':');
+			doff = strrchr(dname, ':');
+			if (stat(dname, &stb) == 0) {
+				pr_err("cannot determine if %s is a device name, or a device with a data-offset argument of '%s'\n",
+				       dname, doff+1);
+				pr_err("check that you have specified a data-offset for all array members\n");
+				exit(2);
+			}
 			if (doff) {
 				*doff++ = 0;
 				dv->data_offset = parse_size(doff);
-- 
2.4.6

