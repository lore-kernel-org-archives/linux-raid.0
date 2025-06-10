Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C699C1442E8;
	Tue, 10 Jun 2025 04:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749531072; cv=none; b=H8nMDB8hvH6qPjCtsoahnmKw9Cd9KVZE2It2CfdueyuYQ6DrcHdzOHlJGa56SMSoVoh4rmaXhMjxXRotuLCAU2JqSdgn0gp2OK6YWTCzRDDxoB3b3+mec5DnmewROaxKZpu5j+Ws+kUth/voagbas2Wd3KuSEFcLKfRtLQSKe90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749531072; c=relaxed/simple;
	bh=uZgphwBeHf778Ln1O1/3OF/G9SwrH0jaR/rDbljnxfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rzKnfp9smxlJi1XNT5lD94vr5karUn3s4QDQMmEUSOLEuDWnHDbazWl5Oj9sI1U7LF6romcCtfS4KzRqarTz0KPgTephcdIxcwLOrkUBwjKzWQg8HTSao/o07v/o+Sl7qPTNNTm6DiZvzNOTxiHjZ8cJFyg8Dmc3OMHvlovCXEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QgnXsmfn; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QgnXsmfn"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-234fcadde3eso59352665ad.0;
        Mon, 09 Jun 2025 21:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749531070; x=1750135870; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODpxTBv56QNZwrv92AANqmn4LxRiBYElDB1MSNxuMXg=;
        b=QgnXsmfnUUSndo04bd6GXLY20+WYLcM7BhzF2IMHpQCIA9q6oHBDPch0ukQAMS2z0v
         NAjFqpCNmxY8J/BBOnJbXy97osMAvResndmnAKEXwpu1XHyXxfgxiJo414ugIudb9sIg
         1HFOcEkKKN0/9B/OnS2MKcqKWzwVqKyl/xwAGaudpvn5nDexi5kVeC470Rn2yDs4tz+r
         +0LiArAREynAdFK7c473shqdBC6cRDrpEDyEKxqmlUjol5ZaybcxXxpHicYWKEih34jc
         6kcxEYTUKLAwt6kodlb/g9JnuFMfE+7Uv3M5xZ8HYP+j0pFKXvHVTXJW87Uj7cB3QyHz
         10gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749531070; x=1750135870;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ODpxTBv56QNZwrv92AANqmn4LxRiBYElDB1MSNxuMXg=;
        b=u9Xht7km+9bulv/zEezu62FfTtUl8eX3y0cUltLXJ9csbSyGidjfC9P+hVssu4PAwu
         NMppsvvg1vskzia2XLiZp+q4UdC+wtLvZSVJrb31CVmIrQSkGyxT0QKSg06ZWEA459a/
         OXA58ZWH6t8tHcWkPxw7vAEQ2w2864FTQZLwr1YxL8OxPsvs4Z94opV1HaM+gjrgT0QB
         Z0aNp/DdS7WMpDnZPLruKKTMjS+B0a7gJIKqzSjqvm/E662PlRypyw+irGc/Ipll6tNm
         SvDmZ0rzEnroCGYRtCnD+uhPjAyyd2WSGAuHUR5BSmehLzdgKLaYGohSVIms5sgA4lCz
         Katw==
X-Forwarded-Encrypted: i=1; AJvYcCW2mIdQRn0q0yta0mtrkYuaCgFwb6CZPqGT6UnaZEaJcqLQonaNZay9TJb1pRwnrePPooFlV7vZAPdOJt8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv5+LIDz2qIJvu7E4CpTpdOk4h/wXu3XpBEjteBM+IrpH3CSf8
	WNYlJ7EjJ+rumH8OADuJcRcyEUpdWo/2PAlwtFzHXG4nkzliw8NDKIc+
X-Gm-Gg: ASbGncuRdQ+dv8zLIO3OJHEWyspN3NcpvaCe3OdKsFCoX+icwB/l1ORbs/GhXl5NKmk
	VxmOt5jHK7Za7k0wUzRwsfo/7oa/UBZdUEJZdkk3H0iqIqwZ+pXWuMadgvQbAwhgz/yOwk0jS9D
	KIAIFZlc0JCVnVMn3pSNnw67KE6Pib3jzIV2ocP0OeIuoeTv8Y2B/PHhlmU8OFdTpFrY9y3heVk
	tJ+zksaMypKLqgw0mGV4iD5RdYZu+6PftCnVjuRBRZJYQObiZrD86BinOBUbtenb1B1GQ2xdbED
	MfgLPxvmYkkyfZSTxbuUaP7nGJtxU5cVt4c4HlPqy0F+/YMWJ3hwRgVtPr2r8oCXS2D5wB2XrAl
	FIk7UOFmLo5Jt
