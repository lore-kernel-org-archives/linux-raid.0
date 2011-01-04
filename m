From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 13/34] FIX: Get array information in reshape_array()
Date: Tue, 04 Jan 2011 15:37:20 +0100
Message-ID: <20110104143720.6697.22710.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Uninitialized array structure is used.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index c568a55..6dbc3b7 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1637,6 +1637,10 @@ static int reshape_array(char *container, int fd, char *devname,
 		fprintf(stderr, Name ": %s\n", msg);
 		return 1;
 	}
+	if (ioctl(fd, GET_ARRAY_INFO, &array) != 0) {
+		dprintf("Canot get array information.\n");
+		return 1;
+	}
 	spares_needed =  max(reshape.before.raid_disks,
 			     reshape.after.raid_disks) - array.raid_disks;
 

