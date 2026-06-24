Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6783A3988FA;
	Wed, 24 Jun 2026 06:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283395; cv=none; b=Y8cFO7e6jQ2oG2IqLA/+6eHIVOzegIJnz4JpDMc0ul9F57ePlG/tILp7w4qT+MZyMXVqY9I6/ZtVrixvH8f7ohSaIdOFNgspoPD8o3kP85jCw8Sffe0jWjq0PpfzDaRqnfBweUlmsqKX25yXXpeaaEkNDFyUsjXCfvSi+YJHfkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283395; c=relaxed/simple;
	bh=fYvaC3xgeha/MV2e9XisRAEZ+q+Z/qviFaDgG1G2G7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihJUv7LkLSLylpaZ8TgW5eRf+sHGdn1qugLtWcmJhbcQPeAggTn3NpTm2+CDst0HjbdX5RPolteiJrsPuNLxC3JWSqJ0khco+w4tQ3zVK4EQj7nwz08l1YQpKRdIgTv2p+4waNfOuTlyx4Ac7YaFm88BMVd8fxLIg99Lu4hvpr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d70/lMXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d70/lMXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE3A1F000E9;
	Wed, 24 Jun 2026 06:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283394;
	bh=/emPOsUiiv48ZOlGnM1vu9DYhjw3ZOdT+9SJI8SLqfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d70/lMXlIUPM8O8WVXpFnu/BvQL24BjB33kPCA0C2e3zi39rnr5w9/0K1MmADHvf+
	 yiifm3t01JQ80gqYm4XRkY7BuF4NE8QwitQr5wMbCajbBe9pMpz1IUorATWVDjgWac
	 lvOnywXm538Rv0ebxCDdB5C3kiw2cJD+npqJwHvI13C/ayj1S/OTezFVL6mQ3Q+J8q
	 YQ7eh3CKBsh+Ym2/wIRbIzlbpxezhzYqNTlS1V2Onbjn93gwrYnrUzikoFb2xuWQNd
	 oKZCVJK7CSSDeYFpGyr2lcOMD5i2ebCR8e6/mNl86U7MqkJNVtpKCraq58VVy6rmrG
	 ++wvj9QV3WPmw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 20/20] md/raid5: split reshape bios before bitmap accounting
Date: Wed, 24 Jun 2026 14:42:17 +0800
Message-ID: <f4bcf3a6cdb16689c42f2f5b5bb6b5dca0c84768.1782282042.git.yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org> <cover.1782282042.git.yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Use the shared mddev_bio_split_at_reshape_offset() helper so RAID5
submits only one-side bios to llbitmap during reshape.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ac7ea483502f..fb346a3c4aa3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6181,6 +6181,14 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 		return true;
 	}
 
+	bi = mddev_bio_split_at_reshape_offset(mddev, bi, NULL,
+					       &conf->bio_split);
+	if (!bi) {
+		if (rw == WRITE)
+			md_write_end(mddev);
+		return true;
+	}
+
 	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
 	bi->bi_next = NULL;
 
-- 
2.51.0

