Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150B3C32772
	for <linux-raid@archiver.kernel.org>; Tue, 23 Aug 2022 17:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243318AbiHWRQn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 Aug 2022 13:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344139AbiHWRPf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 Aug 2022 13:15:35 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D674F12756
        for <linux-raid@vger.kernel.org>; Tue, 23 Aug 2022 06:50:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661262557; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=DVY5sPDVlgNYicDAX5LmAmMVQ6PCSMta/9bFJTe+37x2R+V17UT4qiBQZypYtIRdLKO/vovkBgwogXg+l6ceTaNrZTt1333QmkYPoKFlV6wIWICGF5+h4+/1dSiGCQ2lKU6x5OrX0xuUVlrJjpuW0DxXQtDSsJhv7vvkNZ37XvE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1661262557; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=eF7So43rg1fc+9ISdFUo2WZ2UvbM4EnqYRxWD1r9ngo=; 
        b=EX8xmqVvFJ2yzEOmo70xE2fWpz/H9bfuKYiTqjQQ+DTPjrRIEdLch5TgYfzzVqJS+mHfimrwNe37Yp52EIKDaoS27MLUnFbfacaJ4Rq0b1dDVqc0RML2vJ7sr31eYSxtwtqPV7b772Wd28Mr9IeW+O4Fl+/G9tekdXcOVFHeJuM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1661262555067958.0916088589785; Tue, 23 Aug 2022 15:49:15 +0200 (CEST)
Message-ID: <c3810d35-c918-e128-5184-52cef5710422@trained-monkey.org>
Date:   Tue, 23 Aug 2022 09:49:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH mdadm] mdadm: Don't open md device for CREATE and ASSEMBLE
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Logan Gunthorpe <logang@deltatee.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>, Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220714223749.17250-1-logang@deltatee.com>
 <150ffbb2-9881-9c1f-cc5e-331926b8e423@linux.dev>
 <20220719132739.00001b94@linux.intel.com>
 <dcaf3af0-95c5-bf9a-bd2c-9c6a60c67e97@deltatee.com>
 <20220720102015.00000bd0@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220720102015.00000bd0@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/20/22 04:20, Mariusz Tkaczyk wrote:
> On Tue, 19 Jul 2022 10:43:06 -0600
> Logan Gunthorpe <logang@deltatee.com> wrote:
> 
>> On 2022-07-19 05:27, Mariusz Tkaczyk wrote:
>>> On Fri, 15 Jul 2022 10:20:26 +0800
>>> Guoqing Jiang <guoqing.jiang@linux.dev> wrote:  
>>>> On 7/15/22 6:37 AM, Logan Gunthorpe wrote:  
>>>>> To fix this, don't bother trying to open the md device for CREATE and
>>>>> ASSEMBLE commands, as the file descriptor will never be used anyway
>>>>> even if it is successfully openned.  
>>> Hi All,
>>>
>>> This is not a fix, it just reduces race probability because file descriptor
>>> will be opened later.  
>>
>> That's not correct. The later "open" call actually will use the new_array
>> parameter which will wait for the workqueue before creating a new array
>> device, so the old one is properly cleaned up and there is no longer
>> a race condition with this patch. If new_array doesn't exist and it falls back
>> to a regular open, then it will still do the right thing and open the device 
>> with create_on_open.
> 
> Array is created by /sys/module/md/parameters/new_array if chosen_name has
> certain form. For IMSM, when we are creating arrays using "/dev/md/name" or
> "name" only create_on_open is used (if no "names=yes" in config). I
> understand that it works with tests but I don't feel that it is complete yet.
> Could you how it behaves when we use "whatever"? 
> 
> #mdadm -CR whatever -l0 -n2 /dev/nvme[01]n1
> 
> Please do not use --name= parameter.
> 
> I want to disable create_on_open and always use new_array in the future, without
> fallback to create_on_open possibility. So I would like to have solution which
> is not relying on it.
>>
>>> I tried to resolve it in the past by adding completion to md driver and
>>> force mdadm --stop command to wait for sysfs clean up but I have never
>>> finished it. IMO it is a better way, wait for device to be fully removed by
>>> MD during stop. Thoughts?  
>>
>> I don't think that would work very well. Userspace would end up blocking
>> on --stop indefinitely if there are any references delaying cleanup to
>> the device. That's not very user friendly. Given that opening the md
>> device has side-effects, I think we should avoid opening when we
>> should know that we are about to try to create a new device.
> 
> Got it, thanks!
> 
> Hmm, so maybe the existing MD device should be marked as "in the middle of
> removal" somehow to gives mdadm possibility to detect that. If we are using
> node as name "/dev/mdX" then we will need to throw error, but when node needs
> to be determined by find_free_devnm() then it will simply skip this one and
> gives next one. But it will require changes in kernel probably.
> 
>>
>>> One objection I have here is that error handling is changed, so it could be
>>> harmful change for users.   
>>
>> Hmm, yes seems like I was a bit sloppy here. However, it still seems possible
>> to fix this up by not pre-opening the device. The only use for the mdfd
>> in CREATE, ASSEMBLE and BUILD is to get the minor number if
>> ident.super_minor == -2 and check if an existing specified device is an md 
>> device (which may be redundant). We could replace this with a stat() call to
>> avoid opening the device. What about the patch at the end of this email?
> 
> LGTM, I put small comment. But as I said before, probably it don't fix all
> creation cases.

Hi Mariusz,

Just to recap on this, do you support applying this patch as is, or
should we wait for the longer term fix you were mentioning?

Thanks,
Jes

