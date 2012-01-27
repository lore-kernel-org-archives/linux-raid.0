From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH] imsm: fix, the second array need to have the whole
 available space on devices
Date: Fri, 27 Jan 2012 15:28:36 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D408A87C@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>
List-Id: linux-raid.ids

Fix the case with creating an array with given container in command line
instead of real devices:
mdadm -CR /dev/md/raid0 -l 0 -n 2 -z5G /dev/md/imsm

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0e9269f..03e10bd 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5525,8 +5525,15 @@ static int reserve_space(struct supertype *st, int raiddisks,
 			size /= 2 * chunk;
 			size *= 2 * chunk;
 		}
+		maxsize = size;
+	}
+	if (!check_env("IMSM_NO_PLATFORM") &&
+	    mpb->num_raid_devs > 0 && size && size != maxsize) {
+		fprintf(stderr, Name ": attempting to create a second "
+			"volume with size less then remaining space. "
+			"Aborting...\n");
+		return 0;
 	}
-
 	cnt = 0;
 	for (dl = super->disks; dl; dl = dl->next)
 		if (dl->e)
-- 
1.7.1

