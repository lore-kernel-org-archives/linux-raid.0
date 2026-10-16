Received: from a27-52.smtp-out.us-west-2.amazonses.com (a27-52.smtp-out.us-west-2.amazonses.com [54.240.27.52])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEB138DD3;
	Fri, 16 Oct 2026 04:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.27.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124745; cv=none; b=ULU7QWaQ/vyUkFjFVaRVGkdHWJ2vcoxqjeXOSnh0iobiTpt23kGbTeTKwI/Rn5xUMgcQmGTukt8c1+TUHsmuYoHsTda29zKYUzHgEujpTQO3f01RwuIBTHogGSHNSWOBrIIG46znRY7/dgP21elR7ZrhAs4dyYBZP0UJmN/SYDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124745; c=relaxed/simple;
	bh=/ssxF5HvQo6gEw10H7jK5yS8w/E6a/FwNZ5ElsLQyLg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cZjGO6rTx4SycBrmygPTeNBVR/CoDqtllOQAYt3Z9ZBMvaWMQW7DL3So0srCYYT0SpWjRvSqXLOppHpjqWOAuPhDyM3tuxuWoE/twNLAAkJp6FC6I+cfMQ1Cgl6AVBW/0sSSr30IxwmB3I8nDVKw/i8T83gpZWZWwulSAxL9cRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.me; spf=pass smtp.mailfrom=bounce.dougvj.me; dkim=pass (2048-bit key) header.d=dougvj.me header.i=@dougvj.me header.b=a/ZOJX/J; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=W8HOIU0H; arc=none smtp.client-ip=54.240.27.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.dougvj.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dougvj.me header.i=@dougvj.me header.b="a/ZOJX/J";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="W8HOIU0H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=75cpmoop2pyf56gdndy2e364ijbokrge; d=dougvj.me; t=1792124744;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding;
	bh=/ssxF5HvQo6gEw10H7jK5yS8w/E6a/FwNZ5ElsLQyLg=;
	b=a/ZOJX/JfXbMMcZ2VV0ZO+Y6els0ktiJMVJVnyzk0D+hA6B3i3838BaYh+ieg2jn
	3DbKCNQxMscNvZVFHu5xEsStnh/LVJwUAxFUiDtRz9jxHy6x2L2vH6lqK4AAKrWa+Ig
	o60pSzio+3AJNFNm24YGWq3YSsuHxh0GBwC/PkjuQKFZ+IqdvVigYLjPJFvRFX1ZKmL
	VbkzgdOnXmntWQxr3GJTeZXwRzc/dr/PqiNlOXgRG6aeWaLdK3Y1YltAFy7soM5GQy9
	rwARL1l4mZw8mzb340GRaM0SbGnClzZ/BnjMM1kAzY9ZtEKZhXulRZ8LZpBasL3s3eK
	DnDh4jtmmQ==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1792124744;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
	bh=/ssxF5HvQo6gEw10H7jK5yS8w/E6a/FwNZ5ElsLQyLg=;
	b=W8HOIU0HLkb8Ut0W8P8NdN1ckQXZLrOUT35Gwy4rGJaUXBDfghdz+DZ1YXlzNmBh
	ZbiD51HLSrZGyV75EOd7rdlUfSEYBpIDq9tbwIfaLIArYiNAy2SOcdijJCL8Rc4X7ph
	i/JRebt4mRadnCuagfvHhRr7mkqNbG0ngWWnJqT8=
From: Doug V Johnson <me@dougvj.me>
Authentication-Results: mail.bonnevilleinformatics.com;
	auth=pass smtp.mailfrom=me@dougvj.me
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai@fygo.io, magiclinan@didiglobal.com, 
	xiao@kernel.org, chencheng@fnnas.com, linux-kernel@vger.kernel.org, 
	Doug Johnson <me@dougvj.me>
Subject: [PATCH v4 0/3] md/raid5: freeze and interrupt reshape when handling failed reshape
Date: Fri, 16 Oct 2026 04:25:43 +0000
Message-ID: <010101a142f570d2-8a719acb-e1b2-4d74-82f8-b2138eab84da-000000@us-west-2.amazonses.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: -
Feedback-ID: ::1.us-west-2.yIAaOWcA3P0r3CWRzBxY2mlnWgm/DtEO6k5/iZ9ogRk=:AmazonSES
X-SES-Outgoing: 2026.10.16-54.240.27.52

From: Doug Johnson <me@dougvj.me>

Some time ago I had a RAID6 array reshape stall on me creating a hung
kernel thread that I couldn't recover from without a magic SysRq. I
was able to reproduce the issue with a test case:

https://github.com/dougvj/md_badblock_reshape_stall_test

A patch was recently merged that stopped the kernel stall:

Commit 788e4139463f ("md/raid5: fix reshape deadlock while
failed devices more than max degraded"), by Chen Cheng:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=788e4139463f74b945600237f7186411015d996e

Submission and review:
https://lists.openwall.net/linux-kernel/2026/07/11/656

In v3 of this patch series, I had similar reshape failure handling,
but Chen's approach was more correct. However, it doesn't account for
reshape failures that occur even when all devices are active and in
sync, such as when there are more bad blocks in a stripe than can be
recovered at a given RAID level.

I have a test fixture for this published here:

Link: https://github.com/dougvj/md-raid-reshape-badblock-corruption-test

This clearly demonstrates that there are still gaps in handling
unrecoverable reads during a reshape.

In this patch series the gaps are addressed:

1. If an unrecoverable read failure occurs during the reshape, stop the
   reshape using Chen's approach but always mark the reshape frozen
   and interrupted to improve array recoverability conditions in the
   case where devices are online but still produce unrecoverable reads.

2. Detection of known bad read conditions from bad block metadata before
   starting a reshape to prevent starting a reshape that will fail.

3. Additional kernel logging for bad block metadata paths for improved
   cause tracing.

With these 3 changes, this unusual situation is significantly mitigated.

Claude Opus 4.6 was used early 2026 to assist with the sweep overlap
logic.  Codex GPT-6.1-Sol assisted with the upstream rebase, preflight
implementation, regression analysis, QEMU fixtures, testing, and patch
preparation.  Claude Fable 5.1 reviewed the series at medium effort;
its findings prompted targeted reproductions and the degraded-member
correction.

I wrote the prose in the code and commits, except for the schematic
example in patch 1, which Codex helped draft. Codex also assisted
with the citations and this disclosure. GPT-6 Astra independently
reviewed the series with an isolated context.

Assisted-by: LLM

Doug V Johnson (3):
  md/raid5: freeze and interrupt reshape when handling failed reshape
  md/raid5: do not reshape if overlapping rdev bad block ranges prevent
    it
  md/raid5: warn when a read fails due in some part to bad-block
    metadata

 drivers/md/raid5.c | 108 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.h |   2 +-
 2 files changed, 109 insertions(+), 1 deletion(-)


base-commit: 4056b3c9d3c92ea45955641dbafeb9b960e146ef
-- 
2.54.0

