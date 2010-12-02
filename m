From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 08/10] FIX: sync_completed_fd handler has to be closed
Date: Thu, 02 Dec 2010 09:19:43 +0100
Message-ID: <20101202081943.4639.19975.stgit@gklab-170-024.igk.intel.com>
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

sync_completed_fd handler has to be closed when array is closing.
This is in pair to open handler code.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 managemon.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/managemon.c b/managemon.c
index 12a3792..df491ba 100644
--- a/managemon.c
+++ b/managemon.c
@@ -120,6 +120,7 @@ static void close_aa(struct active_array *aa)
 	close(aa->action_fd);
 	close(aa->info.state_fd);
 	close(aa->resync_start_fd);
+	close(aa->sync_completed_fd);
 }
 
 static void free_aa(struct active_array *aa)

