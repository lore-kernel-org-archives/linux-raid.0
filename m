Received: from sg-1-31.ptr.blmpb.com (sg-1-31.ptr.blmpb.com [118.26.132.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2F6340A47
	for <linux-raid@vger.kernel.org>; Tue, 28 Oct 2025 15:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761665650; cv=none; b=UZFoHCNCwhX/26VlKEzoKxcdyyoxQ2+dOR27Nsyr1HzkzXNd8uuG7C/egR7hohrM2ahSjhQL63fsOVoU4TS54ZtM7XDJZn/7dJBmT6OKE8yeeDxjj4v7DWfiyXD8G8BuyXzzMCHHOoZfOoQ0xw2TQlm1f5+6kkS9EQQr+PQxJko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761665650; c=relaxed/simple;
	bh=4IrSWXZVWE8wX+lS3a6orwuQneA6zfCmRF/jCGyjG+g=;
	h=Cc:From:Mime-Version:References:Subject:To:Message-Id:In-Reply-To:
	 Date:Content-Type; b=D3Zu4Iu45KAv3YnkkS9JkQSs/2KK0MQ7XSEl0LI/8iVIetJOg74TLdVpN1fdS1ltbEJY305+jjSZFfD90bfHdpDNv6VdNq0yToq71ABtu0AFtbjY2hfqgL47L046pRJapQ6qAspJUEBQDXxrbYCz50O3z/mmmdCAAfuPGcSlAIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=w80GL4b9; arc=none smtp.client-ip=118.26.132.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="w80GL4b9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761665636;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=/9s8M9cOsvsYf+nAprefO7yZAEUEoYSVcLqMEourXWE=;
 b=w80GL4b9b3ZXVdLh+zcY8OmLhSpM12cYSYav7PkKMblGQKWB/1xoDGijvzTUxebuvaONCI
 6JIypl/uaEr+Jo5vAMFVc/E7W541ch4Zj80fpehnj49JomI8P6rRXeHg0q4JZ/vE1OhHE1
 3S2biulnLpHnnnM8uDjayr5ReA78+NhEA7J82h3ib++xHbyj3166nMSoB3vck3DkWe+bTl
 81Byro5qN2Uej28RfTyFlGXiv7dzMmIfSqwO4lHgnZHve0RcWKOLYZX+Xp61phUUG4S6eA
 DlyJbpXasGvXbiZrY23Vv5uHxuSZpZpOikmYkSKtRR4y6kR1Vio0nk1ldcE17w==
Reply-To: yukuai@fnnas.com
Cc: <song@kernel.org>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028133737.98300-1-xni@redhat.com>
Subject: Re: [PATCH 1/1] md: avoid repeated calls to del_gendisk
X-Lms-Return-Path: <lba+26900e262+a7c367+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Tue, 28 Oct 2025 23:33:53 +0800
To: "Xiao Ni" <xni@redhat.com>, <linux-raid@vger.kernel.org>
Message-Id: <b1a04060-e49f-4733-8421-ab59217c387b@fnnas.com>
In-Reply-To: <20251028133737.98300-1-xni@redhat.com>
Date: Tue, 28 Oct 2025 23:33:52 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2025/10/28 21:37, Xiao Ni =E5=86=99=E9=81=93:

> There is a uaf problem which is found by case 23rdev-lifetime:
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
> Signed-off-by: Xiao Ni <xni@redhat.com>
> Suggested-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/md.c | 3 ++-
>   drivers/md/md.h | 1 +
>   2 files changed, 3 insertions(+), 1 deletion(-)
>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
