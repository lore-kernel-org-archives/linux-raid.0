From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 3/3] Incremental: move suitable spares to container when
 subarrays started.
Date: Tue, 4 Jan 2011 15:05:52 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E759FE4@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From c558e3339abec25a12537498feea49f976639617 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 23 Dec 2010 13:55:41 +0100
Subject: [PATCH 3/3] Incremental: move suitable spares to container when subarrays started.
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

By default Incremental places all imsm spares in separate container
with uuid=0:0:0:0. (patch giving spares uuid_zero needed)

When we find enough members to start an array
we are able to determine domain so we search spare container
for suitable spares and move them to the container that
is currently assembled.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Incremental.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 4ee1981..a4cfffc 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1553,6 +1553,51 @@ static int Incremental_container(struct supertype *st, char *devname,
 		assemble_container_content(st, mdfd, ra, runstop,
 					   chosen_name, verbose);
 	}
+
+	/* Now move all suitable spares from spare container */
+	struct domainlist *domains = domain_from_array(list, st->ss->name);
+	if (domains) {
+		struct map_ent *smp;
+		int suuid[4];
+		
+		memcpy(suuid, uuid_zero, sizeof(int[4]));
+		smp = map_by_uuid(&map, suuid);
+		if (smp) {
+			int sfd = open(smp->path, O_RDONLY);
+			if (sfd > 0) {
+				/* spare container found */
+				struct supertype *sst = super_imsm.match_metadata_desc("imsm");
+				struct mdinfo *sinfo;
+				unsigned long long min_size = 0;
+				if (st->ss->min_acceptable_spare_size)
+					min_size = st->ss->min_acceptable_spare_size(st);
+				if (!sst->ss->load_container(sst, sfd, NULL)) {
+					close(sfd);
+					sinfo = container_chose_spares(sst, min_size,
+								domains, NULL, st->ss->name, 0);
+					sst->ss->free_super(sst);
+					if (sinfo){
+						int count = 0;
+						struct mdinfo *disks = sinfo->devs;
+						while (disks) {
+							/* move spare from spare container
+							to currently assembled one */
+							if (move_spare(smp->path, devname,
+								makedev(disks->disk.major, disks->disk.minor)))
+								count++;
+							disks = disks->next;
+						}
+						if (count)
+							fprintf(stderr, Name ": Added %d spare%s to %s\n",
+								count, count>1?"s":"", devname) ;
+					}
+					sysfs_free(sinfo);
+				} else
+					close(sfd);
+			}
+		}
+	}
+	domain_free(domains);
 	map_unlock(&map);
 	return 0;
 }
-- 
1.7.1

