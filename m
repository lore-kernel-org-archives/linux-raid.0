Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839AD3C02;
	Thu, 21 Dec 2023 01:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ze0Un40F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18A4C433C8;
	Thu, 21 Dec 2023 01:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703122056;
	bh=zyNhx7wdd5QSxYbJW/D9WAj4JzwNhV3UubRpnGHAwEU=;
	h=From:To:Cc:Subject:Date:From;
	b=Ze0Un40FSza+ewR/HyaGPiBMv8UBYmJ+Jk2aJgKxKQEpUlyMsiy9IEMZ5RizMBpBg
	 AnuPQbbQDMRO/ZyHmhS79PYvQNjphw3sifS/kuCR49JubPqltXZczqoBq4KEMGYV/q
	 qoqxLHwNveCOCKgho2jzwFun/0XZFRYTzlVZeOMbHyNw/WamNOCcnE1f1int2MT00t
	 WmeNVFPAZk3uQWkcZirI190O6bxjMWYTEhlEUNdQ4FsAFwgQljxOXjtoCdQvgfNLrM
	 8x7AQPL11d0xYQOVq9GrQVMiNlOXPUay0QhRp6arEXtF6z2+SEVHpBYSVlgAyTAB6q
	 3mrMM8sa6yrEA==
From: Song Liu <song@kernel.org>
To: linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: axboe@kernel.dk,
	kent.overstreet@linux.dev,
	janpieter.sollie@edpnet.be,
	colyli@suse.de,
	bagasdotme@gmail.com,
	Song Liu <song@kernel.org>
Subject: [PATCH 0/2] block, md: Better handle REQ_OP_FLUSH
Date: Wed, 20 Dec 2023 17:27:13 -0800
Message-Id: <20231221012715.3048221-1-song@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A recent bug report [1] shows md is handling a flush from bcachefs as read:

bch2_journal_write=>
  submit_bio=>
    ...
    md_handle_request =>
      raid5_make_request =>
        chunk_aligned_read =>
          raid5_read_one_chunk =>
	    ...

It appears md code only checks REQ_PREFLUSH for flush requests, which
doesn't cover all cases. OTOH, op_is_flush() doesn't check REQ_OP_FLUSH
either.

Fix this by:
1) Check REQ_PREFLUSH in op_is_flush();
2) Use op_is_flush() in md code.

Thanks,
Song

[1] https://bugzilla.kernel.org/show_bug.cgi?id=218184

Song Liu (2):
  block: Check REQ_OP_FLUSH in op_is_flush()
  md: Use op_is_flush() to check flush bio

 drivers/md/raid0.c        | 2 +-
 drivers/md/raid1.c        | 2 +-
 drivers/md/raid10.c       | 2 +-
 drivers/md/raid5.c        | 2 +-
 include/linux/blk_types.h | 3 ++-
 5 files changed, 6 insertions(+), 5 deletions(-)

--
2.34.1
