Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60973C6FA82
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 16:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiINQbn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 12:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiINQbT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 12:31:19 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BFA30578
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 09:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=xnFrqPnAMM7ulLo8a7i9cWjmvrMopgyucPp68ek1y+Y=; b=S9MMj1z9Tv9tu408zfMz2e+woj
        fTuQG+bz0t4lNaDbsV525sUs/2NnF38nBAuLl4V9e6dFuoE44ASB8xf1AaKw/D+QdzQ2b/FxH+8td
        Z52F/45+enhTHRRvZSsfafWPb3+2/FtDrR9schyIDUsZGVlu2LUX7YNWntwmqK/Bxt3atrnwDoEnF
        LdO0z6rd1jwib6esxXq0qbYxfRsW+zDPJRntOvarwjFmHCyKbhKQTCki0Xm33uFdpMGjHAJtLCkou
        sALSBi01cP3Ou3rS1tqiqmRcFy8AIc4ip+G5F0pHCgqEUxNbECU3ja7pZc0CWrdAZ6ZhyrB0ijnRV
        537wtGcw==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oYVGw-001gCh-AA; Wed, 14 Sep 2022 10:29:59 -0600
Message-ID: <0ecc42e3-53bf-ac8d-2154-db28f27fabc3@deltatee.com>
Date:   Wed, 14 Sep 2022 10:29:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
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
 <856072cb-ebdf-52fe-1a13-857763077bca@deltatee.com>
 <20220914140106.00000b36@linux.intel.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220914140106.00000b36@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm v2 1/2] mdadm: Add --discard option for Create
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-09-14 06:01, Mariusz Tkaczyk wrote:
>>>> As I understand it the offset and size will give the bounds of the
>>>> data region on the disk. Do you not think it works for zoned raid0?  
>>>
>>> mdadm operates on 512B, so using 4K data regions could be destructive.
>>> Also left shift causes that size value is increasing. We can't clear more
>>> that user requested. We need to use 512b sectors as mdadm does.  
>>
>> I don't really follow this.
> 
> I understand that you want left shit is used to round size to data region
> and I assumed that data_region is 4K and that is probably wrong.
> You are right I has no sense, my apologizes.
> 
> Let's imagine that our size is for example, 2687 sectors. Left shit will
> cause that we will get 2751488 and that will be passed as a size to function.
> Similar for data_offset. That is much more than we want to clear.
> Do I miss something? I guess that ioctl operates on sectors too but please
> correct me if that is wrong.

The BLKDISCARD ioctl assumes bytes for the range, not sectors. Though it
does have to be sector aligned.

dv->data_offset is then in sectors, so we shift by 9.

s->size is in KB, so we shift by 10.

Logan
