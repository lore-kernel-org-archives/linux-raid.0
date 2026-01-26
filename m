Received: from sg-1-14.ptr.blmpb.com (sg-1-14.ptr.blmpb.com [118.26.132.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A57225775
	for <linux-raid@vger.kernel.org>; Mon, 26 Jan 2026 05:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769405912; cv=none; b=itdaK3xfHSZQxulI3db9S+y7SOvWzxP2lqKcJcZtcQYe0juf5Clw1IqE6Uiq+a176UIVsyGwvzyvrqbrlFvuwbw123RzU1pGIWHQZlwjrio2uO9cBh+ylWYhXukCNQnvl9LKq7LfzCgPahGQv08ePDfyJh4io/1EM8Qe7jgPadc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769405912; c=relaxed/simple;
	bh=lTsy52bfPViFcjPIgmRhjEEFnlgqjPhHrDfhA+9IGNE=;
	h=To:Date:References:In-Reply-To:From:Subject:Message-Id:
	 Mime-Version:Content-Type; b=ihKMU8BynCLRTdVVaR5whBGBajrK+DLVqFgdW8Nxys+OXGhdrOrcruv/hqTHuHVUKVSvcC2dTSJZSJ3/eCqxg77WhDVBCP8Ux1IAZdfbR5CJgI5TglyW8XLOMDSC3MdlX4SXFAzEN8jnGyR3XR5uFx+4kdMe+5mYfFoYE2WDoeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=PstrO72q; arc=none smtp.client-ip=118.26.132.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="PstrO72q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1769405893;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=nvzr+Bt8e6PFr2lwZVdqyKlcKLPqmpg2RvisSopX9vU=;
 b=PstrO72qf6wBp+01V0qMXMVLwd0I3oBwRfGc7S1AF+oHlo8/XtVOXE1lSfVOgBW4asbUoR
 did3oi0zZbT6JXN67kyJzSrmTbMCiZYopxg/DzOf0AMgQH3iuhTi69kHCAGomZKSSSVOyX
 FzZ72xV3mnsmiO4u8NiskqWWIhikdsygnCN5OT+ibnRaF0269Dm7J6vaTaJlPxg6hfxJV/
 n/BlxWHZkfbQgAz9qoSl8qRfDJkKZnvbo+hg6ok3ewVpLnnybCtc4HdJ3f15cdJWLFrp+9
 CeT0bnvVct9O4FaE+XGT06/p4L51ghYMm5RY/1WdSS/S0j2baAWDpfn8AAcbQA==
To: "Jiasheng Jiang" <jiashengjiangcool@gmail.com>, 
	"Song Liu" <song@kernel.org>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yukuai@fnnas.com>
Date: Mon, 26 Jan 2026 13:38:08 +0800
User-Agent: Mozilla Thunderbird
Content-Language: en-US
References: <20260117145903.28921-1-jiashengjiangcool@gmail.com>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260117145903.28921-1-jiashengjiangcool@gmail.com>
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+26976fdc3+c46cc8+vger.kernel.org+yukuai@fnnas.com>
Subject: Re: [PATCH] md-cluster: fix NULL pointer dereference in process_metadata_update
Message-Id: <caeed769-26ea-4b16-bc7b-6333739ca63b@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Mon, 26 Jan 2026 13:38:10 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/1/17 22:59, Jiasheng Jiang =E5=86=99=E9=81=93:

> The function process_metadata_update() blindly dereferences the 'thread'
> pointer (acquired via rcu_dereference_protected) within the wait_event()
> macro.
>
> While the code comment states "daemon thread must exist", there is a vali=
d
> race condition window during the MD array startup sequence (md_run):
>
> 1. bitmap_load() is called, which invokes md_cluster_ops->join().
> 2. join() starts the "cluster_recv" thread (recv_daemon).
> 3. At this point, recv_daemon is active and processing messages.
> 4. However, mddev->thread (the main MD thread) is not initialized until
>     later in md_run().
>
> If a METADATA_UPDATED message is received from a remote node during this
> specific window, process_metadata_update() will be called while
> mddev->thread is still NULL, leading to a kernel panic.
>
> To fix this, we must validate the 'thread' pointer. If it is NULL, we
> release the held lock (no_new_dev_lockres) and return early, safely
> ignoring the update request as the array is not yet fully ready to
> process it.
>
> Signed-off-by: Jiasheng Jiang<jiashengjiangcool@gmail.com>
> ---
>   drivers/md/md-cluster.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
Applied to md-7.0

--=20
Thansk,
Kuai
