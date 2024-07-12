Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988C44EB5E;
	Fri, 12 Jul 2024 08:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720773358; cv=none; b=Jv9DPx0cJ4lGsJT5O6q8S7XmTqsD7p/XBC+2JJ1glsrEG/gW0QZ+WntFOd8nX3cz7t6HvIjVCwuPylolfQCJs2pqLx7BB/rtchLrlmxwN1r4J3Vf9XvvUgxut2gq0RGMvjIhD2gUSKZfTKOuvoAZ6+rpqwawsn4a48R6Og8gISI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720773358; c=relaxed/simple;
	bh=XmJLqmKHSdcJ0+HXF3Of6ehX//qbqlHPDTGvULQNHQ8=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=hka7Kxj+KD61lW0VSZRP+abGBPbZhPPiqA+lmdzqqKIqwdvfObUvuu3dhbl1IDpy24JSTg+UOYZddLtMiGb6XPShUzklNKxUAgCPRmhuhKPMS0w4MIgvsqsTA6ahhLF49ZyCiW6YrMfz4swgqz3+tyeH6YBWyokwlkAcnVh5GvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WL4g01S6Vz4f3jHg;
	Fri, 12 Jul 2024 16:35:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id E1E831A016E;
	Fri, 12 Jul 2024 16:35:51 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP2 (Coremail) with SMTP id Syh0CgB34Ybm6pBmwtCHBw--.34938S3;
	Fri, 12 Jul 2024 16:35:51 +0800 (CST)
Subject: Re: Lockup of (raid5 or raid6) + vdo after taking out a disk under
 load
To: Konstantin Kharlamov <Hi-Angel@yandex.ru>, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <a6d068a26a90057fb3cdaa59f9d57a2af41a6b22.camel@yandex.ru>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1f879e67-4d64-4df0-5817-360d84ff8b89@huaweicloud.com>
Date: Fri, 12 Jul 2024 16:35:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a6d068a26a90057fb3cdaa59f9d57a2af41a6b22.camel@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgB34Ybm6pBmwtCHBw--.34938S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GF1kWw45tw18ZF1xXw13Arb_yoW3Cr1rpr
	Z8JFy5ur4vgr18Xrs7A3WjqryUJa17ZF4DXFyUZr1xAFn7Xryaqr18JrWUJF9rCF95X3y3
	tF4Yya4xKFykKaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/07/12 14:53, Konstantin Kharlamov 写道:
> (this is a dup of yesterday's bugzilla bug 219030 as some maintainers
> prefer bugreporting over bugzilla some over ML, and the cases are
> indistinguishable)

