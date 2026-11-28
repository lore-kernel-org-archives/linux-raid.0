Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795839422;
	b=OoJfak/fsXPyscAwZSb5mLvGHJXiqTb04TljSznj3yJvnBqzFpYc1w7YJtuZmB7Mqka2
	 6r+x9bBtvHrNK+hl9Byt4mHc6TYvHL3qEOC9mBuc/N/P5NME5g916yObfp7Sb6ZflJmnd
	 Cu41mJzpY2s3r9WT7qjaUgnEXa9SMagOwJbdgdfWPMkreLlKV6KN0uIHBjCrFvZiRV5Qh
	 eYJsIC0Pr1siGm+9cGKnfclNsmiwmgFWOF92cok4Gr+iPUp7eI3Yo78TephtqOEtRj0ex
	 SJSZo5kR9/FvaJfBn+LR6kgY12Et/Tp9C3tmSqhQYNlKIZ8u/PqE34l0/xVvI9g+TsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795839422;
	h=DMARC-Filter:DKIM-Signature:Date:Mime-Version:Received:
	 X-Lms-Return-Path:Content-Type:Content-Language:Cc:Message-Id:
	 In-Reply-To:X-Original-From:References:To:From:Subject:User-Agent:
	 Content-Transfer-Encoding;
	bh=WUhjeYXeTTEyFoK6xLs581wHEx2G/fmCVns8wNPh6N4=;
	b=wrBkSf7blcg1m3DzkzWA/OHc3OfACvX8zEGhcLh6cx2VfXpmgS7UuVGCuzmaAUhynCfL
	 9R2aUl0lp77A+fJu/5N9gKQtZfXKvwnR+wKsHCCQR/zgo20JjREuu46lNJ+7BZYNHdpPn
	 J+8uYruPKqHtC36Oy0CK4R/lTxkuWY/oCDZgc/QKh+iy/ihCKgim446m9YPhy9xQWswIK
	 Z6af3522J3RdQZ0hXyf5yKXjmlgaEAMSuZU4qNSk3Z0QGyhL6CzTOjBdRCa8ZjAJzbTC7
	 TezyIqJ5SNLZ2vFqUgkAPs9p2CsiZSx/891V3IvGTConVnRSKByhrztCDZySZAi0zYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=h4jwbVIL;
	arc=none smtp.remote-ip=209.127.231.44
Received: from va-2-44.ptr.blmpb.com (va-2-44.ptr.blmpb.com [209.127.231.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982DF606A31C
	for <linux-raid@vger.kernel.org>; Sat, 28 Nov 2026 04:17:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 982DF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=h4jwbVIL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795839417;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=WUhjeYXeTTEyFoK6xLs581wHEx2G/fmCVns8wNPh6N4=;
 b=h4jwbVILf635zFwD2p4VIcMTkQOSZmMyOH7dNgFxBmhNV+I1Zf7RpboH+2UjERVWw0JppY
 qgC8AUbNSq/98k+bItlkmlo/mOYlJFt+c8BLKDMqmDlhzeYXRaeTbJUZrPXYDNq9femODr
 yMTcm+Qc6wnzqMqFMuZx2mvulI6Rpkx9Bm3g1/9ofmbHDNOSgm34Oj62rDCTLcgnM0oEp9
 0Nhazi68mP+yGlUloALHawe9KrRA3bJJuIeeJAjqIH/fcFVokdYNFHU9NLgZYYXI/CfPlu
 lH/WKVHnXyfqE+x4hRRxhbJ7RCMP2qWtS+7ZMLUAWqQqqP8XVhTyvfZkMoHmbQ==
Date: Sat, 28 Nov 2026 12:16:53 +0800
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Received: from [198.18.0.1] ([183.34.192.120]) by smtp.larksuite.com with ESMTPS; Sat, 28 Nov 2026 04:16:55 +0000
X-Lms-Return-Path: <lba+26b0a55b8+32f0a5+vger.kernel.org+chencheng@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <nixiao@fygo.io>, 
	<linux-raid@vger.kernel.org>
Message-Id: <73c3b82d-4066-44ba-9802-ea8c661294e5@fygo.io>
In-Reply-To: <90cdaf01-289f-4d95-ab8f-55fbb5c93155@fygo.io>
X-Original-From: Chen Cheng <chencheng@fygo.io>
References: <20261128040527.3087280-1-chencheng@fygo.io> <90cdaf01-289f-4d95-ab8f-55fbb5c93155@fygo.io>
To: "Song Liu" <song@kernel.org>, "Yu Kuai" <yukuai@fygo.io>
From: "Chen Cheng" <chencheng@fygo.io>
Subject: Re: [PATCH] md: identify array and device in metadata write errors
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: 7bit

chencheng@fygo.io is correct. Please use this submission and disregard 
the earlier one sent from chencheng@fnnas.com. Sorry for the duplicate.

On 2026/11/28 12:11, Chen Cheng wrote:
> Ignore this one please, a apologize for noise because misuse my
> deprecated e-mail address, thanks.
> 
> On 2026/11/28 12:05, Chen Cheng wrote:
>> The error log in super_written() does not show which array or device
>> failed. Add both names to help locate the failed write.
>>
>> Signed-off-by: Chen Cheng <chencheng@fygo.io>
>> ---
>>    drivers/md/md.c | 3 ++-
>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 03e35386a802..5c4c721dbba4 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -1107,11 +1107,12 @@ static void super_written(struct bio *bio)
>>    {
>>    	struct md_rdev *rdev = bio->bi_private;
>>    	struct mddev *mddev = rdev->mddev;
>>    
>>    	if (bio->bi_status) {
>> -		pr_err("md: %s gets error=%d\n", __func__,
>> +		pr_err("md: %s: %pg: %s gets error=%d\n",
>> +		       mdname(mddev), bio->bi_bdev, __func__,
>>    		       blk_status_to_errno(bio->bi_status));
>>    		md_error(mddev, rdev);
>>    		if (!test_bit(Faulty, &rdev->flags)
>>    		    && (bio->bi_opf & MD_FAILFAST)) {
>>    			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
