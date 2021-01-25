Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD89C433DB
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jan 2021 18:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4C2222D04
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jan 2021 18:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbhAYScZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Jan 2021 13:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbhAYScG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Jan 2021 13:32:06 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D7CC061574
        for <linux-raid@vger.kernel.org>; Mon, 25 Jan 2021 10:31:26 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gx1so145076pjb.1
        for <linux-raid@vger.kernel.org>; Mon, 25 Jan 2021 10:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fj+Mfh+iRTxHQ178jS8NvM3lFwTcOTHpKQTHJjUZLmQ=;
        b=NdQRadAEr90lOki82TN6DFtvOSfUjjxSRo0YnI+9kABgrnXatJDaUbKH+9fZNKlj37
         8v87B8qPFNTO01QF4Z+jIs5WJSNxzD33TVTDgtv3nEZ0w4x9IK0JXeObsgFXpyWnJclh
         r1MPwMoLp0LwM1UHh5fYunKmOYFttusTDMogxqlA60ejvcSjL5+cjWapnKTGwkLE1WBl
         +wecUym331pkGeIW1V+NRLHgryE1s5ac1/KqEetgGSVYiji7zS/TssjK7ZHThlzIZPks
         OzM9LBWUFP8lxX7V4KXEiIL3WHyGamsVVlVK0jNWsvr2a+VU1wTnQ8QTxvk6YIBylWd2
         kcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fj+Mfh+iRTxHQ178jS8NvM3lFwTcOTHpKQTHJjUZLmQ=;
        b=h5eb0hGC6sZ8V3VyCYSxY+iOOXmC20rZDgk1N2hRhDwlVivIwIVPQRTjLXljApls+x
         exg+6w7Ar/CKFbnEnsNNWXgG68IB6uJ5j8x6wM/tBbaUXb+CcL7jx6gOL4OZ24rDQ7wr
         fgvveWM6QIWtthwOXlx6ttG8V4QLZard8LJkMUfwRQW1dk19f2ZN2Q4Vt+UP+mGutVH/
         4O3wRqp8KMswEt+4hu5QBSJ96GlApBkR9jJyGjhzu+kjjKlAdgs3hnkQPX8WHwACSb6O
         MDcGlg4Auk+UxST42J5Z8ex8/gDBI3J2ZIpwup4uVK1jl+5g1PFB6O7kLp2N1riHCfF8
         PYWQ==
X-Gm-Message-State: AOAM5313KsYmAGb/rOZ0URNEap3hi3ZCCA3k3+AN9NVAQ7Xsafhp9UeT
        8uPp5rLx3vJMg9JH9nrkfuoGLg==
X-Google-Smtp-Source: ABdhPJw45UKblJYIjAuYyqjrm84zW5HcAl4q2OlrL0kcx51YsGL6Wwv5aF+a7froFnxQYB/1Z5yYqg==
X-Received: by 2002:a17:902:b717:b029:dc:3e69:6dd5 with SMTP id d23-20020a170902b717b02900dc3e696dd5mr1995124pls.70.1611599485884;
        Mon, 25 Jan 2021 10:31:25 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 24sm10567912pgt.14.2021.01.25.10.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 10:31:25 -0800 (PST)
Subject: Re: [PATCH 05/10] block: do not reassig ->bi_bdev when partition
 remapping
To:     Christoph Hellwig <hch@lst.de>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
References: <20210124100241.1167849-1-hch@lst.de>
 <20210124100241.1167849-6-hch@lst.de>
 <dfdff48c-c263-8e7c-cb52-28e7bee00c45@kernel.dk>
 <20210125175528.GA13451@lst.de>
 <2b600368-96fa-7caf-f05b-321de616f7c9@kernel.dk>
 <13667b22-029b-d7be-02da-96fce22cfd8f@kernel.dk>
 <20210125181349.GA14432@lst.de>
 <1c0fabdc-9b73-dfd7-f49d-c211d58cbf12@kernel.dk>
 <20210125181826.GA14957@lst.de>
 <22e0f687-3165-e9d1-e1bd-9769a11dc0ea@kernel.dk>
 <20210125182150.GA15367@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <387c824a-c713-a087-2f6f-434ba127b1df@kernel.dk>
Date:   Mon, 25 Jan 2021 11:31:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210125182150.GA15367@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/25/21 11:21 AM, Christoph Hellwig wrote:
> On Mon, Jan 25, 2021 at 11:19:23AM -0700, Jens Axboe wrote:
>> On 1/25/21 11:18 AM, Christoph Hellwig wrote:
>>> On Mon, Jan 25, 2021 at 11:15:04AM -0700, Jens Axboe wrote:
>>>> On 1/25/21 11:13 AM, Christoph Hellwig wrote:
>>>>> On Mon, Jan 25, 2021 at 11:03:24AM -0700, Jens Axboe wrote:
>>>>>> Partition table entries are not in disk order.
>>>>>
>>>>> And the issue shows up with the series just up to the this patch,
>>>>> without any later patches?
>>>>
>>>> At that patch specifically. I bisected it, and then I double checked
>>>> by running the previous commit (boots fine), then apply this one, and
>>>> then I run into that error. So it should be 100% reliable.
>>>
>>> Ok, I have an idea.  With EOD message you mean this printk, right:
>>>
>>> 	pr_info_ratelimited("attempt to access beyond end of device\n"
>>>                             "%s: rw=%d, want=%llu, limit=%llu\n",
>>> 			    ...
>>>
>>> right?
>>
>> Yep
> 
> Can you give this untested patch a spin?  This should fix the
> case where we check the eod for the original partition with the
> remapped bi_sectors.  Looking into a local reproducer now.

Yep, with that applied on top my laptop boots again.

-- 
Jens Axboe

