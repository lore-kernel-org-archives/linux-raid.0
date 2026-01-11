Received: from va-2-30.ptr.blmpb.com (va-2-30.ptr.blmpb.com [209.127.231.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FE71D5CF2
	for <linux-raid@vger.kernel.org>; Sun, 11 Jan 2026 16:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768148022; cv=none; b=RBqmK5UQ4XnO9UTpeBYdGtKof1k+M9A4WlW50kFAlBgWffLid9L6fV+VOZ1v/6r7TfubFFm15E0kKVkYlqgybKLPJ5blN6Z0Q0pZmRValfjPRw8YYgu82tsyUo2gvGvNBigUfgS6zIFkv4HmW1axBoESm7XsAiDPxV5w9MNNU9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768148022; c=relaxed/simple;
	bh=zhe9BvZPN/wsVfzNGU6GDIgeisaeIozUTV+d742IyJg=;
	h=Message-Id:Content-Type:To:From:References:In-Reply-To:Cc:Subject:
	 Date:Mime-Version; b=nLLtFI2mPlQs2uZrbHHTd29uB/6NJbfj44w9ioXFkaS+yT675ssh+dpCHu7QzcI0kwGEN2S9UBwc5wT6q0KMzPmJtsjqkZJeTKvmjTd4HnNNlMeScYRCn5XLAPI5LKPY3cMiMaIQiLHR4ROGdRq5Z/HiQLrks/orq67RXhPK/cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=KYlgXWQz; arc=none smtp.client-ip=209.127.231.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="KYlgXWQz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768147972;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ZJU5tEJSnchLl4ygOLByJMRXBbr5qOJjRHInuiUKMu0=;
 b=KYlgXWQzl7f2gil6Y/AaQ0oHRMQvBDV4pIsHYXhYP6UYBL/eDUGS0L2w3KU65KsAW1BoWL
 0Ee4APEOz7X2qazVrJwJTOxE4vqq0Fy72WF4ZpR3ZQMBnPZ/Kg+NI1p+6IEx0Z+7qZGSnO
 nVOCc1DA6F+LNekPtxmMY1kbArtu5Vua3Elr+XYHKlI535A2lWvFvRnOeCK7ydpsJ5aMU3
 Zm0dhTXn/gYFcaMhwd3ulfgQJRe4PN2VI2u7xWR9nJTae5XiEXvjJuw0SZLHO/c6t60R+r
 lMi2nImNzivPjHLS3/6MDWD6E92CugDum8UZA0DwhekEE7YgnowcEIz2bOBdww==
Reply-To: yukuai@fnnas.com
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Language: en-US
Message-Id: <dc64a750-1785-482a-964b-d1e590876bc2@fnnas.com>
Content-Type: text/plain; charset=UTF-8
To: "Jiasheng Jiang" <jiashengjiangcool@gmail.com>, 
	"Song Liu" <song@kernel.org>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26963cc02+9b3e71+vger.kernel.org+yukuai@fnnas.com>
References: <20260110221244.14304-1-jiashengjiangcool@gmail.com>
In-Reply-To: <20260110221244.14304-1-jiashengjiangcool@gmail.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md: fix hang in stop_sync_thread by setting THREAD_WAKEUP in md_wakeup_thread_directly
Date: Mon, 12 Jan 2026 00:12:48 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.185]) by smtp.feishu.cn with ESMTPS; Mon, 12 Jan 2026 00:12:49 +0800

Hi,

=E5=9C=A8 2026/1/11 6:12, Jiasheng Jiang =E5=86=99=E9=81=93:
> Analysis of md.c shows that the md_thread() loop relies on the
> THREAD_WAKEUP bit being set to progress beyond wait_event(). However,
> md_wakeup_thread_directly() currently only calls wake_up_process()
> without setting this bit.
>
> As a result, a thread woken by md_wakeup_thread_directly() will find the
> wait condition remains False and immediately return to sleep without
> executing its run() handler. In the case of stop_sync_thread(), this
> causes the sync thread to ignore the interruption request, leading to
> a permanent hang.

This doesn't look correct, md_wakeup_thread_directly() is not used in the
case to start a new md_do_sync() as you described. It's used in the case
that md_do_sync() is already running and stuck somewhere and could be
interrupted by setting MD_RECOVERY_INTR.

>
> Fix this by ensuring the THREAD_WAKEUP bit is set before waking the
> process in md_wakeup_thread_directly().
>
> Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
> ---
>   drivers/md/md.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6d73f6e196a9..8709e9fd7f39 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8512,8 +8512,10 @@ static void md_wakeup_thread_directly(struct md_th=
read __rcu **thread)
>  =20
>   	rcu_read_lock();
>   	t =3D rcu_dereference(*thread);
> -	if (t)
> +	if (t) {
> +		set_bit(THREAD_WAKEUP, &t->flags);
>   		wake_up_process(t->tsk);
> +	}
>   	rcu_read_unlock();
>   }
>  =20

--=20
Thansk,
Kuai
