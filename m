Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347C92A1A4;
	Fri, 24 Jan 2025 02:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737686089; cv=none; b=EfJmhCQg+rRbQ91Hk2bCSMNZrGzjy8z7/ScW4/atKtNiUEX1IvVIF9smGEiDv3B96kJvZJJHxfqadqQYpEn0dLXnzcBMuTqeJc9fDNUiJO6zVVAthyJg9yV+/UgJdoNaogEar7VFG74np2aa4+2YWryRCZjAxXHVMSEbwDglSTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737686089; c=relaxed/simple;
	bh=TAbvEeMDrLUarBiXdhbV22NgR77susDn4wLE0dvHivE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=g74Zd3DyseM16Dgt/iTxl/+9+kr86G+t8EKmWnvehFNJ1pNjbgQyloLd8TTZaOHrfiM4nQiVNXPfIPyMrb+ci3HUS+6hyK1PfOJtyK+0l/cjLdsKY/LUWzW+GcrDFoDsQmIuC2OC7Wpi9gTSEBK+2hO5cSRUtfTsgFblkiQ4CD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YfM1F56Z4z4f3jqw;
	Fri, 24 Jan 2025 10:18:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 3477E1A1061;
	Fri, 24 Jan 2025 10:18:41 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP3 (Coremail) with SMTP id _Ch0CgB3ysR9+JJnUNIrBw--.15884S3;
	Fri, 24 Jan 2025 10:18:39 +0800 (CST)
Subject: Re: [REGRESSION] kernel panic at bitmap_get_stats+0x2b/0xa0 since
 6.12
To: Yu Kuai <yukuai1@huaweicloud.com>,
 Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org,
 mariusz.tkaczyk@linux.intel.com, song@kernel.org, pmenzel@molgen.mpg.de
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Darren Kenny <darren.kenny@oracle.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <ca3a91a2-50ae-4f68-b317-abd9889f3907@oracle.com>
 <e6b8d928-36d3-d2e5-a773-2f73b8f92bbc@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6b72aec8-cc23-27d1-38ae-827bf800f21d@huaweicloud.com>
Date: Fri, 24 Jan 2025 10:18:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <e6b8d928-36d3-d2e5-a773-2f73b8f92bbc@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB3ysR9+JJnUNIrBw--.15884S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Cr4kWr45tr4DJw1DWFWDtwb_yoWDKrWxpr
	n3GFW5GrW8Jr1xJryqqr1UWFy8t3WUAa4DJr97Aa4UCF47JFn0gr18Xa1qgr1Dtr48Zry3
	Kr4Dtrnava4UGaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/



