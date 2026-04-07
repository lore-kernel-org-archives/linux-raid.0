Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4576379EE8
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 05:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775539624; cv=none; b=EpZvmtJZNIQo3HfqYorRkJKCf8qqfVXzpldYdXnjPGT4DAnhIHRstZ3alBs/87J9deMiEARkrxpoP5XlaWnVeHjv2CFWmjbzyXNXFYYy2lCHegArQxsUbFgd7kTIabXQXpuc/ufXFVXkrJfiPGVhcclKQ8afN7JsiLwbV3f8JBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775539624; c=relaxed/simple;
	bh=tJUwQFXKRHdidzMYapx82VwTqpXdsNWekTey3su8BPk=;
	h=From:Content-Type:Message-Id:In-Reply-To:Subject:Date:
	 Mime-Version:To:References; b=Shhocs5xVFCXSPUj5aqyH/RHtxQiymeXvcSkG7RoMmyYjZm3YxeZLUBeWEMLjR9xSDt5MDcnJxVzj985pwz2c7DEKM1kJW4qeRDixeB1lmzhsVEZDz6l5CYIGomg9UW36ANHnnaZjROJxD/v2o1AEy+RpuWGgI8xbLlci+D4Z6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=SjVOH7CR; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="SjVOH7CR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775539612;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=wVuCmfrGLUirAw/owG7lMqw/Apu+au6oyArF2rwEg2c=;
 b=SjVOH7CREFAG4ub3heUciol0/DVQlYfLg13eP+xCAA/VdmvaEdg987hGWQolHXpQZfsQUN
 mVxF5rIzUs4fToKP28cMlzAwIKMjWaX4lz8RAiA16J7B7g1kRys4pa/7dGzcT3x8h4j5ln
 O0iitKetewkii/E56Uxx2nH0MdbIsuw1zLTO6Q6VCwBKjB7upmB1hQ+Ped9t+cCxhPcowR
 sPyEScOMqf6H4poiOw75nzysJeeZBxt7qQ6fkIaryf6kIJi9F8j5GITf8npeMhcLJ8EcRy
 CnRMfPLiCyUkz8x+gM0vYsPHuedlVUxYGdrW/wtvKXcPUZG/bIjIJNbiF8e5nA==
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.129]) by smtp.feishu.cn with ESMTPS; Tue, 07 Apr 2026 13:26:49 +0800
Content-Language: en-US
Message-Id: <86da2304-406c-40cd-82ab-06f604f46a47@fnnas.com>
X-Lms-Return-Path: <lba+269d4959a+49ed76+vger.kernel.org+yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260328193522.3624-1-abd.masalkhi@gmail.com>
Subject: Re: [PATCH] md: remove unused static md_wq workqueue
Date: Tue, 7 Apr 2026 13:26:47 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Original-From: Yu Kuai <yukuai@fnnas.com>
References: <20260328193522.3624-1-abd.masalkhi@gmail.com>

=E5=9C=A8 2026/3/29 3:35, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> The md_wq workqueue is defined as static and initialized in md_init(),
> but it is not used anywhere within md.c.
>
> All asynchronous and deferred work in this file is handled via
> md_misc_wq or dedicated md threads.
>
> Fixes: b75197e86e6d3 ("md: Remove flush handling")
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
> ---
>   drivers/md/md.c | 8 --------
>   1 file changed, 8 deletions(-)
Applied to md-7.1

--=20
Thansk,
Kuai
