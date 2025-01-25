Received: from mail.bonnevilleinformatics.com (mail.bn-i.net [69.92.154.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26E31E7C2B;
	Sat, 25 Jan 2025 01:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=69.92.154.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737768813; cv=none; b=XBSPCocRFaLS4oE+zrKNhrJ2XveBDd3dxGmRxRbTVa/aQpbzUZHSu+LaG1sisnrObC0YA+zySiq/egHOUFRnCxS76s6SDTG2fDZRz2aUS/OS5N4F40IYh1+e3zS84xI0FTSlkbdjYmYHJFi2VV8CY6Ok3v1657kOl7chht9PXHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737768813; c=relaxed/simple;
	bh=kOiDARYbmCGzBtSwW0hw7HsXZ52LJIRPVhc9it4eaTw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tk65D9ZIj+S84IhAg1Ve2IGy509hYop+SAz1byc5KKJCAYFgsX9t1AZSf7lNNDGvVEskYnf6Kn/pXU41TpTVHUrAP06cJP1ZYkbFNvrzuxO0He5Cv2+/hTMqlNzmpCR/A8aAGCfSj8UhnTGCpM97hFS3gjVIKfzTt7zkv4/olOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.net; spf=pass smtp.mailfrom=dougvj.net; dkim=pass (1024-bit key) header.d=dougvj.net header.i=@dougvj.net header.b=L0rlyI/z; arc=none smtp.client-ip=69.92.154.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dougvj.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=dougvj.net header.i=@dougvj.net header.b="L0rlyI/z"
From: Doug V Johnson <dougvj@dougvj.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dougvj.net; s=dkim;
	t=1737768457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/lyccTGQ7mqKDVei63cP+kBivFiAlc8djv7aI8R2xgs=;
	b=L0rlyI/zgItTor2KZD+bvdLTBbnDeBopz2TQQ2i22v+RnHe8r7FJHPOOZaJpEA/IFQJeS0
	hmYX8T2VBP4oxr4k7FX9VMB4N1kaptCRl0ijBB86HTsqyZuccde7Li6HEd5JCMgLuyXvN3
	okqBQ+0zgVZIg9EtteUHlBwO5v9gF3s=
Authentication-Results: mail.bonnevilleinformatics.com;
	auth=pass smtp.mailfrom=dougvj@dougvj.net
To: 
Cc: Doug Johnson <dougvj@gmail.com>,
	Doug V Johnson <dougvj@dougvj.net>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] md/raid5: skip stripes with bad reads during reshape to avoid stall
Date: Fri, 24 Jan 2025 18:26:57 -0700
Message-ID: <20250125012702.18773-1-dougvj@dougvj.net>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: -

While adding an additional drive to a raid6 array, the reshape stalled
at about 13% complete and any I/O operations on the array hung,
creating an effective soft lock. The kernel reported a hung task in
mdXX_reshape thread and I had to use magic sysrq to recover as systemd
hung as well.

I first suspected an issue with one of the underlying block devices and
as precaution I recovered the data in read only mode to a new array, but
it turned out to be in the RAID layer as I was able to recreate the
issue from a superblock dump in sparse files.

After poking around some I discovered that I had somehow propagated the
bad block list to several devices in the array such that a few blocks
were unreable. The bad read reported correctly in userspace during
recovery, but it wasn't obvious that it was from a bad block list
metadata at the time and instead confirmed my bias suspecting hardware
issues

I was able to reproduce the issue with a minimal test case using small
loopback devices. I put a script for this in a github repository:

https://github.com/dougvj/md_badblock_reshape_stall_test

This patch handles bad reads during a reshape by unmarking the
STRIPE_EXPANDING and STRIPE_EXPAND_READY bits effectively skipping the
stripe and then reports the issue in dmesg.

Signed-off-by: Doug V Johnson <dougvj@dougvj.net>
---
 drivers/md/raid5.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5c79429acc64..0ae9ac695d8e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4987,6 +4987,14 @@ static void handle_stripe(struct stripe_head *sh)
 			handle_failed_stripe(conf, sh, &s, disks);
 		if (s.syncing + s.replacing)
 			handle_failed_sync(conf, sh, &s);
+		if (test_bit(STRIPE_EXPANDING, &sh->state)) {
+			pr_warn_ratelimited("md/raid:%s: read error during reshape at %lu",
+					    mdname(conf->mddev),
+					    (unsigned long)sh->sector);
+			/* Abort the current stripe */
+			clear_bit(STRIPE_EXPANDING, &sh->state);
+			clear_bit(STRIPE_EXPAND_READY, &sh->state);
+		}
 	}
 
 	/* Now we check to see if any write operations have recently
-- 
2.48.1

