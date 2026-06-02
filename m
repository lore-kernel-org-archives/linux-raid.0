Received: from va-2-30.ptr.blmpb.com (va-2-30.ptr.blmpb.com [209.127.231.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCD923EAAF
	for <linux-raid@vger.kernel.org>; Tue,  2 Jun 2026 03:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780369647; cv=none; b=nkaqs2o3N8ZN/gIgq7NUygeUAdn75r8T5OspwRjUg08fBtDOxKKHLjx3uTQZZRFPiwBED7Jbwe6G8piX303pymau3qY/YqrQ8MrErVTG9Z7HwPuYflv54BydNTd/PXnNCJvLMRcA71nOZ5FJxZ0xE+oKtlp1A1lKfkSQjtz2jhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780369647; c=relaxed/simple;
	bh=u0F/UiPe/Ds/hTqT1T8FZnOyFdvOY8K67htgUqBwfQ0=;
	h=To:Date:In-Reply-To:Cc:From:References:Subject:Message-Id:
	 Mime-Version:Content-Type; b=ri5J5ML76md4kRAJb1NaIC9nUJ5yUlKSqik0/g3QW4n4xtsCJaGF7cZz5H3vdo21wQRvzNjREGckWl3UnCPdHdJqbwx2SEC0ghV1zLfDLmkqmCKrVO1/pYhI6n7uqBbR3YaDIkGR4Brg94N2t/qD+5Ls0qwcq4/voKZOWBfnY2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=oRpCjy8W; arc=none smtp.client-ip=209.127.231.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="oRpCjy8W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1780369633;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=u0F/UiPe/Ds/hTqT1T8FZnOyFdvOY8K67htgUqBwfQ0=;
 b=oRpCjy8WrxunDH8l6wsgRRbS//U7DcyFZbjGRHGTkXTwJ5bBgNe72NvTLHj+DEZJLn3RVz
 xjQFAAQRltmkeaH6O1R5Y92t/PuUwajUhepVpz0Lm9mpl43ClhM2hho9BwN4qIxDCaq4hz
 0mPXp7PGS886+VFGVhM68+/VXLWabewzf0HVADq1ofMlGDxHZQShmy6PXmSLy4rpJYLEV3
 hqv9jv8M/53sonmkWtnJEENq2w5Epupx0oqVVTxqyearVtsVAObcVOjvt8Ly1fPRzITROU
 ZhA3dx2Y0VGWdC5BLE0adciPBijezzWmttpLGqVDo2G7weTADB9Dd+wzXDxNVA==
To: "Jens Axboe" <axboe@kernel.dk>
Date: Tue, 2 Jun 2026 11:07:08 +0800
Content-Language: en-US
In-Reply-To: <753dfdb4-7d68-4183-af3f-d51e92d4dd31@kernel.dk>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Cc: <linux-raid@vger.kernel.org>, <linux-block@vger.kernel.org>, 
	"Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, 
	"Chen Cheng" <chencheng@fnnas.com>, "Christoph Hellwig" <hch@lst.de>, 
	"Li Nan" <magiclinan@didiglobal.com>, 
	"Thorsten Blum" <thorsten.blum@linux.dev>, <yukuai@fygo.io>
From: "Yu Kuai" <yukuai@fnnas.com>
References: <20260531112618.160409-1-yukuai@fygo.io> <753dfdb4-7d68-4183-af3f-d51e92d4dd31@kernel.dk>
X-Original-From: Yu Kuai <yukuai@fygo.io>
Subject: Re: [GIT PULL] md-7.2-20260531
Message-Id: <07d9a72c-6443-4d48-ae7e-a2dd8237fb39@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.134]) by smtp.feishu.cn with ESMTPS; Tue, 02 Jun 2026 11:07:10 +0800
X-Lms-Return-Path: <lba+26a1e48df+f70d66+vger.kernel.org+yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/6/2 2:55, Jens Axboe =E5=86=99=E9=81=93:
> On 5/31/26 5:26 AM, Yu Kuai wrote:
>> Hi Jens,
>>
>> Please consider pulling the following changes into your for-7.2/block
>> branch.
>>
>> This pull request contains:
>>
>> Bug Fixes:
>> - Only requeue dm-raid bios when dm is suspending. (Benjamin Marzinski)
>> - Reset raid10 read_slot when reusing r10bio for discard. (Chen Cheng)
>> - Fix raid1/raid10 deadlock in read error recovery path. (Abd-Alrhman Ma=
salkhi)
>> - Fix raid1/raid10 error-path detection with md_cloned_bio(). (Abd-Alrhm=
an Masalkhi)
>> - Fix raid1/raid10 bio accounting for split md cloned bios. (Abd-Alrhman=
 Masalkhi)
>> - Fix raid1 nr_pending leak in REQ_ATOMIC bad-block path. (Abd-Alrhman M=
asalkhi)
>>
>> Improvements:
>> - Skip redundant raid_disks updates when the value is unchanged. (Abd-Al=
rhman Masalkhi)
>>
>> Cleanups:
>> - Update MAINTAINERS email addresses. (Yu Kuai, Li Nan)
>> - Clean up raid1 read error handling. (Christoph Hellwig)
>> - Move the exceed_read_errors condition out of fix_read_error(). (Christ=
oph Hellwig)
>> - Use str_plural() in raid0 dump_zones(). (Thorsten Blum)
> Pulled, thanks.
>
> Side note - emails from you with the new email address all end up in
> spam. I just noticed some of them this morning. But I think you want to
> ensure that the DKIM etc part of your email is all kosher, gmail flags
> all of it.

Thanks a lot for the notice, we'll look into this.

>
--=20
Thansk,
Kuai
