Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0789422D4DD;
	Fri, 19 Sep 2025 01:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758245847; cv=pass; b=YgrpJLk0Mr7fJmlqa0x0QSLMgNGl+0BO/BxWxJmR4gNoNvDqopvLbl0ccMq7OHLDA0qM7he0TiCciUL2QTk2T3nCcXWWIuxeb0UAHspahdqJfinx2zvoJLmrvZrDkW2//WAdp9nI4SqupX/I1jYO1nBHPVGnXfZFHpSQ9nwz3J8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758245847; c=relaxed/simple;
	bh=AU6icGqFjD454HFB3uJtjBWkANK1+uaD/jOLk3X0/UI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V4OQQCO0hg+GSc51b/6ADeJkz7ib4gyXZQIU4kac8W7+hDruGr3Ae4EMYj0CNX6HyYg2ZzJMPwlCa+IWnQZjRTd3Q8SuI5je0R8f5Phsi8GpqXP5LI9Zs0ltHXdPhNvG0JqTolPD6lLFani8R7pLURPDEizOckdFtNOaIm5p+rM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=yukuai.org.cn; spf=pass smtp.mailfrom=yukuai.org.cn; dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b=ayF5ksR6; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b="ayF5ksR6"
ARC-Seal: i=1; a=rsa-sha256; t=1758245817; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Bp2d0L+QsDaUQQc3xzaYanRUgAcCJFx8dR2+NYZpv2zDDn+fpEHq5+dsfxaBV747e6weq32sl8VxV0ddyJSsqnnpneBUOM9FDJyzh7jceoKHmutB/csFiWv0rnmGSR1uIb0WySCplx+WA8/P76UjoE1BhSpkA17xhPsNUtcG7iI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1758245817; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Jwoy6Md55EywMO/Hx3ugz1OtoswgEHnjt/ozxWWF0pU=; 
	b=haq6V5Y1wn8vMW7g9VQkOxVaWUfXWT5XSNbqDeQc5Eg4NCvFAluO4N6K8YnVA9H5hrW1FbqIOR2sibUcU73lk35ZuYBaHD5Rw7qI0yl7ppK3v/Y16TOA67mBaAB0gRWHwuKblzBOP7FW1KG0wEJZVFk78HzwrSuxyq+zQ6/C4Kk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=yukuai.org.cn;
	spf=pass  smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=pass header.from=<hailan@yukuai.org.cn>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1758245817;
	s=zmail; d=yukuai.org.cn; i=hailan@yukuai.org.cn;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Jwoy6Md55EywMO/Hx3ugz1OtoswgEHnjt/ozxWWF0pU=;
	b=ayF5ksR6l3bjCvJWN1X3y0Fw1Sz2KghgPv1mAGy7UWxIYsTi19mYi9MzQJBqTkIN
	9M22y/9dLkpyRuoC4Fi6Zwc7puAR0A2HkxsbCFNV1RRzdp3LeGA+iDoZ3Cu/HYwOphW
	bo0Om4EnGvvuSUZlum/leggKXA3hhgcXtDy9MBEs=
Received: by mx.zohomail.com with SMTPS id 175824581381954.119581983356284;
	Thu, 18 Sep 2025 18:36:53 -0700 (PDT)
Message-ID: <6ce45082-2913-4ca2-b382-5beff6a799c6@yukuai.org.cn>
Date: Fri, 19 Sep 2025 09:36:48 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/9] md/raid1,raid10: Don't set MD_BROKEN on failfast
 bio failure
To: Kenta Akagi <k@mgml.me>, yukuai1@huaweicloud.com, song@kernel.org,
 mtkaczyk@kernel.org, shli@fb.com, jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yukuai3@huawei.com
References: <010601995d6b88a4-423a9b3c-3790-4d65-86a4-20a9ddea0686-000000@ap-northeast-1.amazonses.com>
From: Yu Kuai <hailan@yukuai.org.cn>
In-Reply-To: <010601995d6b88a4-423a9b3c-3790-4d65-86a4-20a9ddea0686-000000@ap-northeast-1.amazonses.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Hi,

在 2025/9/18 23:22, Kenta Akagi 写道:
>>> @@ -470,7 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
>>>                (bio->bi_opf & MD_FAILFAST) &&
>>>                /* We never try FailFast to WriteMostly devices */
>>>                !test_bit(WriteMostly, &rdev->flags)) {
>>> -            md_error(r1_bio->mddev, rdev);
>>> +            md_bio_failure_error(r1_bio->mddev, rdev, bio);
>>>            }
>> Can following check of faulty replaced with return value?
> In the case where raid1_end_write_request is called for a non-failfast IO,
> and the rdev has already been marked Faulty by another bio, it must not retry too.
> I think it would be simpler not to use a return value here.

You can just add Faulty check inside md_bio_failure_error() as well, and both
failfast and writemostly check.

Thanks,
Kuai


