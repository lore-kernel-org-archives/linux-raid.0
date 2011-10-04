From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/3] Monitor reshaped array
Date: Tue, 04 Oct 2011 17:53:56 +0200
Message-ID: <20111004155356.27434.65439.stgit@gklab-128-013.igk.intel.com>
References: <20111004155129.27434.81564.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111004155129.27434.81564.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Reshape can be run for monitored arrays only /external metadata case/.
Before reshape can be executed, make sure that just starter array/container
is monitored. If not, run mdmon for it.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 0d3730b..2000dd0 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1570,6 +1570,12 @@ int assemble_container_content(struct supertype *st, int mdfd,
 			if (err)
 				return 1;
 
+			if (st->ss->external) {
+				if (!mdmon_running(st->container_dev))
+					start_mdmon(st->container_dev);
+				ping_monitor_by_id(st->container_dev);
+			}
+
 			err = Grow_continue(mdfd, st, content, backup_file,
 					    freeze_reshape);
 		} else switch(content->array.level) {

