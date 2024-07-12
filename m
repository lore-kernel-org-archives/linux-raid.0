Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A357D645;
	Fri, 12 Jul 2024 01:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720747027; cv=none; b=gjGM00VT1vzR0UyBs1dEUC/wI5YTothLxfE1UyOFFEGvMGzgC/Vk3e3ormOhPtRM/vQlWnyIDPciJ8fWlAMzNaI7IwPzYrSNS4TEp3gRn3VS0iQuNk+b1G+1fswkurD8wW4HML2hnljuU+MBrRhlxPHJ6mhmxdWOWBfp6dM9Bd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720747027; c=relaxed/simple;
	bh=KSp2GPbV32LJLn86Yky21kRZsUJ4OoGNXE8iPmOErYA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=aYMBiRE1XpAXdO0IuLKHHQXajXWzbYZBqmR3kmOMvZo0QsL80u52ELmyDwbJ0E1pew/P07xQ6c2gsKfY8BjOK7TXEVmSDIXPkgN6qHilkXGhkfbQoA3VgBvfsbiGeMZAWIS3KsWCR0xVfY14bVg9NrK7AnkARykF561zwbxo4Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WKtwj1yh8z4f3jLh;
	Fri, 12 Jul 2024 09:16:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id ED8CA1A0184;
	Fri, 12 Jul 2024 09:17:00 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP2 (Coremail) with SMTP id Syh0CgAHvoMKhJBmZVdqBw--.37541S3;
	Fri, 12 Jul 2024 09:16:59 +0800 (CST)
Subject: Re: [PATCH] md/raid1: set max_sectors during early return from
 choose_slow_rdev()
To: =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Song Liu <song@kernel.org>,
 Paul Luse <paul.e.luse@linux.intel.com>, Xiao Ni <xni@redhat.com>,
 Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <349e4894-b6ea-6bc4-b040-4a816b6960ab@huaweicloud.com>
 <20240711202316.10775-1-mat.jonczyk@o2.pl>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e9585300-1666-ca71-8684-8824fe2ddaf1@huaweicloud.com>
Date: Fri, 12 Jul 2024 09:16:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240711202316.10775-1-mat.jonczyk@o2.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgAHvoMKhJBmZVdqBw--.37541S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAw4UXr4UGF17Xw1xJw17GFg_yoWrGFWkpa
	y8WFWYkw15JryDGw4DAw109FyrAa98GrW7Wrn3Gw17Zr1avrZF9FW7WFyagr1DCry5Wa48
	W3WqgrW5u3Wvva7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
	6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUOyCJDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/07/12 4:23, Mateusz Jończyk 写道:
> Linux 6.9+ is unable to start a degraded RAID1 array with one drive,
> when that drive has a write-mostly flag set. During such an attempt,
> the following assertion in bio_split() is hit:
> 
> 	BUG_ON(sectors <= 0);
> 
> Call Trace:
> 	? bio_split+0x96/0xb0
> 	? exc_invalid_op+0x53/0x70
> 	? bio_split+0x96/0xb0
> 	? asm_exc_invalid_op+0x1b/0x20
> 	? bio_split+0x96/0xb0
> 	? raid1_read_request+0x890/0xd20
> 	? __call_rcu_common.constprop.0+0x97/0x260
> 	raid1_make_request+0x81/0xce0
> 	? __get_random_u32_below+0x17/0x70
> 	? new_slab+0x2b3/0x580
> 	md_handle_request+0x77/0x210
> 	md_submit_bio+0x62/0xa0
> 	__submit_bio+0x17b/0x230
> 	submit_bio_noacct_nocheck+0x18e/0x3c0
> 	submit_bio_noacct+0x244/0x670
> 
> After investigation, it turned out that choose_slow_rdev() does not set
> the value of max_sectors in some cases and because of it,
> raid1_read_request calls bio_split with sectors == 0.
> 
> Fix it by filling in this variable.
> 
> This bug was introduced in
> commit dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_balance()")
> but apparently hidden until
> commit 0091c5a269ec ("md/raid1: factor out helpers to choose the best rdev from read_balance()")
> shortly thereafter.
> 
> Cc: stable@vger.kernel.org # 6.9.x+
> Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
> Fixes: dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_balance()")
> Cc: Song Liu <song@kernel.org>
> Cc: Yu Kuai <yukuai3@huawei.com>
> Cc: Paul Luse <paul.e.luse@linux.intel.com>
> Cc: Xiao Ni <xni@redhat.com>
> Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Link: https://lore.kernel.org/linux-raid/20240706143038.7253-1-mat.jonczyk@o2.pl/
> 
> --

Thanks for the patch!

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

BTW, do you have plans to add a new test to mdadm tests? I'll
pick it up if you don't, just let me know.

Thanks,
Kuai

> 
> Tested on both Linux 6.10 and 6.9.8.
> 
> Inside a VM, mdadm testsuite for RAID1 on 6.10 did not find any problems:
> 	./test --dev=loop --no-error --raidtype=raid1
> (on 6.9.8 there was one failure, caused by external bitmap support not
> compiled in).
> 
> Notes:
> - I was reliably getting deadlocks when adding / removing devices
>    on such an array - while the array was loaded with fsstress with 20
>    concurrent processes. When the array was idle or loaded with fsstress
>    with 8 processes, no such deadlocks happened in my tests.
>    This occurred also on unpatched Linux 6.8.0 though, but not on
>    6.1.97-rc1, so this is likely an independent regression (to be
>    investigated).
> - I was also getting deadlocks when adding / removing the bitmap on the
>    array in similar conditions - this happened on Linux 6.1.97-rc1
>    also though. fsstress with 8 concurrent processes did cause it only
>    once during many tests.
> - in my testing, there was once a problem with hot adding an
>    internal bitmap to the array:
> 	mdadm: Cannot add bitmap while array is resyncing or reshaping etc.
> 	mdadm: failed to set internal bitmap.
>    even though no such reshaping was happening according to /proc/mdstat.
>    This seems unrelated, though.
> ---
>   drivers/md/raid1.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7b8a71ca66dd..82f70a4ce6ed 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -680,6 +680,7 @@ static int choose_slow_rdev(struct r1conf *conf, struct r1bio *r1_bio,
>   		len = r1_bio->sectors;
>   		read_len = raid1_check_read_range(rdev, this_sector, &len);
>   		if (read_len == r1_bio->sectors) {
> +			*max_sectors = read_len;
>   			update_read_sectors(conf, disk, this_sector, read_len);
>   			return disk;
>   		}
> 
> base-commit: 256abd8e550ce977b728be79a74e1729438b4948
> 

