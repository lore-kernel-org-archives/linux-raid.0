Received: from sg-1-22.ptr.blmpb.com (sg-1-22.ptr.blmpb.com [118.26.132.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A6C1A0BD0
	for <linux-raid@vger.kernel.org>; Sat, 27 Dec 2025 02:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766801747; cv=none; b=bVCH2R+OB5aGQNW0MvbqvcDGCsKm5kj5fUhXPJxg1sUfiUoEWtQxUt4tShOxQpsNjOkV4tJiLjz1sF+jaXIylqFozMQsWZtHDjqKP5gi3DGNUYGTgi0EZlxP4e1wO3MRYJ7Oqj8kZHq5CO8P4WHTtkndB1NZQvBrqwhgrmEIkow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766801747; c=relaxed/simple;
	bh=ZFkH7WFCm3YSB1Et+9Nh12Iz2BfjKtALE3yxlP9MnR4=;
	h=References:To:Cc:Message-Id:In-Reply-To:From:Date:Content-Type:
	 Subject:Mime-Version; b=DSNPE42fxYU+/LDDJoGZ1BejxzbV6mwqsB7aV8pMsAGBciRQRZFVPN/VzfKI5RYQWLHpdLt8hVlwicnJ4ca/iwx4914WxjmrVkSSx2Sx4aBFupENau4AMGyv0oJk5yOhMiaVOr2ZViSg6zD4nDQxeF3+JCGiXu1gBfVUgoRyNiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=n8nx2QqB; arc=none smtp.client-ip=118.26.132.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="n8nx2QqB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1766801732;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=9HBRjc76ARzg1TtFIP1lJ2YlFqz4P6+Rwmr5r3LHl3I=;
 b=n8nx2QqBrbXX+/9fs4pFuKNloGnNjTi6SiMtz6By8qyWOaIDOpBJY5l3x8xJQaZjKh8ta2
 3NiYwZ6qllzMRIjnzuUITfDY9DzCccBCnBbWYJSBQ9KZA516WedLZJkkvA4KKIgK3xzUCT
 BClYkcsCpDi8EXXIbKa0ztwh9LWGxnMvjvsSbVk0MbVgdxidebxmjZL0UDqNhpM38icWwl
 /Vu7x0DVg8+weBiDOSDomrd6XABK2bPfywVv68vhnjYTeQxNHMcyMHtb+CTyCwQvekuW2L
 iwDgv+TpPwUqKzZ3rLgdTph91NtKmtJ3+2VudCC+3psXIL8/bPeAM6FrinLp4A==
User-Agent: Mozilla Thunderbird
References: <20251226024221.724201-1-linan666@huaweicloud.com>
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Sat, 27 Dec 2025 10:15:29 +0800
To: <linan666@huaweicloud.com>, <song@kernel.org>, <linan122@huawei.com>, 
	<xni@redhat.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<bugreports61@gmail.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>, 
	<yukuai@fnnas.com>
Message-Id: <950d3456-fd12-4ac9-8a9d-4f81c0b121f6@fnnas.com>
In-Reply-To: <20251226024221.724201-1-linan666@huaweicloud.com>
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
Content-Language: en-US
Date: Sat, 27 Dec 2025 10:15:27 +0800
X-Lms-Return-Path: <lba+2694f4142+9b7425+vger.kernel.org+yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Subject: Re: [PATCH v3 1/2] md: Fix logical_block_size configuration being overwritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

=E5=9C=A8 2025/12/26 10:42, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> In super_1_validate(), mddev->logical_block_size is directly overwritten
> with the value from metadata. This causes the previously configured lbs
> to be lost, making the configuration ineffective. Fix it.
>
> Fixes: 62ed1b582246 ("md: allow configuring logical block size")
> Signed-off-by: Li Nan<linan122@huawei.com>
> Reviewed-by: Yu Kuai<yukuai@fnnas.com>
> ---
>   drivers/md/md.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)

Applied to md-6.19

--=20
Thansk,
Kuai