在 2025/01/24 9:30, Yu Kuai 写道:
> Hi,
> 
> 在 2025/01/23 5:58, Harshit Mogalapalli 写道:
>> Hi all,
>>
>>
>> We started seeing panic during boot cycle on 6.12 upstream kernel.
>>
>> Data points:
>> * This is reproducible on 6.12.9
>> * Also reproducible on 6.13 from yesterday.
>> * Not reproducible on 6.11
>>
>> So I looked at commits between 6.11-> 6.12 , and narrowed it down to a 
>> patch series which made changed to md-bitmap.c
>>
>> https://lore.kernel.org/all/20240826074452.1490072-1-yukuai1@huaweicloud.com/ 
>>
>>
>> After narrowing down further: it is narrowed down to this commit
>>
>> ec6bb299c7c3 md/md-bitmap: add 'sync_size' into struct md_bitmap_stats
>>
>>
>> #regzbot introduced: ec6bb299c7c3
>>
>>
>> Also, the panic points to the middle line below:
>>
>>      sb = kmap_local_page(bitmap->storage.sb_page);
>> *    stats->sync_size = le64_to_cpu(sb->sync_size);
>>      kunmap_local(sb);
>>
>> Call trace is as follows:
>>
>> [   21.427462] Oops: general protection fault, probably for 
>> non-canonical address 0x8730d3f80000028: 0000 [#1] PREEMPT SMP NOPTI
>> [   21.440104] CPU: 56 UID: 0 PID: 1531 Comm: mdadm Not tainted 
>> 6.13.0-master.20250121.ol8.x86_64 #1
>> [   21.450019] Hardware name: Oracle Corporation ORACLE SERVER 
>> X9-2L/ASM,MTHRBD,2U, BIOS 62110100 07/15/2024
>> [   21.460710] RIP: 0010:bitmap_get_stats+0x2b/0xa0
>> [   21.465872] Code: 0f 1e fa 0f 1f 44 00 00 48 89 f2 48 85 ff 74 7d 
>> 48 8b 4f 50 48 2b 0d dc 9f e5 00 48 8b 35 e5 9f e5 00 48 c1 f9 06 48 
>> c1 e1 0c <48> 8b 4c 31 28 48 89 4a 20 48 8b 4f 18 48 89 4a 10 48 8b 4f 
>> 10 48
>> [   21.486849] RSP: 0018:ff3e5f658fc3fb18 EFLAGS: 00010206
>> [   21.492690] RAX: ffffffff8d17d660 RBX: ff27d0600af69690 RCX: 
>> 094b3d0000000000
>> [   21.500663] RDX: ff3e5f658fc3fb28 RSI: ff27d03f80000000 RDI: 
>> ff27d06008cd9c00
>> [   21.507233] mlx5_core 0000:b1:00.0: Rate limit: 127 rates are 
>> supported, range: 0Mbps to 97656Mbps
>> [   21.508629] RBP: ff27d0604a737418 R08: 0000000000000000 R09: 
>> 0000000000000000
>> [   21.508631] R10: 0000000000000000 R11: 0000000000000000 R12: 
>> 00000000012c2000
>> [   21.508631] R13: ff27d0604a737018 R14: ff27d0604a737000 R15: 
>> ff27d0604a737018
>> [   21.508632] FS:  00007f61a01c98c0(0000) GS:ff27d07f7f600000(0000) 
>> knlGS:0000000000000000
>> [   21.508634] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   21.508635] CR2: 000056503c28f458 CR3: 00000020c000c004 CR4: 
>> 0000000000771ef0
>> [   21.518772] mlx5_core 0000:b1:00.0: E-Switch: Total vports 27, per 
>> vport: max uc(128) max mc(2048)
>> [   21.526600] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
>> 0000000000000000
>> [   21.526601] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
>> 0000000000000400
>> [   21.526602] PKRU: 55555554
>> [   21.526603] Call Trace:
>> [   21.526604]  <TASK>
>> [   21.535111] mlx5_core 0000:b1:00.0: Flow counters bulk query buffer 
>> size increased, bulk_query_len(8)
>> [   21.542533]  ? show_trace_log_lvl+0x1b0/0x300
>> [   21.542537]  ? show_trace_log_lvl+0x1b0/0x300
>> [   21.556126] mlx5_core 0000:b1:00.0: mlx5_pcie_event:301:(pid 529): 
>> PCIe slot advertised sufficient power (27W).
>> [   21.557983]  ? md_seq_show+0x2d2/0x5b0
>> [   21.557988]  ? __die_body.cold+0x8/0x12
>> [   21.641128]  ? die_addr+0x3c/0x60
>> [   21.645080]  ? exc_general_protection+0x17d/0x400
>> [   21.650574]  ? asm_exc_general_protection+0x26/0x30
>> [   21.656267]  ? __pfx_bitmap_get_stats+0x10/0x10
>> [   21.661568]  ? bitmap_get_stats+0x2b/0xa0
>> [   21.666277]  md_seq_show+0x2d2/0x5b0
>> [   21.670507]  seq_read_iter+0x2b9/0x470
>> [   21.674924]  seq_read+0x12f/0x180
>> [   21.678853]  proc_reg_read+0x57/0xb0
>> [   21.683074]  vfs_read+0xf6/0x380
>> [   21.686902]  ? __seccomp_filter+0x30b/0x520
>> [   21.691786]  ksys_read+0x6c/0xf0
>> [   21.695607]  do_syscall_64+0x82/0x170
>> [   21.699909]  ? arch_exit_to_user_mode_prepare.isra.0+0x1e/0xd0
>> [   21.706637]  ? syscall_exit_to_user_mode+0x37/0x1a0
>> [   21.712295]  ? __memcg_slab_free_hook+0xf7/0x160
>> [   21.717660]  ? __x64_sys_close+0x3c/0x80
>> [   21.722248]  ? kmem_cache_free+0x400/0x460
>> [   21.727028]  ? syscall_exit_to_user_mode_prepare+0x174/0x1b0
>> [   21.733553]  ? arch_exit_to_user_mode_prepare.isra.0+0x1e/0xd0
>> [   21.740270]  ? syscall_exit_to_user_mode+0x37/0x1a0
>> [   21.745913]  ? do_syscall_64+0x8e/0x170
>> [   21.750388]  ? do_syscall_64+0x8e/0x170
>> [   21.754857]  ? clear_bhb_loop+0x45/0xa0
>> [   21.759318]  ? clear_bhb_loop+0x45/0xa0
>> [   21.763772]  ? clear_bhb_loop+0x45/0xa0
>> [   21.768218]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>> [   21.774014] RIP: 0033:0x7f619f862585
>> [   21.778170] Code: fe ff ff 50 48 8d 3d 52 a8 06 00 e8 e5 08 02 00 
>> 0f 1f 44 00 00 f3 0f 1e fa 48 8d 05 d5 71 2a 00 8b 00 85 c0 75 0f 31 
>> c0 0f 05 <48> 3d 00 f0 ff ff 77 53 c3 66 90 41 54 49 89 d4 55 48 89 f5 
>> 53 89
>> [   21.799471] RSP: 002b:00007ffe50c2d3c8 EFLAGS: 00000246 ORIG_RAX: 
>> 0000000000000000
>> [   21.808099] RAX: ffffffffffffffda RBX: 000056503c2802a0 RCX: 
>> 00007f619f862585
>> [   21.816240] RDX: 0000000000000400 RSI: 000056503c28d000 RDI: 
>> 0000000000000004
>> [   21.824382] RBP: 0000000000000d68 R08: 0000000000000008 R09: 
>> 0000000000000001
>> [   21.832518] R10: 0000000000000000 R11: 0000000000000246 R12: 
>> 00007f619fb00860
>> [   21.840654] R13: 00007f619fb013a0 R14: 000056503c280a50 R15: 
>> 000056503c281480
>> [   21.848789]  </TASK>
>> [   21.851389] Modules linked in: raid1 mgag200 drm_client_lib 
>> drm_shmem_helper drm_kms_helper sd_mod sg raid0 mlx5_core(+) ahci 
>> libahci drm crct10dif_pclmul ghash_clmulni_intel mlxfw sha512_ssse3 
>> igb nvme sha256_ssse3 libata tls sha1_ssse3 megaraid_sas nvme_core 
>> pci_hyperv_intf psample dca nvme_auth i2c_algo_bit nfit(+) libnvdimm 
>> aesni_intel gf128mul crypto_simd cryptd
>> [   21.888253] ---[ end trace 0000000000000000 ]---
>> [   22.452319] RIP: 0010:bitmap_get_stats+0x2b/0xa0
>> [   22.457699] Code: 0f 1e fa 0f 1f 44 00 00 48 89 f2 48 85 ff 74 7d 
>> 48 8b 4f 50 48 2b 0d dc 9f e5 00 48 8b 35 e5 9f e5 00 48 c1 f9 06 48 
>> c1 e1 0c <48> 8b 4c 31 28 48 89 4a 20 48 8b 4f 18 48 89 4a 10 48 8b 4f 
>> 10 48
>> [   22.479037] RSP: 0018:ff3e5f658fc3fb18 EFLAGS: 00010206
>> [   22.485067] RAX: ffffffff8d17d660 RBX: ff27d0600af69690 RCX: 
>> 094b3d0000000000
>> [   22.493217] RDX: ff3e5f658fc3fb28 RSI: ff27d03f80000000 RDI: 
>> ff27d06008cd9c00
>> [   22.501372] RBP: ff27d0604a737418 R08: 0000000000000000 R09: 
>> 0000000000000000
>> [   22.509527] R10: 0000000000000000 R11: 0000000000000000 R12: 
>> 00000000012c2000
>> [   22.517686] R13: ff27d0604a737018 R14: ff27d0604a737000 R15: 
>> ff27d0604a737018
>> [   22.525845] FS:  00007f61a01c98c0(0000) GS:ff27d07f7f600000(0000) 
>> knlGS:0000000000000000
>> [   22.535089] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   22.541701] CR2: 000056503c28f458 CR3: 00000020c000c004 CR4: 
>> 0000000000771ef0
>> [   22.549866] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
>> 0000000000000000
>> [   22.558040] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
>> 0000000000000400
>> [   22.566202] PKRU: 55555554
>> [   22.569425] Kernel panic - not syncing: Fatal exception
>> [   22.576477] Kernel Offset: 0xb600000 from 0xffffffff81000000 
>> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>> [   22.654941] Rebooting in 60 seconds..
>>
>>
>> I would be happy to try any patches.
> 
> Can you try the following patch on latest kernel?
> 
> Thanks for the report!
> Kuai
> 

