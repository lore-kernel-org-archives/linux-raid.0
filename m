Received: from mail.minuette.net (mail.minuette.net [198.50.230.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA55AF9D9
	for <linux-raid@vger.kernel.org>; Sun, 28 Apr 2024 20:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.50.230.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714334873; cv=none; b=QBGye1j92nIZ1PWytnUXma7Zezi2hZ/xYP8Gb8PZx0ZxA7OutnnEfgP8PnXfDH96npP+sVtd7grc+Y3gIgix8BkHlbRvvqz872V4FMfVTC6HPEk6uxm0jFfRUTPaYwFj40pM2RTHiv0wBqrPbE0jE1lB68PwidWA9dNTFRkmkJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714334873; c=relaxed/simple;
	bh=igMvm9L4Dqm5hb43c5CKhKrjWYW7/WqqioYWyd3RYbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FsXN4jjaHztcCmmVWphvNonCRKtfkScVICd6tHhPb1x8/5YZflZxUZmIHxF9LG3fPgGP5RST23gN7lA/OLAt9UAZfhPHuHtDj/8siOZewPi1FJLNXDrkdwOyxE7Sxdld5Fx0MhxHPZ9LXpkMcbuXQSyJBNM1upHVi4RGonMEc4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=minuette.net; spf=pass smtp.mailfrom=minuette.net; dkim=pass (4096-bit key) header.d=minuette.net header.i=@minuette.net header.b=hF2iDFBG; arc=none smtp.client-ip=198.50.230.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=minuette.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=minuette.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=minuette.net header.i=@minuette.net header.b="hF2iDFBG"
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.minuette.net 9ED3A63C8E89
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=minuette.net;
	s=default; t=1714334870;
	bh=jQFqRACUpyDOpeczzLlNcs9fgepyEgZiydNU3ZR7h3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hF2iDFBGEDiqbL+7BBjbe6Wch0UAkO7mitPgu5HxEyFQp8ze4JoFCneVpN+Tj0PCy
	 IH4aGBMVGSmG27xjuhX5cZus2N5tg2J+QxgkjVfNtDu9xMDcMpA1yy326rg3Vbh18p
	 lde1UHMg7RtR8IJTpX9pduNSxCV+ZRhvmxhxDUe7nTSiwfLHu9ytvBLITR7q3FaSXv
	 MQqKL9KUxwhbLoWOZlH/7yzBNjo/iaS+XtNUFo8u8TU/pW/gUGcCp+kbwHel7LbkRZ
	 KR2atI3b6a3TtBhMH0/T6kgbaDdvQpFEaIiB2RQnEasGKJAYaIlWdLGrBpUkD4buZL
	 RcI1Fv7C8FLaroBuZB5nV/M6lzdTtihan3LNjRsxLawtAiLwcYOb+d8njpoZJG5DrW
	 fcuTkfzedXypG+115ep3zA+uNrDWoQWx3KOcKBB1VbuaelD7ASjwVtIH1U7rga8Jaf
	 rLbxzoEHkdsSHAUTR6Jkrd5oAsZPz4eLLvgo5mTDLFBPFbflNeGzJvpmFjPoAP0+xP
	 H4UzCFUPWwroZb1iRrrZb91iCuut2YodTGU5PE2xPaTmfiMPxWBN/lzVJXqUaKQ6Ww
	 V6XqD9gu9CPU94qEhE75WON3Pshg+7kt4AwAzXzDh1RG7gPdXOjc36L+0Y5sNmILl0
	 adBexHfxJ7Eivyoim/86xWD0=
From: Colgate Minuette <rabbit@minuette.net>
To: Paul E Luse <paul.e.luse@linux.intel.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: General Protection Fault in md raid10
Date: Sun, 28 Apr 2024 13:07:49 -0700
Message-ID: <4914495.31r3eYUQgx@sparkler>
In-Reply-To: <20240427092119.24ae3b44@peluse-desk5>
References:
 <8365123.T7Z3S40VBb@sparkler> <20240427092119.24ae3b44@peluse-desk5>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Saturday, April 27, 2024 9:21:19 AM PDT Paul E Luse wrote:
> On Sun, 28 Apr 2024 12:41:13 -0700
> 
> Colgate Minuette <rabbit@minuette.net> wrote:
> > Hello all,
> > 
> > I am trying to set up an md raid-10 array spanning 8 disks using the
> > following command
> > 
> > >mdadm --create /dev/md64 --level=10 --layout=o2 -n 8
> > >/dev/sd[efghijkl]1
> > 
> > The raid is created successfully, but the moment that the newly
> > created raid starts initial sync, a general protection fault is
> > issued. This fault happens on kernels 6.1.85, 6.6.26, and 6.8.5 using
> > mdadm version 4.3. The raid is then completely unusable. After the
> > fault, if I try to stop the raid using
> > 
> > >mdadm --stop /dev/md64
> > 
> > mdadm hangs indefinitely.
> > 
> > I have tried raid levels 0 and 6, and both work as expected without
> > any errors on these same 8 drives. I also have a working md raid-10
> > on the system already with 4 disks(not related to this 8 disk array).
> > 
> > Other things I have tried include trying to create/sync the raid from
> > a debian live environment, and using near/far/offset layouts, but
> > both methods came back with the same protection fault. Also ran a
> > memory test on the computer, but did not have any errors after 10
> > passes.
> > 
> > Below is the output from the general protection fault. Let me know of
> > anything else to try or log information that would be helpful to
> > diagnose.
> > 
> > [   10.965542] md64: detected capacity change from 0 to 120021483520
> > [   10.965593] md: resync of RAID array md64
> > [   10.999289] general protection fault, probably for non-canonical
> > address 0xd071e7fff89be: 0000 [#1] PREEMPT SMP NOPTI
> > [   11.000842] CPU: 4 PID: 912 Comm: md64_raid10 Not tainted
> > 6.1.85-1-MANJARO #1 44ae6c380f5656fa036749a28fdade8f34f2f9ce
> > [   11.001192] Hardware name: ASUS System Product Name/TUF GAMING
> > X670E-PLUS WIFI, BIOS 1618 05/18/2023
> > [   11.001482] RIP: 0010:bio_copy_data_iter+0x187/0x260
> > [   11.001756] Code: 29 f1 4c 29 f6 48 c1 f9 06 48 c1 fe 06 48 c1 e1
> > 0c 48 c1 e6 0c 48 01 e9 48 01 ee 48 01 d9 4c 01 d6 83 fa 08 0f 82 b0
> > fe ff ff <48> 8b 06 48 89 01 89 d0 48 8b 7c 06 f8 48 89 7c 01 f8 48
> > 8d 79 08 [   11.002045] RSP: 0018:ffffa838124ffd28 EFLAGS: 00010216
> > [   11.002336] RAX: ffffca0a84195a80 RBX: 0000000000000000 RCX:
> > ffff89be8656a000 [   11.002628] RDX: 0000000000000642 RSI:
> > 000d071e7fff89be RDI: ffff89beb4039df8 [   11.002922] RBP:
> > ffff89bd80000000 R08: ffffa838124ffd74 R09: ffffa838124ffd60 [
> > 11.003217] R10: 00000000000009be R11: 0000000000002000 R12:
> > ffff89be8bbff400 [   11.003522] R13: ffff89beb4039a00 R14:
> > ffffca0a80000000 R15: 0000000000001000 [   11.003825] FS:
> > 0000000000000000(0000) GS:ffff89c5b8700000(0000) knlGS:
> > 0000000000000000 [   11.004126] CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033 [   11.004429] CR2: 0000563308baac38 CR3:
> > 000000012e900000 CR4: 0000000000750ee0 [   11.004737] PKRU: 55555554
> > [   11.005040] Call Trace:
> > [   11.005342]  <TASK>
> > [   11.005645]  ? __die_body.cold+0x1a/0x1f
> > [   11.005951]  ? die_addr+0x3c/0x60
> > [   11.006256]  ? exc_general_protection+0x1c1/0x380
> > [   11.006562]  ? asm_exc_general_protection+0x26/0x30
> > [   11.006865]  ? bio_copy_data_iter+0x187/0x260
> > [   11.007169]  bio_copy_data+0x5c/0x80
> > [   11.007474]  raid10d+0xcad/0x1c00 [raid10
> > 1721e6c9d579361bf112b0ce400eec9240452da1]
> > [   11.007788]  ? srso_alias_return_thunk+0x5/0x7f
> > [   11.008099]  ? srso_alias_return_thunk+0x5/0x7f
> > [   11.008408]  ? prepare_to_wait_event+0x60/0x180
> > [   11.008720]  ? unregister_md_personality+0x70/0x70 [md_mod
> > 64c55bfe07bb9f714eafd175176a02873a443cb7]
> > [   11.009039]  md_thread+0xab/0x190 [md_mod
> > 64c55bfe07bb9f714eafd175176a02873a443cb7]
> > [   11.009359]  ? sched_energy_aware_handler+0xb0/0xb0
> > [   11.009681]  kthread+0xdb/0x110
> > [   11.009996]  ? kthread_complete_and_exit+0x20/0x20
> > [   11.010319]  ret_from_fork+0x1f/0x30
> > [   11.010325]  </TASK>
> > [   11.010326] Modules linked in: platform_profile libarc4
> > snd_hda_core snd_hwdep i8042 realtek kvm cfg80211 snd_pcm sp5100_tco
> > mdio_devres serio snd_timer raid10 irqbypass wmi_bmof pcspkr k10temp
> > i2c_piix4 rapl rfkill libphy snd soundcore md_mod gpio_amdpt
> > acpi_cpufreq gpio_generic mac_hid uinput i2c_dev sg crypto_user fuse
> > loop nfnetlink bpf_preload ip_tables x_tables ext4 crc32c_generic
> > crc16 mbcache jbd2 usbhid dm_crypt cbc encrypted_keys trusted
> > asn1_encoder tee dm_mod crct10dif_pclmul crc32_pclmul crc32c_intel
> > polyval_clmulni polyval_generic gf128mul ghash_clmulni_intel
> > sha512_ssse3 sha256_ssse3 sha1_ssse3 nvme aesni_intel crypto_simd
> > mpt3sas nvme_core cryptd ccp nvme_common xhci_pci raid_class
> > xhci_pci_renesas scsi_transport_sas amdgpu drm_ttm_helper ttm video
> > wmi gpu_sched drm_buddy drm_display_helper cec [   11.012188] ---[
> > end trace 0000000000000000 ]---
> 
> I wish had some some ides for you, I'm sure others will soon.  Two
> quick questions though:
> 
> 1) what is the manuf/model of the 8 drives?
> 2) have you tried creating a 4 disk RAID10 out of those drives? (just
> curious since you have a 4 disk RAID10 working there)
> 
> -Paul

1. Samsung MZILS15THMLS-0G5, "1633a"
2. I tried making a 4 disk and a 3 disk RAID10, both immediately had the same 
protection fault upon initial sync.

-Colgate