At least I'll keep an eye on ML, not bugzilla.
> 
> We're seeing this on both LTS `6.1.97` as well the newest stable
> `6.9.8` (note though that VDO was only merged in 6.9, so for upstream
> it's probably the only one that matters. Traces below are from 6.9.8).
> 
> Creating a raid5 (alternatively raid6) + VDO, then starting a load and
> after a minute physically taking out a disk of the VG results in a
> lockup stack getting spammed over and over.
> 
> Seems unreproducible by removing a disk through software means of
> `/sys/block/sdX/device/delete`, i.e. it seem to only happen when either
> removing the disk physically or by disabling power on the JBOD slot
> with a command like `sg_ses --dev-slot-num=9 --set=3:4:1 /dev/sg26`.
> 
> Also when lockup happens, `reboot -ff` no longer does anything.
> 
> When looking at repeating stacktraces, the execution seems to loop
> around `raid5_get_active_stripe`, `raid5_compute_sector`,
> `raid5_release_stripe`.
> 
> # Steps to reproduce
> 
> 1. Create raid5 LV + VDO by executing a `./mk_lvm_raid5.sh /dev/sdX1
> /dev/sdY1 /dev/sdZ1` where `mk_lvm_raid5.sh` has the following content:
> 
>      #!/bin/bash
> 
>      set -exu
> 
>      if [ "$#" -ne 3 ]; then
>          echo "Wrong number of parameters.
>      Usage: $(basename $0) disk1 disk2 disk3"
>          exit 1
>      fi
> 
>      # create the VG
>      pvcreate -f "$1" "$2" "$3"
>      vgcreate p_r5 "$1" "$2" "$3"
> 
>      # create the LV
>      lvcreate --type raid5 -i 2 -L 21474836480b -I 64K -n
> vdo_internal_deco_vol p_r5 -y
>      lvconvert -y --type vdo-pool --virtualsize 107374182400B -n
> deco_vol p_r5/vdo_internal_deco_vol
> 
> 2. Start load by executing `fio ./fio-30%write.fio` with the `fio-
> 30%write.fio` having the following content:
> 
>      [test IOPS]
>      blocksize=8k
>      filename=/dev/p_r5/deco_vol
>      filesize=100G
>      direct=1
>      buffered=0
>      ioengine=libaio
>      iodepth=32
>      rw=randrw
>      rwmixwrite=30
>      numjobs=4
>      group_reporting
>      time_based
>      runtime=99h
>      clat_percentiles=0
>      unlink=1
> 
> 3. Wait for about a minute
> 4. Remove a disk of the volume group, either physically, or by turning
> off jbod slot's power (DO NOT use /…/device/delete).

Looks like this is because IO is failed from raid level, and then dm
level keep retry this IO(This will be related to the step 4), hence
raid5d stuck in the loop to hanlde new IO.

Can you give the following patch a test to confirm this?

Thanks!
Kuai

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c14cf2410365..a0f784cd664c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6776,7 +6776,9 @@ static void raid5d(struct md_thread *thread)

                 while ((bio = remove_bio_from_retry(conf, &offset))) {
                         int ok;
+
                         spin_unlock_irq(&conf->device_lock);
+                       cond_resched();
                         ok = retry_aligned_read(conf, bio, offset);
                         spin_lock_irq(&conf->device_lock);
                         if (!ok)
@@ -6790,11 +6792,11 @@ static void raid5d(struct md_thread *thread)
                         break;
                 handled += batch_size;

-               if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
-                       spin_unlock_irq(&conf->device_lock);
+               spin_unlock_irq(&conf->device_lock);
+               if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING))
                         md_check_recovery(mddev);
-                       spin_lock_irq(&conf->device_lock);
-               }
+               cond_resched();
+               spin_lock_irq(&conf->device_lock);
         }
         pr_debug("%d stripes handled\n", handled);


