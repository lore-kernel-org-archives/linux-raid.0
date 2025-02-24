Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE69241CA6;
	Mon, 24 Feb 2025 10:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740391249; cv=none; b=gBmHVAenkxEB4umqnao7VTp9AFzRl5zyo6nCU2DvzTXdmAt1MZRca6j6dxkj/uy2r3f0UbUPAH1hugByX2hIVkgUUc551Gtj0GHryCUDpfRdgo17RBkt1nFnJmDu/1/w1HaP0eQFTs709rqEX/T1R7JypfmZopsck5+RQAbJKG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740391249; c=relaxed/simple;
	bh=nChE4LK8cNgAKNxmzM/m4plG3ZITdbtg/Hk1Zy69K6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ch4VyRifY+FaKIvcR5ZCEseop4ljCBw08YWWHiXL99rb+8duROh0D4wIaW+f2EPK86TwlTB5aeENV5734Q5qgrED4A2niFHE9ZBFN2nDu2zIiAKzhpe2yDvjZ3EqHMdqOPkhEyTe27QwCU2gdPrELb62IYjDCRnCaelgNJw/IUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tNpwqWye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tNpwqWye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5F9C4CED6;
	Mon, 24 Feb 2025 10:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740391248;
	bh=nChE4LK8cNgAKNxmzM/m4plG3ZITdbtg/Hk1Zy69K6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tNpwqWyeOKSIcvnb2sWn6XJZqaAc3ytto3eXEQHMclnQYXGJD5BS9/tQHe49QPRGv
	 It8jRM4GUVBE9mzxY1SfL4KF3WWkKz9OFmo3Tfu0qAPPbCK+UQuEBP/ebkduQdu96w
	 GCdJHPnG6pgU8cj//rnP9GANvn2Q0B0FLl59XLbXBtgf+LTzmpJvMgWROsn2ZxnEeE
	 GBnVf8A612NKaE2Q1/Y3CNf3YrgvFGFDynlSGKI51VKCbwQvEJvg1xE5lnW3DOf1r5
	 4KTmC3UrA+JFgJ5uqtiSeQ//wUPj9engBAZc2R9AldwJjpgZAd5gC/jaVEKMNkCqZd
	 zmbwIjLcSMBBw==
Date: Mon, 24 Feb 2025 20:30:45 +1030
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH 7/8][next] md/raid5: Avoid -Wflex-array-member-not-at-end
 warnings
Message-ID: <e6dfc07ceb44da02e9e012114a5ae44e4a9ec3d0.1739957534.git.gustavoars@kernel.org>
References: <cover.1739957534.git.gustavoars@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1739957534.git.gustavoars@kernel.org>

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

Change the type of the middle struct members currently causing trouble
from `struct bio` to `struct bio_hdr`.

We also use `container_of()` whenever we need to retrieve a pointer to
the flexible structure `struct bio`, through which we can access the
flexible-array member in it, if necessary.

With these changes fix 10 of the following warnings:

drivers/md/raid5.h:262:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/md/raid5.h:262:38: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/md/raid5.c | 10 +++++-----
 drivers/md/raid5.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5c79429acc64..76981d8cbc5d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1178,8 +1178,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 again:
 		dev = &sh->dev[i];
-		bi = &dev->req;
-		rbi = &dev->rreq; /* For writing to replacement */
+		bi = container_of(&dev->req, struct bio, __hdr);
+		rbi = container_of(&dev->rreq, struct bio, __hdr); /* For writing to replacement */
 
 		rdev = conf->disks[i].rdev;
 		rrdev = conf->disks[i].replacement;
@@ -2720,7 +2720,7 @@ static void raid5_end_read_request(struct bio * bi)
 	sector_t s;
 
 	for (i=0 ; i<disks; i++)
-		if (bi == &sh->dev[i].req)
+		if (bi == container_of(&sh->dev[i].req, struct bio, __hdr))
 			break;
 
 	pr_debug("end_read_request %llu/%d, count: %d, error %d.\n",
@@ -2848,11 +2848,11 @@ static void raid5_end_write_request(struct bio *bi)
 	int replacement = 0;
 
 	for (i = 0 ; i < disks; i++) {
-		if (bi == &sh->dev[i].req) {
+		if (bi == container_of(&sh->dev[i].req, struct bio, __hdr)) {
 			rdev = conf->disks[i].rdev;
 			break;
 		}
-		if (bi == &sh->dev[i].rreq) {
+		if (bi == container_of(&sh->dev[i].rreq, struct bio, __hdr)) {
 			rdev = conf->disks[i].replacement;
 			if (rdev)
 				replacement = 1;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index eafc6e9ed6ee..3df59302e953 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -259,7 +259,7 @@ struct stripe_head {
 		/* rreq and rvec are used for the replacement device when
 		 * writing data to both devices.
 		 */
-		struct bio	req, rreq;
+		struct bio_hdr	req, rreq;
 		struct bio_vec	vec, rvec;
 		struct page	*page, *orig_page;
 		unsigned int    offset;     /* offset of the page */
-- 
2.43.0

