From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/3] Don't tell sysfs to launch the container as we are doing it ourselves
Date: Fri, 21 Oct 2011 15:33:19 +0200
Message-ID: <1319204000-6661-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1319204000-6661-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319204000-6661-1-git-send-email-Jes.Sorensen@redhat.com>
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
index 1a9a97b..cff7663 100644
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
1.7.4.4

