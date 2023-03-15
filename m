Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC627C61DA4
	for <linux-raid@archiver.kernel.org>; Wed, 15 Mar 2023 10:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjCOKj7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Mar 2023 06:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbjCOKj6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Mar 2023 06:39:58 -0400
Received: from out-16.mta0.migadu.com (out-16.mta0.migadu.com [IPv6:2001:41d0:1004:224b::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EC9166D0
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 03:39:56 -0700 (PDT)
Message-ID: <3ef18a75-8a1a-aa28-47e8-cba3f60475c7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678876795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cjwxKrKQZuhNxEIYX90Y0MywU0FCiUAjpBUrtds/caE=;
        b=Ljgpx5n63CnSevp907fPbhcFVkLWOWcU55sEc/X8BC6ZdYrUls4oV0k/Jgft0DSCldHN95
        24FcMo5r7Oa7mzcvjGCj2BArbP2pX+KDRgDrv6tGFb1udqyMRm/jrLN3wT777qAmt6K38H
        MkK1OutBxTjRaKH3wURx+jbSm4NtoGU=
Date:   Wed, 15 Mar 2023 18:39:50 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 5/5] md: protect md_thread with a new disk level spin
 lock
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, agk@redhat.com,
        snitzer@kernel.org, song@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230315061810.653263-1-yukuai1@huaweicloud.com>
 <20230315061810.653263-6-yukuai1@huaweicloud.com>
 <16613534-5482-23c5-fa97-cfaedecab3d7@linux.dev>
 <7cc22b63-a2f7-67ed-1a50-9fb415fadb81@huaweicloud.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <7cc22b63-a2f7-67ed-1a50-9fb415fadb81@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 3/15/23 18:02, Yu Kuai wrote:
> Hi,
>
> 在 2023/03/15 17:39, Guoqing Jiang 写道:
>>
>>
>> On 3/15/23 14:18, Yu Kuai wrote:
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>
>>> Our test reports a uaf for 'mddev->sync_thread':
>>>
>>> T1                      T2
>>> md_start_sync
>>>   md_register_thread
>>>             raid1d
>>>              md_check_recovery
>>>               md_reap_sync_thread
>>>                md_unregister_thread
>>>                 kfree
>>>
>>>   md_wakeup_thread
>>>    wake_up
>>>    ->sync_thread was freed
>>
>> Better to provide the relevant uaf (user after free perhaps you mean)
>> log from the test.
> Ok, I'll add uaf report(the report is from v5.10) in the next version.

Can you also try with latest mainline instead of just against 5.10 kernel?

Thanks,
Guoqing
