Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94407C4321E
	for <linux-raid@archiver.kernel.org>; Thu, 13 Oct 2022 22:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiJMWpL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiJMWpF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Oct 2022 18:45:05 -0400
Received: from resqmta-c1p-023465.sys.comcast.net (resqmta-c1p-023465.sys.comcast.net [IPv6:2001:558:fd00:56::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48516049C
        for <linux-raid@vger.kernel.org>; Thu, 13 Oct 2022 15:44:56 -0700 (PDT)
Received: from resomta-c1p-023267.sys.comcast.net ([96.102.18.232])
        by resqmta-c1p-023465.sys.comcast.net with ESMTP
        id j6mboDhuNf0y0j6uGoIgBU; Thu, 13 Oct 2022 22:42:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1665700944;
        bh=LV8/JcMHb+MmlhgjlVRQXW/dcI3Ijaatxb0kxbiP4wE=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version;
        b=Fnkzuf7M7yXmK0kgcjoeMYIhbc3kJAWTBZlnOb55RDDpx9d6rr9Yo+DmXbr7CQTHl
         4tRWD2vDgQ2Dmup3ijI/KK508+ha/wNi6kVegvonAzZUCMa0Xe8C8bW9Z+4I1nkl4m
         Uoa4iZqH+J+SVM2cFct9SqV5HN5qqN/Aqp2Aar+pxuUfO4M5/T0SrZpJYj2c4yZ6zg
         ++WLlzKtjsygmF24f1V9TCX1zqqfQRWhPxRqwiBqDendtwtj5ncM7eGt7MlQZOM8+G
         Iif5G5R3pZAERCKB+lbi7OgopJT1CS9Fk92swJ47ARoRR+FVUmx3feGMbJIkyKEF/b
         /269EXTaICgaA==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-c1p-023267.sys.comcast.net with ESMTPA
        id j6toofOVmA6uYj6tuozg6t; Thu, 13 Oct 2022 22:42:03 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvfedrfeekuddgudefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvehomhgtrghsthdqtfgvshhipdfqfgfvpdfpqffurfetoffkrfenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhonhgrthhhrghnucffvghrrhhitghkuceojhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvqeenucggtffrrghtthgvrhhnpedtteeljeffgfffveehhfetveefuedvheevffffhedtjeeuvdevgfeftddtheeftdenucfkphepjedurddvtdehrddukedurdehtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopehjuggvrhhrihgtkhdqmhhosghlgedrrghmrhdrtghorhhprdhinhhtvghlrdgtohhmpdhinhgvthepjedurddvtdehrddukedurdehtddpmhgrihhlfhhrohhmpehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvhdpnhgspghrtghpthhtohepjedprhgtphhtthhopehsohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrhgrihgusehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhonhgrthhhrghnrdguvghrrhhitghkse
 hsohhlihguihhgmhdrtghomhdprhgtphhtthhopehjohhnrghthhgrnhigrdhskhdruggvrhhrihgtkhesihhnthgvlhdrtghomhdprhgtphhtthhopehmrghrihhushiirdhtkhgrtgiihihksehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtohepjhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghv
X-Xfinity-VMeta: sc=-100.00;st=legit
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
To:     Song Liu <song@kernel.org>
Cc:     <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        jonathan.derrick@solidigm.com, jonathanx.sk.derrick@intel.com,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jonathan Derrick <jonathan.derrick@linux.dev>
Subject: [PATCH v2 2/3] md/bitmap: Add sysfs interface for flush threshold
Date:   Thu, 13 Oct 2022 16:41:50 -0600
Message-Id: <20221013224151.300-3-jonathan.derrick@linux.dev>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221013224151.300-1-jonathan.derrick@linux.dev>
References: <20221013224151.300-1-jonathan.derrick@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Adds a sysfs interface in the bitmap device for setting the chunk flush
threshold. This is an unsigned integer value which defines the amount of
dirty chunks allowed to be pending between bitmap flushes.

Signed-off-by: Jonathan Derrick <jonathan.derrick@linux.dev>
---
 Documentation/admin-guide/md.rst |  5 +++++
 drivers/md/md-bitmap.c           | 33 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
index d8fc9a59c086..d688ae4065cf 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -401,6 +401,11 @@ All md devices contain:
      once the array becomes non-degraded, and this fact has been
      recorded in the metadata.
 
+  bitmap/flush_threshold
+     The number of outstanding dirty chunks that are allowed to be pending
+     before unplugging the bitmap queue. The default behavior is to always
+     unplugging the queue when requested.
+
   consistency_policy
      This indicates how the array maintains consistency in case of unexpected
      shutdown. It can be:
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index c5c77f8371a8..cd8250368860 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2652,6 +2652,38 @@ static struct md_sysfs_entry max_backlog_used =
 __ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
        behind_writes_used_show, behind_writes_used_reset);
 
+static ssize_t
+bitmap_flush_threshold_show(struct mddev *mddev, char *page)
+{
+	ssize_t ret;
+	spin_lock(&mddev->lock);
+	if (mddev->bitmap == NULL)
+		ret = sprintf(page, "0\n");
+	else
+		ret = sprintf(page, "%u\n",
+			      mddev->bitmap_info.flush_threshold);
+	spin_unlock(&mddev->lock);
+	return ret;
+}
+
+static ssize_t
+bitmap_flush_threshold_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	unsigned int thresh;
+	int ret;
+	if (!mddev->bitmap)
+		return -ENOENT;
+	ret = kstrtouint(buf, 10, &thresh);
+	if (ret)
+		return ret;
+	mddev->bitmap_info.flush_threshold = thresh;
+	return len;
+}
+
+static struct md_sysfs_entry bitmap_flush_threshold =
+__ATTR(flush_threshold, S_IRUGO | S_IWUSR,
+       bitmap_flush_threshold_show, bitmap_flush_threshold_store);
+
 static struct attribute *md_bitmap_attrs[] = {
 	&bitmap_location.attr,
 	&bitmap_space.attr,
@@ -2661,6 +2693,7 @@ static struct attribute *md_bitmap_attrs[] = {
 	&bitmap_metadata.attr,
 	&bitmap_can_clear.attr,
 	&max_backlog_used.attr,
+	&bitmap_flush_threshold.attr,
 	NULL
 };
 const struct attribute_group md_bitmap_group = {
-- 
2.31.1

