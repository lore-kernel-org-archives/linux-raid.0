From: <stockhausen@collogia.de>
Subject: [PATCH v1 1/8]     raid5: introduce configuration option rmw_level
Date: Sun, 10 Aug 2014 11:56:30 +0000
Message-ID: <ec01734b-6458-49a6-a286-0016ac95cbc4@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-062be645-4c5b-4264-9e0b-d32808d5f443"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-062be645-4c5b-4264-9e0b-d32808d5f443
Content-Type: text/plain

commit 669a741254c4b8daa22ce091081259dce7f6ba71
Author: Markus Stockhausen <markus.stockhausen@collogia.de>
Date:   Sun Aug 10 09:25:55 2014 +0000

    raid5: introduce configuration option rmw_level
    
    Depending on the RAID level md currently allows optimized rmw logic
    for write operations. It is totally missing in RAID6 code and will be
    implemented in this patch series. To support easier testing of such a
    code this patch allows manual control of the rmw/rcw descision through
    the new interface /sys/block/mdX/md/rmw_level.
    
    The configuration can handle three levels of control.
    
    rmw_level=0: Disable rmw for all RAID types. This level is enforced
    for RAID6 and from now on allowed for RAID4/5. Hardware assisted
    P/Q calculation has no implementation path yet to factor in/out
    chunks of a syndrome. Enforcing this level can be benefical for slow
    CPUs with hardware syndrome support and fast SSDs.
    
    rmw_level=1: Estimate rmw IOs and rcw IOs. Execute rmw only if we will
    save IOs. This equals the "old" unpatched behaviour and will be the
    default for RAID4/5.
    
    rmw_level=2: Execute rmw even if calculated IOs for rmw and rcw are
    equal. We might have higher CPU consumption because of calculating the
    parity twice but it can be benefical otherwise. E.g. RAID4 with fast
    dedicated parity disk/SSD. The option is implemented just to be
    forward-looking.
    
    If we switch/grow between RAID levels the flag will be automatically
    adapted to the default sane value required for that level.

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6234b2e..ba32c1f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3103,14 +3103,14 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	 * that in case of drive failure or read-error correction, we
 	 * generate correct data from the parity.
 	 */
-	if (conf->max_degraded == 2 ||
+	if (conf->rmw_level == PARITY_DISABLE_RMW ||
 	    (recovery_cp < MaxSector && sh->sector >= recovery_cp)) {
 		/* Calculate the real rcw later - for now make it
 		 * look like rcw is cheaper
 		 */
 		rcw = 1; rmw = 2;
-		pr_debug("force RCW max_degraded=%u, recovery_cp=%llu sh->sector=%llu\n",
-			 conf->max_degraded, (unsigned long long)recovery_cp,
+		pr_debug("force RCW rmw_level=%u, recovery_cp=%llu sh->sector=%llu\n",
+			 conf->rmw_level, (unsigned long long)recovery_cp,
 			 (unsigned long long)sh->sector);
 	} else for (i = disks; i--; ) {
 		/* would I have to read this buffer for read_modify_write */
@@ -3138,7 +3138,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	pr_debug("for sector %llu, rmw=%d rcw=%d\n",
 		(unsigned long long)sh->sector, rmw, rcw);
 	set_bit(STRIPE_HANDLE, &sh->state);
-	if (rmw < rcw && rmw > 0) {
+	if ((rmw < rcw || (rmw == rcw && conf->rmw_level == PARITY_PREFER_RMW)) && rmw > 0) {
 		/* prefer read-modify-write, but need to get some data */
 		if (conf->mddev->queue)
 			blk_add_trace_msg(conf->mddev->queue,
@@ -3165,7 +3165,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 			}
 		}
 	}
-	if (rcw <= rmw && rcw > 0) {
+	if ((rcw < rmw || (rcw == rmw && conf->rmw_level != PARITY_PREFER_RMW)) && rcw > 0) {
 		/* want reconstruct write, but need to get some data */
 		int qread =0;
 		rcw = 0;
@@ -5364,6 +5364,49 @@ raid5_stripecache_size = __ATTR(stripe_cache_size, S_IRUGO | S_IWUSR,
 				raid5_store_stripe_cache_size);
 
 static ssize_t
+raid5_show_rmw_level(struct mddev  *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	if (conf)
+		return sprintf(page, "%d\n", conf->rmw_level);
+	else
+		return 0;
+}
+
+static ssize_t
+raid5_store_rmw_level(struct mddev  *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	unsigned long new;
+
+	if (!conf)
+		return -ENODEV;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+
+	if (kstrtoul(page, 10, &new))
+		return -EINVAL;
+
+	if (new != PARITY_DISABLE_RMW &&
+	    new != PARITY_PREFER_RCW &&
+	    new != PARITY_PREFER_RMW)
+		return -EINVAL;
+
+	/* RAID6 does not support rmw yet */
+	if (new != PARITY_DISABLE_RMW && conf->level == 6)
+		return -EINVAL;
+
+	conf->rmw_level = new;
+	return len;
+}
+
+static struct md_sysfs_entry
+raid5_rmw_level = __ATTR(rmw_level, S_IRUGO | S_IWUSR,
+			 raid5_show_rmw_level,
+			 raid5_store_rmw_level);
+
+static ssize_t
 raid5_show_preread_threshold(struct mddev *mddev, char *page)
 {
 	struct r5conf *conf = mddev->private;
@@ -5527,6 +5570,7 @@ static struct attribute *raid5_attrs[] =  {
 	&raid5_preread_bypass_threshold.attr,
 	&raid5_group_thread_cnt.attr,
 	&raid5_skip_copy.attr,
+	&raid5_rmw_level.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
@@ -5850,10 +5894,13 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 	conf->chunk_sectors = mddev->new_chunk_sectors;
 	conf->level = mddev->new_level;
-	if (conf->level == 6)
+	if (conf->level == 6) {
 		conf->max_degraded = 2;
-	else
+		conf->rmw_level = PARITY_DISABLE_RMW;
+	} else {
 		conf->max_degraded = 1;
+		conf->rmw_level = PARITY_PREFER_RCW;
+	}
 	conf->algorithm = mddev->new_layout;
 	conf->reshape_progress = mddev->reshape_position;
 	if (conf->reshape_progress != MaxSector) {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index bc72cd4..90a9097 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -340,6 +340,15 @@ enum {
 	STRIPE_OP_RECONSTRUCT,
 	STRIPE_OP_CHECK,
 };
+
+/*
+ * RAID parity calculation preferences
+ */
+enum {
+	PARITY_DISABLE_RMW = 0,
+	PARITY_PREFER_RCW,
+	PARITY_PREFER_RMW,
+};
 /*
  * Plugging:
  *
@@ -397,7 +406,7 @@ struct r5conf {
 	spinlock_t		hash_locks[NR_STRIPE_HASH_LOCKS];
 	struct mddev		*mddev;
 	int			chunk_sectors;
-	int			level, algorithm;
+	int			level, algorithm, rmw_level;
 	int			max_degraded;
 	int			raid_disks;
 	int			max_nr_stripes;

------=_NextPartTM-000-062be645-4c5b-4264-9e0b-d32808d5f443
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-062be645-4c5b-4264-9e0b-d32808d5f443--
