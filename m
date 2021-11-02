Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D896C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 16:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5780060C49
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 16:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhKBQCy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Nov 2021 12:02:54 -0400
Received: from sender12-1.zoho.eu ([185.20.211.225]:17212 "EHLO
        sender12-1.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234359AbhKBQCx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Nov 2021 12:02:53 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Nov 2021 12:02:53 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1635868809; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=bynylD1SY2rSgMxtt10iM8bGPFGpvz3pi6ili6gXDihAd8SX/6KS9QjlclKn6HiEJ4nPM7MCisugK6jbUlK4vzinooDcOxc6ixt8KC7iifnsZwkFSTMurm5mSugdJAIeYQN4TO0R5bZ/zBH1qOgCQfKS+rAS+m/yegLltXIvgqc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1635868809; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=8qKFoggFdywP1p8ZI9kwk1PZui4mlV4gwHRePrTlKYw=; 
        b=FadhPjqWzlsmeXwMs2P7wNem1ZtUwnc7yuAQxFNFiL2PIX/hNwZ09+O+HHISevuF5pXib4ks/chbIeQNVqM85Q0I6tGYoWLz3AYVbVBaPjdNUOqnuEbCTI1BanaA9JboOVRjo/gX51IqoysadMFAOBjzdjF/T7N3dJhhJY6RtR0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1635868808448670.581819801646; Tue, 2 Nov 2021 17:00:08 +0100 (CET)
Subject: Re: [PATCH 1/1] mdadm/Detail: Can't show container name correctly
 when unpluging disks
To:     Xiao Ni <xni@redhat.com>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     Nigel Croxon <ncroxon@redhat.com>, Fine Fan <ffan@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <1634740723-5298-1-git-send-email-xni@redhat.com>
 <974e4fc3-f85c-bfa7-176e-a440fbdfc001@linux.intel.com>
 <CALTww2_3e8-U-s4wkURv=zPATWrKSKcjWgK4EXSV-YtAbMNrkA@mail.gmail.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <3f0d4285-664d-4088-0138-ba71858e970f@trained-monkey.org>
Date:   Tue, 2 Nov 2021 12:00:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CALTww2_3e8-U-s4wkURv=zPATWrKSKcjWgK4EXSV-YtAbMNrkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/21/21 8:09 PM, Xiao Ni wrote:
> On Thu, Oct 21, 2021 at 5:13 PM Tkaczyk, Mariusz
> <mariusz.tkaczyk@linux.intel.com> wrote:
>>
>> Hi Xiao,
>> On 20.10.2021 16:38, Xiao Ni wrote:
>>> +             char dv[32], dv_rep[32];
>>> +
>>> +             sprintf(dv, "/sys/dev/block/%d:%d",
>>> +                             disks[d*2].major, disks[d*2].minor);
>>> +             sprintf(dv_rep, "/sys/dev/block/%d:%d",
>>> +                             disks[d*2+1].major, disks[d*2+1].minor);Please use snprintf and PATH_MAX instead 32.
>>> +
>>> +             if ((!access(dv, R_OK) &&
>>> +                 (disks[d*2].state & (1<<MD_DISK_SYNC))) ||
>> IMO not correct style, please verify with checkpatch.
>> should be: [d * 2]
> 
> Hi Mariusz
> 
> I ran checkpatch before sending this patch. The checkpatch I used is
> from Song's git
> (https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git). It only
> reports one warning
> like this:
> 
> WARNING: Unknown commit id 'db5377883fef', maybe rebased or not pulled?
> #34:
> Fixes: db5377883fef (It should be FAILED when raid has)
> 
> total: 0 errors, 1 warnings, 25 lines checked
> 
> It's right. Because the commit is from mdadm git. Do we use different
> checkpatch?

checkpatch is awful in general, but I agree with Mariusz, adding the
spaces is a lot prettier.

> 
>>> +                 (!access(dv_rep, R_OK) &&
>>> +                 (disks[d*2+1].state & (1<<MD_DISK_SYNC)))) {
>>
>> Could you define function for that?
>> something like (you can add access() verification if needed):
>> is_dev_alive(mdu_disk_info_t *disk)
>> {
>>         char *devnm = devid2kname(makedev..);
>>         if (devnm)
>>                 return true;
>>         return false;
>> }
> 
> Sure, it sounds better. I'll do this in the next version.
>>
>> using true/false will require to add #include <stdbool.h>.
>> Jes suggests to use meaningful return values. This is only
>> suggestion so you can ignore it and use 0 and 1.
> 
> <stdbool.h> is a c++ header and it needs libstdc++-devel, I don't want
> to include one package only for using true/false.

stdbool.h is provided by GCC directly on Fedora 33 it's
/usr/lib/gcc/x86_64-redhat-linux/10/include/stdbool.h

>> and then check:
>> if (is_dev_alive([d * 2]) & disks[d * 2].state & (1<<MD_DISK_SYNC) ||
>>     (is_dev_alive([d * 2 + 1]) & disks[d * 2 + 1].state & (1<<MD_DISK_SYNC))
>>
>> What do you think?
> 
> It's good for me.

I think using bool for this makes sense when the helper is called
'is_dev_alive()' (as much as I dislike the bool type).

Cheers,
Jes


