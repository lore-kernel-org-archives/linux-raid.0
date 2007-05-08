From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 5] md: Remove the slash from the name of a kmem_cache used by raid5.
Date: Tue, 8 May 2007 14:29:29 +1000
Message-ID: <1070508042929.28767@suse.de>
References: <20070508142718.28571.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


SLUB doesn't like slashes as it wants to use the cache name
as the name of a directory (or symlink) in sysfs.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-05-07 14:36:01.000000000 +1000
+++ ./drivers/md/raid5.c	2007-05-07 15:08:45.000000000 +1000
@@ -931,8 +931,8 @@ static int grow_stripes(raid5_conf_t *co
 	struct kmem_cache *sc;
 	int devs = conf->raid_disks;
 
-	sprintf(conf->cache_name[0], "raid5/%s", mdname(conf->mddev));
-	sprintf(conf->cache_name[1], "raid5/%s-alt", mdname(conf->mddev));
+	sprintf(conf->cache_name[0], "raid5-%s", mdname(conf->mddev));
+	sprintf(conf->cache_name[1], "raid5-%s-alt", mdname(conf->mddev));
 	conf->active_name = 0;
 	sc = kmem_cache_create(conf->cache_name[conf->active_name],
 			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
