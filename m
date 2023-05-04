Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A8AC7EE21
	for <linux-raid@archiver.kernel.org>; Thu,  4 May 2023 08:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjEDIYK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 May 2023 04:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjEDIX2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 May 2023 04:23:28 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0367DA5
        for <linux-raid@vger.kernel.org>; Thu,  4 May 2023 01:17:14 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QBmr16m15z4f3mLh
        for <linux-raid@vger.kernel.org>; Thu,  4 May 2023 16:16:49 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3X7PyaVNkwFbsIg--.27310S3;
        Thu, 04 May 2023 16:16:51 +0800 (CST)
Subject: Re: linux mdadm assembly error: md: cannot handle concurrent
 replacement and reshape. (reboot while reshaping)
To:     Peter Neuwirth <reddunur@online.de>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
References: <e2f96772-bfbc-f43b-6da1-f520e5164536@online.de>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <34d38acf-64aa-d9c1-e603-a4551612b8ac@huaweicloud.com>
Date:   Thu, 4 May 2023 16:16:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e2f96772-bfbc-f43b-6da1-f520e5164536@online.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3X7PyaVNkwFbsIg--.27310S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww1rAFW3tF43Ww1UGr4rKrg_yoW8ury3pa
        93JF45Kr4vgwsav3ykZrW8XF15GFy8ZrZ8GrWrt3yxA390gr10v34rJa1YgF4DGF1S9w47
        XryFk395CFWYva7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2023/04/28 5:09, Peter Neuwirth 写道:
> Hello linux-raid group.
> 
> I have an issue with my linux raid setup and I hope somebody here
> could help me get my raid active again without data loss.
> 
> I have a debian 11 system with one raid array (6x 1TB hdd drives, raid 
> level 5 )
> that was active running till today, when I added two more 1TB hdd drives
> and also changed the raid level to 6.
> 
> Note: For completition:
> 
> My raid setup month ago was
> 
> mdadm --create --verbose /dev/md0 -c 256K --level=5 --raid-devices=6  
> /dev/sdd /dev/sdc /dev/sdb /dev/sda /dev/sdg /dev/sdf
> 
> mkfs.xfs -d su=254k,sw=6 -l version=2,su=256k -s size=4k /dev/md0
> 
> mdadm --detail --scan | tee -a /etc/mdadm/mdadm.conf
> 
> update-initramfs -u
> 
> echo '/dev/md0 /mnt/data ext4 defaults,nofail,discard 0 0' | sudo tee -a 
> /etc/fstab
> 
> 
> Today I did:
> 
> mdadm --add /dev/md0 /dev/sdg /dev/sdh
> 
> sudo mdadm --grow /dev/md0 --level=6
> 
> 
> This started a growth process, I could observe with
> watch -n 1 cat /proc/mdstat
> and md0 was still usable all the day.
> Due to speedy file access reasons I paused the grow and insertion
> process today at about 50% by issue
> 
> echo "frozen" > /sys/block/md0/md/sync_action
> 
> 
> After the file access was done, I restarted the
> process with
> 
> echo reshape > /sys/block/md0/md/sync_action
>
After look into this problem, I figure out that this is how the problem
(corrupted data) triggered in the first place, while the problem that
kernel log about "md: cannot handle concurrent replacement and reshape"
is not fatal.

"echo reshape" will restart the whole process, while recorded reshape
position should be used. This is a seriously kernel bug, I'll try to fix
this soon.

By the way, "echo idle" should avoid this problem.

Thanks,
Kuai
> 
> but I saw in mdstat that it started form the scratch.
> After about 5 min I noticed, that /dev/dm0 mount was gone with
> an input/output error in syslog and I rebooted the computer, to see the
> kernel would reassemble dm0 correctly. Maybe the this was a problem,
> because the dm0 was still reshaping, I do not know..

