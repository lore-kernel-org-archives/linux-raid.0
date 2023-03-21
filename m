Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B42C74A5B
	for <linux-raid@archiver.kernel.org>; Tue, 21 Mar 2023 12:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjCUM2j (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Mar 2023 08:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjCUM2h (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Mar 2023 08:28:37 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0FA61B3
        for <linux-raid@vger.kernel.org>; Tue, 21 Mar 2023 05:28:06 -0700 (PDT)
Received: from kwepemm600010.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PgrQG5W9TzSnFd;
        Tue, 21 Mar 2023 20:24:38 +0800 (CST)
Received: from [10.174.177.197] (10.174.177.197) by
 kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 20:28:02 +0800
Subject: Re: [PATCH] Fix race of "mdadm --add" and "mdadm --incremental"
To:     Martin Wilck <mwilck@suse.com>, <jes@trained-monkey.org>,
        <pmenzel@molgen.mpg.de>, <colyli@suse.de>,
        <linux-raid@vger.kernel.org>
CC:     <miaoguanqin@huawei.com>, <louhongxiang@huawei.com>
References: <20230321085500.867948-1-lixiaokeng@huawei.com>
 <9115e7943113fc01cc4c197b2b2641617fdd4919.camel@suse.com>
From:   Li Xiao Keng <lixiaokeng@huawei.com>
Message-ID: <53283581-1490-6408-6df0-c929d7a6832b@huawei.com>
Date:   Tue, 21 Mar 2023 20:28:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9115e7943113fc01cc4c197b2b2641617fdd4919.camel@suse.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2023/3/21 17:21, Martin Wilck wrote:
> On Tue, 2023-03-21 at 16:55 +0800, Li Xiaokeng wrote:
>> From: lixiaokeng <lixiaokeng@huawei.com>
>>
>> When we add a new disk to a raid, it may return -EBUSY.
>>
>> The main process of --add:
>> 1. dev_open
>> 2. store_super1(st, di->fd) in write_init_super1
>> 3. fsync(di->fd) in write_init_super1
>> 4. close(di->fd)
>> 5. ioctl(ADD_NEW_DISK)
>>
>> However, there will be some udev(change) event after step4. Then
>> "/usr/sbin/mdadm --incremental ..." will be run, and the new disk
>> will be add to md device. After that, ioctl will return -EBUSY.
>>
>> Here we add map_lock before write_init_super in "mdadm --add"
>> to fix this race.
>>
>> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> 
> As noted in the previous thread about the topic, this will only help
> if "mdadm -I" quits when it can't lock the device. Or am I overlooking
> something?
> 

  I am sorry for missing previous email before sending patch.

  At first, I had similar doubts. But I test it, "Incremental" will
be blocked if "Add" uses map_lock. Only when open and flock return
error, map_lock() returns -1. It is hardly to happen. In commit
"ad5bc697a", the return value of map_lock() is not checked. So
I don't change the codes of the original map_lock(). If it's better
to return error when map_lock fails, I will change my patch.

Regards,
Li Xiao Keng

> Martin
> 
> .
> 
