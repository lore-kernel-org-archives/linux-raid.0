Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F0144AB68;
	Fri, 16 Oct 2026 08:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792141086; cv=none; b=WUo4FlHcJjovbc3cpMl94MCXzH3VxUdk5QDTWY07NGeNjXLZhVkQ98DzfMFk36JAsS0+dN4CzQarv6CnozWvsPD0+3WJXosUDN6KUYtkdjY4EPcRflzKDIkEQbYpiKVAZpKHTEanZ37heyNbe5iX9IMfiO9NRzItngYN916y+bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792141086; c=relaxed/simple;
	bh=qVIji9WD0S6F+09kzf19YberFDnmc/Nupo+F4khIm/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YlNXfDdwuki+aC+l2Lrj41RSB46QaeR/WJvaet+a0leUm02il8k3DjSJmpr8ubZXmSGWv/IPFlNH2PHChgXL3bNvQKNP0GFVpbyOGdnLSp1QVmuS0rHaOtnqXjlXZuXa6IQScca9e4PyTT2ktrbcKW/ecyoMaaqphxBslkE616w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j5f3T44ryzKHMss;
	Fri, 16 Oct 2026 16:57:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7CF7640882;
	Fri, 16 Oct 2026 16:58:00 +0800 (CST)
Received: from [10.174.178.164] (unknown [10.174.178.164])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBXkO8W59FqM6mTAg--.17388S3;
	Fri, 16 Oct 2026 16:58:00 +0800 (CST)
Message-ID: <c0d6fa42-2570-4ead-98da-b7718824a35b@huaweicloud.com>
Date: Fri, 16 Oct 2026 16:57:57 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid5: reject raid4/5 with fewer than 2 devices
To: Zizhi Wo <wozizhi@huaweicloud.com>, song@kernel.org, yukuai@fygo.io,
 magiclinan@didiglobal.com, xiao@kernel.org, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yangerkun@huawei.com,
 chengzhihao1@huawei.com
References: <20261013092538.636212-1-wozizhi@huaweicloud.com>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <20261013092538.636212-1-wozizhi@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXkO8W59FqM6mTAg--.17388S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CF1Dtw1kArWxWrWUJr18Krg_yoW5JF1fp3
	yS93ZIvrn5Jryay397X3Wqga4Yqws7C3yktrZ3ZryxZw45Zr4Uu3y7GFyUWFyvv398AayU
	Ja409rWDC340krDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkq14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtVW8
	ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
	0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/



在 2026/10/13 17:25, Zizhi Wo 写道:
> From: Zizhi Wo <wozizhi@huawei.com>
> 
> A raid4/5 array assembled with a single device has data_disks == 0, which
> is then used throughout the mapping math:
>   1) as a divisor in raid5_compute_sector() (division-by-zero splat);
>   2) as a multiplier in roundup_pow_of_two(data_disks * ...) in
>      raid5_set_limits(), which makes roundup_pow_of_two(0) shift by 64,
>      yielding a shift-out-of-bounds splat.
>   ......
> 
> I reproduced this issue in my environment as well:
> 
> [  294.891435] UBSAN: shift-out-of-bounds in include/linux/log2.h:57:13
> [  294.891446] shift exponent 64 is too large for 64-bit type 'long unsigned int'
> [  294.891457] CPU: 21 UID: 0 PID: 1351 Comm: sh Not tainted 7.3.0-rc7 #112 PREEMPT(full)
> [  294.891477] Call Trace:
> [  294.891481]  <TASK>
> [  294.891486]  dump_stack_lvl+0x5d/0x80
> [  294.891525]  ubsan_epilogue+0x5/0x2b
> [  294.891538]  __ubsan_handle_shift_out_of_bounds.cold+0x5e/0x113
> [  294.891568]  raid5_set_limits+0x2da/0x497
> [  294.891618]  raid5_run.cold+0x635/0xd6e
> 
> setup_conf() already rejects raid6 with fewer than 4 devices; only the
> initial raid4/5 assembly path never had the check. Add it so a degenerate
> single-device raid4/5 is refused before data_disks is used.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>   drivers/md/raid5.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b91545ce090d..5a7839542e24 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7660,10 +7660,16 @@ static struct r5conf *setup_conf(struct mddev *mddev)
>   	if (mddev->new_level == 6 && mddev->raid_disks < 4) {
>   		pr_warn("md/raid:%s: not enough configured devices (%d, minimum 4)\n",
>   			mdname(mddev), mddev->raid_disks);
>   		return ERR_PTR(-EINVAL);
>   	}
> +	if ((mddev->new_level == 4 || mddev->new_level == 5) &&
> +	    mddev->raid_disks < 2) {
> +		pr_warn("md/raid:%s: not enough configured devices (%d, minimum 2)\n",
> +			mdname(mddev), mddev->raid_disks);
> +		return ERR_PTR(-EINVAL);
> +	}
>   
>   	if (!mddev->new_chunk_sectors ||
>   	    (mddev->new_chunk_sectors << 9) % PAGE_SIZE ||
>   	    !is_power_of_2(mddev->new_chunk_sectors)) {
>   		pr_warn("md/raid:%s: invalid chunk size %d\n",

Please ignore this patch.

I just noticed that this issue has already been fixed. Sorry for the
noise.

Thanks,
Zizhi Wo




