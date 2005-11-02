From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 007 of 10] Ignore auto-readonly flag for arrays where it isn't meaningful.
Date: Wed, 2 Nov 2005 21:15:41 +1100
Message-ID: <1051102101541.23938@suse.de>
References: <20051102205640.22689.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The 'auto-readonly' flag (which suppresses resync and superblock
updates until the first write) is not meaningful for personalities
that don't support resync or superblock writes (raid0, linear, etc).

So clear the setting early to avoid it confusing anything - e.g. appearing
in /proc/mdstat

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 +++
 1 file changed, 3 insertions(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-02 17:33:26.000000000 +1100
+++ ./drivers/md/md.c	2005-11-02 17:33:29.000000000 +1100
@@ -2058,6 +2058,9 @@ static int do_md_run(mddev_t * mddev)
 	}
 	if (mddev->pers->sync_request)
 		sysfs_create_group(&mddev->kobj, &md_redundancy_group);
+	else if (mddev->ro == 2) /* auto-readonly not meaningful */
+		mddev->ro = 0;
+
  	atomic_set(&mddev->writes_pending,0);
 	mddev->safemode = 0;
 	mddev->safemode_timer.function = md_safemode_timeout;
