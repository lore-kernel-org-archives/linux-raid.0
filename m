Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A527CF9D9
	for <linux-raid@vger.kernel.org>; Sun, 28 Apr 2024 19:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714333993; cv=none; b=WzmTkHoO6bSYKY4Gm0yY0K02PvGY34p9giTi30cOx5VHMhdeikRcNWBloFWznM2vVyIr9mUoCUfP2Uqk6/eBXKIsLqq1/+9VDTgv/wd3vdWpNBbG4PZ1b/lPj7gQV7jVSRIL+Bwuhq98G0X8/6spJP8At0fQ51zkzkRZis7pdOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714333993; c=relaxed/simple;
	bh=MmJu7GJ9zXUR4xhqz1CIF1rnVvXAqwzgHzDinVpp21M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B9kXMiOPK8AaV+FAOn9r7dsPD7t753KTAnmfhRwYtSR7xz6AviNR0+G5utZ+F9F9Qlt+yB/z8Sd6ZEtwkKd81aM1unUePpuyIkpjxng9hTD2eL2mbey8Twcg1WFnEtFKP5Os99uMuS72kemMk0UggeTEOjTmmPP6tXBD346ivkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yg8D75kl; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yg8D75kl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714333991; x=1745869991;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MmJu7GJ9zXUR4xhqz1CIF1rnVvXAqwzgHzDinVpp21M=;
  b=Yg8D75kl1izZD6/oTUtmmD4OHmEl7R0nK9aLiNGWMq9o0NlVZkDXmNml
   VUmIBfMYtnmxNO7Q2f7dHlHIW3T7hihf95IxyP+zdHT4Ib7Wf/6LRbCpA
   fG0E2mEBauefo0sA0S+CbHBuDmlM1wKqf37FERuE0//L70a7e2+iC/Zfh
   Sm5NP9r9IUu329bYSsVBeq0TOXCfMJuaW1d9ZJQyaNkrzQ3MjmpnpulSA
   djzRBzvvCPBa+spslwfhskKwa9+8d3cpqMtSM0sZXPh64EOsn2UkQvtM6
   XaP8BPrsAWnLr6f39RJfKrwY02sbW1GS2V6leEl1aWuL4GzfAD0ibIZE7
   g==;
X-CSE-ConnectionGUID: qssWS4c3SDabWLH/Chv9RA==
X-CSE-MsgGUID: g7LcGfGxSD64ocFInlozZw==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="9868183"
X-IronPort-AV: E=Sophos;i="6.07,238,1708416000"; 
   d="scan'208";a="9868183"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2024 12:53:10 -0700
X-CSE-ConnectionGUID: RIedFaKJSbO6IC0jdEQfCw==
X-CSE-MsgGUID: PODNHjyPRzGwFxfuPEEciQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,238,1708416000"; 
   d="scan'208";a="26013702"
Received: from jessep1-mobl2.amr.corp.intel.com (HELO peluse-desk5) ([10.212.50.38])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2024 12:53:10 -0700
Date: Sat, 27 Apr 2024 09:21:19 -0700
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: Colgate Minuette <rabbit@minuette.net>
Cc: linux-raid@vger.kernel.org
Subject: Re: General Protection Fault in md raid10
Message-ID: <20240427092119.24ae3b44@peluse-desk5>
In-Reply-To: <8365123.T7Z3S40VBb@sparkler>
References: <8365123.T7Z3S40VBb@sparkler>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; aarch64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 28 Apr 2024 12:41:13 -0700
Colgate Minuette <rabbit@minuette.net> wrote:

