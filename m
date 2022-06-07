Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B3CC43334
	for <linux-raid@archiver.kernel.org>; Tue,  7 Jun 2022 07:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiFGHgJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Jun 2022 03:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiFGHgI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Jun 2022 03:36:08 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB904674DC
        for <linux-raid@vger.kernel.org>; Tue,  7 Jun 2022 00:36:06 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LHMZh3m53zjYmS;
        Tue,  7 Jun 2022 15:35:08 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 7 Jun 2022 15:36:05 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 7 Jun 2022 15:36:04 +0800
Message-ID: <739e0bdb-7856-8d2d-b1fb-40bd52718f7a@huawei.com>
Date:   Tue, 7 Jun 2022 15:36:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH 4/5] find_disk_attached_hba: fix memleak
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
CC:     <jes@trained-monkey.org>, <linux-raid@vger.kernel.org>,
        <linfeilong@huawei.com>, <lixiaokeng@huawei.com>
References: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
 <12e34ddf-6e60-ab5f-020d-bd004fbbef06@huawei.com>
 <20220531100412.0000440a@linux.intel.com>
From:   Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <20220531100412.0000440a@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

在 2022/5/31 16:04, Mariusz Tkaczyk 写道:
> On Tue, 31 May 2022 14:50:44 +0800
> Wu Guanghao <wuguanghao3@huawei.com> wrote:
> 
>> If disk_path = diskfd_to_devpath(), we need free(disk_path) before
>> return, otherwise there will be a memory leak
>>
>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
>> ---
>>  super-intel.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/super-intel.c b/super-intel.c
>> index ef21ffba..98fb63d5 100644
>> --- a/super-intel.c
>> +++ b/super-intel.c
>> @@ -700,8 +700,11 @@ static struct sys_dev* find_disk_attached_hba(int fd,
>> const char *devname) return 0;
>>
>>  	for (elem = list; elem; elem = elem->next)
>> -		if (path_attached_to_hba(disk_path, elem->path))
>> +		if (path_attached_to_hba(disk_path, elem->path)) {
>> +			if (disk_path != devname)
>> +				free(disk_path);
>>  			return elem;
>> +		}
>>
>>  	if (disk_path != devname)
>>  		free(disk_path);
> 
> Patch is obviously correct but we can avoid code duplication:
> 
> 	for (elem = list; elem; elem = elem->next)
> 		if (path_attached_to_hba(disk_path, elem->path))
> 			break;
> 
> 	if (disk_path != devname)
> 		free(disk_path);
> 
> 	return elem;
> 
> Last list element will be NULL anyway. Could you adopt it?
> 
Sure, I follow your advices and keep you updated about patch V2.
> Thanks,
> Mariusz
> 
> .
> 
