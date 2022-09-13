Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16989ECAAD8
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 17:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiIMROA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 13:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbiIMRN0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 13:13:26 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E379675F
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 09:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=2cBwnsypOzqJIUOr+3OuzvgtIBRJrwSrC6A1epZEl38=; b=CffJYyOAjCeUSxg+b7COwTJARy
        VpeXClLu2bHb48pPAYlqMGnSa0bQ+We6wYAjGa5tls8xJI911ZjRdDVg4qjCbnQd847X6HhyU755l
        BforGZ3HcqZHxDzyrNYtFnMKk2KZYxmTTpPgh2xLgYkrq0fmOsCshi8TcX9B6Vh0uthk0kMr0he5U
        mLQ2QyHyPny7mGqrOebkzl37XZ8n7RjX8tRdEArWw0uMJ5YbrtKcebc90wceSUWOuwmPD9hjrDFz8
        6O4k56C0fyzuckI4Zu87doGSsYY/wYBnjr5UPDhCVCKFDV62N5coLlYavhPk9nNeXBais+JZdH3mb
        dzUZRJCA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oY84n-000q1U-Lx; Tue, 13 Sep 2022 09:43:54 -0600
Message-ID: <856072cb-ebdf-52fe-1a13-857763077bca@deltatee.com>
Date:   Tue, 13 Sep 2022 09:43:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-CA
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220908230847.5749-1-logang@deltatee.com>
 <20220908230847.5749-2-logang@deltatee.com>
 <20220909115749.00007431@linux.intel.com>
 <6dd46583-05ef-12e7-8a37-b732cbe79f23@deltatee.com>
 <20220913093559.0000438b@linux.intel.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220913093559.0000438b@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm v2 1/2] mdadm: Add --discard option for Create
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-09-13 01:35, Mariusz Tkaczyk wrote:
> On Fri, 9 Sep 2022 09:47:21 -0600
> Logan Gunthorpe <logang@deltatee.com> wrote:
>>>> +{
>>>> +	uint64_t range[2] = {offset, size};  
>>> Probably you don't need to specify [2] but it is not an issue I think.
>>>   
>>>> +	unsigned long buf[4096 / sizeof(unsigned long)];  
>>>
>>> Can you use any define for 4096?   
>>
>> I don't see any appropriate defines in the code base. It really just
>> needs to be bigger than any O_DIRECT restrictions. 4096 bytes is usually
>> the worst case.
> 
> See comment bellow.

I don't see how the comment below relates to this at all. This 4k has
nothing to do with anything related to the array, it wos only a
convenient size to read and check the result. But per Martin's points,
this code will go away in v3 seeing it's more appropriate to use
WRITE_ZEROS and that interface guarantees that there will be zeros, thus
no need to check.


>> That's correct. I discussed this in the cover letter. That's why this
>> check is here. Per some of the discussion from others I still think the
>> best course of action is to just check what the discard did and fail if
>> it is non-zero. Even though many NVMe and ATA devices have the ability
>> to control or query the behaviour, the kernel doesn't support this and
>> I don't think it can be relied upon.
> 
> It is also controversial approach[1].
> 
> I think that the best we can do here is to warn user, for example:
> "Please ensure that drive you used return zeros after discard."
> We should ask for confirmation (it should be possible to skip with --run).
> I would like to leave discard feature validation on user side, it is not mdadm
> task. Simply, if you want to use it, then it is done on your own risk and
> hopefully you know what you want to achieve.
> That will simplify implementation on mdadm side. What do you think?

I think the better approach is to just use WRITE_ZEROS.

>>>> @@ -945,6 +983,15 @@ int Create(struct supertype *st, char *mddev,
>>>>  				}
>>>>  				if (fd >= 0)
>>>>  					remove_partitions(fd);
>>>> +
>>>> +				if (s->discard &&
>>>> +				    discard_device(c, fd, dv->devname,
>>>> +						   dv->data_offset << 9,
>>>> +						   s->size << 10)) {
>>>> +					ioctl(mdfd, STOP_ARRAY, NULL);
>>>> +					goto abort_locked;
>>>> +				}
>>>> +  
>>> Feel free to use up to 100 char in one line it is allowed now.
>>> Why we need dv->data_offset << 9 and  s->size << 10 here?
>>> How this applies to zoned raid0?  
>>
>> As I understand it the offset and size will give the bounds of the
>> data region on the disk. Do you not think it works for zoned raid0?
> 
> mdadm operates on 512B, so using 4K data regions could be destructive.
> Also left shift causes that size value is increasing. We can't clear more that
> user requested. We need to use 512b sectors as mdadm does.

I don't really follow this.

> I don't know how native raid0 size is passed and how zones are created but I
> suspect that s->size may not be correct for all drives. It it a global property
> but for zoned raid member size could be different. You need to check how it
> applies.

> Also, I'm not sure if this feature is needed for raid0, because there is no
> resync. Maybe we can exclude raid0 from discard?

I'll check raid0 size. If possible I'd rather not have the restriction
to avoid raid0 as it becomes complicated and users may have reason to
zero besides avoiding resync.
>>
>> Well it was my opinion that it was clearer in the code to just
>> explicitly include discard in the conditionals instead of making discard
>> also set assume-clean, but if you think otherwise I can change it for v3.
>>
>> What kind of user message are you thinking is necessary here?
> 
> In my convention, all shape attributes should be set in mdadm.c, later they
> should be considered as const, we should not overwrite them. This structure
> represents user settings.
> This is why I consider updating assume_clean in Create.c as wrong. When discard
> is set then we are assuming that user want to skip resync too, otherwise it
> doesn't have sense. Also, if discard of any drive fails we are returning error
> and create operation will fail anyway.

The v2 version of this patch did not modify the shape attributes in
Create.c; that was only in v1.

> I would expected something like: "Discard requested, setting --assume-clean to
> skip resync".
> Also, will be great if you can add some tests, at least for command-line.

Ok.

Logan
