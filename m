Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A319CC6FD1D
	for <linux-raid@archiver.kernel.org>; Wed, 15 Mar 2023 13:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjCONLY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbjCONLJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Mar 2023 09:11:09 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6392068B
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 06:11:03 -0700 (PDT)
Received: from kwepemm600010.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Pc9fp0Vy6zSkly;
        Wed, 15 Mar 2023 21:07:46 +0800 (CST)
Received: from [10.174.177.197] (10.174.177.197) by
 kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 21:11:00 +0800
Subject: Re: [QUESTION] How to fix the race of "mdadm --add" and "mdadm mdadm
 --incremental --export"
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Martin Wilck <mwilck@suse.com>, Song Liu <song@kernel.org>
CC:     Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>, Coly Li <colyli@suse.de>,
        <linux-raid@vger.kernel.org>, linfeilong <linfeilong@huawei.com>,
        <louhongxiang@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
References: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
 <c00c211a3126d7a30c662117d28f3a4a9c81f7dc.camel@suse.com>
 <20230314165938.00003030@linux.intel.com>
 <04a4cc6aac10cd24d5bc0b3485d47f6ccb752eab.camel@suse.com>
 <20230315111027.0000372d@linux.intel.com>
From:   Li Xiao Keng <lixiaokeng@huawei.com>
Message-ID: <cbea1358-768d-d5f7-5733-06687ad3243a@huawei.com>
Date:   Wed, 15 Mar 2023 21:10:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20230315111027.0000372d@linux.intel.com>
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



On 2023/3/15 18:10, Mariusz Tkaczyk wrote:
> On Tue, 14 Mar 2023 17:11:06 +0100
> Martin Wilck <mwilck@suse.com> wrote:
> 
>> On Tue, 2023-03-14 at 16:59 +0100, Mariusz Tkaczyk wrote:
>>> On Tue, 14 Mar 2023 16:04:23 +0100
>>> Martin Wilck <mwilck@suse.com> wrote:
>>>   
>>>> On Tue, 2023-03-14 at 22:58 +0800, Li Xiao Keng wrote:  
>>>>> Hi,
>>>>>    Here we meet a question. When we add a new disk to a raid, it
>>>>> may
>>>>> return
>>>>> -EBUSY.
>>>>>    The main process of --add（for example md0, sdf):
>>>>>        1.dev_open(sdf)
>>>>>        2.add_to_super
>>>>>        3.write_init_super
>>>>>        4.fsync(fd)
>>>>>        5.close(fd)
>>>>>        6.ioctl(ADD_NEW_DISK).
>>>>>    However, there will be some udev(change of sdf) event after
>>>>> step5.
>>>>> Then
>>>>> "/usr/sbin/mdadm --incremental --export $devnode --offroot
>>>>> $env{DEVLINKS}"
>>>>> will be run, and the sdf will be added to md0. After that, step6
>>>>> will
>>>>> return
>>>>> -EBUSY.
>>>>>    It is a problem to user. First time adding disk does not
>>>>> return
>>>>> success
>>>>> but disk is actually added. And I have no good idea to deal with
>>>>> it.
>>>>> Please
>>>>> give some great advice.    
>>>>
>>>> I haven't looked at the code in detail, but off the top of my head,
>>>> it
>>>> should help to execute step 5 after step 6. The close() in step 5
>>>> triggers the uevent via inotify; doing it after the ioctl should
>>>> avoid
>>>> the above problem.  
>>> Hi,
>>> That will result in EBUSY in everytime. mdadm will always handle
>>> descriptor and kernel will refuse to add the drive.  
>>
>> Why would it cause EBUSY? Please elaborate. My suggestion would avoid
>> the race described by Li Xiao Keng. I only suggested to postpone the
>> close(), nothing else. The fsync() would still be done before the
>> ioctl, so the metadata should be safely on disk when the ioctl is run.
> 
> Because device will be claimed in userspace by mdadm. MD may check if device
> is not claimed. I checked bind_rdev_to_array() and I don't find an obvious
> answer, so I could be wrong here.
> 
  I test move close() after ioctl(). The reason of EBUSY is that mdadm
open(sdf) with O_EXCL. So fd should be closed before ioctl. When I remove
O_EXCL, ioctl() will return success. I guess MD check if device is not
claimed in md_import_device()->lock_rdev()->blkdev_get_by_dev()->blkdev_get().

> Maybe someone more kernel experienced can speak here? Song, could you look?
> 
> I think that the descriptor opened by incremental block kernel from adding the
> device to the array but also the same incremental is able to add it later
> because metadata is on device. There is no retry in Manage_add() flow so it
> must be added by Incremental so the question is if it is already in
> array or disk is just claimed and that is the problem.
> 
> Eventually, you can test your proposal that should gives us an answer.
> 
>>
>> This is a recurring pattern. Tools that manipulate block devices must
>> be aware that close-after-write triggers an uevent, and should make
>> sure that they don't close() such files prematurely.
> 
> Agree. Mdadm has this problem, descriptors are opened and closed may times.

Yes, there is closing descriptors in write_init_super1, Kill(),
tst->ss->free_super(tst) between fsync() and ioctl().

>>
>>>>
>>>> Another obvious workaround in mdadm would be to check the state of
>>>> the
>>>> array in the EBUSY case and find out that the disk had already been
>>>> added.
>>>>
>>>> But again, this was just a high-level guess.
>>>>
>>>> Martin
>>>>   
>>>
>>> Hmm... I'm not a native expert but why we cannot write metadata after
>>> adding
>>> drive to array? Why kernel can't handle that?
>>>
> 
> Ok, there is an assumption in kernel that device MUST have metadata.
> 
>>> Ideally, we should lock device and block udev- I know that there is
>>> flock
>>> based API to do that but I'm not sure if flock() won't cause the same
>>> problem.  
>>
>> That doesn't work reliably. At least not in general. The mechanmism is
>> disabled for for dm devices (e.g. multipath), for example. See
>> https://github.com/systemd/systemd/blob/a5c0ad9a9a2964079a19a1db42f79570a3582bee/src/udev/udevd.c#L483
>>
> Yeah, I know but udev processes the disk, not MD device so the locking
> should work. But if we cannot trust it, we shouldn't follow this idea.
>>  
>>> There is also something like "udev-md-raid-creating.rules". Maybe we
>>> can reuse
>>> it?
>>>   
>>
>> Unless I am mistaken, these rules are exactly those that cause the
>> issue we are discussing. Since these rules are also part of the mdadm
>> package, it might be possible to set some flag under /run that would
>> indicate to the rules that auto-assembly should be skipped. But that
>> might be racy, too.
> 
> Yeah, bad idea. Agree.
> 
> New day, new ideas:
> - why we cannot let udev to add the device? just write metadata and finish,
>   udev should handle that because metadata is there.
  If we let udev to add the device, We cannot determine whether the disk is
added successfully from the command ("--add") return value. For example,
writing metadata succeeded, but udev failed.
> 
> - incremental uses map_lock() to prevent concurrent updates, I seems to b
>   missed for --add. That could be a key to prevent the behavior.Incremental is
>   checking if it can lock the map file. If not, it finishes gracefully. To lock
>   array we need to read metadata first, so it goes to the first question- is it
>   a problem that incremental has opened descriptor?
> 
> Thanks,
> Mariusz
> .
> 
