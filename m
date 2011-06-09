From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/4] FIX: Cannot create volume
Date: Thu, 09 Jun 2011 18:29:21 +0200
Message-ID: <20110609162921.690.90444.stgit@gklab-128-013.igk.intel.com>
References: <20110609162050.690.87261.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110609162050.690.87261.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

getinfo_super() can clear entire 'inf' structure before filling with new
information. Disk number required later is lost.

Restore disk number information after getinfo_super() call.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Create.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Create.c b/Create.c
index 7b4d0fe..d01dea7 100644
--- a/Create.c
+++ b/Create.c
@@ -805,7 +805,6 @@ int Create(struct supertype *st, char *mddev,
 			switch(pass) {
 			case 1:
 				*inf = info;
-
 				inf->disk.number = dnum;
 				inf->disk.raid_disk = dnum;
 				if (inf->disk.raid_disk < raiddisks)
@@ -856,12 +855,13 @@ int Create(struct supertype *st, char *mddev,
 					/* getinfo_super might have lost these ... */
 					inf->disk.major = major(stb.st_rdev);
 					inf->disk.minor = minor(stb.st_rdev);
+					inf->disk.number = dnum;
+					inf->disk.raid_disk = dnum;
 				}
 				break;
 			case 2:
 				inf->errors = 0;
 				rv = 0;
-
 				rv = add_disk(mdfd, st, &info, inf);
 
 				if (rv) {

