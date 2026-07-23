Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2064C77DF;
	Thu, 23 Jul 2026 13:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784814969; cv=none; b=RmanNK2a90RRSwAwBhNF8w8padywHSx0WjAmwOUnBb+JCPRLILIJN1paeGIJlrRpt7amqftDIixOZdcFHF9JMNTopTnr6CjWAIMZbBEzvrGYk8gR757o6cgngTMUQS3nyvAyRFclLcV2Adt1m2IvXyeHJZO1g0/MXGdVobO+tBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784814969; c=relaxed/simple;
	bh=39mkJPwtzNFZ8nRNEFnHXySP+q5lQynf/eepMujHrrg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FLuTBRrOetJnm8LKU80NN93exK3wTh8jd68vxhJY/ab3kpHZW+7o7hlQEfCCF6UBGrrYM6fnsHsZ5RSSxa4YC1sR8Y94VqcyqCMbxFhOaKnnpRvYeym9Si98ZecB3bNr2HOolXl6zAuCrhgjfvoxn5C1SChUUZPz7Afy8JbCN1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TaguCRR9; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TaguCRR9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784814945; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=rTKyGSGgkShjZzpP3QRx1yF53Mb5XhDQUXW+TRrvk/U=;
	b=TaguCRR9tz2jWTkiTJ9IK2/jBMqJkkhDIIEbZCeP8KQBivwFrYzfRD+kXGiJMJ7Esz6+WtWqYbWuMpV8y4L+wfndhrEfHQF58fZcA/Ih60gILT3SH1qvOwWrSneGxon6uGk/bOLCwDq7jkC4lkQ+HDeW/bb1VJdGCV3/DBtq/ow=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=yunye.zhao@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X7gKXb1_1784814940;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:yunye.zhao@linux.alibaba.com fp:SMTPD_---0X7gKXb1_1784814940 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Jul 2026 21:55:44 +0800
From: Yunye Zhao <yunye.zhao@linux.alibaba.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>
Subject: [PATCH v2 1/3] md/raid10: fix still_degraded being inverted in raid10_sync_request()
Date: Thu, 23 Jul 2026 21:55:33 +0800
Message-Id: <20260723135535.101995-2-yunye.zhao@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20260723135535.101995-1-yunye.zhao@linux.alibaba.com>
References: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com>
 <20260723135535.101995-1-yunye.zhao@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit fe6a19d40ceb ("md/md-bitmap: merge md_bitmap_start_sync() into
bitmap_operations") converted still_degraded from int to bool, but
inverted the assignment in the loop that checks whether the array will
still be degraded after the current device is recovered:
"still_degraded = 1" became "still_degraded = false".

As a result, recovering a device while another mirror is still missing
calls md_bitmap_start_sync() with degraded == false, which clears bitmap
bits that the still-missing device needs.  When that device is re-added,
its bitmap-based recovery finds the bits already cleared and skips every
region written while the array was degraded, so it is marked In_sync
while holding stale data: silent corruption.

Reproducer (raid10 near=2, 4 disks, internal bitmap):
 - fail and remove one disk of each mirror pair
 - write to the degraded array
 - re-add both disks and let recovery finish
 - "check" reports mismatch_cnt=262272 after 256 MiB of degraded
   writes and file contents differ; the second disk's "recovery"
   completes in milliseconds because everything is skipped

The same conversion in raid1 got it right (still_degraded = true).
Restore the correct value.

Fixes: fe6a19d40ceb ("md/md-bitmap: merge md_bitmap_start_sync() into bitmap_operations")
Cc: stable@vger.kernel.org
Signed-off-by: Yunye Zhao <yunye.zhao@linux.alibaba.com>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a3cfdd3f5df..54cddb3a98cd 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3365,7 +3365,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				struct md_rdev *rdev = conf->mirrors[j].rdev;
 
 				if (rdev == NULL || test_bit(Faulty, &rdev->flags)) {
-					still_degraded = false;
+					still_degraded = true;
 					break;
 				}
 			}

base-commit: 4539944e515183668109bdf4d0c3d7d228383d88
-- 
2.19.1.6.gb485710b

