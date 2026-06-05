Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D973E4C70;
	Fri,  5 Jun 2026 03:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780629736; cv=none; b=Ej1cdmf7F/QmolE7ui95u+BDpN8Xru+0PJU5ybeT6wZhIZNCAby0Pb8CTfZvZ2kP+Ybkan6uIgKy2dXtfuf3EBxbI+2QhpitkXpJOaspXYVepy9jOELY/qMY+Fi1ZhI93legDeMPofyP9aANcFvRKJvELcz4wZLvMqYHeBnVK5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780629736; c=relaxed/simple;
	bh=sFZdfWOe0Y44AxjLe05J00ib+1VEgmwl3sCVBEZtCUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sC4P2XbSU4F2WMBAdnxY7hHTYwNEQ7Bu9kGw10GC0xHXKRpIO0FrSAfzsJlmFfYkOtBZMT3+/qz/VvWEB+FKReQzTalUixkaoW/Gs7jGVGlITGdJcbvTkXCIEE7FDbxZeVDrLYgCTweuku5xLeWp5zBJs5NCwMKupcUmUMBG9vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gFK+Vt7l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFK+Vt7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3121A1F00899;
	Fri,  5 Jun 2026 03:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780629733;
	bh=v66bTfehFWEt48mRp0lqMgVYHC92SMhbb+XEPoZlJio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFK+Vt7leNMu3U+FqAMJjNfN0eyV9yRulxXRREshLcihbuPbazgRDrOjWB6Ajngl5
	 fY56Jyj1nbJNB/YLEc67QEEbaWfI9s3SzpKhTi3UBcsU02baAxuY+3y1KwOstjHsiB
	 TlyfDKMzmkk05rbAJpSCEKZawGoKO6M5kD96L+iNAASbEuDaNiCW2IL3QsB9bS9v6f
	 7TJm9LtS8fHehP0ha/jCiL97scnWnWt8QEK7PF3GzN9RdBr6VVyM2zYDgpNVxympYS
	 Ft9n3zY81AzQQ2iGTBBgi0jaqX611vQVIOzP0aH8SZTTdJDPRlCfytH2LLEGG36l0s
	 1EYk4Z4jAQI7w==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid5: allow discard with llbitmap
Date: Fri,  5 Jun 2026 11:22:05 +0800
Message-ID: <20260605032205.2376714-3-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605032205.2376714-1-yukuai@kernel.org>
References: <20260605032205.2376714-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Raid5 disables discard unless devices_handle_discard_safely is set
because lower devices that do not return zeroes after discard can
leave a discarded stripe inconsistent. A later partial write can then
reconstruct bad data if a member fails.

The legacy bitmap needs this restriction because it only records
write-intent dirty ranges. It cannot distinguish discarded data from
valid data, so discard can make data inconsistent after later partial
writes and failures.

llbitmap records discarded ranges as unwritten. Raid5 already consults
llbitmap state to force RCW or lazy recovery before using parity for
unwritten data. Therefore non-zeroing discard is safe with llbitmap
while the existing full-stripe granularity and lower-device
discard-size checks still apply.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index debf35342ae0..4e9a758a8cc9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7829,11 +7829,12 @@ static int raid5_set_limits(struct mddev *mddev)
 	 * We only allow DISCARD if the sysadmin has confirmed that only safe
 	 * devices are in use by setting a module parameter.  A better idea
 	 * might be to turn DISCARD into WRITE_ZEROES requests, as that is
 	 * required to be safe.
 	 */
-	if (!devices_handle_discard_safely ||
+	if ((!devices_handle_discard_safely &&
+	     mddev->bitmap_id != ID_LLBITMAP) ||
 	    lim.max_discard_sectors < (stripe >> 9) ||
 	    lim.discard_granularity < stripe)
 		lim.max_hw_discard_sectors = 0;
 
 	/*
-- 
2.51.0

