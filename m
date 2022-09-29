Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B5CC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 29 Sep 2022 15:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbiI2PG4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Sep 2022 11:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbiI2PGz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Sep 2022 11:06:55 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5846E10BB2A
        for <linux-raid@vger.kernel.org>; Thu, 29 Sep 2022 08:06:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664463949; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=PXfkNKLLzCwzvC4hfenfJEzyT6QIlDC3V0j/H4KSMVSn7BcgBqhX1NchPJWzGNq3pZ6O+diwnj1jQ05EyG/qZlbj/73lroee33QMjuZ0JQN3PJc6K+cTLvGhYQf+9x/OJl7wTsFm3vxBUzhWs8WrlKwWheArPZ2r3W/rgZRok9I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1664463949; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=dlgHV99/ifn1ba4bAcm3un/CzugEt5rOFBeoR5fuYGE=; 
        b=I7RKNNtSGEdR020FBRAxAazacVXrk7acEcYgGvOEcTJTysXbYfrDG9rimGeGyD22A1JmXnWYjuG7rj/afb4+BHcNNWeu7Jb5AsWZIlAPoLKFY7D1WrFzENyHuSv7+zFX8DZkXTkxkcIhz+GsB6P42SLJ/rx9mCnJdc2lu5oMFMo=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 166446394645728.64320462781393; Thu, 29 Sep 2022 17:05:46 +0200 (CEST)
Date:   Thu, 29 Sep 2022 11:05:44 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v4] mdadm: replace container level checking with inline
Content-Language: en-US
To:     Coly Li <colyli@suse.de>, Kinga Tanska <kinga.tanska@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20220902064923.19955-1-kinga.tanska@intel.com>
 <CBEBAEB3-59DC-4756-9393-3709C0306F59@suse.de>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <a644fd31-1d05-9c35-6612-06d0577c2506@trained-monkey.org>
In-Reply-To: <CBEBAEB3-59DC-4756-9393-3709C0306F59@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/3/22 03:11, Coly Li wrote:
> 
> 
>> 2022年9月2日 14:49，Kinga Tanska <kinga.tanska@intel.com> 写道：
>>
>> To unify all containers checks in code, is_container() function is
>> added and propagated.
>>
>> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> 
> Acked-by: Coly Li <colyli@suse.de>
> 
> 
> But this patch has a minor conflict with Mateusz’s “Manage: Block unsafe member failing” series, it is simply because your patch landed a bit late than Mateusz’s.
> I already rebased your patch in the mdadm-CI queue. After I finish to review all the pending patches, let’s see whether you should post a v6 version or I can post the rebased one for you.

Applied!

I pulled in this one since the Block series also had a conflict and this
one applied cleanly.

Thanks,
Jes


> Thanks.
> 
> Coly Li
> 
> 
>> ---
>> Assemble.c    |  7 +++----
>> Create.c      |  6 +++---
>> Grow.c        |  6 +++---
>> Incremental.c |  4 ++--
>> mdadm.h       | 14 ++++++++++++++
>> super-ddf.c   |  6 +++---
>> super-intel.c |  4 ++--
>> super0.c      |  2 +-
>> super1.c      |  2 +-
>> sysfs.c       |  2 +-
>> 10 files changed, 33 insertions(+), 20 deletions(-)
>>
>> diff --git a/Assemble.c b/Assemble.c
>> index 1dd82a8c..8b0af0c9 100644
>> --- a/Assemble.c
>> +++ b/Assemble.c
>>
> [snipped]
> 
>> @@ -1809,7 +1808,7 @@ try_again:
>> 		}
>> #endif
>> 	}
>> -	if (c->force && !clean && content->array.level != LEVEL_CONTAINER &&
>> +	if (c->force && !clean && !is_container(content->array.level) &&
>> 	    !enough(content->array.level, content->array.raid_disks,
>> 		    content->array.layout, clean, avail)) {
>> 		change += st->ss->update_super(st, content, "force-array”,
> 
> 
> The conflict is here, and the rebased change looks like this,
> 
> @@ -1807,7 +1806,7 @@ try_again:
>                 }
>  #endif
>         }
> -       if (c->force && !clean && content->array.level != LEVEL_CONTAINER &&
> +       if (c->force && !clean && !is_container(content->array.level) &&
>             !enough(content->array.level, content->array.raid_disks,
>                     content->array.layout, clean, avail)) {
>                 change += st->ss->update_super(st, content, UOPT_SPEC_FORCE_ARRAY,


