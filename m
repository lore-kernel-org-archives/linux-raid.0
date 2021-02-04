Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C71F2C433DB
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 08:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 874F864E16
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 08:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhBDI1T (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 03:27:19 -0500
Received: from mga07.intel.com ([134.134.136.100]:4832 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234950AbhBDI1S (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 4 Feb 2021 03:27:18 -0500
IronPort-SDR: 3njnIojjjeTeWnkaRP7GJkGLbvB9gnzxNg/uO9e7hVW9hexx0kHi9B3hdab0dWiUmoFRtLZh8M
 nOkzk3o8Q3Tw==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="245268652"
X-IronPort-AV: E=Sophos;i="5.79,400,1602572400"; 
   d="scan'208";a="245268652"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 00:25:33 -0800
IronPort-SDR: hXadvmmvn2dcjKrAnBrkwpiX93C39xJRavvmBuISg5dOrGENouYDvHbaeZzkUcmx0/Jy2VS77I
 qHOML6JOPCwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,400,1602572400"; 
   d="scan'208";a="372359014"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 04 Feb 2021 00:25:29 -0800
Received: from [10.249.149.178] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.149.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 66F5F5807FC;
        Thu,  4 Feb 2021 00:25:27 -0800 (PST)
Subject: Re: One failed raid device can't umount automatically
To:     Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>,
        artur.paszkiewicz@intel.com, Jes Sorensen <jes.sorensen@gmail.com>,
        NeilBrown <neilb@suse.com>, Nigel Croxon <ncroxon@redhat.com>
References: <1b0aaa70-a7bf-c35f-12c0-425e76200f0c@redhat.com>
 <b4cc93d4-4923-4959-3258-f03eca58f18e@redhat.com>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <fc497639-925d-c217-e241-52f293eea382@linux.intel.com>
Date:   Thu, 4 Feb 2021 09:25:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <b4cc93d4-4923-4959-3258-f03eca58f18e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 01.02.2021 15:35, Xiao Ni wrote:
> Hi all
Hi Xiao,
> 
> Any good suggestion for this problem?
> 
Replacing udisk by umount won't work from udev context. Umount gets
perrmision denied. You should ask systemd developers to find out
udev friendly way for stopping from udev context. If it is not possible,
in my opinion we should drop this functionality.

> Regards
> Xiao
> 
> On 01/12/2021 04:42 PM, Xiao Ni wrote:
>> Hi all
>>
>> We support to umount one failed raid device automatically. But it can't work now.
>> For example, one 3 disks raid5 device /dev/md0. I unplug two disks one by one.
>> The udev rule udev-md-raid-assembly.rules is triggered when unplug disk.
>>
>> In this udev rule, it calls `mdadm -If $disk` when unplug one disk. Function 
>> IncrementalRemove
>> is called. When the raid doesn't have enough disks to be active, it tries to 
>> stop the array.
>> Before stopping the array, it tries to umount the raid device first.
>>
>> Now it uses udisks to umount raid device. I printed logs during test. It gives 
>> error message
>> "Permission denied". Then I tried with umount directly, it failed with the 
>> same error message.
>>
>> diff --git a/Incremental.c b/Incremental.c
>> index e849bdd..96ba234 100644
>> --- a/Incremental.c
>> +++ b/Incremental.c
>> @@ -1620,6 +1620,7 @@ static void run_udisks(char *arg1, char *arg2)
>>                 manage_fork_fds(1);
>>                 execl("/usr/bin/udisks", "udisks", arg1, arg2, NULL);
>>                 execl("/bin/udisks", "udisks", arg1, arg2, NULL);
>> +               execl("/usr/bin/umount", "umount", arg2, NULL);
>>                 exit(1);
>>         }
>>         while (pid > 0 && wait(&status) != pid)
>>
>> Does anyone know how to fix this problem?
>>
>> Regards
>> Xiao
>>
>
Thanks,
Mariusz