Please use this patch, I found that last patch has problem while
testing.

Thanks,

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 63879582d1c3..e01c2d0479e3 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2340,7 +2340,10 @@ static int bitmap_get_stats(void *data, struct 
md_bitmap_stats *stats)

         if (!bitmap)
                 return -ENOENT;
-
+       if (bitmap->mddev->bitmap_info.external)
+               return -ENOENT;
+       if (!bitmap->storage.sb_page) /* no superblock */
+               return -EINVAL;
         sb = kmap_local_page(bitmap->storage.sb_page);
         stats->sync_size = le64_to_cpu(sb->sync_size);
         kunmap_local(sb);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 94166b2e9512..c9de57701e43 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8470,6 +8470,10 @@ static int md_seq_show(struct seq_file *seq, void *v)
                 return 0;

         spin_unlock(&all_mddevs_lock);
+
+       /* prevent bitmap to be freed after checking */
+       mutex_lock(&mddev->bitmap_info.mutex);
+
         spin_lock(&mddev->lock);
         if (mddev->pers || mddev->raid_disks || 
!list_empty(&mddev->disks)) {
                 seq_printf(seq, "%s : ", mdname(mddev));
@@ -8545,6 +8549,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
                 seq_printf(seq, "\n");
         }
         spin_unlock(&mddev->lock);
