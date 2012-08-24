From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 3] DM RAID: Move 'rebuild' checking code to its own
 function
Date: Fri, 24 Aug 2012 13:18:42 -0500
Message-ID: <1345832322.25206.17.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jbrassow@redhat.com, neilb@suse.de
List-Id: linux-raid.ids

DM RAID:  Move chunk of code to it's own function

The code that checks whether device replacements/rebuilds are possible given
a specific RAID type is moved to it's own function.  It will further expand
when the code to check RAID10 is added.  A separate function makes it easier
to read.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -338,6 +338,52 @@ static int validate_region_size(struct r
 }
 
 /*
+ * validate_rebuild_devices
+ * @rs
+ *
+ * Determine if the devices specified for rebuild can result in a valid
+ * usable array that is capable of rebuilding the given devices.
+ *
+ * Returns: 0 on success, -EINVAL on failure.
+ */
+static int validate_rebuild_devices(struct raid_set *rs)
+{
+	unsigned i, rebuild_cnt = 0;
+
+	if (!(rs->print_flags & DMPF_REBUILD))
+		return 0;
+
+	for (i = 0; i < rs->md.raid_disks; i++)
+		if (!test_bit(In_sync, &rs->dev[i].rdev.flags))
+			rebuild_cnt++;
+
+	switch (rs->raid_type->level) {
+	case 1:
+		if (rebuild_cnt >= rs->md.raid_disks)
+			goto too_many;
+		break;
+	case 4:
+	case 5:
+	case 6:
+		if (rebuild_cnt > rs->raid_type->parity_devs)
+			goto too_many;
+		break;
+	case 10:
+	default:
+		DMERR("The rebuild parameter is not supported for %s",
+		      rs->raid_type->name);
+		rs->ti->error = "Rebuild not supported for this RAID type";
+		return -EINVAL;
+	}
+
+	return 0;
+
+too_many:
+	rs->ti->error = "Too many rebuild devices specified";
+	return -EINVAL;
+}
+
+/*
  * Possible arguments are...
  *	<chunk_size> [optional_args]
  *
@@ -365,7 +411,7 @@ static int parse_raid_params(struct raid
 {
 	char *raid10_format = "near";
 	unsigned raid10_copies = 2;
-	unsigned i, rebuild_cnt = 0;
+	unsigned i;
 	unsigned long value, region_size = 0;
 	sector_t sectors_per_dev = rs->ti->len;
 	sector_t max_io_len;
@@ -461,30 +507,6 @@ static int parse_raid_params(struct raid
 
 		/* Parameters that take a numeric value are checked here */
 		if (!strcasecmp(key, "rebuild")) {
-			rebuild_cnt++;
-
-			switch (rs->raid_type->level) {
-			case 1:
-				if (rebuild_cnt >= rs->md.raid_disks) {
-					rs->ti->error = "Too many rebuild devices specified";
-					return -EINVAL;
-				}
-				break;
-			case 4:
-			case 5:
-			case 6:
-				if (rebuild_cnt > rs->raid_type->parity_devs) {
-					rs->ti->error = "Too many rebuild devices specified for given RAID type";
-					return -EINVAL;
-				}
-				break;
-			case 10:
-			default:
-				DMERR("The rebuild parameter is not supported for %s", rs->raid_type->name);
-				rs->ti->error = "Rebuild not supported for this RAID type";
-				return -EINVAL;
-			}
-
 			if (value > rs->md.raid_disks) {
 				rs->ti->error = "Invalid rebuild index given";
 				return -EINVAL;
@@ -608,6 +630,9 @@ static int parse_raid_params(struct raid
 	}
 	rs->md.dev_sectors = sectors_per_dev;
 
+	if (validate_rebuild_devices(rs))
+		return -EINVAL;
+
 	/* Assume there are no metadata devices until the drives are parsed */
 	rs->md.persistent = 0;
 	rs->md.external = 1;


