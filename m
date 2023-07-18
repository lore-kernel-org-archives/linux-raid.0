Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C8DEB64DA
	for <linux-raid@archiver.kernel.org>; Tue, 18 Jul 2023 09:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbjGRJ0o (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Jul 2023 05:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbjGRJ0j (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 Jul 2023 05:26:39 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355181FC1
        for <linux-raid@vger.kernel.org>; Tue, 18 Jul 2023 02:26:13 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4R4tqB2VT5z4f3lX2
        for <linux-raid@vger.kernel.org>; Tue, 18 Jul 2023 17:25:58 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCHLaGnWrZktGD8OA--.15318S3;
        Tue, 18 Jul 2023 17:26:00 +0800 (CST)
Subject: Re: Corrupted RAID 1
To:     Leslie Rhorer <lesrhorer@att.net>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <d44dd435-46e8-f40c-e8cf-24e6c6e93687.ref@att.net>
 <d44dd435-46e8-f40c-e8cf-24e6c6e93687@att.net>
Cc:     "yukuai (C)" <yukuai3@huawei.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b4bd295a-25a2-c66d-0bdc-29cdf402bbbb@huaweicloud.com>
Date:   Tue, 18 Jul 2023 17:25:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d44dd435-46e8-f40c-e8cf-24e6c6e93687@att.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCHLaGnWrZktGD8OA--.15318S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CFWxZF4DKF18ur1xtryUGFg_yoW8Cr17p3
        9Yqr4YkFykAF1fC34rGa1Iyay8GrsxJa98Krn5Ja4xu3W3Ww1jqFya93yYq3W29rnYgFyj
        vr4UKw1fuFnrWaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
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
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/07/14 4:58, Leslie Rhorer 写道:
>      I have a corrupted bootable RAID 1 array on a pair of SDD drives, 
> and I fear I need some assistance.  Actually, there are four partitions 
> on each drive, and two RAID 1 arrays were assembled from each drive.  
> When working properly, the second pair of partitions were mounted as / 
> and the first pair were mounted as /boot.  The OS is Debian Buster.  
> When I attempt to boot the system, it goes directly to the GRUB prompt.
> 
>      I pulled the drives and attached them to an active system.  Mdadm 
> reports both partition tables to be intact with partition labels of fd, 
> 83, ef, and 82, respectively and MBR magic of aa55.  When I try to 
> assemble any array says the partitions exist but are not md arrays.
> 
>      Fdisk reports the partition types as Linux raid autodetect, Linux, 
> EFI, and Linux swap / Solaris.  The EFI partitions are marked bootable 
> and contain the following:
> 
> total 3472
> -rwxr-xr-x 1 root root     108 May 28  2022 BOOTX64.CSV
> -rwxr-xr-x 1 root root   84648 May 28  2022 fbx64.efi
> -rwxr-xr-x 1 root root     152 May 28  2022 grub.cfg
> -rwxr-xr-x 1 root root 1672576 May 28  2022 grubx64.efi
> -rwxr-xr-x 1 root root  845480 May 28  2022 mmx64.efi
> -rwxr-xr-x 1 root root  934240 May 28  2022 shimx64.efi
> 
>      Any suggestions?  I should say that the running system
> (Bullseye) is not the same version as the failed one (Buster).  Of 
> course the failed system does need to be upgraded, but there are 
> specific reasons why this is quite undesirable at this point.
> .

There really is not enough information, what is the kernel version?
And in the active system, what mdadm cmds you're using and what's the
result? (And please show us the result of mdadm -E /dev/[partition]).

Thanks,
Kuai
> 

