Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C148438D402
	for <linux-raid@vger.kernel.org>; Mon,  1 Jun 2026 09:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780304613; cv=none; b=kZLtuKdNGTRDN18EXup4vxhO/dHws3B6gprsbK6NaKoOfFvkeSshSxIbZE1MAR0opGYgDMflXflQm8z9cPf53ZOUm1tYjpeC8yoKM+DgNAj6wcwCwcrP1BJpGWhC/0x+Y9sFs7+tnV89tE33UPl4vkubTN3e6H5ay8lQhaElwoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780304613; c=relaxed/simple;
	bh=vD7+fS4n6xxyWC+h2kpZsaWcAegfna/Ovaba2MnAGGs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JlQS7eKsNMoPGOEIrxkUBnj+nHcV4rH/HfFCdHWfI1Mj6C6Y9psL+D1ildYxuZcY7DvRP9D2RtdGp2PcaBd8z0DgziIy6I1r2YzW0NI9i/+8hTgUgVFtpqAC+NNnekLgkFczzLKZJd0nFzUd/V6bzyKoYtOgVLZvl9VWrW8/obo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=okI4E1WV; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="okI4E1WV"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45efa80e0afso1216395f8f.2
        for <linux-raid@vger.kernel.org>; Mon, 01 Jun 2026 02:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780304610; x=1780909410; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=FCD2fd71JEkzJVC0PFR3+O4hOvwrepEdxpDr+tJYldg=;
        b=okI4E1WVz72DCN4fK0BEVPy3+YPcZfMW2tiMhmsekV/fc9Xg8M2mned0wZQsSOtngS
         tg1nzhI0TXw1JrP2MC7BT0tJcPt1Sz9mMz3np2PA8dtiwq4+kpOYVJU6tUS3r/WGYmQW
         +lSNpTQQ0VW2m0wkrMxz7+sz+v4QL2P3zGzTUcnvQJXfW11fmdz2O88XCaXiIaeoWVnT
         5ht6v86Jx6KfbST4LfOss+HD5K94Y7Zl/zTq14gMsiQlOY454devStPCQwksZsji3FUz
         pQ1PDVfN9IHgZXw4JunVd+hcKQfjoYYRwnCpYPdeaQzdgm52T09KVhv804U1RCqZWldK
         Z9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780304610; x=1780909410;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FCD2fd71JEkzJVC0PFR3+O4hOvwrepEdxpDr+tJYldg=;
        b=PUwFBNT2+9IjnwMxjGtXwZ/xyvnaRLigtty+ZPsUPP6KeBsJQPO8fVuKd0YZ5bz+WF
         2yyp5zIkn5epXLPqbGdzZNAqiakB5T71NRc4fb2TWVW8uaqNtz7ceze45AkRAXRYpmDu
         EuycZJISU3m0XXmci/bWxpJNrSfOoT2MYhOvQVm8vXhJ1AACrpRzPv0DKO32j+tzJj9f
         VaCZvtxiPjbRwXOSxtGZQAcq1rVdqWvbZP26vXS81Foi52hPgElBGo52g9gwOhSRCS2r
         3148kFOgdmbnD8fT/UIJ28N2YEiRuFI/+UDWiZqIclkFsnclYhbSRMGkqDhWoTwYdjIk
         2vrg==
X-Gm-Message-State: AOJu0YzuP7asT6dEU9qQHcH8GYKximUtxHuNgAhnacaZo6A7yWmtGS0V
	zjVOwroR+78ulZ+g9mVyI2GbzT7fRdy1aGtkJNebRoGMmhEssOLWM+dv
