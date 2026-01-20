Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CBA3314AE
	for <linux-raid@vger.kernel.org>; Tue, 20 Jan 2026 03:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768880342; cv=none; b=K/xFdxTr5weQcusIna35Q5po9DXivJqovLKZcFI2KrwJFxRE4t0vKYaxZ8bnVwYwL10irn9BvQ8GxZJuup7xDvqlx/mn7cUmiXvfcISYSITdRQF7R1IF9jnnSrfEvx9s1oFbe1qVUmhlJBlM/5eyDeyPnqlAeHtH8qs212JlHXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768880342; c=relaxed/simple;
	bh=PkOqAkOQqiZN490He9aCUNJHgNa47/cWd8G+ulsnHSE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=dyCh8+2UDy+BKRj66BGa9/dnxnuHJ9EfbyHKi5vFysVNF+GUg8X45x5o0fLcUfaumBBMeBMzMj5pO7OJ3h3GVQO/sB5oRUbMTvsOHiuloyFTaLn/bYpuOKzyc0zYvmAuZdE/7HJaKCA5HA5fNH2CXz5AJ5KG3n+3vHSVxQM+Qpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c56VIhLt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VN2XY2fE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c56VIhLt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VN2XY2fE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768880339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uNQX2q8xw+A15ZGW/8chYOaYRaybot2NtFtiikg5Gf0=;
	b=c56VIhLtuVW44TBTPunWIEWp0KALIE+CVI9JrHhfDAnIAIwusBd+bWyJ0IAuC/PNVZNtLW
	c5qNj94kJxT0rJqo+z5HjQMHwkrXm22gzyjI4dOfiQH4XhthKCxRpuBwO6fI+6Mhw/l9cz
	1NssbEeKFQ6ttEE4GI0fhyHbD92DGdQ=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-152-4nP2KnmbMZmDUD7Ot-5z2Q-1; Mon, 19 Jan 2026 22:38:57 -0500
X-MC-Unique: 4nP2KnmbMZmDUD7Ot-5z2Q-1
X-Mimecast-MFC-AGG-ID: 4nP2KnmbMZmDUD7Ot-5z2Q_1768880336
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c52d37d346fso2633918a12.0
        for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 19:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768880336; x=1769485136; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uNQX2q8xw+A15ZGW/8chYOaYRaybot2NtFtiikg5Gf0=;
        b=VN2XY2fE9yANylbo85zAIo1PjE6GPF8vz/u/A+wBWVHdzyiouvPnlCSZtYd52zP0sN
         TkgbcR9BuiSrC1NQXxRD132lmoRzFu2kp+9Xu0kMIcqj+QzWlasuI4bjcFTtQkHLDDah
         ocTJI9aqRVc82ygM6a5RwGHgttFrlMAGVS7JGMf6zCWICPm15YpBUts1w+nGJDnn1pQ+
         VgmZIzgFHaxWHp0Ejo2FKauLu4aUMBi/sNTHMsYUHe2WipUlR36UnMv82kDYNUM0jbJX
         yDCYc4a2Lxd4HP/tNdjQK8A0GurhYYaDEJ8jHRAht9Ua6aTc1qLSV1nnCx5BSLzGR39d
         EBlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768880336; x=1769485136;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uNQX2q8xw+A15ZGW/8chYOaYRaybot2NtFtiikg5Gf0=;
        b=Kn+9dL9abyn3VYNeRo+a3tkoP3IJcLi1DlNCn19la6l11f23Z17JzTOccPZMPlhnob
         uR9ec6NGWTkRtNzXlraMQfa6NyOWXVo1OhHGF0p6EgsBu/YozPCXUsTWCkUQfwYvh7G7
         7OJ61VxYDA/G8CbelHGDlPyY+LPnY/y6zOO7GaReH9fvdJhgCFwAuH1GFgfPRSkM8j7V
         MZllHfuOBtLO4FhP3+0IC+vJ2wKFTuLIV0TorGnIMcwKelSYgZfRzi2KpYH6IK4YvntR
         sFeczkasrtMzupoJcLoEGgEkjpgRldQPShUS9s4kPGPG5aOXOL6zkFsDZ3TiLTYCXuNe
         4iUg==