> Hello all,
> 
> I am trying to set up an md raid-10 array spanning 8 disks using the
> following command
> 
> >mdadm --create /dev/md64 --level=10 --layout=o2 -n 8
> >/dev/sd[efghijkl]1  
> 
> The raid is created successfully, but the moment that the newly
> created raid starts initial sync, a general protection fault is
> issued. This fault happens on kernels 6.1.85, 6.6.26, and 6.8.5 using
> mdadm version 4.3. The raid is then completely unusable. After the
> fault, if I try to stop the raid using
> 
> >mdadm --stop /dev/md64  
> 
> mdadm hangs indefinitely.
> 
> I have tried raid levels 0 and 6, and both work as expected without
> any errors on these same 8 drives. I also have a working md raid-10
> on the system already with 4 disks(not related to this 8 disk array).
> 
> Other things I have tried include trying to create/sync the raid from
> a debian live environment, and using near/far/offset layouts, but
> both methods came back with the same protection fault. Also ran a
> memory test on the computer, but did not have any errors after 10
> passes.
> 
> Below is the output from the general protection fault. Let me know of
> anything else to try or log information that would be helpful to
> diagnose.
> 
> [   10.965542] md64: detected capacity change from 0 to 120021483520
> [   10.965593] md: resync of RAID array md64
> [   10.999289] general protection fault, probably for non-canonical
> address 0xd071e7fff89be: 0000 [#1] PREEMPT SMP NOPTI
> [   11.000842] CPU: 4 PID: 912 Comm: md64_raid10 Not tainted
> 6.1.85-1-MANJARO #1 44ae6c380f5656fa036749a28fdade8f34f2f9ce
> [   11.001192] Hardware name: ASUS System Product Name/TUF GAMING
> X670E-PLUS WIFI, BIOS 1618 05/18/2023
> [   11.001482] RIP: 0010:bio_copy_data_iter+0x187/0x260
> [   11.001756] Code: 29 f1 4c 29 f6 48 c1 f9 06 48 c1 fe 06 48 c1 e1
> 0c 48 c1 e6 0c 48 01 e9 48 01 ee 48 01 d9 4c 01 d6 83 fa 08 0f 82 b0
> fe ff ff <48> 8b 06 48 89 01 89 d0 48 8b 7c 06 f8 48 89 7c 01 f8 48
> 8d 79 08 [   11.002045] RSP: 0018:ffffa838124ffd28 EFLAGS: 00010216
> [   11.002336] RAX: ffffca0a84195a80 RBX: 0000000000000000 RCX:
> ffff89be8656a000 [   11.002628] RDX: 0000000000000642 RSI:
> 000d071e7fff89be RDI: ffff89beb4039df8 [   11.002922] RBP:
> ffff89bd80000000 R08: ffffa838124ffd74 R09: ffffa838124ffd60 [
> 11.003217] R10: 00000000000009be R11: 0000000000002000 R12:
> ffff89be8bbff400 [   11.003522] R13: ffff89beb4039a00 R14:
> ffffca0a80000000 R15: 0000000000001000 [   11.003825] FS:
> 0000000000000000(0000) GS:ffff89c5b8700000(0000) knlGS:
> 0000000000000000 [   11.004126] CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033 [   11.004429] CR2: 0000563308baac38 CR3:
> 000000012e900000 CR4: 0000000000750ee0 [   11.004737] PKRU: 55555554
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
> [   11.010326] Modules linked in: platform_profile libarc4
> snd_hda_core snd_hwdep i8042 realtek kvm cfg80211 snd_pcm sp5100_tco
> mdio_devres serio snd_timer raid10 irqbypass wmi_bmof pcspkr k10temp
> i2c_piix4 rapl rfkill libphy snd soundcore md_mod gpio_amdpt
> acpi_cpufreq gpio_generic mac_hid uinput i2c_dev sg crypto_user fuse
> loop nfnetlink bpf_preload ip_tables x_tables ext4 crc32c_generic
> crc16 mbcache jbd2 usbhid dm_crypt cbc encrypted_keys trusted
> asn1_encoder tee dm_mod crct10dif_pclmul crc32_pclmul crc32c_intel
> polyval_clmulni polyval_generic gf128mul ghash_clmulni_intel
> sha512_ssse3 sha256_ssse3 sha1_ssse3 nvme aesni_intel crypto_simd
> mpt3sas nvme_core cryptd ccp nvme_common xhci_pci raid_class
> xhci_pci_renesas scsi_transport_sas amdgpu drm_ttm_helper ttm video
> wmi gpu_sched drm_buddy drm_display_helper cec [   11.012188] ---[
> end trace 0000000000000000 ]---
> 
> 
> 
I wish had some some ides for you, I'm sure others will soon.  Two
quick questions though:

1) what is the manuf/model of the 8 drives?
2) have you tried creating a 4 disk RAID10 out of those drives? (just
curious since you have a 4 disk RAID10 working there)

-Paul


