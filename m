Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF52017A2E6
	for <linux-raid@vger.kernel.org>; Thu, 25 Dec 2025 07:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766648672; cv=none; b=XEMdYuWVf09s/9cm0ZCh6KN3q0S4gUDTLyR4Ybn7BhZuwSnjdKfuUToI0aanLFbPxtDg0MOXgDRdocsQ2HfDCvNihW5mr4QN8pP/7yTYd0LukWePGri5bmrLbl1yz1QY5VAOi5FdKELxc1iAmgQtlWldlOt6XHTVxcwscq+8q64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766648672; c=relaxed/simple;
	bh=Zrf0QB2/b0yEESeceRk8ZOjbIkYx3l/uZkTEUQ1kuis=;
	h=Mime-Version:References:In-Reply-To:Cc:To:Subject:Content-Type:
	 From:Date:Message-Id; b=mI4ybzSgeeJ9ElZmN/xMWWZo+qC9C+AvfKSc/YmCb//OJrUTnuzZ1m4hmygLCjK9MJMOTeRnRAK1mTHmmpkNQbFzatn1ZSWpd8RaQWJ4q9DeAzNgUhA1O+wuWImXErqCdzEIdhs8TLKYyrWkebCi/Waw//cBCG0AvSAiu1n31wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=g113w6Jb; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="g113w6Jb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1766647942;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=IRIRm6MF/GRa9MxRKCJir48PdJsdMGIFNGRBfcL0urI=;
 b=g113w6JbffKQL9rnPhZtMT1PbnT1A3prFwrRzbrrb0tobiOsku385chiqg4r6+qbFk8rI5
 VSe11cIplQZdriy045L6PTXyHZJvcjAaq+Y+j+1s1wtjPco246vspljdf3y6q3r7//eZpE
 9kp7SnIYht6CKspZcMIshcSKgNpIyVf+QGOjjzIegyo2EaMUQXPm43hciZvBdmVQ6Yr2Fg
 foPbjahV5dtprlK5OXkIh+6k2BkG6rLcwngn/lVmZSPddbhZoY8U3/j6J3dfCzC+xrVXON
 OFf/R+qcZBNLMH+We6TNPMJYhwno0SnSGDKIrjDbLs3GMOj+U/eZ4pIJDakKKA==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251124084559.4097567-1-linan666@huaweicloud.com>
In-Reply-To: <20251124084559.4097567-1-linan666@huaweicloud.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>, <yukuai@fnnas.com>
Content-Language: en-US
To: <linan666@huaweicloud.com>, <song@kernel.org>
Subject: Re: [PATCH] md/raid5: Fix a deadlock of reshape and suspend
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Thu, 25 Dec 2025 15:32:19 +0800
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Thu, 25 Dec 2025 15:32:17 +0800
Message-Id: <13706e9e-541a-4c09-b104-2d7272d0a2fa@fnnas.com>
X-Lms-Return-Path: <lba+2694ce884+ad222a+vger.kernel.org+yukuai@fnnas.com>

Hi,

=E5=9C=A8 2025/11/24 16:45, linan666@huaweicloud.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> Commit 868bba54a3bc ("md/raid5: fix a deadlock in the case that reshape i=
s
> interrupted") fixed a raid deadlock of reshape, but a similar issue is hi=
t
> by mdadm test 25raid456-reshape-deadlock.
>
>    INFO: task (udev-worker):63822 blocked for more than 122 seconds.
>          Not tainted 6.18.0-rc2-g0555b5424915-dirty #153
>    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messa=
ge.
>    __schedule
>    schedule
>    schedule_timeout
>    wait_woken
>    raid5_make_request
>    md_handle_request
>    md_submit_bio
>    [...]
>    blkdev_read_iter
>    vfs_read
>    ksys_read
>    __x64_sys_read
>
> It is triggered by:
> 1) normal IO waits for reshape to progress
> 2) user sets ACTION_FROZEN via ioctl
> 3) reshape is interrupted and cannot restart
> 4) users try to suspend array while active IO waits reshape
>
> Following Kuai's previous fix, such IOs should fail in
> make_stripe_request(). Thus, set a timeout for wait_woken() to fix
> the deadlock, and blocked IO will fail in the next cycle.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/raid5.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index cdbc7eba5c54..957e712d2be9 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6185,7 +6185,7 @@ static bool raid5_make_request(struct mddev *mddev,=
 struct bio * bi)
>   			}
>  =20
>   			wait_woken(&wait, TASK_UNINTERRUPTIBLE,
> -				   MAX_SCHEDULE_TIMEOUT);
> +				   msecs_to_jiffies(10000));

Instead of this change to wake up every 10s unconditionally, can you fix th=
is by wake up
synchronously when array is frozen or suspended that reshape can't continue=
.

>   			continue;
>   		}
>  =20

--=20
Thansk,
Kuai
