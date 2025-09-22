Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD15F23CB;
	Mon, 22 Sep 2025 00:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758502346; cv=none; b=YEZFCDJEhdPrWz5nLIHM7Fb+lgkwiO+MYWcgX6vi4CmbBDCecO20qT75mwdWMEhTGO+7prOHONCFHY6Pv84PpNwciczMgZGKcbXDUUPtcgLJqQobtQiheWcklJwRQrNDglqzkZQAT9Kh//WS0TfFk4/fpRI5UuZVBycwiYBlr1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758502346; c=relaxed/simple;
	bh=UKRekcHypWryxdpArJ6WlIlnp7KFq6gZd6htTWU62t8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=dY9AMm/7eLOSEirYKmxflDPRsv/EkdfP2ijkvRl1rfZUQycI7dtA4CiCOf+nY8uATcEPfs9ce3NOYHpd1ne9YHcLX4fq2qgpfolvZmoH8LbQdoy9tVUGZoUco0o9CEnqAI2hxsXSARtEqV4u3WcG/GRhN4qWciFUgnWF2IU5/QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cVPhT3ggMzYQtpn;
	Mon, 22 Sep 2025 08:52:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F19911A0A1B;
	Mon, 22 Sep 2025 08:52:12 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3CGG7ndBolluSAQ--.55304S3;
	Mon, 22 Sep 2025 08:52:12 +0800 (CST)
Subject: Re: [PATCH] md raid: fix hang when stopping arrays with metadata
 through dm-raid
To: Heinz Mauelshagen <heinzm@redhat.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <cover.1758201368.git.heinzm@redhat.com>
 <b58dddf537d5aa7519670a4df5838e7056a37c2a.1758201368.git.heinzm@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7df6e7be-0fd1-0277-038e-3cc4efe5bf9b@huaweicloud.com>
Date: Mon, 22 Sep 2025 08:52:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <b58dddf537d5aa7519670a4df5838e7056a37c2a.1758201368.git.heinzm@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3CGG7ndBolluSAQ--.55304S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZrWrAw4kJr4DKw45tF15XFb_yoW8Kr45p3
	97K3WYyr1DJr9ag3ZrZr4kWFy5XF1vkrZxtr17Cw1vkw18WFn5KFya9an5Xa9Fv34vyF4a
	vw4rJryDWr1v9F7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jjVb
	kUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/09/18 21:42, Heinz Mauelshagen Ð´µÀ:
> When using device-mapper's dm-raid target, stopping a RAID array can cause the
> system to hang under specific conditions.
> 
> This occurs when:
> 
> -  A dm-raid managed device tree is suspended from top to bottom
>     (the top-level RAID device is suspended first, followed by its
>      underlying metadata and data devices)
> 
> -  The top-level RAID device is then removed
> 
> The hang happens because removing the top-level device triggers md_stop() from the
> dm-raid destructor.  This function attempts to flush the write-intent bitmap, which
> requires writing bitmap superblocks to the metadata sub-devices.  However, since
> these metadata devices are already suspended, the write operations cannot complete,
> causing the system to hang.
> 
> Fix:
> 
> -  Prevent bitmap flushing when md_stop() is called from dm-raid contexts
>     and avoid a quiescing/unquescing cycle which could also cause I/O

If bitmap flush is skipped, then bitmap can still be dirty after dm-raid
is stopped, and the next time when dm-raid is reloaded, looks like there
will be unnecessary data resync because there are dirty bits?

Thanks,
Kuai

> 
> -  Avoid any I/O operations that might occur during the quiesce/unquiesce process in md_stop()
> 
> This ensures that RAID array teardown can complete successfully even when the
> underlying devices are in a suspended state.
> 
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> ---
>   drivers/md/md.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4e033c26fdd4..53e15bdd9ab2 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6541,12 +6541,14 @@ static void __md_stop_writes(struct mddev *mddev)
>   {
>   	timer_delete_sync(&mddev->safemode_timer);
>   
> -	if (mddev->pers && mddev->pers->quiesce) {
> -		mddev->pers->quiesce(mddev, 1);
> -		mddev->pers->quiesce(mddev, 0);
> -	}
> +	if (!mddev_is_dm(mddev)) {
> +		if (mddev->pers && mddev->pers->quiesce) {
> +			mddev->pers->quiesce(mddev, 1);
> +			mddev->pers->quiesce(mddev, 0);
> +		}
>   
> -	mddev->bitmap_ops->flush(mddev);
> +		mddev->bitmap_ops->flush(mddev);
> +	}
>   
>   	if (md_is_rdwr(mddev) &&
>   	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
> 

