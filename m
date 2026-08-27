Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1CC3812C2;
	Thu, 27 Aug 2026 02:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787799178; cv=none; b=PJz35k4+L7aQL4muO2EPY35mMnyI5urON3IMcax+U8p8YK2wlTSueAeSVG4wE01x+RAF2tqBtfnYCunl4ycEzuybsndmv0sjTdd7c9qBdNU2Sb/l4Pm1fjnv46MKCqRTbfMi3RGlTMDBWhIdlYzEg8VDmbK4oI/tnaXElzykWLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787799178; c=relaxed/simple;
	bh=biZ/o/U/TU+X1hazTnABtit2M7iAOWQdYiuSnkZn6/4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Pzi+AhErZblvfR5XAXdWULC6MW080xSY2EwKb4Z8E/ZcV3z073My7W1pELcEW4MnReqTH3qefZ7T54+JQdD22Zy4DcCb5hJ1Hb6FpV0gFrscdGkbeVcCnZ0nx2zxm0aj/FtSkq4fiK7vDSSh7UlgZq+za2GLd13yKf6bbJ9QE/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=RHXGCskq; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="RHXGCskq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=GQ
	/5iD+Dl0CU/ydwpKnFa71HIbspsETfxUx98qiNHPE=; b=RHXGCskqOI3PCd/JiC
	+vDjzckGHAEUWvQs8kwMmxWoaGbKuNA/+Psn8orc8MJhfpstVHUA326ZHXsvMKUZ
	Ip+SBHQKA6duEf2v48PmfdKkmtIPfNHe3H44qx3vPidpgGDYitx+lBGQfWrEmzuB
	WSfBcNzjr4tsILePRbeFEUZ+s=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wAHhIhtpo9qE6RhSQ--.15025S2;
	Thu, 27 Aug 2026 10:52:30 +0800 (CST)
From: ghuicao@163.com
To: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cao Guanghui <caoguanghui@kylinos.cn>
Subject: [PATCH] md-cluster: check pers->resize() return value in update_size()
Date: Thu, 27 Aug 2026 10:52:29 +0800
Message-Id: <20260827025229.40138-1-ghuicao@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAHhIhtpo9qE6RhSQ--.15025S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF48XFW7GryrWr43CrWruFg_yoW8Gry8pr
	Wvva4akrykC3yUGw47Jws7ua4rKw1xJrWYyry7Cw1Skw4DJrZFkF4Fgas0qan8Cry3XanI
	qrs8XF4ku3Wv9w7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j72-5UUUUU=
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC-A5D1WqPpm7dDAAA3Y

From: Cao Guanghui <caoguanghui@kylinos.cn>

In update_size(), when cluster_check_sync_size() detects that not all
nodes have updated their sync_size, the initiator reverts the array
size via pers->resize().  However, the return value of resize() is
immediately overwritten by __sendmsg(), so a resize failure is
silently lost.

If the revert resize fails, the array remains at the new (larger)
size while other nodes have not confirmed the change, leaving the
cluster in an inconsistent state with no error logged.

Check the resize() return value and log an error before sending the
METADATA_UPDATED message, so that a resize failure is visible to the
user.

Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
---
 drivers/md/md-cluster.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1349,7 +1349,10 @@ static void update_size(struct mddev *mddev, sector_t old_dev_sectors)
 	} else {
 		/* revert to previous sectors */
 		ret = mddev->pers->resize(mddev, old_dev_sectors);
+		if (ret)
+			pr_err("%s:%d: failed to revert array size\n",
+			       __func__, __LINE__);
 		ret = __sendmsg(cinfo, &cmsg);
 		if (ret)
 			pr_err("%s:%d: failed to send METADATA_UPDATED msg\n",
 			       __func__, __LINE__);
-- 
2.34.1

