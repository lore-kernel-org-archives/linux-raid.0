Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E167F
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 01:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714352560; cv=none; b=azTuU0t0yRy4sKT/mPDsHBcTLPuskV5LdUbd72AQ5C3meoi5Y4/u5y5BO11yTpnNW6i/U4Hb2SGqLBDExTYbsQhMvdQFseCzDWBPlFfBV7XCUTHM1UKkrx72PRDIhvgB7KxpO0ldZC9SqZvWUoNRpukJkJa2TyxrK5jILXpI2JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714352560; c=relaxed/simple;
	bh=xAMfWYRaetkmTMKXU7mamhIIleGfp3BaxsCJ8OFaI0U=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=B77oDznPSB8+V+7En2Qpt7Ppce69CCD7vyn1SlPXACWSC+t9rkzolvPhOzsaYJKGu5BT+ixHbhdsmkKXQJ/s/fMlbcN+Uc2nX/WYYN5MX2maMnwXW3m6k1u2Th7giYsYu+BGIMOk9A43PMtV1GI1tAM4YzPY3BIZJluc8wbc9h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VSQ664TpKz4f3m76
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 09:02:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 0E4051A0568
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 09:02:32 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX6RGm8S5myOL0LA--.14864S3;
	Mon, 29 Apr 2024 09:02:31 +0800 (CST)
Subject: Re: General Protection Fault in md raid10
To: Colgate Minuette <rabbit@minuette.net>, linux-raid@vger.kernel.org
References: <8365123.T7Z3S40VBb@sparkler>
Cc: "yukuai (C)" <yukuai3@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <208eb375-4859-3b32-59d6-7243f9892f1e@huaweicloud.com>
Date: Mon, 29 Apr 2024 09:02:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <8365123.T7Z3S40VBb@sparkler>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX6RGm8S5myOL0LA--.14864S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXrW5CF4xJFW5Gry5Zw4DXFb_yoW7Gr47pF
	W7try5Gr48trnrJwn7Xw1kCw18JrsrZa97Gry3Xr10y3W5Wr1qqr18KF4UKF17Gr4Yvry2
	vF1Dt3Z5Kr98AaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
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
	c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/04/29 3:41, Colgate Minuette Ð´µÀ:
> Hello all,
> 
> I am trying to set up an md raid-10 array spanning 8 disks using the following
> command
> 
>> mdadm --create /dev/md64 --level=10 --layout=o2 -n 8 /dev/sd[efghijkl]1
> 
> The raid is created successfully, but the moment that the newly created raid
> starts initial sync, a general protection fault is issued. This fault happens
> on kernels 6.1.85, 6.6.26, and 6.8.5 using mdadm version 4.3. The raid is then
> completely unusable. After the fault, if I try to stop the raid using
> 
>> mdadm --stop /dev/md64
> 
> mdadm hangs indefinitely.
> 
> I have tried raid levels 0 and 6, and both work as expected without any errors
> on these same 8 drives. I also have a working md raid-10 on the system already
> with 4 disks(not related to this 8 disk array).
> 
> Other things I have tried include trying to create/sync the raid from a debian
> live environment, and using near/far/offset layouts, but both methods came back
> with the same protection fault. Also ran a memory test on the computer, but
> did not have any errors after 10 passes.
> 
> Below is the output from the general protection fault. Let me know of anything
> else to try or log information that would be helpful to diagnose.
> 
> [   10.965542] md64: detected capacity change from 0 to 120021483520
> [   10.965593] md: resync of RAID array md64
> [   10.999289] general protection fault, probably for non-canonical address
> 0xd071e7fff89be: 0000 [#1] PREEMPT SMP NOPTI
> [   11.000842] CPU: 4 PID: 912 Comm: md64_raid10 Not tainted 6.1.85-1-MANJARO
> #1 44ae6c380f5656fa036749a28fdade8f34f2f9ce
> [   11.001192] Hardware name: ASUS System Product Name/TUF GAMING X670E-PLUS
> WIFI, BIOS 1618 05/18/2023
> [   11.001482] RIP: 0010:bio_copy_data_iter+0x187/0x260
> [   11.001756] Code: 29 f1 4c 29 f6 48 c1 f9 06 48 c1 fe 06 48 c1 e1 0c 48 c1
> e6 0c 48 01 e9 48 01 ee 48 01 d9 4c 01 d6 83 fa 08 0f 82 b0 fe ff ff <48> 8b 06
> 48 89 01 89 d0 48 8b 7c 06 f8 48 89 7c 01 f8 48 8d 79 08
> [   11.002045] RSP: 0018:ffffa838124ffd28 EFLAGS: 00010216
> [   11.002336] RAX: ffffca0a84195a80 RBX: 0000000000000000 RCX: ffff89be8656a000
> [   11.002628] RDX: 0000000000000642 RSI: 000d071e7fff89be RDI: ffff89beb4039df8
> [   11.002922] RBP: ffff89bd80000000 R08: ffffa838124ffd74 R09: ffffa838124ffd60
> [   11.003217] R10: 00000000000009be R11: 0000000000002000 R12: ffff89be8bbff400
> [   11.003522] R13: ffff89beb4039a00 R14: ffffca0a80000000 R15: 0000000000001000
> [   11.003825] FS:  0000000000000000(0000) GS:ffff89c5b8700000(0000) knlGS:
> 0000000000000000
> [   11.004126] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   11.004429] CR2: 0000563308baac38 CR3: 000000012e900000 CR4:
> 0000000000750ee0
> [   11.004737] PKRU: 55555554
> [   11.005040] Call Trace:
> [   11.005342]  <TASK>
> [   11.005645]  ? __die_body.cold+0x1a/0x1f
> [   11.005951]  ? die_addr+0x3c/0x60
> [   11.006256]  ? exc_general_protection+0x1c1/0x380
> [   11.006562]  ? asm_exc_general_protection+0x26/0x30
> [   11.006865]  ? bio_copy_data_iter+0x187/0x260
> [   11.007169]  bio_copy_data+0x5c/0x80
> [   11.007474]  raid10d+0xcad/0x1c00 [raid10
> 1721e6c9d579361bf112b0ce400eec9240452da1]
Can you try to use addr2line or gdb to locate which this code line
is this correspond to?

