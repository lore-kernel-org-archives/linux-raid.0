Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B7727E048
	for <linux-raid@vger.kernel.org>; Mon, 18 Aug 2025 07:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755502833; cv=none; b=rQa/+Fia1X8ahq6UnoOhiBNhxq3mchyHd7epIWyh5DpDW+1YPZgwgqS/zZFBY+URPEsJF0FY/P6UMHjboCGYNmPkV95wuP5BxfAmlGbk0oUNQT+/VNuagEYVrdiBlQC5MUy7FaRssseGt/j/IZQq4jTxPu4NCR5N3vN443UtB88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755502833; c=relaxed/simple;
	bh=/iuVHmS49mgZnP+Wgk+bx1B18i1cs4jyN8mfZQCtLHY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=u0qxArbDnO7nuqN9VU//FfjSIPqc4fRoZlCfmcKVMK2qxXsrUjWZ6nY1sje3PlYNg7Aypn9UbJz7/3eny6ZEoT2jx2jbSxgmbsVqP3nBXedV53xHYYErzr6BKpLNWMsSh0aadLHgKyXmfE9DfoZ9Yv+jtyxNyQB/cDx6wLRF75Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c54Pl6m5WzYQvdC
	for <linux-raid@vger.kernel.org>; Mon, 18 Aug 2025 15:40:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 85C951A018D
	for <linux-raid@vger.kernel.org>; Mon, 18 Aug 2025 15:40:26 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgC3MxTp2KJoBVxSEA--.23561S3;
	Mon, 18 Aug 2025 15:40:26 +0800 (CST)
Subject: Re: [PATCH v2] md/raid5: fix parity corruption on journal failure
To: Meir Elisha <meir.elisha@volumez.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250816122804.1007376-1-meir.elisha@volumez.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3e52a369-32e8-028f-2799-0cd6044a6dcf@huaweicloud.com>
Date: Mon, 18 Aug 2025 15:40:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250816122804.1007376-1-meir.elisha@volumez.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3MxTp2KJoBVxSEA--.23561S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtFy8Aw15WFW7KFyrJF47Jwb_yoWxCFy3pF
	WfG3Z8tr1jqw43t3srZr48A3ZYqa4qy3yfuFn5Zryv9rs8Kr93ta43Ga45uFs8uF9rJ3yx
	Xa48trWvgFnYvrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU20PSUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/08/16 20:28, Meir Elisha 写道:
