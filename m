Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDED8C6FD1F
	for <linux-raid@archiver.kernel.org>; Wed, 15 Mar 2023 02:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjCOCZf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 22:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCOCZe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 22:25:34 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E257E24717
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 19:25:32 -0700 (PDT)
Received: from kwepemm600010.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PbvNj2rfLzrSpl;
        Wed, 15 Mar 2023 10:24:37 +0800 (CST)
Received: from [10.174.177.197] (10.174.177.197) by
 kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 10:25:30 +0800
Subject: Re: [QUESTION] How to fix the race of "mdadm --add" and "mdadm mdadm
 --incremental --export"
To:     Coly Li <colyli@suse.de>
CC:     Jes Sorensen <jes@trained-monkey.org>,
        Martin Wilck <mwilck@suse.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        <linux-raid@vger.kernel.org>, linfeilong <linfeilong@huawei.com>,
        <louhongxiang@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
References: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
 <D83807D8-A971-4503-9D77-7496EE59E597@suse.de>
From:   Li Xiao Keng <lixiaokeng@huawei.com>
Message-ID: <2821e13a-c30f-f4dd-c336-2678acf1163d@huawei.com>
Date:   Wed, 15 Mar 2023 10:25:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <D83807D8-A971-4503-9D77-7496EE59E597@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.197]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2023/3/15 0:40, Coly Li wrote:
> 
> 
>> 2023年3月14日 22:58，Li Xiao Keng <lixiaokeng@huawei.com> 写道：
>>
>> Hi,
>>   Here we meet a question. When we add a new disk to a raid, it may return
>> -EBUSY.
>>   The main process of --add（for example md0, sdf):
>>       1.dev_open(sdf)
>>       2.add_to_super
>>       3.write_init_super
>>       4.fsync(fd)
>>       5.close(fd)
>>       6.ioctl(ADD_NEW_DISK).
>>   However, there will be some udev(change of sdf) event after step5. Then
>> "/usr/sbin/mdadm --incremental --export $devnode --offroot $env{DEVLINKS}"
>> will be run, and the sdf will be added to md0. After that, step6 will return
>> -EBUSY.
>>   It is a problem to user. First time adding disk does not return success
>> but disk is actually added. And I have no good idea to deal with it. Please
>> give some great advice.
> 
> BTW, may I ask what is the mdadm version used in the above scenario?
> 
The mdadm version is 4.1. After read the newest upstream code, I think
the problem also exists.

> Thanks.
> 
> Coly Li
> 
> .
> 

Regards
Li Xiao Keng
