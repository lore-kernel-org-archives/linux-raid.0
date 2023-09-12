Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1964BCA0ECF
	for <linux-raid@archiver.kernel.org>; Tue, 12 Sep 2023 07:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjILHSo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Sep 2023 03:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbjILHSn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Sep 2023 03:18:43 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29CB10C2
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 00:18:38 -0700 (PDT)
Received: from kwepemm600010.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RlFJ63f4VzrSn7;
        Tue, 12 Sep 2023 15:16:38 +0800 (CST)
Received: from [10.174.177.197] (10.174.177.197) by
 kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 12 Sep 2023 15:18:33 +0800
Subject: Re: [PATCH v3] Fix race of "mdadm --add" and "mdadm --incremental"
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
CC:     Jes Sorensen <jes@trained-monkey.org>,
        Martin Wilck <mwilck@suse.com>, Coly Li <colyli@suse.de>,
        <linux-raid@vger.kernel.org>, <louhongxiang@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
References: <a25e4d75-ebc3-0841-832c-34b8e5f4cbb7@huawei.com>
 <20230911180032.00007bbb@linux.intel.com>
From:   Li Xiao Keng <lixiaokeng@huawei.com>
Message-ID: <d1744e2f-0476-153e-11b6-662f16d54b73@huawei.com>
Date:   Tue, 12 Sep 2023 15:18:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20230911180032.00007bbb@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.197]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2023/9/12 0:00, Mariusz Tkaczyk wrote:
> On Thu, 7 Sep 2023 19:37:44 +0800
> Li Xiao Keng <lixiaokeng@huawei.com> wrote:
> 
>> There is a raid1 with sda and sdb. And we add sdc to this raid,
>> it may return -EBUSY.
>>
>> The main process of --add:
>> 1. dev_open（sdc) in Manage_add
>> 2. store_super1(st, di->fd) in write_init_super1
>> 3. fsync(fd) in store_super1
>> 4. close(di->fd) in write_init_super1
>> 5. ioctl(ADD_NEW_DISK)
>>
>> Step 2 and 3 will add sdc to metadata of raid1. There will be
>> udev(change of sdc) event after step4. Then "/usr/sbin/mdadm
>> --incremental --export $devnode --offroot $env{DEVLINKS}"
>> will be run, and the sdc will be added to the raid1. Then
>> step 5 will return -EBUSY because it checks if device isn't
>> claimed in md_import_device()->lock_rdev()->blkdev_get_by_dev()
>> ->blkdev_get().  
>>
>> It will be confusing for users because sdc is added first time.
>> The "incremental" will get map_lock before add sdc to raid1.
>> So we add map_lock before write_init_super in "mdadm --add"
>> to fix the race of "add" and "incremental".
>>
>> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
>> Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
> 
> Hello Li Xiao Keng,
> Thanks for the patch, I'm trying to get my head around this.
> As I understand, you added a mapfile locking and you are failing when the log
> is already claimed, but you prefer to return -1 and print error instead of
> returning EBUSY, right?
No, I do not prefer to return -1 and print error instead of returning EBUSY.
At first, I had the same idea as Martin, thinking that map_lock() would fail when
it is locked by someone else.Actually it is not fail but block. So now I just
print error and go ahead if map_lock() fails, like map_lock() elsewhere.
> 
> If yes, it has nothing to do with fixing. It is just a obscure hack to make it,
> let say more reliable. We can either get EBUSY and know that is expected. I
> see no difference, your solution is same confusing as current implementation.
> 
> Also, you used map_lock(). I remember that initially I proposed - my bad.
> We also rejected udev locking, as a buggy. In fact- I don't see ready
> synchronization method to avoid this race in mdadm right now.
> 
> The best way, I see is:
> 1. Write metadata.
> 2. Give udev chance to process the device.
> 3. Add it manually if udev failed (or D_NO_UDEV).
Is there any command to only write metadata?  Or change implementation of --add ?
> 
> If it does not work for you, we need to add synchronization, I know that there
> is pidfile used for mdmon, perhaps we can reuse it? We don't need something
> fancy, just something to keep all synchronised and block incremental to led
> --add finish the action.
> 
> We cannot use map_lock() and map_unlock() in this context. It claims lock on
> mapfile which describes every array in your system (base details, there is no
> info about members), see /var/run/mdadm. Add is just a tiny action to add disk
> and we are not going to update the map. Taking this lock will make --add
> more vulnerable, for example it will fail because another array is assembled or
> created in the same time (I know that it will be hard to achieve but it is
> another race - we don't want it).
When I test this patch, I find map_lock(）in --incremental is block but not fail.
So I think it will not fail when another array is assembled.
> 
> And we cannot allow for partially done action, you added this lock after
> writing metadata (according to description), we are not taking this lock to
> complete the action, just to hide race. Lock should be taken before
> writing metadata, but we know that it will not hide an issue.
Here I add map_lock() before writing metadata and ulock it until finish. Do you
mean it should be before attempt_re_add()?
> 
> In this for it cannot be merged I don't see a gain, we are returning -1 instead
> -22, what is the difference? I don't see error message as more meaningful nowThis patch just wants to make "--add" success.

