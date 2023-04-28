Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1259AC77B61
	for <linux-raid@archiver.kernel.org>; Fri, 28 Apr 2023 02:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344770AbjD1CB1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Apr 2023 22:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjD1CBX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 Apr 2023 22:01:23 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F963C21
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 19:01:09 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Q6wnD4hzBz4f3jLS
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 10:01:04 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP2 (Coremail) with SMTP id Syh0CgAXvuvgKEtkVqzNIA--.21021S3;
        Fri, 28 Apr 2023 10:01:06 +0800 (CST)
Subject: Re: linux mdadm assembly error: md: cannot handle concurrent
 replacement and reshape. (reboot while reshaping)
To:     Peter Neuwirth <reddunur@online.de>, linux-raid@vger.kernel.org
References: <e2f96772-bfbc-f43b-6da1-f520e5164536@online.de>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Cc:     "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <66d84cc8-9db8-d380-8932-2c5ab7d35ec7@huaweicloud.com>
Date:   Fri, 28 Apr 2023 10:01:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e2f96772-bfbc-f43b-6da1-f520e5164536@online.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgAXvuvgKEtkVqzNIA--.21021S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCw4UXw4kXFWrAFykZFWxCrg_yoW5uw4Dpr
        1fJw13GryUGw1ktr1UGr1UXryUJr1UJw1UJr4UXFy8Jr1UAr1jqr1UXr10gryUJrW8Jr15
        Jw1UJryUZr1UGr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/04/28 5:09, Peter Neuwirth 写道:
> 
> ------------------------------------------------------------------------------------------------------------------------ 
> 
> Some Logs:
> ------------------------------------------------------------------------------------------------------------------------ 
> 
> 
> uname -a ; mdadm --version
> Linux srv11 5.10.0-21-amd64 #1 SMP Debian 5.10.162-1 (2023-01-21) x86_64 
> GNU/Linux
> mdadm - v4.1 - 2018-10-01
> 
> srv11:~# mdadm -D /dev/md0
> /dev/md0:
>             Version : 1.2
>       Creation Time : Mon Mar  6 18:17:30 2023
>          Raid Level : raid6
>       Used Dev Size : 976630272 (931.39 GiB 1000.07 GB)
>        Raid Devices : 7
>       Total Devices : 6
>         Persistence : Superblock is persistent
> 
>         Update Time : Thu Apr 27 17:36:15 2023
>               State : active, FAILED, Not Started
>      Active Devices : 5
>     Working Devices : 6
>      Failed Devices : 0
>       Spare Devices : 1
> 
>              Layout : left-symmetric-6
>          Chunk Size : 256K
> 
> Consistency Policy : unknown
> 
>          New Layout : left-symmetric
> 
>                Name : solidsrv11:0  (local to host solidsrv11)
>                UUID : 1a87479e:7513dd65:37c61ca1:43184f65
>              Events : 4700
> 
>      Number   Major   Minor   RaidDevice State
>         -       0        0        0      removed
>         -       0        0        1      removed
>         -       0        0        2      removed
>         -       0        0        3      removed
>         -       0        0        4      removed
>         -       0        0        5      removed
>         -       0        0        6      removed
> 
>         -       8       32        2      sync   /dev/sdc
>         -       8      144        4      sync   /dev/sdj
>         -       8       80        0      sync   /dev/sdf
>         -       8       16        1      sync   /dev/sdb
>         -       8      128        5      sync   /dev/sdi
>         -       8       96        4      spare rebuilding   /dev/sdg

Looks like the /dev/sdg is not the original device, above log shows that
RaidDevice 3 is missing, and /dev/sdg is replacement of /dev/sdj.

So reshapge is still in progress, and somehow sdg is the replacement of
sdj, this matches the condition in raid5_run:

7952                 if (rcu_access_pointer(conf->disks[i].replacement) &&
7953                     conf->reshape_progress != MaxSector) {
7954                         /* replacements and reshape simply do not 
mix. */
7955                         pr_warn("md: cannot handle concurrent 
replacement and reshape.\n");
7956                         goto abort;
7957                 }

I'm by no means raid5 expert but I will suggest to remove /dev/sdg and
try again to assemble.

Thanks,
Kuai