+       mutex_unlock(&mddev->bitmap_info.mutex);
         spin_lock(&all_mddevs_lock);

         if (mddev == list_last_entry(&all_mddevs, struct mddev, 
all_mddevs))

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 94166b2e9512..b07e9c595a7c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8429,12 +8429,14 @@ static void md_bitmap_status(struct seq_file 
> *seq, struct mddev *mddev)
>          unsigned long chunk_kb;
>          int err;
> 
> +       /* prevent bitmap to be freed after checking */
> +       mutex_lock(&mddev->bitmap_info.mutex);
>          if (!md_bitmap_enabled(mddev))
> -               return;
> +               goto out;
> 
>          err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
>          if (err)
> -               return;
> +               goto out;
> 
>          chunk_kb = mddev->bitmap_info.chunksize >> 10;
>          used_pages = stats.pages - stats.missing_pages;
> @@ -8450,6 +8452,9 @@ static void md_bitmap_status(struct seq_file *seq, 
> struct mddev *mddev)
>          }
> 
>          seq_putc(seq, '\n');
> +
> +out:
> +       mutex_unlock(&mddev->bitmap_info.mutex);
>   }
> 
>   static int md_seq_show(struct seq_file *seq, void *v)
> 
>>
>> Thanks,
>> Harshit
>>
> 
> .
> 

