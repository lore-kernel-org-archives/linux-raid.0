From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 03/31] FIX: allow for execution for new size set to 0
Date: Tue, 9 Nov 2010 17:00:45 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CA92@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

User doesn't change array size during operation on container.
This has to be performed automatically.
When no size is specified by user as expected, 0 size should be passed for container operations and '0' value should be accepted.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mdadm/mdadm/Grow.c b/mdadm/mdadm/Grow.c index 3721c9c..d97480a 100644
--- a/mdadm/mdadm/Grow.c
+++ b/mdadm/mdadm/Grow.c
@@ -1177,7 +1177,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		int count;
 
 		/* double check that we are not changing anything but raid_disks */
-		if (size >= 0 || layout_str != NULL || chunksize != 0 || level != UnSet) {
+		if (size > 0 || layout_str != NULL || chunksize != 0 || level != 
+UnSet) {
 			fprintf(stderr,
 				Name ": %s is a container, only 'raid-devices' can be changed\n",
 				devname);

