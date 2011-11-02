From: Jes.Sorensen@redhat.com
Subject: [PATCH 06/12] disk_init_and_add(): Fail if opening sysfs file descriptors fail
Date: Wed,  2 Nov 2011 15:42:11 +0100
Message-ID: <1320244937-9739-7-git-send-email-Jes.Sorensen@redhat.com>
References: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 managemon.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/managemon.c b/managemon.c
index 9e0a34d..fceaeb9 100644
--- a/managemon.c
+++ b/managemon.c
@@ -409,7 +409,13 @@ static int disk_init_and_add(struct mdinfo *disk, struct mdinfo *clone,
 
 	*disk = *clone;
 	disk->recovery_fd = sysfs_open(aa->devnum, disk->sys_name, "recovery_start");
+	if (disk->recovery_fd < 0)
+		return -1;
 	disk->state_fd = sysfs_open(aa->devnum, disk->sys_name, "state");
+	if (disk->state_fd < 0) {
+		close(disk->recovery_fd);
+		return -1;
+	}
 	disk->prev_state = read_dev_state(disk->state_fd);
 	disk->curr_state = disk->prev_state;
 	disk->next = aa->info.devs;
-- 
1.7.6.4

