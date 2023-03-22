Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0DBC6FD1D
	for <linux-raid@archiver.kernel.org>; Wed, 22 Mar 2023 02:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjCVCYy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Mar 2023 22:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjCVCYx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Mar 2023 22:24:53 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72935A1B2
        for <linux-raid@vger.kernel.org>; Tue, 21 Mar 2023 19:24:51 -0700 (PDT)
Received: from dggpemm500014.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PhC2X4jQ8zrW4f;
        Wed, 22 Mar 2023 10:23:48 +0800 (CST)
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 10:24:49 +0800
Message-ID: <91f6086c-249d-167c-4948-1359d7b4115b@huawei.com>
Date:   Wed, 22 Mar 2023 10:24:41 +0800
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
From:   Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <20230321111828.0000172d@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



在 2023/3/21 18:18, Mariusz Tkaczyk 写道:
> On Tue, 21 Mar 2023 16:56:37 +0800
> Wu Guanghao <wuguanghao3@huawei.com> wrote:
> 
>> The latest kernel version will not report an error through mdadm
>> set_disk_faulty.
>>
>> $ lsblk
>> sdb                                           8:16   0   10G  0 disk
>> └─md0                                         9:0    0 19.9G  0 raid0
>> sdc                                           8:32   0   10G  0 disk
>> └─md0                                         9:0    0 19.9G  0 raid0
>>
>> old kernel:
>> ...
>> $ mdadm /dev/md0 -f /dev/sdb
>> mdadm: set device faulty failed for /dev/sdb:  Device or resource busy
>> ...
>>
>> latest kernel:
>> ...
>> $ mdadm /dev/md0 -f /dev/sdb
>> mdadm: set /dev/sdb faulty in /dev/md0
>> ...
>>
>> The old kernel judges whether the Faulty flag is set in rdev->flags,
>> and returns -EBUSY if not. And The latest kernel only return -EBUSY
>> if the MD_BROKEN flag is set in mddev->flags. raid0 doesn't set error_handler,
>> so MD_BROKEN will not be set, it will return 0.
>>
>> So if error_handler isn't set for a raid type, also return -EBUSY.
> Hi,
> Please test with:
> https://lore.kernel.org/linux-raid/20230306130317.3418-1-mariusz.tkaczyk@linux.intel.com/
> 
> Thanks,
> Mariusz
> 

Hi, Mariusz

Are there other patches?  There are other problems with this patch.
https://lore.kernel.org/linux-raid/20230306130317.3418-1-mariusz.tkaczyk@linux.intel.com/

md_submit_bio()
	...
	// raid0 set disk faulty failed, but MD_BROKEN flag is set，
	// write IO will fail.
	if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw == WRITE)) {
		bio_io_error(bio);
		return;
	}
	...

old kernel:
...
$ mdadm /dev/md0 -f /dev/sdb
mdadm: set device faulty failed for /dev/sdb:  Device or resource busy

$ mkfs.xfs /dev/md0
log stripe unit (524288 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=/dev/md0               isize=512    agcount=16, agsize=1800064 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=28801024, imaxpct=25
         =                       sunit=128    swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=14064, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Discarding blocks...Done.
...


merged patch kernel:
...
# mdadm /dev/md0 -f /dev/sdb
mdadm: set device faulty failed for /dev/sdb:  Device or resource busy

mkfs.xfs /dev/md0
log stripe unit (524288 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=/dev/md0               isize=512    agcount=8, agsize=65408 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=523264, imaxpct=25
         =                       sunit=128    swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
mkfs.xfs: pwrite failed: Input/output error
...


Regards,
Wu
>>
>> Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
>> ---
>>  drivers/md/md.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 927a43db5dfb..b1786ff60d97 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -2928,10 +2928,10 @@ state_store(struct md_rdev *rdev, const char *buf,
>> size_t len) int err = -EINVAL;
>>         bool need_update_sb = false;
>>
>> -       if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
>> -               md_error(rdev->mddev, rdev);
>> +       if (cmd_match(buf, "faulty") && mddev->pers) {
>> +               md_error(mddev, rdev);
>>
>> -               if (test_bit(MD_BROKEN, &rdev->mddev->flags))
>> +               if (!mddev->pers->error_handler || test_bit(MD_BROKEN,
>> &mddev->flags)) err = -EBUSY;
>>                 else
>>                         err = 0;
>> @@ -7421,7 +7421,7 @@ static int set_disk_faulty(struct mddev *mddev, dev_t
>> dev) err =  -ENODEV;
>>         else {
>>                 md_error(mddev, rdev);
>> -               if (test_bit(MD_BROKEN, &mddev->flags))
>> +               if (!mddev->pers->error_handler || test_bit(MD_BROKEN,
>> &mddev->flags)) err = -EBUSY;
>>         }
>>         rcu_read_unlock();
>> --
>> 2.27.0
>> .
> 
> 
> .
> 
