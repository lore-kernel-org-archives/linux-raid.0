From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: Verify if array name doesn't exist already
Date: Thu, 22 Dec 2011 15:21:10 +0100
Message-ID: <20111222142109.5678.19199.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When e.g. array name (an) is correct and it is the same as container name (cn),
file element creation /dev/md/an will replace /dev/md/cn.
This can cause that user cannot access container using /dev/md/cn.

Verify during array creation if chosen name is not already existing one.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Create.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Create.c b/Create.c
index 5d1548b..e522d8e 100644
--- a/Create.c
+++ b/Create.c
@@ -558,6 +558,17 @@ int Create(struct supertype *st, char *mddev,
 		map_unlock(&map);
 		return 1;
 	}
+	/* verify if chosen_name is not in use,
+	 * it could be in conflict with already existing device
+	 * e.g. container, array
+	 */
+	if (stat(chosen_name, &stb) != -1) {
+		fprintf(stderr, Name ": Array name %s is in use already.\n",
+			chosen_name);
+		close(mdfd);
+		map_unlock(&map);
+		return 1;
+	}
 	mddev = chosen_name;
 
 	vers = md_get_version(mdfd);