X-Gm-Gg: Acq92OFuwRMlG76UH2olzI7A23gy7zFf7BWbS2cf+SCVgOCUUkd7J7dMVLOqGB3h94x
	HdopkPffCObVfk6vR0HdcjtecUMqgusgFcwkFdDnN4x31tCaVlT3mkQEDpzVvSjy9G/vRXoCjk+
	NloBtIrdbsXGK1W2lj0ecrpWAATGu1RO9Pb3Xy7O+tj/EJzTR3Wwyq1H5RU3t3p6w7SJQw5JMNl
	xY0whAg6ew23hgM5x6YwwtweLq4msClc9v1lcGAQuv1fjJi7YCuZIuAyvOCALV6IbxtwmnGYnA3
	PhvwMdZZ4+4yVVeiYERVPv9ZJQrin/p7Er6yZrGgyhh3kIINA6eIDDS5m3Ij9o3So6DjylINqHu
	5Le+UcbhPYpShcej7E0XExeagmOfAbLqnMiVW2Iigl9mQ/lDRzelP5TFtiH4J6O3mVQQjXYXaHy
	s7e7u+ED6IlOLcRVMTFm58AySnq1/u+c1DVX4f8kcvyhBlsnx4X4Jk9FYYhNG18Xm83xeH026/M
	8VuHCZ4uqFNnA==
X-Received: by 2002:a05:6000:40cd:b0:439:c18f:5aaf with SMTP id ffacd0b85a97d-45ef6b96607mr17259268f8f.34.1780304609702;
        Mon, 01 Jun 2026 02:03:29 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:60b:2e65:8d3:ed5d:6174:8946])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef356b129sm29754388f8f.32.2026.06.01.02.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 02:03:29 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: John Garry <john.g.garry@oracle.com>, song@kernel.org, yukuai@fnnas.com,
 linan122@huawei.com, martin.petersen@oracle.com, axboe@kernel.dk
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] raid1: fix nr_pending leak in REQ_ATOMIC bad-block
 error path
In-Reply-To: <d9c769f5-19a3-4724-b805-3e2f30541c64@oracle.com>
References: <20260530151411.4119-1-abd.masalkhi@gmail.com>
 <d9c769f5-19a3-4724-b805-3e2f30541c64@oracle.com>
Date: Mon, 01 Jun 2026 11:03:25 +0200
Message-ID: <m2h5nmljj6.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


hi,

Thank you for the feedback.

On Mon, Jun 01, 2026 at 09:43 +0100, John Garry wrote:
> On 30/05/2026 16:14, Abd-Alrhman Masalkhi wrote:
>> In raid1_write_request(), each per-mirror loop iteration begins by
>> incrementing rdev->nr_pending. If a REQ_ATOMIC write encounters a
>> badblock within the requested range, the code jumps to err_handle
>> without dropping the reference taken for the current mirror.
>> 
>> err_handle's cleanup loop will only decrements for k < i and
>> r1_bio->bios[k] is non-NULL. The current slot is therefore skipped,
>> leaving its nr_pending reference leaked permanently. The reference
>> prevents the rdev from ever being removed, since raid1_remove_conf()
>> refuses to remove an rdev with nr_pending > 0.
>> 
>> Fix this by calling rdev_dec_pending() before jumping to err_handle.
>> 
>> Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>
> FWIW,
>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
>
>> ---
>>   drivers/md/raid1.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 181400e147c0..0084bbc24076 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1580,8 +1580,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>>   				 * complexity of supporting that is not worth
>>   				 * the benefit.
>>   				 */
>> -				if (bio->bi_opf & REQ_ATOMIC)
>> +				if (bio->bi_opf & REQ_ATOMIC) {
>> +					rdev_dec_pending(rdev, mddev);
>
> It's not so nice that we have 2x locations that does the 
> rdev_dec_pending work
>

Are you suggesting deferring atomic_inc(&rdev->nr_pending) until after
the if (test_bit(WriteErrorSeen, &rdev->flags)) {..} block? The patch
is already in md-7.2; should I send a separate cleanup patch?

>>   					goto err_handle;
>> +				}
>>   
>>   				good_sectors = first_bad - r1_bio->sector;
>>   				if (good_sectors < max_sectors)
>

-- 
Best Regards,
Abd-Alrhman
