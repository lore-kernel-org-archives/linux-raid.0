Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFE5C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 01:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbhLJBZw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 20:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbhLJBZv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 20:25:51 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B4DC061746
        for <linux-raid@vger.kernel.org>; Thu,  9 Dec 2021 17:22:17 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639099335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aSnrE3NeMY9Wz0xjCLON/6MuLGno2E07XDkwQCjC3rw=;
        b=Z8RZy98k5+HQ6EuoHUpGbe1mmO1FVDBHkPYtd2H9OsXI89Sy4PiFuYE0kL9ymKULrR0QAQ
        WeSuHW6uhxXjAwyIWply+QARXOfvNSzRD/UE9g43TxlN4hwlJJ34n9QIM69dl4h1LlLk2k
        TOO++vNRdXTXX1k0tcYebXZyTdBXfXI=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH 1/2] md/raid0: Free r0conf memory when register integrity
 failed
To:     Song Liu <song@kernel.org>, Xiao Ni <xni@redhat.com>
Cc:     Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <1639029324-4026-1-git-send-email-xni@redhat.com>
 <1639029324-4026-2-git-send-email-xni@redhat.com>
 <CAPhsuW48S-L9QTH6q_7+Nq0+MmOfswPu5epMq=bkGokxBRE2ew@mail.gmail.com>
Message-ID: <978b1c0a-2ba0-d736-8e3c-99a15997b7d5@linux.dev>
Date:   Fri, 10 Dec 2021 09:22:11 +0800
MIME-Version: 1.0
In-Reply-To: <CAPhsuW48S-L9QTH6q_7+Nq0+MmOfswPu5epMq=bkGokxBRE2ew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/10/21 2:02 AM, Song Liu wrote:
> On Wed, Dec 8, 2021 at 9:55 PM Xiao Ni<xni@redhat.com>  wrote:
>> It doesn't free memory when register integrity failed. And move
>> free conf codes into a single function.
>>
>> Signed-off-by: Xiao Ni<xni@redhat.com>
>> ---
>>   drivers/md/raid0.c | 18 +++++++++++++++---
>>   1 file changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>> index 62c8b6adac70..3fa47df1c60e 100644
>> --- a/drivers/md/raid0.c
>> +++ b/drivers/md/raid0.c
>> @@ -356,6 +356,7 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
>>          return array_sectors;
>>   }
>>
>> +static void free_conf(struct r0conf *conf);
>>   static void raid0_free(struct mddev *mddev, void *priv);
>>
>>   static int raid0_run(struct mddev *mddev)
>> @@ -413,19 +414,30 @@ static int raid0_run(struct mddev *mddev)
>>          dump_zones(mddev);
>>
>>          ret = md_integrity_register(mddev);
>> +       if (ret)
>> +               goto free;
>>
>>          return ret;
>> +
>> +free:
>> +       free_conf(conf);
> Can we just use raid0_free() here? Also, after freeing conf,
> we should set mddev->private to NULL.

Agree, like what raid1_run did. And we might need to check the
return value of pers->run in level_store as well.

Thanks,
Guoqing
