Received: from sg-1-19.ptr.blmpb.com (sg-1-19.ptr.blmpb.com [118.26.132.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A5F208D0
	for <linux-raid@vger.kernel.org>; Sat,  8 Nov 2025 09:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762595693; cv=none; b=BLzfS/qT3kX4S96ofEy8dSOEun/SGosIacTcXWOlpaQTTKzhWczw5XYQylcwHfZXwUY/WbgwRk+Cc0NtdBJa9N/KG5QXbQsYGsnn4y2I+Im7pGUakfNPhffbCDrfl4WNCIQ+fH/aC9KJC47MWRj7Njq/YrQpr5rk/CPWgXpym88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762595693; c=relaxed/simple;
	bh=gJtpFQVARCpd2jkbjp9/8CzXIsyJGDxZBYgAIpSPOug=;
	h=Content-Type:Cc:From:Mime-Version:To:Message-Id:References:
	 Subject:Date:In-Reply-To; b=d3hhQBsOAiRP0DaEjuYYhmx7dKABwjchs0p75dAKWivUGkmJPz5XMAjciZWjDKnwhW2QNvLYRbgIFrZE/9AddtlPkN7nUNU5HttUuQv6LEH5nNbAGSZJEIbKEqOn88xvlchnvxrWrKd04ByyyqH1X4iBjGQg2n34nHsIN2Ud0AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=BKKYXks8; arc=none smtp.client-ip=118.26.132.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="BKKYXks8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1762595561;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ibQZl+yhe25t2tGt0EJxLW64qpRkpA3/K7GI/aHGpZQ=;
 b=BKKYXks8Yht17iNCNx3xTHIqE5hQoSr5y5LCRroUBW6DuzuZtQIeMWYndc+VoMw/MxyhY1
 b6xYGpGDoi3WjdqZM1k0E15GDH97CYQNjLlTwzqLgvD25owdmqlDuL3fVPey02YH4HagCT
 0ZCybrxeMZD4m8ZdSr3Vby03+LP1jOP89jHImwib592SGcwFI/KxP6HtMkGt8pD5oEsh+U
 dq6b3L2zruj2O6v1IB5ARm9pvgCw4rp+d3m8hrm8+dqAODBhwEeX3fNSpEo04hi0uA8JTO
 ajByy69ehPHb73/9Ryjf2W+OXDh5q04PY9CS5N1e3dFTirVYL9ePB9hZkspdcw==
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Sat, 08 Nov 2025 17:52:38 +0800
Content-Type: text/plain; charset=UTF-8
Cc: <song@kernel.org>
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
To: "Xiao Ni" <xni@redhat.com>, <linux-raid@vger.kernel.org>
X-Lms-Return-Path: <lba+2690f12e7+3288e3+vger.kernel.org+yukuai@fnnas.com>
Message-Id: <a5a49131-d692-48d3-9b66-0cce34264279@fnnas.com>
References: <20251029063419.21700-1-xni@redhat.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Subject: Re: [PATCH V2 1/1] md: avoid repeated calls to del_gendisk
Date: Sat, 8 Nov 2025 17:52:37 +0800
In-Reply-To: <20251029063419.21700-1-xni@redhat.com>

=E5=9C=A8 2025/10/29 14:34, Xiao Ni =E5=86=99=E9=81=93:

> here is a uaf problem which is found by case 23rdev-lifetime:
>
> Oops: general protection fault, probably for non-canonical address 0xdead=
000000000122
> RIP: 0010:bdi_unregister+0x4b/0x170
> Call Trace:
>   <TASK>
>   __del_gendisk+0x356/0x3e0
>   mddev_unlock+0x351/0x360
>   rdev_attr_store+0x217/0x280
>   kernfs_fop_write_iter+0x14a/0x210
>   vfs_write+0x29e/0x550
>   ksys_write+0x74/0xf0
>   do_syscall_64+0xbb/0x380
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff5250a177e
>
> The sequence is:
> 1. rdev remove path gets reconfig_mutex
> 2. rdev remove path release reconfig_mutex in mddev_unlock
> 3. md stop calls do_md_stop and sets MD_DELETED
> 4. rdev remove path calls del_gendisk because MD_DELETED is set
> 5. md stop path release reconfig_mutex and calls del_gendisk again
>
> So there is a race condition we should resolve. This patch adds a
> flag MD_DO_DELETE to avoid the race condition.
>
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Signed-off-by: Xiao Ni<xni@redhat.com>
> Suggested-by: Yu Kuai<yukuai@fnnas.com>

Applied to md-6.19
Thanks