I never see problem like this before... And it'll be greate if you
can bisect this since you can reporduce this problem easily.

Thanks,
Kuai

> [   11.007788]  ? srso_alias_return_thunk+0x5/0x7f
> [   11.008099]  ? srso_alias_return_thunk+0x5/0x7f
> [   11.008408]  ? prepare_to_wait_event+0x60/0x180
> [   11.008720]  ? unregister_md_personality+0x70/0x70 [md_mod
> 64c55bfe07bb9f714eafd175176a02873a443cb7]
> [   11.009039]  md_thread+0xab/0x190 [md_mod
> 64c55bfe07bb9f714eafd175176a02873a443cb7]
> [   11.009359]  ? sched_energy_aware_handler+0xb0/0xb0
> [   11.009681]  kthread+0xdb/0x110
> [   11.009996]  ? kthread_complete_and_exit+0x20/0x20
> [   11.010319]  ret_from_fork+0x1f/0x30
> [   11.010325]  </TASK>
> [   11.010326] Modules linked in: platform_profile libarc4 snd_hda_core
> snd_hwdep i8042 realtek kvm cfg80211 snd_pcm sp5100_tco mdio_devres serio
> snd_timer raid10 irqbypass wmi_bmof pcspkr k10temp i2c_piix4 rapl rfkill
> libphy snd soundcore md_mod gpio_amdpt acpi_cpufreq gpio_generic mac_hid
> uinput i2c_dev sg crypto_user fuse loop nfnetlink bpf_preload ip_tables
> x_tables ext4 crc32c_generic crc16 mbcache jbd2 usbhid dm_crypt cbc
> encrypted_keys trusted asn1_encoder tee dm_mod crct10dif_pclmul crc32_pclmul
> crc32c_intel polyval_clmulni polyval_generic gf128mul ghash_clmulni_intel
> sha512_ssse3 sha256_ssse3 sha1_ssse3 nvme aesni_intel crypto_simd mpt3sas
> nvme_core cryptd ccp nvme_common xhci_pci raid_class xhci_pci_renesas
> scsi_transport_sas amdgpu drm_ttm_helper ttm video wmi gpu_sched drm_buddy
> drm_display_helper cec
> [   11.012188] ---[ end trace 0000000000000000 ]---
> 
> 
> 
> .
> 

