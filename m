Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8066C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  8 Feb 2022 15:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378648AbiBHPFE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Feb 2022 10:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378470AbiBHPFD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Feb 2022 10:05:03 -0500
X-Greylist: delayed 906 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 07:05:02 PST
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2665FC06174F
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 07:05:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1644331768; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=OH6Mlf4kvqA7Mfx0PidkNagSU9wS996p6TbOQB1FDZ705eKZFNvYdWkMhu/pMRjMOmRWjJY5UBq3zJVWbDK3c5MMWFpxhFALKxf72o28bjc5IUJ7As/CerZGtMYQB/Nf5VYPcfnWUsPIOmcnK02vKtvFGTnNTREMUpAIvw41Z8k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1644331768; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=JMIreQFmQ2B26E9jaujjGoq/Dk/nB8vGmA57JMR0sFM=; 
        b=LJaXMsHKq9lGMo5yeRPNGtUJaPvvsC8/SRdCr7lgpO1ZOVljyoICidJ3yPorg3gQqsEBdhAy35KHE2u2AEDPwbreUEtSrjsqOyiMJB666oJ96c3R3q+7In8DWRXG1BZaOJ8THyRzfDUhsqulneTv3P94pjl6bmkLCcKbV1TJEIU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1644331762093833.7795225352093; Tue, 8 Feb 2022 15:49:22 +0100 (CET)
Message-ID: <20e46312-9648-9efd-7ee3-2aa7189dccf1@trained-monkey.org>
Date:   Tue, 8 Feb 2022 09:49:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] mdadm: fix msg when removing a device using the short arg
 -r
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org,
        Wu Guanghao <wuguanghao3@huawei.com>, Coly Li <colyli@suse.de>
References: <20220207221519.3169427-1-ncroxon@redhat.com>
 <20220208101450.00007baf@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220208101450.00007baf@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/8/22 04:14, Mariusz Tkaczyk wrote:
> On Mon,  7 Feb 2022 17:15:19 -0500
> Nigel Croxon <ncroxon@redhat.com> wrote:
> 
>> The change from commit mdadm: fix coredump of mdadm
>> --monitor -r broke the printing of the return message when
>> passing -r to mdadm --manage, the removal of a device from
>> an array.
>>
>> If the current code reverts this commit, both issues are
>> still fixed.
>>
>> The original problem reported that the fix tried to address
>> was:  The --monitor -r option requires a parameter,
>> otherwise a null pointer will be manipulated when
>> converting to integer data, and a core dump will appear.
>>
>> The original problem was really fixed with:
>> 60815698c0a Refactor parse_num and use it to parse optarg.
>> Which added a check for NULL in 'optarg' before moving it
>> to the 'increments' variable.
>>
>> New issue: When trying to remove a device using the short
>> argument -r, instead of the long argument --remove, the
>> output is empty. The problem started when commit 
>> 546047688e1c was added.
>>
>> Steps to Reproduce:
>> 1. create/assemble /dev/md0 device
>> 2. mdadm --manage /dev/md0 -r /dev/vdxx
>>
>> Actual results:
>> Nothing, empty output, nothing happens, the device is still
>> connected to the array.
>>
>> The output should have stated "mdadm: hot remove failed
>> for /dev/vdxx: Device or resource busy", if the device was
>> still active. Or it should remove the device and print
>> a message:
>>
>> # mdadm --set-faulty /dev/md0 /dev/vdd
>> mdadm: set /dev/vdd faulty in /dev/md0
>> # mdadm --manage /dev/md0 -r /dev/vdd
>> mdadm: hot removed /dev/vdd from /dev/md0
>>
>>
>> The following commit should be reverted as it breaks
>> mdadm --manage -r.
>>
>> commit 546047688e1c64638f462147c755b58119cabdc8
>> Author: Wu Guanghao <wuguanghao3@huawei.com>
>> Date:   Mon Aug 16 15:24:51 2021 +0800
>> mdadm: fix coredump of mdadm --monitor -r
>>
>> -Nigel
>>
>> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
>>
>>
> Hi,
> Thanks for the reminder. Revert is obviously correct. Jes could you
> merge it?
> 
> In systemd world mdmonitor is rarely started from cmdline. If
> "increment" option is not settable via config then it is probably
> unused. I consider this option as deprecated and I suspect that no one
> is using it now. Can we remove it completely?
> 
> If you disagree with that, then we should add support for it in config
> file to make it usable. Additionally, I suggest to change "-r" for
> "increments" to short opt always used with parameter.

Nigel,

Send me a patch and I'll apply it. Reminder, keep the author of the
patch you want to revert in CC.

Thanks,
Jes

