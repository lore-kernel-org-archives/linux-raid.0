From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] monitor: Make sure that last_checkpoint is set to 0 after
 sync
Date: Thu, 16 Jun 2016 11:12:20 +0200
Message-ID: <146606834045.17835.18148510717600494913.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com, aleksey.obitotskiy@intel.com, tomasz.majchrzak@intel.com
List-Id: linux-raid.ids

In a case of successful completion of a resync (in the last step)
- read_and_act sometimes still reads sync_action as "resync"
but sync_completed already is set to component_size.
When this race occurs, sync operation is
marked as finished, but last_checkpoint is
overwritten with sync_completed. It will cause next
sync operation (ie. reshape) to be reported as complete immediately
after start - mdmon will write successful completion of the reshape
to metadata. This patch sets last_checkpoint to 0 once the sync
is completed to stop it happening.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 monitor.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/monitor.c b/monitor.c
index 870cc1a..4c79ce2 100644
--- a/monitor.c
+++ b/monitor.c
@@ -420,6 +420,9 @@ static int read_and_act(struct active_array *a)
 	if (sync_completed > a->last_checkpoint)
 		a->last_checkpoint = sync_completed;
 
+	if (sync_completed >= a->info.component_size)
+		a->last_checkpoint = 0;
+
 	a->container->ss->sync_metadata(a->container);
 	dprintf("(%d): state:%s action:%s next(", a->info.container_member,
 		array_states[a->curr_state], sync_actions[a->curr_action]);

