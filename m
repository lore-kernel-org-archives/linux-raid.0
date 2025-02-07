Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE692417E0
	for <linux-raid@vger.kernel.org>; Fri,  7 Feb 2025 02:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738895194; cv=none; b=W+bL1lcHS3wcAilNHunfYxLcCXcM4vbVovDJYsCnLminUlWTN/nxaEYpdPDx4as2NUfqw8Au5dyco5AdHESuxZZcFDJij3aFbReNiy3JNHXdmgsBcpyancMFirEWStM7qpN5W/uWpKUB1gCU3UKoIJ3RCc87NpPQU5ph5ZtIkMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738895194; c=relaxed/simple;
	bh=pKIeP0TQEceU3cm1lTaeGaiULX8Z3Ma6M6KjDo0o4Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T2LU16K9B2vBg+Vi9CLrmKlyXEvZbyaHIvsZHkwzRD/X3pYxeSYbqW6KZnUGUtDG8J9tGOt57XEsf7Gj+uKn77ZL6LhpjPJOWkdN30Paamupzd6/VcbbMmKQuNJyFLurqiAOnOp5Cl4E6PEd6CyfyLNviGhx1AgN6u6nXStIJw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=euNu7fFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="euNu7fFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CD4C4CEDD;
	Fri,  7 Feb 2025 02:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738895194;
	bh=pKIeP0TQEceU3cm1lTaeGaiULX8Z3Ma6M6KjDo0o4Qg=;
	h=From:To:Cc:Subject:Date:From;
	b=euNu7fFQ/Mad95gYaXzgS3mKWPgeijUUDUrTDfjxGVgAiMDLwDE00Jng4b0WSfYuA
	 +be93qTw506TWbjJ/XSYwylICaA7fbVR900q9OjJ0o3G8SXPAFWWzG/Iqh8Wolx8la
	 5q/K/ppSukCF7x1f5P5XkuKNMKKIkLOhpEcXDuXNmRjN1eSTgbTqdtI+KpaEvb9PLy
	 bwvDQ+OwUwULIz2pFiRgHqbWhYMATpmczPYyeMTlwqn8NpliyAysveXalOXdfch/QS
	 +MR6bsNOk22zH+GwCYS4JvZucRemc7zJ5sfNld67tyx9Zd3P8CxQMGAhbdiDosD8uO
	 nt6l7+fgoklpw==
From: colyli@kernel.org
To: linux-raid@vger.kernel.org
Cc: Coly Li <colyli@kernel.org>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH V2] md-linear: optimize which_dev() for small disks number
Date: Fri,  7 Feb 2025 10:26:25 +0800
Message-ID: <20250207022625.86802-1-colyli@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@kernel.org>

which_dev() is a top hot function in md-linear.c, every I/O request will
call it to find out which component disk the bio should be issued to.

Current witch_dev() performs a standard binary search, indeed this is
not the fastest algorithm in practice. When the whole conf->disks array
can be stored within a single cache line, simple linear search is faster
than binary search for a small disks number.

From micro benchmark, around 20%~30% latency reduction can be observed.
Of course such huge optimization cannot be achieved in real workload, in
my benchmark with,
1) One md linear device assembled by 2 or 4 Intel Optane memory block
   device on Lenovo ThinkSystem SR650 server.
2) Random write I/O issued by fio, with I/O depth 1 and 512 bytes block
   size.

The percentage of I/O latencies completed with 750 nsec increases from
97.186% to 99.324% in average, in a rough estimation the write latency
improves (reduces) around 2.138%.

This is quite ideal result, I believe on slow hard drives such small
code-running optimization will be overwhelmed by hardware latency and
hard to be recognized.

This patch will go back to binary search when the linear device grows
and conf->disks array cannot be placed within a single cache line.

Although the optimization result is tiny in most of cases, it is good to
have it since we don't pay any other cost.

Signed-off-by: Coly Li <colyli@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai3@huawei.com>
---
Changelog,
v2: return last item of conf->disks[] if fast search missed.
v1: initial version.


 drivers/md/md-linear.c | 45 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index a382929ce7ba..cdb59f2b2a1c 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -25,10 +25,12 @@ struct linear_conf {
 	struct dev_info         disks[] __counted_by(raid_disks);
 };
 
+static int prefer_linear_dev_search;
+
 /*
  * find which device holds a particular offset
  */
-static inline struct dev_info *which_dev(struct mddev *mddev, sector_t sector)
+static inline struct dev_info *__which_dev(struct mddev *mddev, sector_t sector)
 {
 	int lo, mid, hi;
 	struct linear_conf *conf;
@@ -53,6 +55,34 @@ static inline struct dev_info *which_dev(struct mddev *mddev, sector_t sector)
 	return conf->disks + lo;
 }
 
+/*
+ * If conf->disk[] can be hold within a L1 cache line,
+ * linear search is fater than binary search.
+ */
+static inline struct dev_info *which_dev(struct mddev *mddev, sector_t sector)
+{
+	int i;
+
+	if (prefer_linear_dev_search) {
+		struct linear_conf *conf;
+		struct dev_info *dev;
+		int max;
+
+		conf = mddev->private;
+		dev = conf->disks;
+		max = conf->raid_disks;
+		for (i = 0; i < max; i++, dev++) {
+			if (sector < dev->end_sector)
+				return dev;
+		}
+		return &conf->disks[max-1];
+	}
+
+	/* slow path */
+	return __which_dev(mddev, sector);
+}
+
+
 static sector_t linear_size(struct mddev *mddev, sector_t sectors, int raid_disks)
 {
 	struct linear_conf *conf;
@@ -222,6 +252,18 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 	set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
 	kfree_rcu(oldconf, rcu);
+
+	/*
+	 * When elements in linear_conf->disks[] becomes large enought,
+	 * set prefer_linear_dev_search as 0 to indicate linear search
+	 * in which_dev() is not optimized. Slow path in __which_dev()
+	 * might be faster.
+	 */
+	if ((mddev->raid_disks * sizeof(struct dev_info)) >
+	     cache_line_size() &&
+	    prefer_linear_dev_search == 1)
+		prefer_linear_dev_search = 0;
+
 	return 0;
 }
 
@@ -337,6 +379,7 @@ static struct md_personality linear_personality = {
 
 static int __init linear_init(void)
 {
+	prefer_linear_dev_search = 1;
 	return register_md_personality(&linear_personality);
 }
 
-- 
2.48.1

