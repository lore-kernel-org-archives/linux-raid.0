Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78218302772
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577517; cv=none; b=dEqfGO6h9DMziKAMc4vFAa2FrZ9U6UmDb0ReTwiOSQMcWbnyuB8rOLfGd/orMfZmPgqIQILoKz3LY1Hf0hH/uqmuLzBaWyGi/EdgNtrwG7DKFHvmhDzGMSFxbhAoxcfyzqRJ9iJ+LmKF+UiKN3VmkTa0ImpaaQpFhKPgRCVmfyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577517; c=relaxed/simple;
	bh=Wd1cUGfGScYh02ihprIo6cw3komLFAh+Tw0AB+8Ppa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIPLZXuIBuwzz+gEPYXysoUxEHOEXHq0XHeACEwjgKV73J1A3R9ljiwusSsjxvhNBOzPEwC6SU+4xyKzabE7QBS0dRdMmRLbujeKBasoCEchcp7l0o0edR2jfoQus+ZyIlPty0sj6JDouh3pxWUo77KOrkoeZlw4Qr2zrtQUnsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=wtbktcgZ; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="wtbktcgZ"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAj090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:46 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=okaoLlIHcjunkUheKnD4aYuOo8R+kLSHEmrYzp02T+M=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577486; v=1;
        b=wtbktcgZuz9+nzv5a52F/JHVQgDWaq5rj52clpbEjilkx4wZtZoaFf+1d3mrZh86
         dyzaUHjPu3g3FlxWOuaNJwef6vF7CjHdinYe/0oyFJbKZJNXvljoo8c4wruWBUNX
         ufziY2bU+jGtfByu9QyAy1styBgpUKrGjqBgXXMkc1+c6748yfmhtD4C8zrGK9zj
         B0jHEOdj3QvrhFMvOup//Xh7MWEWUYhiTIf/2PjR09/cqA0rbc37oxv/pKKXpoyB
         Kt+XMh/ae5A/VG04xmHL4Ys5nHycFaMoKty8Wt9lpc+radQaxU2jTUGX04mrPIus
         4diIMJW1WBwnedz6r1uL4w==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>, Li Nan <linan122@huawei.com>
Subject: [PATCH v5 09/16] md/raid10: fix failfast read error not rescheduled
Date: Tue, 28 Oct 2025 00:04:26 +0900
Message-ID: <20251027150433.18193-10-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251027150433.18193-1-k@mgml.me>
References: <20251027150433.18193-1-k@mgml.me>
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
index 87468113e31a..1dd27b9ef48e 100644
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

