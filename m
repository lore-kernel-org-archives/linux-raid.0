From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] fix: correct metadata's update communication
Date: Fri, 18 Nov 2011 15:34:33 +0100
Message-ID: <20111118143433.14114.6361.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The problem occurs when array under migration is assembled incrementally.
st->update_tail is not initialized in function
assemble_container_content() and during reshape
the checkpoint information in metadata is not being updated.

The value of st->update_tail is now initialized in function
assemble_container_content() and during reshape the checkpoint
information in metadata is being updated correctly on all disks.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 Assemble.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 3c8e74d..74708d1 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1585,6 +1585,9 @@ int assemble_container_content(struct supertype *st, int mdfd,
 				if (!mdmon_running(st->container_dev))
 					start_mdmon(st->container_dev);
 				ping_monitor_by_id(st->container_dev);
+				if (mdmon_running(st->container_dev) &&
+						st->update_tail == NULL)
+					st->update_tail = &st->updates;
 			}
 
 			err = Grow_continue(mdfd, st, content, backup_file,

