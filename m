Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503F124A054;
	Mon, 24 Feb 2025 09:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740391025; cv=none; b=I2c9rq7r0z7+ckwP8lfb9kGl9NbzmbPHWDuDnNhmgIheDS9IkYtQkTgweUI2KapQkMdI12xFBlq/nQACydOfjXK8VEmEVPFkZDQmOa9K2YeNy2rBZ+yBNOrGBB0pMYB8CflOGE5C5A2Dwy8BP0+RdjRKA3iJIT9TeyqTa0XBmDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740391025; c=relaxed/simple;
	bh=w0YgVKrRrqyq3WB5LJqdCy80y+/4l0zZSSmJeq9kY8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BKhyB2WERuiioUWfxY55HJKP7B5P6CrxsjlHOaOMMfnjwwhEF7O1boqYRMESVln5D8mRH5bMHgwj3KlIOFl8lTuRvFcFgcgKBSm4WAcbok+joLwFEZWxAS8UFCPIOA0a4ir612nqJoLgLLLEHtpCHC3Z0ZWrRAfbjOvyk2tL+AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S/374Pze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S/374Pze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F968C4CEE6;
	Mon, 24 Feb 2025 09:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740391024;
	bh=w0YgVKrRrqyq3WB5LJqdCy80y+/4l0zZSSmJeq9kY8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S/374PzejpKI2vR+hDuN/rtJADsNlL7nQUGK4fk1OPZeOhCf+7pNb0lCkbzgAOuWC
	 2uDpUBuSfyhYUKuCBN6Boie5H2szyaz9a2uzBKot3hZ7OPEG13hmFWawORMCAxB+1p
	 SEHoRB/gubJwzIb7S9n5dHM7MVSEC6Ay+bsTJl0mTUqLSkJKOXSWWxKDDW+fIo27Zt
	 AKDIiB3dVGVuvYDj8xsOI+fQEAEr2+ETaS5+5543B+SGExhG8gCUN27SwK4VLUj3RO
	 9DYHggMuReFIjwvZi1EV8sFV8em3oKZpNgs+MEh5pdZs/AM8oY2+iph05lvFyRRtD/
	 5zl2lI5zO6MUw==
Date: Mon, 24 Feb 2025 20:26:59 +1030
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH 2/8][next] md/raid5-ppl: Avoid -Wflex-array-member-not-at-end
 warning
Message-ID: <7ceee2968cd7efa74c6a39147b14bb1b3bc3928c.1739957534.git.gustavoars@kernel.org>
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

Change the type of the middle struct member currently causing trouble from
`struct bio` to `struct bio_hdr`.

We also use `container_of()` whenever we need to retrieve a pointer to
the flexible structure `struct bio`, through which we can access the
flexible-array member in it, if necessary.

With these changes fix the following warning:
drivers/md/raid5-ppl.c:153:20: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/md/raid5-ppl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index c0fb335311aa..f4333c644b67 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -150,7 +150,7 @@ struct ppl_io_unit {
 	bool submitted;			/* true if write to log started */
 
 	/* inline bio and its biovec for submitting the iounit */
-	struct bio bio;
+	struct bio_hdr bio;
 	struct bio_vec biovec[PPL_IO_INLINE_BVECS];
 };
 
@@ -250,8 +250,8 @@ static struct ppl_io_unit *ppl_new_iounit(struct ppl_log *log,
 	INIT_LIST_HEAD(&io->stripe_list);
 	atomic_set(&io->pending_stripes, 0);
 	atomic_set(&io->pending_flushes, 0);
-	bio_init(&io->bio, log->rdev->bdev, io->biovec, PPL_IO_INLINE_BVECS,
-		 REQ_OP_WRITE | REQ_FUA);
+	bio_init(container_of(&io->bio, struct bio, __hdr), log->rdev->bdev,
+		 io->biovec, PPL_IO_INLINE_BVECS, REQ_OP_WRITE | REQ_FUA);
 
 	pplhdr = page_address(io->header_page);
 	clear_page(pplhdr);
@@ -430,7 +430,7 @@ static void ppl_submit_iounit(struct ppl_io_unit *io)
 	struct ppl_log *log = io->log;
 	struct ppl_conf *ppl_conf = log->ppl_conf;
 	struct ppl_header *pplhdr = page_address(io->header_page);
-	struct bio *bio = &io->bio;
+	struct bio *bio = container_of(&io->bio, struct bio, __hdr);
 	struct stripe_head *sh;
 	int i;
 
-- 
2.43.0

