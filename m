From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] util.c: two typos fixed
Date: Tue, 25 Oct 2011 15:42:25 +0200
Message-ID: <20111025134225.21412.35652.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Two typos fixed.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 util.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/util.c b/util.c
index f785f03..2cf617d 100644
--- a/util.c
+++ b/util.c
@@ -1709,7 +1709,8 @@ int experimental(void)
 	if (check_env("MDADM_EXPERIMENTAL"))
 		return 1;
 	else {
-		fprintf(stderr, Name ": To use this feature MDADM_EXPERIMENTAL enviroment variable has to defined.\n");
+		fprintf(stderr, Name ": To use this feature MDADM_EXPERIMENTAL"
+				" environment variable has to be defined.\n");
 		return 0;
 	}
 }