X-Google-Smtp-Source: AGHT+IEKJtUL8M1JO6rk9GhCv5EH9cg9DM/80mATIX85GOuz487A/4l1RxJmNQbEPuoqOwwWeP0hkw==
X-Received: by 2002:a17:902:dace:b0:234:8ec1:4aea with SMTP id d9443c01a7336-23601deb4bemr222422595ad.52.1749531069866;
        Mon, 09 Jun 2025 21:51:09 -0700 (PDT)
Received: from [10.172.10.87] ([123.113.104.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23603511b2bsm62391585ad.243.2025.06.09.21.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jun 2025 21:51:09 -0700 (PDT)
Message-ID: <13a82dab-94c9-4616-90ff-17a8aa7bff81@gmail.com>
Date: Tue, 10 Jun 2025 12:51:04 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid1: Fix use-after-free in reshape pool wait queue
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250609120155.204802-1-wangjinchao600@gmail.com>
 <698d1e9a-2fc0-fa6b-2f4c-55c5129cdf28@huaweicloud.com>
From: Wang Jinchao <wangjinchao600@gmail.com>
In-Reply-To: <698d1e9a-2fc0-fa6b-2f4c-55c5129cdf28@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/6/10 10:52, Yu Kuai 写道:
> Hi,
>
> 在 2025/06/09 20:01, Wang Jinchao 写道:
>> During raid1 reshape operations, a use-after-free can occur in the 
>> mempool
>> wait queue when r1bio_pool->curr_nr drops below min_nr. This happens
>> because:
>
> Can you attach have the uaf log?
[  921.784898] [      C2] BUG: kernel NULL pointer dereference, address: 
0000000000000002
[  921.784907] [      C2] #PF: supervisor instruction fetch in kernel mode
[  921.784910] [      C2] #PF: error_code(0x0010) - not-present page
[  921.784912] [      C2] PGD 0 P4D 0
[  921.784915] [      C2] Oops: 0010 [#1] PREEMPT SMP NOPTI
[  921.784919] [      C2] CPU: 2 PID: 1659 Comm: zds Kdump: loaded 
Tainted: G     U  W   E      6.8.1-debug-0519 #49
[  921.784922] [      C2] Hardware name: Default string Default 
string/Default string, BIOS DNS9V011 12/24/2024
[  921.784923] [      C2] RIP: 0010:0x2
[  921.784929] [      C2] Code: Unable to access opcode bytes at 
0xffffffffffffffd8.
[  921.784931] [      C2] RSP: 0000:ffffa3fac0220c70 EFLAGS: 00010087
[  921.784933] [      C2] RAX: 0000000000000002 RBX: ffff8890539070d8 
RCX: 0000000000000000
[  921.784935] [      C2] RDX: 0000000000000000 RSI: 0000000000000003 
RDI: ffffa3fac07dfc90
[  921.784936] [      C2] RBP: ffffa3fac0220ca8 R08: 2557c7cc905cff00 
R09: 0000000000000000
[  921.784938] [      C2] R10: 0000000000000000 R11: 0000000000000000 
R12: 000000008fa158a0
[  921.784939] [      C2] R13: 2557c7cc905cfee8 R14: 0000000000000000 
R15: 0000000000000000
[  921.784941] [      C2] FS:  00007d8b034006c0(0000) 
GS:ffff8891bf900000(0000) knlGS:0000000000000000
[  921.784943] [      C2] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  921.784945] [      C2] CR2: ffffffffffffffd8 CR3: 00000001097be000 
CR4: 0000000000f50ef0
[  921.784946] [      C2] PKRU: 55555554
[  921.784948] [      C2] Call Trace:
[  921.784949] [      C2]  <IRQ>
[  921.784950] [      C2]  ? show_regs+0x6d/0x80
[  921.784957] [      C2]  ? __die+0x24/0x80
[  921.784960] [      C2]  ? page_fault_oops+0x156/0x4b0
[  921.784964] [      C2]  ? mempool_free_slab+0x17/0x30
[  921.784968] [      C2]  ? __slab_free+0x15d/0x2e0
[  921.784971] [      C2]  ? do_user_addr_fault+0x2ee/0x6b0
[  921.784975] [      C2]  ? exc_page_fault+0x83/0x1b0
[  921.784979] [      C2]  ? asm_exc_page_fault+0x27/0x30
[  921.784984] [      C2]  ? __wake_up_common+0x76/0xb0
[  921.784987] [      C2]  __wake_up+0x37/0x70
[  921.784990] [      C2]  mempool_free+0xaa/0xc0
[  921.784993] [      C2]  raid_end_bio_io+0x97/0x130 [raid1]
[  921.784999] [      C2]  r1_bio_write_done+0x43/0x60 [raid1]
[  921.785005] [      C2]  raid1_end_write_request+0x10e/0x390 [raid1]
[  921.785011] [      C2]  ? scsi_done_internal+0x6f/0xd0
[  921.785014] [      C2]  ? scsi_done+0x10/0x20
[  921.785016] [      C2]  bio_endio+0xeb/0x180
[  921.785021] [      C2]  blk_update_request+0x175/0x540
[  921.785024] [      C2]  ? ata_qc_complete+0xc9/0x340
[  921.785027] [      C2]  scsi_end_request+0x2c/0x1c0
[  921.785029] [      C2]  scsi_io_completion+0x5a/0x700
[  921.785031] [      C2]  scsi_finish_command+0xc3/0x110
[  921.785033] [      C2]  scsi_complete+0x7a/0x180
[  921.785035] [      C2]  blk_complete_reqs+0x41/0x60
[  921.785038] [      C2]  blk_done_softirq+0x1d/0x30
[  921.785041] [      C2]  __do_softirq+0xde/0x35b
[  921.785045] [      C2]  __irq_exit_rcu+0xd7/0x100
[  921.785048] [      C2]  irq_exit_rcu+0xe/0x20
[  921.785050] [      C2]  common_interrupt+0xa4/0xb0
[  921.785052] [      C2]  </IRQ>
[  921.785053] [      C2]  <TASK>
[  921.785055] [      C2]  asm_common_interrupt+0x27/0x40
[  921.785058] [      C2] RIP: 
0010:vma_interval_tree_subtree_search+0x16/0x80
[  921.785061] [      C2] Code: cc cc cc cc 90 90 90 90 90 90 90 90 90 
90 90 90 90 90 90 90 0f 1f 44 00 00 55 48 8b 47 50 48 89 e5 48 85 c0 74 
06 48 39 70 18 <73> 30 48 8b 8f 80 00 00 00 48 39 ca 72 33 48 8b 47 08 
48 2b 07 48
[  921.785064] [      C2] RSP: 0000:ffffa3fac193b200 EFLAGS: 00000206
[  921.785066] [      C2] RAX: ffff889127715368 RBX: ffff889103bde488 
RCX: 0000000000000000
[  921.785068] [      C2] RDX: 00000000000002a8 RSI: 00000000000002a8 
RDI: ffff88910a4d70e8
[  921.785069] [      C2] RBP: ffffa3fac193b200 R08: 00000000000002a8 
R09: 0000000000000000
[  921.785071] [      C2] R10: 0000000000000000 R11: 0000000000000000 
R12: ffffa3fac193b288
[  921.785072] [      C2] R13: 0000799e22def000 R14: ffffde4f0455d240 
R15: 00000000000002a8
[  921.785075] [      C2]  vma_interval_tree_iter_next+0x98/0xb0
[  921.785077] [      C2]  rmap_walk_file+0xe4/0x1a0
[  921.785081] [      C2]  folio_referenced+0x14c/0x1f0
[  921.785083] [      C2]  ? __pfx_folio_referenced_one+0x10/0x10
[  921.785086] [      C2]  ? __pfx_folio_lock_anon_vma_read+0x10/0x10
[  921.785089] [      C2]  ? __pfx_invalid_folio_referenced_vma+0x10/0x10
[  921.785092] [      C2]  shrink_folio_list+0x7c4/0xc80
[  921.785095] [      C2]  evict_folios+0x32c/0x9f0
[  921.785098] [      C2]  ? xa_load+0x86/0xf0
[  921.785103] [      C2]  try_to_shrink_lruvec+0x1f3/0x390
[  921.785105] [      C2]  ? get_swappiness+0x56/0x90
[  921.785109] [      C2]  shrink_one+0x123/0x1e0
[  921.785111] [      C2]  shrink_node+0x9f1/0xcb0
[  921.785114] [      C2]  ? vmpressure+0x37/0x180
[  921.785118] [      C2]  do_try_to_free_pages+0xdf/0x600
[  921.785121] [      C2]  ? throttle_direct_reclaim+0x105/0x280
[  921.785124] [      C2]  try_to_free_pages+0xe6/0x210
[  921.785128] [      C2]  __alloc_pages+0x70c/0x1360
[  921.785131] [      C2]  ? __do_fault+0x38/0x140
[  921.785133] [      C2]  ? do_fault+0x295/0x4c0
[  921.785135] [      C2]  ? do_user_addr_fault+0x169/0x6b0
[  921.785138] [      C2]  ? exc_page_fault+0x83/0x1b0
[  921.785141] [      C2]  ? stack_depot_save+0xe/0x20
[  921.785145] [      C2]  ? set_track_prepare+0x48/0x70
[  921.785148] [      C2]  ? squashfs_page_actor_init_special+0x16e/0x190
[  921.785152] [      C2]  ? squashfs_readahead+0x562/0x8b0
[  921.785155] [      C2]  ? read_pages+0x6a/0x270
[  921.785158] [      C2]  ? policy_nodemask+0xe1/0x150
[  921.785161] [      C2]  alloc_pages_mpol+0x91/0x210
[  921.785164] [      C2]  ? __kmalloc+0x448/0x4e0
[  921.785166] [      C2]  alloc_pages+0x5b/0xd0
[  921.785169] [      C2]  squashfs_bio_read+0x1b4/0x5e0
[  921.785172] [      C2]  squashfs_read_data+0xba/0x650
[  921.785175] [      C2]  squashfs_readahead+0x599/0x8b0
[  921.785178] [      C2]  ? __lruvec_stat_mod_folio+0x70/0xc0
[  921.785180] [      C2]  read_pages+0x6a/0x270
[  921.785184] [      C2]  page_cache_ra_unbounded+0x167/0x1c0
[  921.785187] [      C2]  page_cache_ra_order+0x2cf/0x350
[  921.785191] [      C2]  filemap_fault+0x5f9/0xc10
[  921.785195] [      C2]  __do_fault+0x38/0x140
[  921.785197] [      C2]  do_fault+0x295/0x4c0
[  921.785199] [      C2]  __handle_mm_fault+0x896/0xee0
[  921.785202] [      C2]  ? __fdget+0xc7/0xf0
[  921.785206] [      C2]  handle_mm_fault+0x18a/0x380
[  921.785209] [      C2]  do_user_addr_fault+0x169/0x6b0
[  921.785212] [      C2]  exc_page_fault+0x83/0x1b0
[  921.785215] [      C2]  asm_exc_page_fault+0x27/0x30
[  921.785218] [      C2] RIP: 0033:0x7d8b0391ad50
[  921.785221] [      C2] Code: Unable to access opcode bytes at 
0x7d8b0391ad26.
[  921.785223] [      C2] RSP: 002b:00007d8b033ff9f8 EFLAGS: 00010293
[  921.785225] [      C2] RAX: 000000000000000d RBX: 00007d8b033ffab8 
RCX: 000000000000000e
[  921.785226] [      C2] RDX: 00007d8b033ffa56 RSI: 00007d8b033ffa49 
RDI: 00007d8b033ffac8
[  921.785228] [      C2] RBP: 00007d8b033ffa49 R08: 00007d8b033ffab8 
R09: 0000000000000000
[  921.785229] [      C2] R10: 0000000000000000 R11: 0000000000000000 
R12: 00007d8b033ffa56
[  921.785230] [      C2] R13: 0000000000001388 R14: 0000000000000016 
R15: 00006306da6e18d0
[  921.785233] [      C2]  </TASK>
[  921.785234] [      C2] Modules linked in: raid1(E) xt_geoip(E) 
bcache(E) binfmt_misc(E) cfg80211(E) sch_fq_codel(E) nf_tables(E) 
zfuse(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E) grace(E) sunrpc(E) 
nfnetlink(E) dmi_sysfs(E) ip_tables(E) x_tables(E) autofs4(E) 
nls_iso8859_1(E) btrfs(E) blake2b_generic(E) xor(E) raid6_pq(E) 
libcrc32c(E) input_leds(E) joydev(E) hid_generic(E) xe(E) 
snd_hda_codec_hdmi(E) drm_ttm_helper(E) gpu_sched(E) 
drm_suballoc_helper(E) drm_gpuvm(E) drm_exec(E) snd_sof_pci_intel_tgl(E) 
snd_sof_intel_hda_common(E) snd_soc_hdac_hda(E) snd_sof_pci(E) 
snd_sof_xtensa_dsp(E) snd_sof_intel_hda(E) snd_sof(E) snd_sof_utils(E) 
snd_soc_acpi_intel_match(E) x86_pkg_temp_thermal(E) snd_soc_acpi(E) 
intel_powerclamp(E) coretemp(E) snd_soc_core(E) snd_compress(E) 
snd_sof_intel_hda_mlink(E) snd_hda_ext_core(E) kvm_intel(E) 
snd_hda_intel(E) mmc_block(E) snd_intel_dspcfg(E) kvm(E) irqbypass(E) 
crct10dif_pclmul(E) crc32_pclmul(E) polyval_clmulni(E) 
polyval_generic(E) ghash_clmulni_intel(E) snd_hda_codec(E) snd_hwdep(E)
[  921.785278] [      C2]  sha256_ssse3(E) snd_hda_core(E) mei_hdcp(E) 
i915(E) sha1_ssse3(E) mei_pxp(E) processor_thermal_device_pci(E) 
snd_pcm(E) processor_thermal_device(E) i2c_algo_bit(E) ee1004(E) rapl(E) 
snd_timer(E) nvme(E) sdhci_pci(E) cqhci(E) drm_buddy(E) cmdlinepart(E) 
ttm(E) spi_nor(E) sdhci(E) mei_me(E) processor_thermal_wt_hint(E) 
drm_display_helper(E) nvme_core(E) snd(E) mtd(E) intel_rapl_msr(E) 
intel_cstate(E) efi_pstore(E) nvme_auth(E) soundcore(E) xhci_pci(E) 
xhci_pci_renesas(E) processor_thermal_rfim(E) processor_thermal_rapl(E) 
i2c_i801(E) mei(E) spi_intel_pci(E) spi_intel(E) ahci(E) r8125(E) 
intel_rapl_common(E) processor_thermal_wt_req(E) libahci(E) i2c_smbus(E) 
mmc_core(E) processor_thermal_power_floor(E) cec(E) rc_core(E) 
processor_thermal_mbox(E) int340x_thermal_zone(E) wmi_bmof(E) video(E) 
intel_pmc_core(E) int3400_thermal(E) intel_hid(E) intel_vsec(E) 
pmt_telemetry(E) wmi(E) pmt_class(E) acpi_thermal_rel(E) 
sparse_keymap(E) acpi_pad(E) acpi_tad(E) mac_hid(E) aesni_intel(E) 
crypto_simd(E) cryptd(E)
[  921.785326] [      C2] CR2: 0000000000000002
>>
>> 1. mempool_init() initializes wait queue head on stack
>> 2. The stack-allocated wait queue is copied to conf->r1bio_pool through
>>     structure assignment
>> 3. wake_up() on this invalid wait queue causes panic when accessing the
>>     stack memory that no longer exists
>
> The list_head inside wait_queue_head?
newpool.wait.head
>>
>> Fix this by properly reinitializing the mempool's wait queue using
>> init_waitqueue_head(), ensuring the wait queue structure remains valid
>> throughout the reshape operation.
>>
>> Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
>> ---
>>   drivers/md/raid1.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 19c5a0ce5a40..fd4ce2a4136f 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -3428,6 +3428,7 @@ static int raid1_reshape(struct mddev *mddev)
>>       /* ok, everything is stopped */
>>       oldpool = conf->r1bio_pool;
>>       conf->r1bio_pool = newpool;
>> +    init_waitqueue_head(&conf->r1bio_pool.wait);
>
> I think the real problem here is the above assignment,it's better to
> fix that instead of reinitializing the list.
>
I believe you’re aware of the issue. But just to be sure, I' ll restate it:

1) mempool_t newpool, oldpool; — newpool is allocated on the stack
2) mempool_init(&newpool, ...) — this sets newpool.wait.head to a stack 
address
3) The stack is later freed or reused by another function
4) mempool_free() calls wake_up(&pool->wait), which tries to wake up a 
wait queue using an invalid address → kernel panic

This fix is simple enough.
Alternatively, we could initialize conf->r1bio_pool directly, but that 
would also require
handling rollback in case the initialization fails.
What would you suggest?
> Thanks,
> Kuai
>
>>         for (d = d2 = 0; d < conf->raid_disks; d++) {
>>           struct md_rdev *rdev = conf->mirrors[d].rdev;
>>
>
