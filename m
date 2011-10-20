From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/3] Don't tell sysfs to launch the container as we are doing it ourselves
Date: Thu, 20 Oct 2011 12:06:17 +0200
Message-ID: <1319105178-7697-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1319105178-7697-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319105178-7697-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, lukasz.dorau@intel.com, adam.kwolek@intel.com, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Incremental.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 4a5e568..f5f0f33 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -446,7 +446,6 @@ int Incremental(char *devname, int verbose, int runstop,
 	if (info.array.level == LEVEL_CONTAINER) {
 		int devnum = devnum; /* defined and used iff ->external */
 		/* Try to assemble within the container */
-		sysfs_uevent(&info, "change");
 		if (verbose >= 0)
 			fprintf(stderr, Name
 				": container %s now has %d devices\n",
-- 
1.7.6.4