> When operating in write-through journal mode, a journal device failure
> can lead to parity corruption and silent data loss.
> This occurs because the current implementation continues to update
> parity even when journal writes fail, violating the write-through
> consistency guarantee.
> 
> Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
> ---
> Changes in v2:
> 	- Drop writes only when s->failed > conf->max_degraded
> 	- Remove changes in handle_stripe()
> 
> When log_stripe() fails in ops_run_io() we keep write to the parity
> disk causing parity to get updated as if the write succeeded.
> shouldn't we fail if the journal is down? am I missing something here?
> Thanks in advance for reviewing.
> 
> Wrote a script for showcasing the issue.
> 
> #!/bin/bash
> 
> set -e
> 
> RAID_DEV="/dev/md127"
> DATA_OFFSET=32
> 
> # Arrays to store disk states
> declare -a BEFORE_BYTES
> declare -a DISK_NAMES
> 
> cleanup() {
>        mdadm --stop $RAID_DEV 2>/dev/null || true
>        dmsetup remove disk0-flakey disk1-flakey journal-flakey 2>/dev/null || true
>        for i in {10..15}; do
>            losetup -d /dev/loop$i 2>/dev/null || true
>        done
>        rm -f /tmp/disk*.img 2>/dev/null || true
> }
> 
> # Function to read first byte from device at offset
> read_first_byte() {
>        local device=$1
>        local offset=$2
>        dd if=$device bs=32k skip=$offset count=4 iflag=direct status=none | head -c 1 | xxd -p
> }
> 
> # Function to calculate which disk holds parity for a given stripe
> # RAID5 left-symmetric algorithm (default)
> get_parity_disk() {
>        local stripe_num=$1
>        local n_disks=$2
>        local pd_idx=$((($n_disks - 1) - ($stripe_num % $n_disks)))
>        echo $pd_idx
> }
> 
> cleanup
> echo "=== RAID5 Parity Bug Test ==="
> echo
> 
> # Create backing files
> for i in {0..5}; do
>        dd if=/dev/zero of=/tmp/disk$i.img bs=1M count=100 status=none
>        losetup /dev/loop$((10+i)) /tmp/disk$i.img
> done
> 
> SIZE=$(blockdev --getsz /dev/loop10)
> 
> # Create normal linear targets first
> dmsetup create disk0-flakey --table "0 $SIZE linear /dev/loop10 0"
> dmsetup create disk1-flakey --table "0 $SIZE linear /dev/loop11 0"
> dmsetup create journal-flakey --table "0 $SIZE linear /dev/loop15 0"
> 
> # Create RAID5 using the dm devices
> echo "1. Creating RAID5 array..."
> mdadm --create $RAID_DEV --chunk=32K --level=5 --raid-devices=5 \
>        /dev/mapper/disk0-flakey \
>        /dev/mapper/disk1-flakey \
>        /dev/loop12 /dev/loop13 /dev/loop14 \
>        --write-journal /dev/mapper/journal-flakey \
>        --assume-clean --force
> 
> echo "write-through" > /sys/block/md127/md/journal_mode
> echo 0 > /sys/block/md127/md/safe_mode_delay
> 
> # Write test pattern
> echo "2. Writing test pattern..."
> for i in 0 1 2 3; do
>        VAL=$((1 << i))
>        echo "VAL:$VAL"
>        perl -e "print chr($VAL) x 32768" | dd of=$RAID_DEV bs=32k count=1 seek=$i oflag=direct status=none
> done
> sync
> sleep 1  # Give time for writes to settle
> 
> echo "3. Reading disk states before failure..."
> 
> # Calculate parity disk for stripe 0 (first 32k chunk)
> STRIPE_NUM=0
> N_DISKS=5
> PARITY_INDEX=$(get_parity_disk $STRIPE_NUM $N_DISKS)
> echo "Calculated parity disk index for stripe $STRIPE_NUM: $PARITY_INDEX"
> 
> # Map RAID device index to loop device
> PARITY_DISK=$((10 + $PARITY_INDEX))
> echo "Parity is on loop$PARITY_DISK"
> echo
> 
> for i in {10..14}; do
>        # Read first byte from device
>        BYTE=$(read_first_byte /dev/loop$i $DATA_OFFSET)
>        BEFORE_BYTES[$i]=$BYTE
>        DISK_NAMES[$i]="loop$i"
>             echo -n "loop$i: 0x$BYTE"
>        if [ "$i" = "$PARITY_DISK" ]; then
>            echo " <-- PARITY disk"
>        else
>            echo
>        fi
> done
> 
> echo
> echo "4. Fail the first disk..."
> 
> dmsetup suspend disk0-flakey
> dmsetup reload disk0-flakey --table "0 $SIZE flakey /dev/loop10 0 0 4294967295 2 error_reads error_writes"
> dmsetup resume disk0-flakey
> 
> perl -e "print chr(4) x 32768" | dd of=$RAID_DEV bs=32k count=1 seek=2 oflag=direct status=none
> sync
> sleep 1
> 
> dmsetup suspend journal-flakey
> dmsetup reload journal-flakey --table "0 $SIZE flakey /dev/loop15 0 0 4294967295 2 error_reads error_writes"
> dmsetup resume journal-flakey
> 
> dmsetup suspend disk1-flakey
> dmsetup reload disk1-flakey --table "0 $SIZE flakey /dev/loop11 0 0 4294967295 2 error_reads error_writes"
> dmsetup resume disk1-flakey
> 
> echo "5. Attempting write (should fail the 2nd disk and the journal)..."
> dd if=/dev/zero of=$RAID_DEV bs=32k count=1 seek=0 oflag=direct 2>&1 || echo "Write failed (expected)"
> sync
> sleep 1
> 
> echo
> echo "6. Checking if parity was incorrectly updated:"
> CHANGED=0
> for i in {10..14}; do
>        # Read current state from device
>        BYTE_AFTER=$(read_first_byte /dev/loop$i $DATA_OFFSET)
>        BYTE_BEFORE=${BEFORE_BYTES[$i]}
> 
>        if [ "$BYTE_BEFORE" != "$BYTE_AFTER" ]; then
>            echo "*** loop$i CHANGED: 0x$BYTE_BEFORE -> 0x$BYTE_AFTER ***"
>            CHANGED=$((CHANGED + 1))
> 
>            if [ "$i" = "$PARITY_DISK" ]; then
>                echo "  ^^ PARITY WAS UPDATED - BUG DETECTED!"
>            fi
>        else
>            echo "loop$i unchanged: 0x$BYTE_BEFORE"
>        fi
> done
> 
> echo
> echo "RESULT:"
> if [ $CHANGED -gt 0 ]; then
>        echo "*** BUG DETECTED: $CHANGED disk(s) changed despite journal failure ***"
> else
>        echo "✓ GOOD: No disks changed
> fi
> 
> cleanup
> 
>   drivers/md/raid5.c | 19 ++++++++++++++++++-
>   1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 023649fe2476..509ab5673cf8 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1146,8 +1146,21 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>   
>   	might_sleep();
>   
> -	if (log_stripe(sh, s) == 0)
> +	if (log_stripe(sh, s) == 0) {
> +		/* Successfully logged to journal */
>   		return;
> +	}

No need to add braces here, just place the comment above if.
> +
> +	if (conf->log && r5l_log_disk_error(conf)) {
> +		/*
> +		 * Journal device failed. Only abort writes if we have
> +		 * too many failed devices to maintain consistency.
> +		 */

Same here, and please use just one if.

> +		if (s->failed > conf->max_degraded && (s->to_write || s->written)) {
> +			set_bit(STRIPE_HANDLE, &sh->state);
> +			return;
> +		}
> +	}
>   
>   	should_defer = conf->batch_bio_dispatch && conf->group_cnt;
>   
> @@ -3672,6 +3685,10 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   		 * still be locked - so just clear all R5_LOCKED flags
>   		 */
>   		clear_bit(R5_LOCKED, &sh->dev[i].flags);
> +		clear_bit(R5_Wantwrite, &sh->dev[i].flags);
> +		clear_bit(R5_Wantcompute, &sh->dev[i].flags);
> +		clear_bit(R5_WantFUA, &sh->dev[i].flags);
> +		clear_bit(R5_Wantdrain, &sh->dev[i].flags);

And please explain why you're clearing these flags.

Thanks,
Kuai

>   	}
>   	s->to_write = 0;
>   	s->written = 0;
> 

