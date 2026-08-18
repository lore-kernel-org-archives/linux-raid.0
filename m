Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DF726AE5
	for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2026 07:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787036834; cv=none; b=Nll5AjjKI7WHuEbfUxUrBHCnp6PtKzQpsrajRJ4bF2ewb2CHLPAtdkctzWLRdOnwZmpnNW+ZOZz58EctEPyZbAihUS/uvgyzqEtFZmB4r57VqecAQsIQFmylIV3zxtYfuMzTis86DJdKV7qI6ofqm0Q7OsOJzfFF5KJbSKxhRjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787036834; c=relaxed/simple;
	bh=7Y324urRghFpYDATbSXCEmmslYVyNpCmAi/8GODA3bo=;
	h=From:Subject:To:Cc:Content-Type:Message-Id:Date:Mime-Version; b=jcV92sqI+W7+T02W9F9fkOmqRTaomcxvdOFs4MZQqIeYgDRMfL+GU77ZSu7mLC6gPjln/nefefUCiAv+W9vuxYKE5OmiSh4i7POgJJTI/lpLGsjmUPECCKd6CIRZOA9UlG/W8KJ75Z6xZgc1bRBVBBz+nq3O9jcLJSuGU9jxTCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=kuEVGqyP; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="kuEVGqyP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1787036819;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=SpAY7MTl0oxwNPGPL4Hgzwur2KmOvhyUR28mBAy0mM8=;
 b=kuEVGqyPnVcVjlFAc9kt2VQVCLijCi7RfsYo/WABYU0Ofm5EdnJYLUw3XfxRw1bMdwm8u8
 CN01shoedvYzCaibKLyLjdho6EGPohwhv/Bykj1DMaOzsl4T8hRRBvxJnsU6w4OR139Kbr
 feRHI/YGPNm7DrmAN08YJw/asxV02RZLa8VgfaZcTKuj+BztGNg+L9YQhnDLVJHgY0VEiq
 uBhjm0tBhcT92RoffaH3V+IbG/oOSwoCTtjg4XiiwPSzdsVeJX4IlKocEKk80/bTSmHK3b
 Cfi8scizVuxAYG6CWyMTcZm8kNd4/8sy1qjd07UpkdEfBdCJxKGTKLQHk40nPw==
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [RFC PATCH 0/5] md/raid1: improve choose_best_rdev read balance
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <xiaon@kernel.org>
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Received: from fedora ([183.34.162.43]) by smtp.feishu.cn with ESMTPS; Tue, 18 Aug 2026 15:06:57 +0800
X-Mailer: git-send-email 2.55.0
Content-Type: text/plain; charset=UTF-8
Message-Id: <20260818070646.1029149-1-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a840492+2a4003+vger.kernel.org+chencheng@fnnas.com>
Date: Tue, 18 Aug 2026 15:06:41 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Original-From: chencheng@fnnas.com

From: Chen Cheng <chencheng@fnnas.com>

Prefer a nonrot disk when one can take the read. When pending is
the same, use a real round-robin among the disks we may pick.

fio libaio direct=1, NVMe none, SATA mq-deadline (stock -> this):

- 2x GM9000: 1M QD16 j1 7.031 -> 13.886 GB/s, 50/50; 4k QD1 50/50
- 2x/3x HDWG740: 0.294 -> 0.514 / 0.630 GB/s
- GM9000+HDD seq: 2.468 or 0.280 -> 7.112 GB/s, 100/0 NVMe
- Fanxiang+HDD seq, HDD first: 0.278 -> 0.562 GB/s
- GM9000+HDD 4k QD8/16: clat -47% / -45%


Chen Cheng (5):
  md/raid1: balance reads across non-rotational disks
  md/raid1: do not move nonrot reads onto a rot disk
  md/raid1: do not send random reads to a rot disk
  md/raid1: use rot policy when no nonrot disk is readable
  md/raid1: clarify choose_best_rdev comments

 drivers/md/raid1.c | 122 ++++++++++++++++++++++++++++++++++++++-------
 drivers/md/raid1.h |   1 +
 2 files changed, 104 insertions(+), 19 deletions(-)

-- 
2.55.0
