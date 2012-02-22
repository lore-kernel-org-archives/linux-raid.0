From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/1] Make error message on failure to --re-add more explicit
Date: Wed, 22 Feb 2012 18:00:00 +0100
Message-ID: <1329930000-20679-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1329930000-20679-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1329930000-20679-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Manage.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Manage.c b/Manage.c
index d9775de..0f9135b 100644
--- a/Manage.c
+++ b/Manage.c
@@ -861,8 +861,12 @@ int Manage_subdevs(char *devname, int fd,
 						dv->devname, devname);
 					fprintf(stderr, Name ": not performing --add as that would convert %s in to a spare.\n",
 						dv->devname);
-					fprintf(stderr, Name ": To make this a spare, use \"mdadm --zero-superblock %s\" first.\n",	
+					fprintf(stderr, Name ": To make this a spare, use \"mdadm --zero-superblock %s\" first.\n",
 						dv->devname);
+					fprintf(stderr, Name ": Note mdadm used to accept re-adding a drive to a raid1 array,\n");
+					fprintf(stderr, Name ": which was a bug. For raid1 arrays it is not possible to\n");
+					fprintf(stderr, Name ": determine which disk is authoritative, and the admin must\n");
+					fprintf(stderr, Name ": decide whether the drive should be converted into a spare.\n");
 					if (tfd >= 0)
 						close(tfd);
 					return 1;
-- 
1.7.4.4

