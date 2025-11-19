Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E4B328B51;
	Wed, 19 Nov 2025 08:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763540981; cv=none; b=DhS4r2PwiupAUWnddOUTtvvPIXcl3Tqd5zDgtl1I8YMbDrY4yz6dCHwka65ujlRNDdoNL7/SypWnuiEHoLSrGIcSZXQEWqGkjPw5mXj39LO/1z1WP31YCNQWLq2YxAmKq4qTAhW8xCyFmBI8Qau+2ahRF1Sn9asYT75XOrxmlD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763540981; c=relaxed/simple;
	bh=AMAnAe8Q6TqcZFPeIAwqnWBXuHA9Lwt9T61GA0OF1qY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PWDj7yJYTmDFmPYhxzxvz+uQxl2wO7fTaFnCLzmbEkzUAyRS3UX4w/LPh0YmDGkRrSs9Fq7VbAhpikiKpaCCDIiSoVvTZvuJODi5iFEh39kycgVEzgjeJLnOII3vYQ/azDGq3tahsNDNUM84HgFeA5sNjKyswap0EDyVsQjYiqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dBF4l5s1KzYQvGZ;
	Wed, 19 Nov 2025 16:28:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id A99501A06D7;
	Wed, 19 Nov 2025 16:29:35 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgB31Hrufx1podgWBQ--.15632S3;
	Wed, 19 Nov 2025 16:29:35 +0800 (CST)
Message-ID: <d760721e-face-7a19-ba3b-7cc59475ef77@huaweicloud.com>
Date: Wed, 19 Nov 2025 16:29:34 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/2] md/raid5: fix IO hang when array is broken with IO
 inflight
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20251117085557.770572-1-yukuai@fnnas.com>
 <20251117085557.770572-3-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251117085557.770572-3-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgB31Hrufx1podgWBQ--.15632S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGw1fJw1rKFyfZryxuryxAFb_yoW5Xw13p3
	95Za1a9ryUWFyvgayDC34Uur1Fy3WkurWYkF43Ca40van0qr9xA393GFy5GrZ8ArWFvay8
	X3W5Jry3XF48JrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07URwZ
	7UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/11/17 16:55, Yu Kuai 写道:
> Following test can cause IO hang:
> 
> mdadm -CvR /dev/md0 -l10 -n4 /dev/sd[abcd] --assume-clean --chunk=64K --bitmap=none
> sleep 5
> echo 1 > /sys/block/sda/device/delete
> echo 1 > /sys/block/sdb/device/delete
> echo 1 > /sys/block/sdc/device/delete
> echo 1 > /sys/block/sdd/device/delete
> 
> dd if=/dev/md0 of=/dev/null bs=8k count=1 iflag=direct
> 
> Root cause:
> 
> 1) all disks removed, however all rdevs in the array is still in sync,
> IO will be issued normally.
> 
> 2) IO failure from sda, and set badblocks failed, sda will be faulty
> and MD_SB_CHANGING_PENDING will be set.
> 
> 3) error recovery try to recover this IO from other disks, IO will be
> issued to sdb, sdc, and sdd.
> 
> 4) IO failure from sdb, and set badblocks failed again, now array is
> broken and will become read-only.
> 
> 5) IO failure from sdc and sdd, however, stripe can't be handled anymore
> because MD_SB_CHANGING_PENDING is set:
> 
> handle_stripe
>   handle_stripe
>   if (test_bit MD_SB_CHANGING_PENDING)
>    set_bit STRIPE_HANDLE
>    goto finish
>    // skip handling failed stripe
> 
> release_stripe
>   if (test_bit STRIPE_HANDLE)
>    list_add_tail conf->hand_list
> 
> 6) later raid5d can't handle failed stripe as well:
> 
> raid5d
>   md_check_recovery
>    md_update_sb
>     if (!md_is_rdwr())
>      // can't clear pending bit
>      return
>   if (test_bit MD_SB_CHANGING_PENDING)
>    break;
>    // can't handle failed stripe
> 
> Since MD_SB_CHANGING_PENDING can never be cleared for read-only array,
> fix this problem by skip this checking for read-only array.
> 
> Fixes: d87f064f5874 ("md: never update metadata when array is read-only.")
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/raid5.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index cdbc7eba5c54..e57ce3295292 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4956,7 +4956,8 @@ static void handle_stripe(struct stripe_head *sh)
>   		goto finish;
>   
>   	if (s.handle_bad_blocks ||
> -	    test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
> +	    (md_is_rdwr(conf->mddev) &&
> +	     test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags))) {


I am not sure where mddev->ro is set to MD_RDONLY — is it via a user's ioctl?


>   		set_bit(STRIPE_HANDLE, &sh->state);
>   		goto finish;
>   	}
> @@ -6768,7 +6769,8 @@ static void raid5d(struct md_thread *thread)
>   		int batch_size, released;
>   		unsigned int offset;
>   
> -		if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
> +		if (md_is_rdwr(mddev) &&
> +		    test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
>   			break;
>   
>   		released = release_stripe_list(conf, conf->temp_inactive_list);

-- 
Thanks,
Nan

