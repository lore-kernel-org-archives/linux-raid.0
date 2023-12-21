Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CA41C05;
	Thu, 21 Dec 2023 01:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bLo41GOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCB7C433C7;
	Thu, 21 Dec 2023 01:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703122061;
	bh=UUJDdM6GbP0jIQzY2+5FIimEuIDnsR5/ZNBx17dVitw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLo41GOC2XTmK1t2OLs6qOzNh/HMyvkzqLcQqlnJQH61ob75zjoxVpW0dyF+Iag+v
	 ZlKYgyBlsVJt+fYzoojD4uB6fGutJ8FgIXEugw6gOika542GAfwxdcrRfzOqXQwIFi
	 h64Y6C/YPTC5KS5IEvjsY0gVJlgd0jAE9R3vPjPz5eVPemYibNhTcj6HP0+XSi77V/
	 Eo3aUDgYpYbm61qIY8LRQFNsRc82NTE8pBv50+n7yjADWCrNwLosjRNGx/92Ygguup
	 nXhBlA0jl0FgxcRAvE9X7anY3+IsOuydPZKEgdiRnUkIXMQuvlxaiyOH3Znnf+8m+2
	 LX+mXUBSeesJA==
From: Song Liu <song@kernel.org>
To: linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: axboe@kernel.dk,
	kent.overstreet@linux.dev,
	janpieter.sollie@edpnet.be,
	colyli@suse.de,
	bagasdotme@gmail.com,
	Song Liu <song@kernel.org>
Subject: [PATCH 1/2] block: Check REQ_OP_FLUSH in op_is_flush()
Date: Wed, 20 Dec 2023 17:27:14 -0800
Message-Id: <20231221012715.3048221-2-song@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231221012715.3048221-1-song@kernel.org>
References: <20231221012715.3048221-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Upper layer (fs, etc.) may issue flush with something like:

  bio_reset(bio, bdev, REQ_OP_FLUSH);
  bio->bi_end_io = xxx;
  submit_bio(bio);

op_is_flush(bio->bi_opf) should return true for this bio.

Signed-off-by: Song Liu <song@kernel.org>
---
 include/linux/blk_types.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d5c5e59ddbd2..338423da84ca 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -487,7 +487,8 @@ static inline bool op_is_write(blk_opf_t op)
  */
 static inline bool op_is_flush(blk_opf_t op)
 {
-	return op & (REQ_FUA | REQ_PREFLUSH);
+	return op & (REQ_FUA | REQ_PREFLUSH) ||
+		(op & REQ_OP_MASK) == REQ_OP_FLUSH;
 }
 
 /*
-- 
2.34.1

