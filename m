Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8AE1C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 30 Sep 2022 15:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiI3Pjh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Sep 2022 11:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiI3Pj3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 30 Sep 2022 11:39:29 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEEB1A0D39
        for <linux-raid@vger.kernel.org>; Fri, 30 Sep 2022 08:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=HfsOe+EtrS3IlrKO1AN6hjFPZ6FqqAUM4YuQ9HOPJTM=; b=aptNgftuKc0jS2SmAOGR+DtG8F
        ZXe+mUt7rf5SLADW4v6/CPrjwz4+opE8E27/0wJ/fMgN3I3h5HshXyIptCunXxr61Odr63DcAaD9q
        ht57ozpc2MgF7LNj1eLJhsxLUGJJhc6O/kmRjEOw1gERksA1RUQs0YmIIkgyMSdsfexrOqHrR6lDy
        LRkZhnDAb1s5oSkzdglcw9v9tFxnaKdcpxgPG95QzuA3KtgGJ7SWbTEZRejnhaQ49Ak5Tmr3AY8r8
        SiGKMpGjEWFKU2DJ7iLZ8ykRN20b/CGCmOBmwJh8v5UY6ydJNpv7ZteXJR1BX2BOzlbQ+u2Rlkio+
        aU5urrGA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oeI6g-00EZhM-K9; Fri, 30 Sep 2022 09:39:19 -0600
Message-ID: <0e23a02b-e0e5-cd11-478f-ecaa39404acd@deltatee.com>
Date:   Fri, 30 Sep 2022 09:39:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-CA
To:     Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220921204356.4336-1-logang@deltatee.com>
 <20220921204356.4336-6-logang@deltatee.com>
 <20220923132006.000006ce@linux.intel.com>
 <9d7c13e8-f553-b648-6026-e815bbc48a08@redhat.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <9d7c13e8-f553-b648-6026-e815bbc48a08@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: xni@redhat.com, mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm v3 5/7] mdadm: Add --write-zeros option for Create
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-09-29 23:23, Xiao Ni wrote:
>>>   extern const char Name[];
>>>   
>>>   struct md_bb_entry {
>>> @@ -387,6 +390,8 @@ struct mdinfo {
>>>   		ARRAY_UNKNOWN_STATE,
>>>   	} array_state;
>>>   	struct md_bb bb;
>>> +
>>> +	pid_t zero_pid;
>>>   };
>> mdinfo is  used  for raid properties. It is used for both system (sysfs_read())
>> and metadata(getinfo_super()). zero_pid property doesn't fit well there, it is
>> used once during creation. Could you please add it to mddev_dev struct or add
>> it to local array /list?
> 
> 
> Hi Logan
> 
> I have the same question about this.
> 
> Beside this problem, the others are good for me. By the way, it needs to 
> pull to the latest upstream. Now
> 
> it has conficts when mergeing v3 patch.

Yup, thanks, I'll make the changes for v4 next week.

Logan

