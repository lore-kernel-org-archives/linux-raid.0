From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 3] md: Raid-6 did not create sysfs entries for stripe cache
Date: Thu, 30 Mar 2006 16:52:47 +1100
Message-ID: <1060330055247.25295@suse.de>
References: <20060330164933.25210.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Brad Campbell <brad@wasp.net.au>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid6main.c |    2 ++
 1 file changed, 2 insertions(+)

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2006-03-30 16:48:30.000000000 +1100
+++ ./drivers/md/raid6main.c	2006-03-30 16:48:52.000000000 +1100
@@ -2151,6 +2151,8 @@ static int run(mddev_t *mddev)
 	}
 
 	/* Ok, everything is just fine now */
+	sysfs_create_group(&mddev->kobj, &raid6_attrs_group);
+
 	mddev->array_size =  mddev->size * (mddev->raid_disks - 2);
 
 	mddev->queue->unplug_fn = raid6_unplug_device;
