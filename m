Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82F5C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 17 Jun 2022 19:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiFQTgO convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Jun 2022 15:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiFQTgM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 17 Jun 2022 15:36:12 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B022359966
        for <linux-raid@vger.kernel.org>; Fri, 17 Jun 2022 12:36:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1655494546; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=gEp7rSk5vA/swW34LZIawCZIcpBtDaglgDkCL90Kd2r4+F1rkYzeXk8scbA2uWt7o2oLpok0/xkCZRgqcd/02DGo36ttVygF9ha5Dd1vwDCVQiMqgNXJuJyvYsN6i60I6OxPlxnLH2rhhJxUpI9iWc3ycgOzlvhUwEu6KjlvAkc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1655494546; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=A2x29vTpk2f/odGCFov+D3r1rvFDomm+fMgXJ3Uevfk=; 
        b=cbW+asdgjulRlgrWetZb0VtJbrh8VILb+aAqhF7BgutONON/wIBcaNT267rcMq5WFmz7d83GElU7rdJH1a4SjsKw92NKva8SU/8fooT0puPaf5Ivaj4OnNEPH2haY1AoVD6rI6Joq+34lPpJgp6+DHz81I/l8Yh66J81Tz2I5ow=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.80] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1655494545585432.04836338388657; Fri, 17 Jun 2022 21:35:45 +0200 (CEST)
Date:   Fri, 17 Jun 2022 15:35:43 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] Revert "mdadm: fix coredump of mdadm --monitor -r"
Content-Language: en-US
To:     Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org,
        mariusz.tkaczyk@linux.intel.com, wuguanghao3@huawei.com,
        colyli@suse.de
References: <20220418174423.846026-1-ncroxon@redhat.com>
 <54144438-5b6a-60dd-6f62-e90e052772ee@redhat.com>
 <62ec6c6e-76b7-e705-7326-a82b59f337b8@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <5f9a4417-d044-a87e-3945-2c6b29278d8c@trained-monkey.org>
In-Reply-To: <62ec6c6e-76b7-e705-7326-a82b59f337b8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/17/22 13:09, Nigel Croxon wrote:
> On 6/14/22 10:11 AM, Nigel Croxon wrote:
>> On 4/18/22 1:44 PM, Nigel Croxon wrote:
>>> This reverts commit 546047688e1c64638f462147c755b58119cabdc8.
>>>
>>> The change from commit mdadm: fix coredump of mdadm
>>> --monitor -r broke the printing of the return message when
>>> passing -r to mdadm --manage, the removal of a device from
>>> an array.
>>>
>>> If the current code reverts this commit, both issues are
>>> still fixed.
>>>
>>> The original problem reported that the fix tried to address
>>> was:  The --monitor -r option requires a parameter,
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
>>> mdadm: set /dev/vdd faulty in /dev/md0
>>> mdadm: hot removed /dev/vdd from /dev/md0
>>>
>>> The following commit should be reverted as it breaks
>>> mdadm --manage -r.
>>>
>>> commit 546047688e1c64638f462147c755b58119cabdc8
>>> Author: Wu Guanghao <wuguanghao3@huawei.com>
>>> Date:   Mon Aug 16 15:24:51 2021 +0800
>>> mdadm: fix coredump of mdadm --monitor -r
>>>
>>> -Nigel
>>>
>>> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
>>> ---
>>>   ReadMe.c | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/ReadMe.c b/ReadMe.c
>>> index 8f873c48..bec1be9a 100644
>>> --- a/ReadMe.c
>>> +++ b/ReadMe.c
>>> @@ -81,11 +81,11 @@ char Version[] = "mdadm - v" VERSION " - "
>>> VERS_DATE EXTRAVERSION "\n";
>>>    *     found, it is started.
>>>    */
>>> -char
>>> short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
>>>
>>> +char
>>> short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
>>>
>>>   char short_bitmap_options[]=
>>> -       
>>> "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
>>> +       
>>> "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
>>>   char short_bitmap_auto_options[]=
>>> -       
>>> "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
>>> +       
>>> "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
>>>   struct option long_options[] = {
>>>       {"manage",    0, 0, ManageOpt},
>>
>> Jes, That is the status of this patch?
>>
>> Thanks, Nigel
> 
> 
> Jes, Is there an issue with reverting this patch?

The fact that I am swamped with my regular work and it hadn't made it
into patchworks. It's applied now.

Jes