X-Forwarded-Encrypted: i=1; AJvYcCVB9mVCQWjq/UaP9JFCzUkWMvItzZfOmz3qJfn2L+U1AxrAPKD7F8vymADUNlYitnkzItCyBofjl36Q@vger.kernel.org
X-Gm-Message-State: AOJu0YxoD9MzqVoBU/3UEwD98al7QsdmmCRmJ65uVVhbgddauAHsc/D+
	2SeGkDh6tXQmgSqUgWdOY1SCRjUC2CuQw+LVw6K3cd5d6erFibhJSmbEaPsKD6ae3HK1CFKlILC
	L7Rz5KKqTC2HfAn9UjBR8KSGJ9ST22HJkT1VXp1eBjIlKQU8UhBUTFlC4UQ3ad4g=
X-Gm-Gg: AY/fxX6K8goh/wckWq2FkKIRodrjQM6yw6xOB9s2t6YbjX19qyrhMq+9YxfOAwzH/vI
	CXq5Fo99p4uKH/B/Vg59Q3bwfDgqFj3w1fyIkmhrKN2tkBscLwK+kOXe3KkOvJ9ZVpXOjf0+w3o
	UQVDNo5d8SfXveAQmAbqHxv3mywx+wZhydUuRM/7guHAJ0mop1Noe4jheCvOPSq6MkQWmP5FNLx
	HTa3LN/lQyAvgsJ8R0sVOXVaBQaMs7fQF59oxhePMwKpI83aZDdDGhdz/CIIZk4PF4pn7kFTWMP
	zGS+lSGru0heXlIx8F2ZHuKI8tWbS4+oXnaVaMAXoQYNfyby4Ci0YP43ovwL7y3zGukK8CIXQYy
	iV04M0/b53WuP5bAC7ESXC1m7Ca3yFGjCkL6t9Tk4S5Vuaq2VggNrNLBhNbvV51LEcKH8m3x29W
	MppB+D/yOQiDXdFWJg12AjSQ==
X-Received: by 2002:a05:6a00:4008:b0:81b:7e83:1735 with SMTP id d2e1a72fcca58-81fa04e2ffamr10948858b3a.0.1768880336222;
        Mon, 19 Jan 2026 19:38:56 -0800 (PST)
X-Received: by 2002:a05:6a00:4008:b0:81b:7e83:1735 with SMTP id d2e1a72fcca58-81fa04e2ffamr10948844b3a.0.1768880335783;
        Mon, 19 Jan 2026 19:38:55 -0800 (PST)
Received: from [10.72.112.107] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa1278460sm10501896b3a.38.2026.01.19.19.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 19:38:54 -0800 (PST)
Message-ID: <e6f77ede-444b-4d5c-9353-b18f84376ee7@redhat.com>
Date: Tue, 20 Jan 2026 11:38:50 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/15] md/raid1: use folio for tmppage
From: Xiao Ni <xni@redhat.com>
To: linan666@huaweicloud.com
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20251217120013.2616531-1-linan666@huaweicloud.com>
 <20251217120013.2616531-5-linan666@huaweicloud.com>
 <CALTww2-bCOHsK=iXqkTokFBdG=kxc6NsdgtyfWPXBaSX6pmcAA@mail.gmail.com>
