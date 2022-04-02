Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D86C433F5
	for <linux-raid@archiver.kernel.org>; Sat,  2 Apr 2022 15:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244262AbiDBPXC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Apr 2022 11:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiDBPXA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Apr 2022 11:23:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4225511C20
        for <linux-raid@vger.kernel.org>; Sat,  2 Apr 2022 08:21:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BC4D31FD01;
        Sat,  2 Apr 2022 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648912865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r5EeElis7o8C2Ld53G26oQHpizmtAqVKMG04hcDg/uo=;
        b=Re1we5uZn7w+TfL49qQs/rqTPTLzf8nzEcOlqu583TJg/GCKKJEQ+71Lqc6ZaiVOplExlD
        zRkNqw0Ef2BgxMVS71XGWxqoioTjuURRgtZzGkWPLq6ohGK7mDIzei5ahYFFwPkbiqcfqD
        uA1qtz5nyyWa7fq6mTF8+f+yaxQehHs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648912865;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r5EeElis7o8C2Ld53G26oQHpizmtAqVKMG04hcDg/uo=;
        b=GSXMvoLSv9Co1Auw7/zCapr6UHb38CenZsNgCCiqpjw8jip4hZ06R9wd6rgTUFrSa13H9r
        KMD6c1RwFL9Ii0CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 219A713440;
        Sat,  2 Apr 2022 15:21:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id URbjLt9pSGI7MgAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 02 Apr 2022 15:21:03 +0000
Message-ID: <531b5a67-c9e8-bab2-b929-c4d4cc441e74@suse.de>
Date:   Sat, 2 Apr 2022 23:21:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] mdadm: fix msg when removing a device using the short arg
 -r
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <20220207221519.3169427-1-ncroxon@redhat.com>
 <20220208101450.00007baf@linux.intel.com>
 <20220322090702.00006d65@linux.intel.com>
Cc:     Wu Guanghao <wuguanghao3@huawei.com>, jes@trained-monkey.org,
        Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220322090702.00006d65@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/22/22 4:07 PM, Mariusz Tkaczyk wrote:
> On Tue, 8 Feb 2022 10:14:50 +0100
> Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:
>
>> On Mon,  7 Feb 2022 17:15:19 -0500
>> Nigel Croxon <ncroxon@redhat.com> wrote:
>>
>>> The change from commit mdadm: fix coredump of mdadm
>>> --monitor -r broke the printing of the return message when
>>> passing -r to mdadm --manage, the removal of a device from
>>> an array.
>>>
>>> If the current code reverts this commit, both issues are
>>> still fixed.
>>>
>>> The original problem reported that the fix tried to address
>>> was:  The --monitor -r option requires a parameter,
>>> otherwise a null pointer will be manipulated when
>>> converting to integer data, and a core dump will appear.
>>>
>>> The original problem was really fixed with:
>>> 60815698c0a Refactor parse_num and use it to parse optarg.
>>> Which added a check for NULL in 'optarg' before moving it
>>> to the 'increments' variable.
>>>
>>> New issue: When trying to remove a device using the short
>>> argument -r, instead of the long argument --remove, the
>>> output is empty. The problem started when commit
>>> 546047688e1c was added.
>>>
>>> Steps to Reproduce:
>>> 1. create/assemble /dev/md0 device
>>> 2. mdadm --manage /dev/md0 -r /dev/vdxx
>>>
>>> Actual results:
>>> Nothing, empty output, nothing happens, the device is still
>>> connected to the array.
>>>
>>> The output should have stated "mdadm: hot remove failed
>>> for /dev/vdxx: Device or resource busy", if the device was
>>> still active. Or it should remove the device and print
>>> a message:
>>>
>>> # mdadm --set-faulty /dev/md0 /dev/vdd
>>> mdadm: set /dev/vdd faulty in /dev/md0
>>> # mdadm --manage /dev/md0 -r /dev/vdd
>>> mdadm: hot removed /dev/vdd from /dev/md0
>>>
>>>
>>> The following commit should be reverted as it breaks
>>> mdadm --manage -r.
>>>
>>> commit 546047688e1c64638f462147c755b58119cabdc8
>>> Author: Wu Guanghao <wuguanghao3@huawei.com>
>>> Date:   Mon Aug 16 15:24:51 2021 +0800
>>> mdadm: fix coredump of mdadm --monitor -r
>>>
>>> -Nigel
>>>
>>> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
>>>
>>>
>> Hi,
>> Thanks for the reminder. Revert is obviously correct. Jes could you
>> merge it?
>>
>> In systemd world mdmonitor is rarely started from cmdline. If
>> "increment" option is not settable via config then it is probably
>> unused. I consider this option as deprecated and I suspect that no one
>> is using it now. Can we remove it completely?
>>
>> If you disagree with that, then we should add support for it in config
>> file to make it usable. Additionally, I suggest to change "-r" for
>> "increments" to short opt always used with parameter.
>>
> Hi Coly,
> Could you take a look?


Copied.


Coly Li

