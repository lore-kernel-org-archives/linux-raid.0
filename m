Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F481335BAF
	for <linux-raid@vger.kernel.org>; Mon,  5 Jan 2026 14:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767624415; cv=none; b=Dk8nr4cTK7Ux7da7gnXEC6ay63DcsU/NjvJXrd1q0qq6DHP1ugGdeGxoOQWRoXCkPwmaOSFq2gwrTahbWbvLB0kvouiOj3tavtQZ9/mAV5n5WHzF2n1Y5qxLjbuJV05L/0GyMUahtUKanQvLlA6kT5B5X0683J0di//1CKS7hws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767624415; c=relaxed/simple;
	bh=ejGBZNU9WJMWKqpvmwqiDbiDAX10TLBQzQDrBexviPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ID++KZ6IwuX+3zOGqLHJTFVtdLF+5Zoj/0ACaNLL2QYIIFx/FaMUavjFsAqjSeaWbRSoCbIfgbwHxlxAwK1dOQathHNatT3/u/rgEucZUCN3mD9l/3Q5hjPknWEdlJHmZLlXh8uTTWMRlm7eNMjHkBUGvqbjIaMQftRsJjRJNNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=Az1ToRGf; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="Az1ToRGf"
Received: from fedora (p3411048-ipxg00d01tokaisakaetozai.aichi.ocn.ne.jp [114.157.12.48])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 605Eenoc052549
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 5 Jan 2026 23:41:08 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=fTM2LuS+zQWnkW2Iqi4WiaphYQuAhQfnZqgoTIDOyU8=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1767624068; v=1;
        b=Az1ToRGfdm0oA0RMBc8hZ8/LdnmawzP9pBP81zNq52M3JhCsoQCHzpA6rFuqJHPV
         hGS1/9MeDmez1X1d1yeMScwzRBX075Xzu19LR660JypYYAv8n9qpHcX4xOtaK40m
         ViEgnpUf6wqtsNxW/AeJatCVn/dfC/lMGzIrGEn1LFFNQVR+DGG8a98nI/tfneq7
         E9PTMAgTCqoaHjPF4wT+wRIXCNl42+Mp3o53KrN6TIxgxnxgVFUJGztBn2MuMsce
         Pbk5GGyLou8LEWHgHxiAYJvsr4Q8buUzMaKM+H9uXkJbNNXT03MM605ee9wkuUU/
         jykEwBT3Gwdh6gM1bo2/Cw==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>, Li Nan <linan122@huawei.com>
Subject: [PATCH v6 2/2] md/raid10: fix failfast read error not rescheduled
Date: Mon,  5 Jan 2026 23:40:25 +0900
Message-ID: <20260105144025.12478-3-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260105144025.12478-1-k@mgml.me>
References: <20260105144025.12478-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid10_end_read_request lacks a path to retry when a FailFast IO fails.
As a result, when Failfast Read IOs fail on all rdevs, the upper layer
receives EIO, without read rescheduled.

Looking at the two commits below, it seems only raid10_end_read_request
lacks the failfast read retry handling, while raid1_end_read_request has
it. In RAID1, the retry works as expected.
* commit 8d3ca83dcf9c ("md/raid10: add failfast handling for reads.")
* commit 2e52d449bcec ("md/raid1: add failfast handling for reads.")

This commit will make the failfast read bio for the last rdev in raid10
retry if it fails.

Fixes: 8d3ca83dcf9c ("md/raid10: add failfast handling for reads.")
Signed-off-by: Kenta Akagi <k@mgml.me>
Reviewed-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid10.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b33149aa5b29..8a254bab52e8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -401,6 +401,13 @@ static void raid10_end_read_request(struct bio *bio)
 		 * wait for the 'master' bio.
 		 */
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
+	} else if (test_bit(FailFast, &rdev->flags) &&
+		 test_bit(R10BIO_FailFast, &r10_bio->state)) {
+		/*
+		 * This was a fail-fast read so we definitely
+		 * want to retry
+		 */
+		;
 	} else if (!raid1_should_handle_error(bio)) {
 		uptodate = 1;
 	} else {
-- 
2.50.1

