Received: from sg-1-21.ptr.blmpb.com (sg-1-21.ptr.blmpb.com [118.26.132.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FCD2C21FA
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 10:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767435411; cv=none; b=ZVVjsmA+SYQ3TdiD7Ht/7bSj/NfN9SDoB+dyxeunDf8MMFYrM3zuNdtsglU1uwsZPiRon1g5zL5z5W6A1Mx0dHyilC7okECtdUoxwZs5vSbn6mIyBvYWa/hstFd9M2bIYPenYbIQPpJqcgAsxlDEl64e1m+3YOuei3NrQBgqv/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767435411; c=relaxed/simple;
	bh=wq047bQiQ03vK7mRehCDe85GQJrZXbt01AwAEcnGvD0=;
	h=To:Mime-Version:Date:Cc:In-Reply-To:References:From:Subject:
	 Message-Id:Content-Type; b=SKTJhPAUGNDbVvmSDgGFKtojMN/jBpTJ4SghqFVwgkwzpwc6FLQo2U++4H8rqO0eybFiyEw3punMr8Z7kMYZ312/Yudgq04/V2U3y6ZoXk9tN+ruEoAaDCJ/V8B9fSiUsHh5fmGTjH/hGdiFcxXSjoCKi4wGyyRBKINerdzauqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=utw2K22d; arc=none smtp.client-ip=118.26.132.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="utw2K22d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1767435397;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ttrXzVqnnxfx/9QpP5aFDC5a/F1wQXnIvCFlYBDLVbA=;
 b=utw2K22daw+0Z940V3lxg5bfS96CA4WHT2a7hrc2DTC1aFfeRO5ngbSHcNhlKVIh9xCDt6
 7PJC3aG+cXSZpRYat3aQo1T5RgSHz3lrgFJAXCO5O8UZDuoxAeTyA9jk10xQikmIap++Mc
 VmddSNFrj8s++xPtuXAszma6f+NUku5h7G72qxOm1CS/PHnzmeN8689V4xWzYUxLMYoqs6
 HMx89BL3Xq4U6oRjNtLhIaR/2QY5EVK+FgmH0Xh4k57NMoXeMmJ7ZExBfJREZAtaUMCpLP
 2JqvjuJYwDdiPHGLxm0E4zRSPpuc8Tgd1io04vcger3/UEwG+ai6DdOiNa3FRg==
To: <linan666@huaweicloud.com>, <song@kernel.org>, <neil@brown.name>, 
	<namhyung@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Date: Sat, 3 Jan 2026 18:16:32 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<k@mgml.me>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>, 
	<yukuai@fnnas.com>
In-Reply-To: <e429dabc-8f93-44a2-9024-1d9c669ef800@fnnas.com>
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.186]) by smtp.feishu.cn with ESMTPS; Sat, 03 Jan 2026 18:16:35 +0800
References: <20251215030444.1318434-1-linan666@huaweicloud.com> <20251215030444.1318434-4-linan666@huaweicloud.com> <e429dabc-8f93-44a2-9024-1d9c669ef800@fnnas.com>
Content-Language: en-US
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v3 03/13] md/raid1,raid10: return actual write status in narrow_write_error
Message-Id: <b4abf0b4-6df2-442e-8549-a409cd24e989@fnnas.com>
X-Lms-Return-Path: <lba+26958ec83+0bbaec+vger.kernel.org+yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/1/3 17:37, Yu Kuai =E5=86=99=E9=81=93:
> Hi,
>
> =E5=9C=A8 2025/12/15 11:04, linan666@huaweicloud.com =E5=86=99=E9=81=93:
>> From: Li Nan <linan122@huawei.com>
>>
>> narrow_write_error() currently returns true when setting badblocks fails=
.

I think you mean rewrite failed and set badblocks succeed.

>> Instead, return actual status of all retried writes, succeeding only whe=
n
>> all retried writes complete successfully. This gives upper layers accura=
te
>> information about write outcomes.
>>
>> When setting badblocks fails, mark the device as faulty and return at on=
ce.
>> No need to continue processing remaining sections in such cases.
>>
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>    drivers/md/raid1.c  | 17 +++++++++--------
>>    drivers/md/raid10.c | 15 +++++++++------
>>    2 files changed, 18 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 90ad9455f74a..9ffa3ab0fdcc 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -2541,11 +2541,15 @@ static bool narrow_write_error(struct r1bio *r1_=
bio, int i)
>>    		bio_trim(wbio, sector - r1_bio->sector, sectors);
>>    		wbio->bi_iter.bi_sector +=3D rdev->data_offset;
>>   =20
>> -		if (submit_bio_wait(wbio) < 0)
>> +		if (submit_bio_wait(wbio)) {
>>    			/* failure! */
>> -			ok =3D rdev_set_badblocks(rdev, sector,
>> -						sectors, 0)
>> -				&& ok;
>> +			ok =3D false;
>> +			if (!rdev_set_badblocks(rdev, sector, sectors, 0)) {
>> +				md_error(mddev, rdev);
>> +				bio_put(wbio);
>> +				break;
>> +			}
>> +		}
>>   =20
>>    		bio_put(wbio);
>>    		sect_to_write -=3D sectors;
>> @@ -2596,10 +2600,7 @@ static void handle_write_finished(struct r1conf *=
conf, struct r1bio *r1_bio)
>>    			 * errors.
>>    			 */
>>    			fail =3D true;
>> -			if (!narrow_write_error(r1_bio, m))
>> -				md_error(conf->mddev,
>> -					 conf->mirrors[m].rdev);
>> -				/* an I/O failed, we can't clear the bitmap */
>> +			narrow_write_error(r1_bio, m);
> I remembered that I said please change this helper to void.

take a look back after patch 4, I still think this should be void.

>
>>    			rdev_dec_pending(conf->mirrors[m].rdev,
>>    					 conf->mddev);
>>    		}
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 40c31c00dc60..21a347c4829b 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -2820,11 +2820,15 @@ static bool narrow_write_error(struct r10bio *r1=
0_bio, int i)
>>    				   choose_data_offset(r10_bio, rdev);
>>    		wbio->bi_opf =3D REQ_OP_WRITE;
>>   =20
>> -		if (submit_bio_wait(wbio) < 0)
>> +		if (submit_bio_wait(wbio)) {
>>    			/* Failure! */
>> -			ok =3D rdev_set_badblocks(rdev, wsector,
>> -						sectors, 0)
>> -				&& ok;
>> +			ok =3D false;
>> +			if (!rdev_set_badblocks(rdev, wsector, sectors, 0)) {
>> +				md_error(mddev, rdev);
>> +				bio_put(wbio);
>> +				break;
>> +			}
>> +		}
>>   =20
>>    		bio_put(wbio);
>>    		sect_to_write -=3D sectors;
>> @@ -2936,8 +2940,7 @@ static void handle_write_completed(struct r10conf =
*conf, struct r10bio *r10_bio)
>>    				rdev_dec_pending(rdev, conf->mddev);
>>    			} else if (bio !=3D NULL && bio->bi_status) {
>>    				fail =3D true;
>> -				if (!narrow_write_error(r10_bio, m))
>> -					md_error(conf->mddev, rdev);
>> +				narrow_write_error(r10_bio, m);
>>    				rdev_dec_pending(rdev, conf->mddev);
>>    			}
>>    			bio =3D r10_bio->devs[m].repl_bio;

--=20
Thansk,
Kuai
