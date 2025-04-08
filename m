Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70915263F40
	for <linux-raid@vger.kernel.org>; Tue,  8 Apr 2025 08:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744100895; cv=none; b=GRX6vmyr28AtrboIsqCtcknxe11uarI27cwjN4DL+nPv4iPDNQacaxuySzVVCrWdLeCAfzK2aSXEgQB81CSCnVbU6cRDsKqObVwTHqSWglSBKWiRq5287rbw6e3ILeZ2lmT8w9Y3A/usQkyXrze8vAmTBH0GNfQJ7JdedPWl6D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744100895; c=relaxed/simple;
	bh=WN3MdrbFEb+XkK7euCBBBLHmpW6eoBdYJ3gapuAZu8o=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=RY9TW05r28BhIFoczRjMO3cplN0F5VdYRZ2CYGYqTe9QwOiF0Xue68u73/WES+x3wYfi0Zeum2+bwF3IBhpSjETGb0QzPV6lsG70iav+0u5d+wTFbFa11JHWobq6X8U9Fna4moOwBZ3acwb1sI2D0qBHQUV2aDG6+Qyo1C4fvPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZWzjJ0Fwmz4f3jYl
	for <linux-raid@vger.kernel.org>; Tue,  8 Apr 2025 16:27:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 08BAB1A0F7C
	for <linux-raid@vger.kernel.org>; Tue,  8 Apr 2025 16:28:06 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB32l4U3vRntYByIw--.59495S3;
	Tue, 08 Apr 2025 16:28:05 +0800 (CST)
Subject: Re: [PATCH] md/raid1: Add check for missing source disk in
 process_checks()
To: Meir Elisha <meir.elisha@volumez.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250408074909.729471-1-meir.elisha@volumez.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <10e5a340-a300-2937-76c1-74040a9a23fd@huaweicloud.com>
Date: Tue, 8 Apr 2025 16:28:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250408074909.729471-1-meir.elisha@volumez.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB32l4U3vRntYByIw--.59495S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAw15JF1xXw48tr1DWrWUXFb_yoW5trWDpa
	9rGFZY9rZ5GryFkryDJFWUuF1Fkw4rtFW7AFZ7G347ZFZ8tFWF9ayUKa45KFyDJr98Ww13
	X3Z8Jay3AF1ftaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

ÔÚ 2025/04/08 15:49, Meir Elisha Ð´µÀ:
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
>   drivers/md/raid1.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 0efc03cea24e..b6a52c137f53 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2296,6 +2296,12 @@ static void process_checks(struct r1bio *r1_bio)
>   			rdev_dec_pending(conf->mirrors[primary].rdev, mddev);
>   			break;
>   		}
> +
> +	if (primary >= conf->raid_disks * 2) {
> +		pr_err_ratelimited("md/raid1:%s: unable to find source disk\n", mdname(mddev));
> +		return;
> +	}

This means all reads failed, then I'm a bit confused why
sync_request_write() doesn't return early?

end_sync_read
  if (!bio->bi_status)
   // uptodate is not set
   set_bit(R1BIO_Uptodate, &r1_bio->state);

sync_request_write
  if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
   if (!fix_sync_read_error(r1_bio))
    // why not return here?
    return;

  process_checks(r1_bio);

The answer is that fix_sync_read_error() is used for the case just one
rdev is read, it just handle the bio from r1_bio->read_disk, and suppose 
that just one rdev is read. And if rdev_set_badblocks() succeed,
fix_sync_read_error() will clear R1BIO_Uptodate and bi_status and
finally cause this problem.

While in this case, all member disks are read for check/repair, hence I
think fix_sync_read_error() is not supposed to be called here, and
better solution will be:

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d422bab77580..dafda9095c73 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2346,10 +2346,15 @@ static void sync_request_write(struct mddev 
*mddev, struct r1bio *r1_bio)
         int disks = conf->raid_disks * 2;
         struct bio *wbio;

-       if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
-               /* ouch - failed to read all of that. */
-               if (!fix_sync_read_error(r1_bio))
+       if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
+               /*
+                * ouch - failed to read all of that. No need to fix 
read error
+                * for check or repair because read all member disks failed.
+                */
+               if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) ||
+                   !fix_sync_read_error(r1_bio))
                         return;
+       }

         if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
                 process_checks(r1_bio);

Thanks,
Kuai

> +
>   	r1_bio->read_disk = primary;
>   	for (i = 0; i < conf->raid_disks * 2; i++) {
>   		int j = 0;
> 

