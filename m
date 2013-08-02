From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] mdmon: let mdmon know the layout
Date: Fri, 02 Aug 2013 10:14:45 +0200
Message-ID: <20130802081445.7222.5151.stgit@gklab-154-244.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

The following commit:

	Fix is_resync_complete for RAID10
	commit 71d68ff62f945254240575cd836f5f2a09ced5d2

requires that mdmon knows the layout.
So make manage_new() read the layout form sysfs.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 managemon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/managemon.c b/managemon.c
index 6cd93e5..7033c19 100644
--- a/managemon.c
+++ b/managemon.c
@@ -650,8 +650,8 @@ static void manage_new(struct mdstat_ent *mdstat,
 		return;
 
 	mdi = sysfs_read(-1, mdstat->devnm,
-			 GET_LEVEL|GET_CHUNK|GET_DISKS|GET_COMPONENT|
-			 GET_DEGRADED|GET_SAFEMODE|
+			 GET_LEVEL|GET_LAYOUT|GET_CHUNK|GET_DISKS|
+			 GET_COMPONENT|GET_DEGRADED|GET_SAFEMODE|
 			 GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE);
 
 	if (!mdi)