> 5. Wait 30 seconds
> 
> ## Expected
> 
> `dmesg -w` won't show anything interesting
> 
> ## Actual
> 
> `dmesg -w` starts showing up traces as follows (not sure why the
> missing line numbers, I have debug symbols locally, I can decode them
> manually with `gdb` if needed):
> 
>      […]
>      [  869.086048] mpt3sas_cm0: log_info(0x31110e05): originator(PL),
> code(0x11), sub_code(0x0e05)
>      [  869.139959] mpt3sas_cm0: mpt3sas_transport_port_remove: removed:
> sas_addr(0x5002538a67b01303)
>      [  869.140085] mpt3sas_cm0: removing handle(0x0022),
> sas_addr(0x5002538a67b01303)
>      [  869.140191] mpt3sas_cm0: enclosure logical
> id(0x50015b2140128f7f), slot(12)
>      [  869.140293] mpt3sas_cm0: enclosure level(0x0000), connector
> name(     )
>      [  893.262506] watchdog: BUG: soft lockup - CPU#5 stuck for 26s!
> [mdX_raid5:24608]
>      [  893.262641] Modules linked in: dm_raid mptctl mptbase bonding
> fcoe libfcoe 8021q garp mrp libfc stp llc scsi_transport_fc
> sch_fq_codel softdog dm_round_robin scsi_dh_alua intel_rapl_msr
> coretemp intel_rapl_common sb_edac x86_pkg_temp_thermal
> intel_powerclamp ast kvm_intel drm_shmem_helper drm_kms_helper kvm
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha512_ssse3
> sha256_ssse3 sha1_ssse3 aesni_intel crypto_simd cryptd rapl
> intel_cstate wdat_wdt intel_pch_thermal ipmi_ssif dm_multipath
> acpi_ipmi sg ipmi_si ipmi_devintf ipmi_msghandler acpi_pad
> acpi_power_meter ramoops reed_solomon efi_pstore drm ip_tables x_tables
> autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq
> async_xor xor async_tx raid6_pq libcrc32c raid0 ses enclosure mlx5_ib
> ib_core raid1 ixgbe igb mlx5_core mdio_devres xfrm_algo i2c_algo_bit
> e1000e mpt3sas hwmon dca mdio i2c_i801 ahci lpc_ich ptp i2c_smbus
> mfd_core raid_class libahci pps_core libphy scsi_transport_sas
>      [  893.264033] CPU: 5 PID: 24608 Comm: mdX_raid5 Not tainted 6.9.8-
> bstrg #3
>      [  893.264254] Hardware name: AIC HA401-LB2/LIBRA, BIOS LIBBV071
> 04/19/2017
>      [  893.264479] RIP: 0010:_raw_spin_lock_irqsave+0xe/0x30
>      [  893.264714] Code: 48 89 ef 5d e9 13 33 47 ff 0f 1f 00 90 90 90
> 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 41 54 55 48 89 fd
> 9c 41 5c <fa> bf 01 00 00 00 e8 07 96 43 ff 48 89 ef e8 df 32 47 ff 4c
> 89 e0
>      [  893.265229] RSP: 0018:ffffbc306091fd70 EFLAGS: 00000246
>      [  893.265502] RAX: 0000000000000001 RBX: 0000000000000001 RCX:
> 0000000000000000
>      [  893.265783] RDX: 0000000000000001 RSI: 0000000000000003 RDI:
> ffff9fbacf48c430
>      [  893.266069] RBP: ffff9fbacf48c430 R08: ffff9fcac1254d58 R09:
> 00000000ffffffff
>      [  893.266366] R10: 0000000000000000 R11: ffffbc306091fe20 R12:
> 0000000000000246
>      [  893.266664] R13: ffff9fcac1254dc0 R14: 0000000000000000 R15:
> 0000000000739d18
>      [  893.266968] FS:  0000000000000000(0000)
> GS:ffff9fc9fff40000(0000) knlGS:0000000000000000
>      [  893.267282] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>      [  893.267603] CR2: 000055f91452ff88 CR3: 0000000124c74004 CR4:
> 00000000003706f0
>      [  893.267933] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
>      [  893.268268] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
>      [  893.268605] Call Trace:
>      [  893.268945]  <IRQ>
>      [  893.269285]  ? watchdog_timer_fn+0x24b/0x2d0
>      [  893.269638]  ? __pfx_watchdog_timer_fn+0x10/0x10
>      [  893.269990]  ? __hrtimer_run_queues+0x112/0x2b0
>      [  893.270347]  ? hrtimer_interrupt+0x101/0x240
>      [  893.270708]  ? __sysvec_apic_timer_interrupt+0x6e/0x180
>      [  893.271075]  ? sysvec_apic_timer_interrupt+0x9d/0xd0
>      [  893.271448]  </IRQ>
>      [  893.271816]  <TASK>
>      [  893.272184]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>      [  893.272568]  ? _raw_spin_lock_irqsave+0xe/0x30
>      [  893.272956]  __wake_up+0x1d/0x60
>      [  893.273345]  md_wakeup_thread+0x38/0x70
>      [  893.273738]  raid5d+0x32a/0x5d0 [raid456]
>      [  893.274147]  md_thread+0xc1/0x170
>      [  893.274545]  ? __pfx_autoremove_wake_function+0x10/0x10
>      [  893.274951]  ? __pfx_md_thread+0x10/0x10
>      [  893.275358]  kthread+0xff/0x130
>      [  893.275760]  ? __pfx_kthread+0x10/0x10
>      [  893.276172]  ret_from_fork+0x30/0x50
>      [  893.276568]  ? __pfx_kthread+0x10/0x10
>      [  893.276961]  ret_from_fork_asm+0x1a/0x30
>      [  893.277351]  </TASK>
> 
> .
> 

