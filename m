Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00371204C1E
	for <linux-raid@vger.kernel.org>; Thu, 10 Apr 2025 07:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744269340; cv=none; b=oET0GuGhYF5Lbh7XDHDA4B4JnIKs/Pi3bXLYFaCZoIC3KwuEwbW0rcLS4yrD3Olu7gFRfiWDwx5L0DH0hn4sDKwpaGOuphRe+wmZQ5JqAShfLgCe+D+lDKPXt2pmbUxb9D6hF4EFpDZBkvJFXVkjduuOR4V4WLY/Sm7y312LUTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744269340; c=relaxed/simple;
	bh=XiTVSJO3eEsynXREdZShEgj3bUOw8kjeF39dP/ZYiUE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=iOb0X++7EQbtigCzDVDtald0bEuLTaiqESHMAFa2ZhC3+tQvumNXQ6FGQDskhN+E5ujKI0TZeidnj1RozW12TDgMwQIiRI1Bo99ec0xpkdVeXuJtrFeBFqxpGKQUL52GjHhwO2kY6FZzyl+D77rXmVPJ4Np4f6M3Pg13He5RlwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZYB0f0sTJz4f3jt7
	for <linux-raid@vger.kernel.org>; Thu, 10 Apr 2025 15:15:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 32BC91A06D7
	for <linux-raid@vger.kernel.org>; Thu, 10 Apr 2025 15:15:32 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2AScPdnrQExJA--.32766S3;
	Thu, 10 Apr 2025 15:15:32 +0800 (CST)
Subject: Re: [PATCH v2] md/raid1: Add check for missing source disk in
 process_checks()
To: Meir Elisha <meir.elisha@volumez.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250408143808.1026534-1-meir.elisha@volumez.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <161625c3-8ba5-eb16-7d6d-e5e4cb125d91@huaweicloud.com>
Date: Thu, 10 Apr 2025 15:15:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250408143808.1026534-1-meir.elisha@volumez.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2AScPdnrQExJA--.32766S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAw15CF43CF4rGw1kGw17Jrb_yoW5Wry5pa
	9rGF9a9rWrGry3tF9rtFWDuFyrAw40qay7tr1xWw17ZrZ8tFZ09FWYqFyUWFyDJryFgw43
	X3WDJrZFyF13taDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/04/08 22:38, Meir Elisha Ð´µÀ:
> During recovery/check operations, the process_checks function loops
> through available disks to find a 'primary' source with successfully
> read data.
> 
> If no suitable source disk is found after checking all possibilities,
> the 'primary' index will reach conf->raid_disks * 2. Add an explicit
> check for this condition after the loop. If no source disk was found,
> print an error message and return early to prevent further processing
> without a valid primary source.
> 
> Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
> ---

Just to be sure, do you tested this version?

Thanks,
Kuai

> Changes from v1:
> 	- Don't fix read errors on recovery/check
> 
> This was observed when forcefully disconnecting all iSCSI devices backing
> a RAID1 array(using --failfast flag) during a check operation, causing
> all reads within process_checks to fail. The resulting kernel oops shows:
> 
>    BUG: kernel NULL pointer dereference, address: 0000000000000040
>    RIP: 0010:process_checks+0x25e/0x5e0 [raid1]
>    Code: ... <4c> 8b 53 40 ... // mov r10,[rbx+0x40]
>    Call Trace:
>     process_checks
>     sync_request_write
>     raid1d
>     md_thread
>     kthread
>     ret_from_fork
> 
>   drivers/md/raid1.c | 26 ++++++++++++++++----------
>   1 file changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 0efc03cea24e..de9bccbe7337 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2200,14 +2200,9 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>   				if (!rdev_set_badblocks(rdev, sect, s, 0))
>   					abort = 1;
>   			}
> -			if (abort) {
> -				conf->recovery_disabled =
> -					mddev->recovery_disabled;
> -				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -				md_done_sync(mddev, r1_bio->sectors, 0);
> -				put_buf(r1_bio);
> +			if (abort)
>   				return 0;
> -			}
> +
>   			/* Try next page */
>   			sectors -= s;
>   			sect += s;
> @@ -2346,10 +2341,21 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
>   	int disks = conf->raid_disks * 2;
>   	struct bio *wbio;
>   
> -	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
> -		/* ouch - failed to read all of that. */
> -		if (!fix_sync_read_error(r1_bio))
> +	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
> +		/*
> +		 * ouch - failed to read all of that.
> +		 * No need to fix read error for check/repair
> +		 * because all member disks are read.
> +		 */
> +		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) ||
> +		    !fix_sync_read_error(r1_bio)) {
> +			conf->recovery_disabled = mddev->recovery_disabled;
> +			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +			md_done_sync(mddev, r1_bio->sectors, 0);
> +			put_buf(r1_bio);
>   			return;
> +		}
> +	}
>   
>   	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
>   		process_checks(r1_bio);
> 

