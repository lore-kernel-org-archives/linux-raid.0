From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v2 6/6] raid5: introduce configuration option rmw_level
Date: Tue, 19 Aug 2014 16:36:56 +0000
Message-ID: <23c42c02-d75e-46f9-8a7c-d59c1a48da76@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-ec3ad7bb-5327-499c-b798-354b38d5d7e1"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-ec3ad7bb-5327-499c-b798-354b38d5d7e1
Content-Type: text/plain

commit a70013beafc2cc768a6a8f65b1decc28fca30cae
Author: Markus Stockhausen <markus.stockhausen@collogia.de>
Date:   Tue Aug 19 16:26:36 2014 +0000

    raid5: introduce configuration option rmw_level
    
    v2: no changes
    
    Depending on the available coding we allow optimized rmw logic for write
    operations. To support easier testing this patch allows manual control
    of the rmw/rcw descision through the interface /sys/block/mdX/md/rmw_level.
    
    The configuration can handle three levels of control.
    
    rmw_level=0: Disable rmw for all RAID types. Hardware assisted P/Q
    calculation has no implementation path yet to factor in/out chunks of
    a syndrome. Enforcing this level can be benefical for slow CPUs with
    hardware syndrome support and fast SSDs.
    
    rmw_level=1: Estimate rmw IOs and rcw IOs. Execute rmw only if we will
    save IOs. This equals the "old" unpatched behaviour and will be the
    default.
    
    rmw_level=2: Execute rmw even if calculated IOs for rmw and rcw are
    equal. We might have higher CPU consumption because of calculating the
    parity twice but it can be benefical otherwise. E.g. RAID4 with fast
    dedicated parity disk/SSD. The option is implemented just to be
    forward-looking and will ONLY work with this patch!

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index eb63e31..3b525f8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5408,6 +5408,49 @@ raid5_stripecache_size = __ATTR(stripe_cache_size, S_IRUGO | S_IWUSR,
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
+	if (new != PARITY_DISABLE_RMW && !raid6_call.xor_syndrome)
+		return -EINVAL;
+
+	if (new != PARITY_DISABLE_RMW &&
+	    new != PARITY_ENABLE_RMW &&
+	    new != PARITY_PREFER_RMW)
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
+
+static ssize_t
 raid5_show_preread_threshold(struct mddev *mddev, char *page)
 {
 	struct r5conf *conf = mddev->private;
@@ -5571,6 +5614,7 @@ static struct attribute *raid5_attrs[] =  {
 	&raid5_preread_bypass_threshold.attr,
 	&raid5_group_thread_cnt.attr,
 	&raid5_skip_copy.attr,
+	&raid5_rmw_level.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index cbb00e2..1893b3a 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -347,6 +347,7 @@ enum {
 enum {
 	PARITY_DISABLE_RMW = 0,
 	PARITY_ENABLE_RMW,
+	PARITY_PREFER_RMW,
 };
 
 /*

------=_NextPartTM-000-ec3ad7bb-5327-499c-b798-354b38d5d7e1
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

------=_NextPartTM-000-ec3ad7bb-5327-499c-b798-354b38d5d7e1--
