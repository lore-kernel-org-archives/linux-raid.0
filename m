Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793706947;
	b=Ruk/YojQDiqXc1JeDMEwDTby/UeOEdmAVIRx5Hp3Y/6yfXwoTgVZmWKL4x7+cpgAukJm
	 ygavh7SsbvayAppTxvRq+NhXZIwrS4REOcCYzBStx09I2ThYkHJ+LHy1JLTbK/UnOSfRk
	 98tjTNRjwpnF/2ybO9BqlQA2Lae2aTQqseND2mkSfTZ+EUg634ZRxL2csCzrF/Q8sh7DI
	 j3vLrGjTNl7MoipGiEmoj4MGC7vul5IfFiDwk5rd7tMrjz0d+ism+xFl36/4JbJR8nMAd
	 /UsHiXilNRrtjIMgv/ja5JyyUv8FCB9EVDstfb7fkA3CrmJQDHaNhnSq9N1fjmhusTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793706947;
	h=DMARC-Filter:X-Alimail-AntiSpam:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=eGUTN5stq2GNQ65GIycmnbGlk5AjIXl4S++YM+uakBs=;
	b=nQLlqkhQgY6riEUzlbr8VSDInbo/ZRl86pTohGAg/quwduoQNcDagaBi40McqidLtTsa
	 erxZ8Ax8Ym49hmeOLcC51JTG8SUnTTGl/FKbCKqUY5nOwnI30N1peXJA3UtWL4dYDJDPk
	 cOWim9NspAx/nwbYO+DaULrbKGAl+e7TDzGXrjOkEsOXZhzB9K/PNxSTbbbKCm2n679JA
	 O/Yulhx2IbvlgX14nvWzPUXqXOHjIZqb7X/RKe/XZvnNgRHWonD4qAroS6lYCBvzzYRaF
	 qRFF7MEX+8zLdqgjJ/lZWQdMfQJS7iUsPCLDmCAPRc77n9HEjJLxyuY5P+BIaQs8U1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kaihong.com;
	spf=pass smtp.mailfrom=kaihong.com;
	arc=none smtp.remote-ip=115.124.28.115
Received: from out28-115.mail.aliyun.com (out28-115.mail.aliyun.com [115.124.28.115])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A88606A333;
	Tue,  3 Nov 2026 11:55:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04A88606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaihong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaihong.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07436259|-1;BR=01201311R111S59rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0107514-0.00587939-0.983369;FP=14128837808419836670|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037033194;MF=wangjichen@kaihong.com;NM=1;PH=DS;RN=10;RT=10;SR=0;TI=SMTPD_---.jvip0Fh_1793706932;
Received: from ubuntu.example.org(mailfrom:wangjichen@kaihong.com fp:SMTPD_---.jvip0Fh_1793706932 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 03 Nov 2026 19:55:33 +0800
From: Wang Jichen <wangjichen@kaihong.com>
To: Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: syzbot+cd254889291ef8666036@syzkaller.appspotmail.com,
	wangjichen <wangjichen@kaihong.com>
Subject: [PATCH] md: avoid block autoload while importing rdev under reconfig_mutex
Date: Tue,  3 Nov 2026 11:55:29 +0000
Message-Id: <20261103115530.2913093-1-wangjichen@kaihong.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: wangjichen <wangjichen@kaihong.com>

md_import_device() runs with mddev->reconfig_mutex held from md_ioctl().
Opening a member disk via bdev_file_open_by_dev() triggers legacy block
autoload (blk_probe_dev), which takes major_names_lock. md_probe() can
run under that lock and call md_alloc(), which takes disks_mutex and
reconfig_mutex — a lockdep ABBA with the ioctl path.

Add bdev_file_open_by_dev_autoload() and use autoload=false from
md_import_device(); member devices must already be present in the
block layer (normal mdadmin usage).

Link: https://syzbot.org/bug?extid=cd254889291ef8666036
Reported-by: syzbot+cd254889291ef8666036@syzkaller.appspotmail.com
Tested-by: Wang Jichen <wangjichen@kaihong.com>
Signed-off-by: Wang Jichen <wangjichen@kaihong.com>
---
 block/bdev.c           | 13 ++++++++++---
 drivers/md/md.c        |  8 ++++++--
 include/linux/blkdev.h |  2 ++
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index f20f91b31..e78936556 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1076,8 +1076,8 @@ static unsigned blk_to_file_flags(blk_mode_t mode)
 	return flags;
 }
 
-struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
-				   const struct blk_holder_ops *hops)
+struct file *bdev_file_open_by_dev_autoload(dev_t dev, blk_mode_t mode,
+		void *holder, const struct blk_holder_ops *hops, bool autoload)
 {
 	struct file *bdev_file;
 	struct block_device *bdev;
@@ -1088,7 +1088,7 @@ struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
 	if (ret)
 		return ERR_PTR(ret);
 
-	bdev = blkdev_get_no_open(dev, true);
+	bdev = blkdev_get_no_open(dev, autoload);
 	if (!bdev)
 		return ERR_PTR(-ENXIO);
 
@@ -1110,6 +1110,13 @@ struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
 	}
 	return bdev_file;
 }
+EXPORT_SYMBOL(bdev_file_open_by_dev_autoload);
+
+struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
+				   const struct blk_holder_ops *hops)
+{
+	return bdev_file_open_by_dev_autoload(dev, mode, holder, hops, true);
+}
 EXPORT_SYMBOL(bdev_file_open_by_dev);
 
 struct file *bdev_file_open_by_path(const char *path, blk_mode_t mode,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a..d3717e2e8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3858,9 +3858,13 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 	if (err)
 		goto out_clear_rdev;
 
-	rdev->bdev_file = bdev_file_open_by_dev(newdev,
+	/*
+	 * md_ioctl() holds reconfig_mutex; legacy autoload in bdev open takes
+	 * major_names_lock via blk_probe_dev() and can deadlock with md_probe().
+	 */
+	rdev->bdev_file = bdev_file_open_by_dev_autoload(newdev,
 			BLK_OPEN_READ | BLK_OPEN_WRITE,
-			super_format == -2 ? &claim_rdev : rdev, NULL);
+			super_format == -2 ? &claim_rdev : rdev, NULL, false);
 	if (IS_ERR(rdev->bdev_file)) {
 		pr_warn("md: could not open device unknown-block(%u,%u).\n",
 			MAJOR(newdev), MINOR(newdev));
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0c2010230..e5121101a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1699,6 +1699,8 @@ struct blk_holder_ops {
 
 struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
 		const struct blk_holder_ops *hops);
+struct file *bdev_file_open_by_dev_autoload(dev_t dev, blk_mode_t mode,
+		void *holder, const struct blk_holder_ops *hops, bool autoload);
 struct file *bdev_file_open_by_path(const char *path, blk_mode_t mode,
 		void *holder, const struct blk_holder_ops *hops);
 int bd_prepare_to_claim(struct block_device *bdev, void *holder,
-- 
2.34.1

