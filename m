Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207ACC6FD1C
	for <linux-raid@archiver.kernel.org>; Wed, 22 Mar 2023 08:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjCVIi2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Mar 2023 04:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCVIi1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Mar 2023 04:38:27 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D177E1BA
        for <linux-raid@vger.kernel.org>; Wed, 22 Mar 2023 01:38:24 -0700 (PDT)
Received: from dggpemm500014.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PhMJ46QgrzKs7d;
        Wed, 22 Mar 2023 16:36:04 +0800 (CST)
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 16:38:21 +0800
Message-ID: <02dac455-df48-a1b0-839f-ffb934024f32@huawei.com>
Date:   Wed, 22 Mar 2023 16:38:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] raid0: fix set_disk_faulty doesn't return -EBUSY
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
CC:     <song@kernel.org>, <linux-raid@vger.kernel.org>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        <louhongxiang@huawei.com>
References: <df1fc8d7-0a34-aef7-aeeb-db4f59755f78@huawei.com>
 <20230321111828.0000172d@linux.intel.com>
 <91f6086c-249d-167c-4948-1359d7b4115b@huawei.com>
 <20230322080541.00004e8a@linux.intel.com>
From:   Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <20230322080541.00004e8a@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



在 2023/3/22 15:05, Mariusz Tkaczyk 写道:
> On Wed, 22 Mar 2023 10:24:41 +0800
> Wu Guanghao <wuguanghao3@huawei.com> wrote:
> 
>> 在 2023/3/21 18:18, Mariusz Tkaczyk 写道:
>>> On Tue, 21 Mar 2023 16:56:37 +0800
>>> Wu Guanghao <wuguanghao3@huawei.com> wrote:
>>>   
>>>> The latest kernel version will not report an error through mdadm
>>>> set_disk_faulty.
>>>>
>>>> $ lsblk
>>>> sdb                                           8:16   0   10G  0 disk
>>>> └─md0                                         9:0    0 19.9G  0 raid0
>>>> sdc                                           8:32   0   10G  0 disk
>>>> └─md0                                         9:0    0 19.9G  0 raid0
>>>>
>>>> old kernel:
>>>> ...
>>>> $ mdadm /dev/md0 -f /dev/sdb
>>>> mdadm: set device faulty failed for /dev/sdb:  Device or resource busy
>>>> ...
>>>>
>>>> latest kernel:
>>>> ...
>>>> $ mdadm /dev/md0 -f /dev/sdb
>>>> mdadm: set /dev/sdb faulty in /dev/md0
>>>> ...
>>>>
>>>> The old kernel judges whether the Faulty flag is set in rdev->flags,
>>>> and returns -EBUSY if not. And The latest kernel only return -EBUSY
>>>> if the MD_BROKEN flag is set in mddev->flags. raid0 doesn't set
>>>> error_handler, so MD_BROKEN will not be set, it will return 0.
>>>>
>>>> So if error_handler isn't set for a raid type, also return -EBUSY.  
>>> Hi,
>>> Please test with:
>>> https://lore.kernel.org/linux-raid/20230306130317.3418-1-mariusz.tkaczyk@linux.intel.com/
>>>
>>> Thanks,
>>> Mariusz
>>>   
>>
>> Hi, Mariusz
>>
>> Are there other patches?  There are other problems with this patch.
>> https://lore.kernel.org/linux-raid/20230306130317.3418-1-mariusz.tkaczyk@linux.intel.com/
>>
>> md_submit_bio()
>> 	...
>> 	// raid0 set disk faulty failed, but MD_BROKEN flag is set，
>> 	// write IO will fail.
>> 	if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw == WRITE)) {
>> 		bio_io_error(bio);
>> 		return;
>> 	}
>> 	...
>>
>> old kernel:
>> ...
>> $ mdadm /dev/md0 -f /dev/sdb
>> mdadm: set device faulty failed for /dev/sdb:  Device or resource busy
>>
>> $ mkfs.xfs /dev/md0
>> log stripe unit (524288 bytes) is too large (maximum is 256KiB)
>> log stripe unit adjusted to 32KiB
>> meta-data=/dev/md0               isize=512    agcount=16, agsize=1800064 blks
>>          =                       sectsz=512   attr=2, projid32bit=1
>>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>>          =                       reflink=1    bigtime=0 inobtcount=0
>> data     =                       bsize=4096   blocks=28801024, imaxpct=25
>>          =                       sunit=128    swidth=256 blks
>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>> log      =internal log           bsize=4096   blocks=14064, version=2
>>          =                       sectsz=512   sunit=8 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> Discarding blocks...Done.
>> ...
>>
>>
>> merged patch kernel:
>> ...
>> # mdadm /dev/md0 -f /dev/sdb
>> mdadm: set device faulty failed for /dev/sdb:  Device or resource busy
>>
>> mkfs.xfs /dev/md0
>> log stripe unit (524288 bytes) is too large (maximum is 256KiB)
>> log stripe unit adjusted to 32KiB
>> meta-data=/dev/md0               isize=512    agcount=8, agsize=65408 blks
>>          =                       sectsz=512   attr=2, projid32bit=1
>>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>>          =                       reflink=1    bigtime=0 inobtcount=0
>> data     =                       bsize=4096   blocks=523264, imaxpct=25
>>          =                       sunit=128    swidth=256 blks
>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>> log      =internal log           bsize=4096   blocks=2560, version=2
>>          =                       sectsz=512   sunit=8 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> mkfs.xfs: pwrite failed: Input/output error
>> ...
>>
>>
> Hi Wu,
> Beside the kernel, there are also patches in mdadm. Please check if you have
> them all.
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=b3e7b7eb1dfedd7cbd9a3800e884941f67d94c96
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=461fae7e7809670d286cc19aac5bfa861c29f93a
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=fc6fd4063769f4194c3fb8f77b32b2819e140fb9
> Hi, Mariusz

Thanks for your reply, I would test with the above patches.

> Some background:
> --faulty (-f) is intended to be used by administrators. We cannot rely on
> kernel answer because if mdadm will try to set device faulty, it results in
> MD_BROKEN and every new IO will be failed (and that is intended change).
> 
> Simply, mdadm must check first if it can remove the drive and that was added by
> the mentioned patches. The first patch (the last one) added verification but
> brings regression, the next two patches are fixes for omitted scenarios.
> 
> Thanks,
> Mariusz
> .

> 
