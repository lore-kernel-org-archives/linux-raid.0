From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] Manage.c: fix small memory leak
Date: Thu, 05 Sep 2013 11:16:34 +0200
Message-ID: <20130905091634.4986.72835.stgit@gklab-154-244.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

'avail' is dynamically allocated, so it should be freed.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 Manage.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Manage.c b/Manage.c
index afa9b42..910caa6 100644
--- a/Manage.c
+++ b/Manage.c
@@ -853,6 +853,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			}
 			array_failed = !enough(array->level, array->raid_disks,
 					       array->layout, 1, avail);
+			free(avail);
 		} else
 			array_failed = 0;
 		if (array_failed) {

