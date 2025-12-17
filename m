Received: from sg-1-18.ptr.blmpb.com (sg-1-18.ptr.blmpb.com [118.26.132.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C2D155C97
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 07:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765955880; cv=none; b=LJjL1e64OLUyYXK6pFM49NdvTpVqWDm9us5ipgomcLVado15ZTx9YH+tVvcmDP0JIPsrkI4dIJ+Mv2qgrPf1x6qHCt7LucZpF0QiQXdhg7uC9Hm1VD6xW/3Y+cNZaO9+MvW2LGOm5m2alPRLKpvmfCopC8vPPvr+iu8SDikC4qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765955880; c=relaxed/simple;
	bh=pPBbEkwMbcZrXwJzmOjeqBsrG4Xd3AgbcxDnh2kQjbI=;
	h=In-Reply-To:To:Date:Message-Id:Mime-Version:Content-Type:
	 References:From:Subject; b=K2Q+g5rbm+iMTNOksZEUNNpwzg9UBIcLmp05XR/047aoBznXPXjNwT2jdkwc4VkNZ+S/tWxpsLpDVCARoy/yhIg4BJSo6xAz4UhwmBFatNYM0LzfrF9lbyzYxqBr09TbxfsrTnyOy5bzZFMtDYZhZ44GGej8ta5M57AI9PwRbVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=h8ZzrV1n; arc=none smtp.client-ip=118.26.132.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="h8ZzrV1n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1765955871;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=pPBbEkwMbcZrXwJzmOjeqBsrG4Xd3AgbcxDnh2kQjbI=;
 b=h8ZzrV1nrM7L/0eWJ1Z7aPqFUG6ExXiniAIKg5LmmRdYouAtotWjkwQerqpSBC1NpIF6LX
 eFDMLAV2VNWpCfoJrCLHwfRz2dfTxIdysKXef+VPbd/Lwm7wjL6XUZEZTtNBkL3MIxjreS
 rJs9BKRsDuAdp7NGNYGtE31fa7FFnQ2pHBBbN2neXHJoX3ikdaFnxX89gz77RyGkEPIdQ5
 58rcFt6/4E1Zg98M0jetzUqgYGErG1R06CVcqfPkCKi3vkhoakH2M3HlBOQpft01hqQkxh
 /PhdlP2g4Lv2x67sUgT9Vs1UwATgsUSPINcIR8/uott/RcIlyqwpPxJVk44TAw==
In-Reply-To: <619a9b00-43dd-4897-8bb0-9ff29a760f52@gmail.com>
To: "BugReports" <bugreports61@gmail.com>, <linux-raid@vger.kernel.org>, 
	<linan122@huawei.com>, <xni@redhat.com>, <yukuai@fnnas.com>
Date: Wed, 17 Dec 2025 15:17:45 +0800
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Message-Id: <f20c3a92-d562-4ac2-98b6-39ff4f3e3bbf@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Wed, 17 Dec 2025 15:17:48 +0800
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com> <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com> <619a9b00-43dd-4897-8bb0-9ff29a760f52@gmail.com>
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel 6.19rc1 once
X-Original-From: Yu Kuai <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+26942591d+15afa9+vger.kernel.org+yukuai@fnnas.com>

Hi,

=E5=9C=A8 2025/12/17 15:13, BugReports =E5=86=99=E9=81=93:
>
> ...
>
> We'll have to backport following patch into old kernels to make new=20
> arrays to assemble in old
> kernels.
>
> ....
>
>
> The md array which i am talking about was not created with kernel=20
> 6.19, it was created sometime in 2024.
>
> It was just used in kernel 6.19 and that broke compatibility with my=20
> 6.18 kernel.

I know, I mean any array that is created or assembled in new kernels will n=
ow have
lsb field stored in metadata. This field is not defined in old kernels and =
that's why
array can't assembled in old kernels, due to unknown metadata.

This is what we have to do for new features, and we're planning to avoid th=
e forward
compatibility issue with the above patch that I mentioned.

--=20
Thansk,
Kuai