In-Reply-To: <CALTww2-bCOHsK=iXqkTokFBdG=kxc6NsdgtyfWPXBaSX6pmcAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/1/19 11:20, Xiao Ni 写道:
> On Wed, Dec 17, 2025 at 8:11 PM <linan666@huaweicloud.com> wrote:
>> From: Li Nan <linan122@huawei.com>
>>
>> Convert tmppage to tmpfolio and use it throughout in raid1.
>>
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>   drivers/md/raid1.h |  2 +-
>>   drivers/md/raid1.c | 18 ++++++++++--------
>>   2 files changed, 11 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
>> index c98d43a7ae99..d480b3a8c2c4 100644
>> --- a/drivers/md/raid1.h
>> +++ b/drivers/md/raid1.h
>> @@ -101,7 +101,7 @@ struct r1conf {
>>          /* temporary buffer to synchronous IO when attempting to repair
>>           * a read error.
>>           */
>> -       struct page             *tmppage;
>> +       struct folio            *tmpfolio;
>>
>>          /* When taking over an array from a different personality, we store
>>           * the new thread here until we fully activate the array.
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 407925951299..43453f1a04f4 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -2417,8 +2417,8 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>>                                rdev->recovery_offset >= sect + s)) &&
>>                              rdev_has_badblock(rdev, sect, s) == 0) {
>>                                  atomic_inc(&rdev->nr_pending);
>> -                               if (sync_page_io(rdev, sect, s<<9,
>> -                                        conf->tmppage, REQ_OP_READ, false))
>> +                               if (sync_folio_io(rdev, sect, s<<9, 0,
>> +                                        conf->tmpfolio, REQ_OP_READ, false))
>>                                          success = 1;
>>                                  rdev_dec_pending(rdev, mddev);
>>                                  if (success)
>> @@ -2447,7 +2447,8 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>>                              !test_bit(Faulty, &rdev->flags)) {
>>                                  atomic_inc(&rdev->nr_pending);
>>                                  r1_sync_page_io(rdev, sect, s,
>> -                                               conf->tmppage, REQ_OP_WRITE);
>> +                                               folio_page(conf->tmpfolio, 0),
>> +                                               REQ_OP_WRITE);
>>                                  rdev_dec_pending(rdev, mddev);
>>                          }
>>                  }
>> @@ -2461,7 +2462,8 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>>                              !test_bit(Faulty, &rdev->flags)) {
>>                                  atomic_inc(&rdev->nr_pending);
>>                                  if (r1_sync_page_io(rdev, sect, s,
>> -                                               conf->tmppage, REQ_OP_READ)) {
>> +                                               folio_page(conf->tmpfolio, 0),
>> +                                               REQ_OP_READ)) {
>>                                          atomic_add(s, &rdev->corrected_errors);
>>                                          pr_info("md/raid1:%s: read error corrected (%d sectors at %llu on %pg)\n",
>>                                                  mdname(mddev), s,
>> @@ -3120,8 +3122,8 @@ static struct r1conf *setup_conf(struct mddev *mddev)
>>          if (!conf->mirrors)
>>                  goto abort;
>>
>> -       conf->tmppage = alloc_page(GFP_KERNEL);
>> -       if (!conf->tmppage)
>> +       conf->tmpfolio = folio_alloc(GFP_KERNEL, 0);
>> +       if (!conf->tmpfolio)
>>                  goto abort;
>>
>>          r1bio_size = offsetof(struct r1bio, bios[mddev->raid_disks * 2]);
>> @@ -3196,7 +3198,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
>>          if (conf) {
>>                  mempool_destroy(conf->r1bio_pool);
>>                  kfree(conf->mirrors);
>> -               safe_put_page(conf->tmppage);
>> +               folio_put(conf->tmpfolio);
>>                  kfree(conf->nr_pending);
>>                  kfree(conf->nr_waiting);
>>                  kfree(conf->nr_queued);
>> @@ -3310,7 +3312,7 @@ static void raid1_free(struct mddev *mddev, void *priv)
>>
>>          mempool_destroy(conf->r1bio_pool);
>>          kfree(conf->mirrors);
>> -       safe_put_page(conf->tmppage);
>> +       folio_put(conf->tmpfolio);
>>          kfree(conf->nr_pending);
>>          kfree(conf->nr_waiting);
>>          kfree(conf->nr_queued);
>> --
>> 2.39.2
>>
> Hi Nan
>
> Same question for patch04 and patch05, tmpage is used in read io path.
>  From the cover letter, this patch set wants to resolve the multi pages
> in sync io path. Is it better to keep them for your future patch set?
>
> Best Regards
> Xiao
>
> Xiao


After reading patch06, I understand here. r1_sync_page_io needs to 
change to r1_sync_folio_io to handle sync read error. Please ignore my 
above comments. patch04 and patch05 look good to me.

Best Regards

Xiao

