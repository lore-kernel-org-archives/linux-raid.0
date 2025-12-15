Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D482E1EE0
	for <linux-raid@vger.kernel.org>; Mon, 15 Dec 2025 12:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765802440; cv=none; b=ltc6xWDy/sDjB26rnNLiIuZQ1aOLqFRe/PmxODEf3V4J9xfcuGfwlKp8rLQZuHEjb9Xgrp0mx7jf9ZO8KYpBezL9B5jXzO9zarLBZc890krH01jlpFXc6dJ1zMW4IQUrZwMs4GXLYsv1yu1lu6zJRJ6Mz4Y78rLQD5AgmtDyb0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765802440; c=relaxed/simple;
	bh=og4JoqyBtgnPht6WDKEX6VZwJcvdGsSit5kZ5zzTBCk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lzl9DzzLMPy4dM41Wp8LxbaTQuKwFtS84ipYCabu1Tl0OrnBbuZg5i5j8NVlVDg2/SdLrnrjKsNrKLoIg36QEvkyZ+vY9S+BvGRU8ydDgfolNHswAFUDUF81L6GNwwmhhckZkSDz25thNO4+tGVr/JtQoKiId9dycI1WRYbilLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dVKQz1WljzKHLv3
	for <linux-raid@vger.kernel.org>; Mon, 15 Dec 2025 20:40:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 405A81A06DD
	for <linux-raid@vger.kernel.org>; Mon, 15 Dec 2025 20:40:33 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgCX+Pi_AUBpvAAdAQ--.957S3;
	Mon, 15 Dec 2025 20:40:33 +0800 (CST)
Message-ID: <7e2e95ce-3740-09d8-a561-af6bfb767f18@huaweicloud.com>
Date: Mon, 15 Dec 2025 20:40:31 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [bug report] md: Remove deprecated CONFIG_MD_MULTIPATH
To: Dan Carpenter <dan.carpenter@linaro.org>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
References: <aT-_mc1MEKdpqkdZ@stanley.mountain>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <aT-_mc1MEKdpqkdZ@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCX+Pi_AUBpvAAdAQ--.957S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KFy7uF13JF15WFy8Aw4xJFb_yoW8tF4Upa
	98uF9I9r48Aw15tw18CaySgFy5Xw4fJayDKr9xAF40v3y5Grs8GasYkF9rtrykZa4qvr1r
	X3yUJws3ZF18W3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8
	JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	_MaUUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/12/15 15:58, Dan Carpenter 写道:
> Hello Song Liu,
> 
> Commit d8730f0cf4ef ("md: Remove deprecated CONFIG_MD_MULTIPATH")
> from Dec 14, 2023 (linux-next), leads to the following Smatch static
> checker warning:
> 
> 	drivers/md/md.c:3912 analyze_sbs()
> 	warn: iterator 'i' not incremented
> 
> drivers/md/md.c
>      3883 static int analyze_sbs(struct mddev *mddev)
>      3884 {
>      3885         int i;
>      3886         struct md_rdev *rdev, *freshest, *tmp;
>      3887
>      3888         freshest = NULL;
>      3889         rdev_for_each_safe(rdev, tmp, mddev)
>      3890                 switch (super_types[mddev->major_version].
>      3891                         load_super(rdev, freshest, mddev->minor_version)) {
>      3892                 case 1:
>      3893                         freshest = rdev;
>      3894                         break;
>      3895                 case 0:
>      3896                         break;
>      3897                 default:
>      3898                         pr_warn("md: fatal superblock inconsistency in %pg -- removing from array\n",
>      3899                                 rdev->bdev);
>      3900                         md_kick_rdev_from_array(rdev);
>      3901                 }
>      3902
>      3903         /* Cannot find a valid fresh disk */
>      3904         if (!freshest) {
>      3905                 pr_warn("md: cannot find a valid disk\n");
>      3906                 return -EINVAL;
>      3907         }
>      3908
>      3909         super_types[mddev->major_version].
>      3910                 validate_super(mddev, NULL/*freshest*/, freshest);
>      3911
> --> 3912         i = 0;
>      3913         rdev_for_each_safe(rdev, tmp, mddev) {
>      3914                 if (mddev->max_disks &&
>      3915                     (rdev->desc_nr >= mddev->max_disks ||
>      3916                      i > mddev->max_disks)) {
>                                ^^^^^^^^^^^^^^^^^^^^
> The patch deleted the i++ so i is always zero.
> 
>      3917                         pr_warn("md: %s: %pg: only %d devices permitted\n",
>      3918                                 mdname(mddev), rdev->bdev,
>      3919                                 mddev->max_disks);
>      3920                         md_kick_rdev_from_array(rdev);
>      3921                         continue;
>      3922                 }
>      3923                 if (rdev != freshest) {
>      3924                         if (super_types[mddev->major_version].
>      3925                             validate_super(mddev, freshest, rdev)) {
>      3926                                 pr_warn("md: kicking non-fresh %pg from array!\n",
>      3927                                         rdev->bdev);
>      3928                                 md_kick_rdev_from_array(rdev);
>      3929                                 continue;
>      3930                         }
>      3931                 }
>      3932                 if (rdev->raid_disk >= (mddev->raid_disks - min(0, mddev->delta_disks)) &&
>      3933                     !test_bit(Journal, &rdev->flags)) {
>      3934                         rdev->raid_disk = -1;
>      3935                         clear_bit(In_sync, &rdev->flags);
>      3936                 }
>      3937         }
>      3938
>      3939         return 0;
>      3940 }
> 
> regards,
> dan carpenter
> 
> .

Hi, dan

Thanks for your report, I will fix it soon.

-- 
Thanks,
Nan

