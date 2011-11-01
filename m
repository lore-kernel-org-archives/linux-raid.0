From: Jes.Sorensen@redhat.com
Subject: [PATCH 18/19] validate_geometry_imsm_volume(): Avoid NULL pointer dereference
Date: Tue,  1 Nov 2011 16:09:34 +0100
Message-ID: <1320160175-18976-19-git-send-email-Jes.Sorensen@redhat.com>
References: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super-intel.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 34a4b34..0193fe7 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5139,7 +5139,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 {
 	struct stat stb;
 	struct intel_super *super = st->sb;
-	struct imsm_super *mpb = super->anchor;
+	struct imsm_super *mpb;
 	struct dl *dl;
 	unsigned long long pos = 0;
 	unsigned long long maxsize;
@@ -5150,6 +5150,8 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 	if (!super)
 		return 0;
 
+	mpb = super->anchor;
+
 	if (mpb->num_raid_devs > 0 && mpb->num_disks != raiddisks) {
 		fprintf(stderr, Name ": the option-rom requires all "
 			"member disks to be a member of all volumes.\n");
-- 
1.7.6.4

