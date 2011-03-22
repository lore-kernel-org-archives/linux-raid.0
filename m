From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: PATCH 2/2] super-intel: enable loading metadata from non-IMSM
 compliant disks
Date: Tue, 22 Mar 2011 16:50:56 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D191E0AF52@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 492192b1777936ccaf745aeb73f83f55c12a5a37 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Tue, 22 Mar 2011 17:24:35 +0100
Subject: [PATCH 2/2] super-intel: enable loading metadata from non-IMSM compliant disks

Honor ignore_hw_compat to load metadata from disk attached to non-IMSM
controller or when there are no IMSM OROM/EFI capabilities.
Used only for guessing and examining metadata format.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index acd7571..8e57171 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2218,11 +2218,12 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst)
 	 * use the same Intel hba
 	 */
 	if (!check_env("IMSM_NO_PLATFORM")) {
-		if (first->hba->type != sec->hba->type)  {
+		if (!first->hba || !sec->hba || (first->hba->type != sec->hba->type))  {
+			
 			fprintf(stderr,
 				"HBAs of devices does not match %s != %s\n",
-				get_sys_dev_type(first->hba->type),
-				get_sys_dev_type(sec->hba->type));
+				first->hba ? get_sys_dev_type(first->hba->type) : NULL,
+				sec->hba ? get_sys_dev_type(sec->hba->type) : NULL);
 			return 3;
 		}
 	}
@@ -2864,7 +2865,7 @@ static int find_intel_hba_capability(int fd, struct intel_super *super, char *de
 {
 	struct sys_dev *hba_name;
 	int rv = 0;
-
+	
 	if ((fd < 0) || check_env("IMSM_NO_PLATFORM")) {
 		super->orom = NULL;
 		super->hba = NULL;
@@ -3386,16 +3387,19 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 			sizeof(*super));
 		return 1;
 	}
+	/* Load hba and capabilities if they exist.
+	 * But do not preclude loading metadata in case capabilities or hba are
+	 * non-compliant and ignore_hw_compat is set.
+	 */
 	rv = find_intel_hba_capability(fd, super, devname);
 	/* no orom/efi or non-intel hba of the disk */
-	if (rv != 0) {
+	if ((rv != 0) && (st->ignore_hw_compat == 0)) {
 		if (devname)
 			fprintf(stderr,
 				Name ": No OROM/EFI properties for %s\n", devname);
 		free_imsm(super);
 		return 2;
 	}
-
 	rv = load_and_parse_mpb(fd, super, devname, 0);
 
 	if (rv) {
-- 
1.6.4.2

