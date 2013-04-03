From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] Add updating component_size to manager thread of mdmon
Date: Wed, 03 Apr 2013 14:43:42 +0200
Message-ID: <20130403124342.23013.5880.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

Mdmon does not update component_size now. It is wrong because in case
of size's expansion component_size is changed by mdadm but mdmon does not
reread its new value and uses a wrong, old one. As a result the metadata
is incorrect during size's expansion. It contains no information that
resync is in progress (there is no checkpoint too). The metadata is
as if resync has already been finished but it has not.

Component_size will be set to match information in sysfs. This value
will be updated by manager thread in manage_member() function.
Now mdmon uses the correct, current value of component_size and the
correct metadata (containing information about resync and checkpoint)
is written.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 managemon.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/managemon.c b/managemon.c
index d155b04..2c55b3c 100644
--- a/managemon.c
+++ b/managemon.c
@@ -444,6 +444,7 @@ static void manage_member(struct mdstat_ent *mdstat,
 	char buf[64];
 	int frozen;
 	struct supertype *container = a->container;
+	unsigned long long int component_size = 0;
 
 	if (container == NULL)
 		/* Raced with something */
@@ -453,6 +454,9 @@ static void manage_member(struct mdstat_ent *mdstat,
 	a->info.array.raid_disks = mdstat->raid_disks;
 	// MORE
 
+	if (sysfs_get_ll(&a->info, NULL, "component_size", &component_size) >= 0)
+		a->info.component_size = component_size << 1;
+
 	/* honor 'frozen' */
 	if (sysfs_get_str(&a->info, NULL, "metadata_version", buf, sizeof(buf)) > 0)
 		frozen = buf[9] == '-';

