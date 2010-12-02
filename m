From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 03/10] FIX: Add error code for raid_disks set
Date: Thu, 02 Dec 2010 09:19:04 +0100
Message-ID: <20101202081904.4639.61446.stgit@gklab-170-024.igk.intel.com>
References: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

If error occurs mdadm exits with no information.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 6e88d6d..eb0c7e0 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1386,6 +1386,9 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		count = reshape_container_raid_disks(container, raid_disks);
 		if (count < 0) {
 			revert_container_raid_disks(st, fd, container);
+			fprintf(stderr, Name
+				": unable to set requested raid disks number = %i\n",
+				raid_disks);
 			rv = 1;
 			goto release;
 		} else if (count == 0) {

