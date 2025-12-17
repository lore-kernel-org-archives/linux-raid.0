Received: from sg-1-18.ptr.blmpb.com (sg-1-18.ptr.blmpb.com [118.26.132.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBE733EB11
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 17:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765991527; cv=none; b=tuqipEgP89NricpxLLR3vHCC06a9DgFa94OTslU3mfleElIa0yDRq/FUiXA7bbtu5eJ9RPEcNtSJc3tdvmQyHS07cOvmhV7r7TzpRKPv5me8xHLLA8e06AZeqikRF+jvItnsAh0nIeTk++P7NV+JYZnhXXRMKePm5U+XCsZq3KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765991527; c=relaxed/simple;
	bh=DSjq2RoIyhNvUNFOqu9um+RuSimk6KlrYztstsTZa/4=;
	h=To:From:Subject:Date:In-Reply-To:References:Cc:Content-Type:
	 Message-Id:Mime-Version; b=Za+PphT1yjOKriy9ewTIEe25dS7j/BkkPQo5edFUlApoDKXyplsTfqudw6bx5aOzLpk7KhAvVAMnK3AkaOfAi/ScQOB9cjSCqj9v8NcTZ0nKXlUFv2hJnwNkkazi4ZjLeEDRHFtqJ4KZlz2kR0C7XbSmXeFySK75OYQZwt2xyXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=CYzOzz+q; arc=none smtp.client-ip=118.26.132.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="CYzOzz+q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1765991508;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=0EhvVRObfPvnEE8BjGaWdsdhDKkQN0iEJzYVBn07ElA=;
 b=CYzOzz+q0hcPgi+C4z9DnfxFziTsSHpAmdgfbMlr1K41alTK1jQGxnOTM66W3BdX7wWySi
 wGqoMY7+lGeFXNRxSAmqeVecbVNLRt1O0oyyOoszJQUKX6nsimemM0sYxlBC4XeBMsuL81
 tRFnr4bDgPWsNL4iEk5tjc+fWGQaOrdpy7wSenH8e79woCf8qhzDGUoUhL5VjGcm3RwRbv
 wZU7+wHj11NoYgdaw3Z4zqE4tFbxP5LPsWWEHhGWHxuwZNyGNxnTGowIEtNz4OZIiHcEAJ
 P3pyreTzddtDypG+tdNik19nFe8cQRTmr8zJAvoCF+yCwKnKPe2zVJ75yoFCuA==
To: "Greg KH" <gregkh@linuxfoundation.org>, <linan666@huaweicloud.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH stable/6.18-6.17] md: add check_new_feature module parameter
Date: Thu, 18 Dec 2025 01:11:43 +0800
In-Reply-To: <2025121700-pedicure-reckless-65b9@gregkh>
Reply-To: yukuai@fnnas.com
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
References: <20251217130513.2706844-1-linan666@huaweicloud.com> <2025121700-pedicure-reckless-65b9@gregkh>
Cc: <stable@vger.kernel.org>, <song@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>, <yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26942e452+ffdab0+vger.kernel.org+yukuai@fnnas.com>
Message-Id: <6979cd43-d38c-477d-857c-8d211bc85474@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Thu, 18 Dec 2025 01:11:45 +0800
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2025/12/17 22:04, Greg KH =E5=86=99=E9=81=93:
> On Wed, Dec 17, 2025 at 09:05:13PM +0800, linan666@huaweicloud.com wrote:
>> From: Li Nan <linan122@huawei.com>
>>
>> commit 9c47127a807da3e36ce80f7c83a1134a291fc021 upstream.
>>
>> Raid checks if pad3 is zero when loading superblock from disk. Arrays
>> created with new features may fail to assemble on old kernels as pad3
>> is used.
>>
>> Add module parameter check_new_feature to bypass this check.
> This is a new feature, why does it need to go to stable kernels?
>
> And a module parameter?  Ugh, this isn't the 1990's anymore, this is not
> good and will be a mess over time (think multiple devices...)

Nan didn't mention the background. We won't backport the new feature to sta=
ble
kernels(Although this fix a data lost problem in the case array is created
with disks in different lbs, anyone is interested can do this). However, th=
is
backport is just used to provide a possible solution for user to still asse=
mble
arrays after switching to old LTS kernels when they are using the default l=
bs.

I think this is fine to provide forward compatibility, please let us know i=
f you
do not like this, or Nan should send a new version with explanation.

>
> thanks,
>
> greg k-h
>
--=20
Thansk,
Kuai
