Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2B7C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  7 Sep 2021 22:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A846C60F14
	for <linux-raid@archiver.kernel.org>; Tue,  7 Sep 2021 22:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbhIGW44 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Sep 2021 18:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhIGW44 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Sep 2021 18:56:56 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6C2C061575
        for <linux-raid@vger.kernel.org>; Tue,  7 Sep 2021 15:55:49 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id w8so434908pgf.5
        for <linux-raid@vger.kernel.org>; Tue, 07 Sep 2021 15:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E4q73Bu3Paj3YnvT2XoH7BwAHEW0BBlEeh8Ls03I2C4=;
        b=hAt/gL1LRTeGswoMalBj3IweKFtRHYgMOFuY3yQ+0KyzSEVa4y+kzd8oVcsUd+Y5NZ
         N/Xa3ku/PTgkZDEjophBq1YEw4VNV6e7pXXD9WISH9oYETVu39/yhF2hwW6mOKYyHebz
         BGTQFOoBev4k1BPNuT+KXHue8Vz+og4CPNQIufiAC7dnJn4HdO1CHYd6ou2fd4fbnzZe
         /C28x9OJXb9/ShOnuMrTTtfljiJC4nUKd0UdEkOxGYRievyApnyR6VV7h5Z4wKJl+C8S
         vfyVa/xjhrIg137ihNwkIe+VTK5WcqwNDdfAAuDx+7+72YdoOgJI/MUFYAYMNtQe/vPM
         /w0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E4q73Bu3Paj3YnvT2XoH7BwAHEW0BBlEeh8Ls03I2C4=;
        b=REMXPjeEXT6pkkCFh77YG/Sz3jNn5463mooLA43LAwZvRCiYoopw/AmG1FiwcYIqHQ
         aeqVfauhoUlSZ5vU19lvnTC6eLQKrT1VkUwNfUjCAj3FE8AarCEnhercXIvA+nhU7BZO
         I4hzdRfXR/W5plNJbR/OKLtA4HgEQW0gkfDqDUprLLmzsq0zEpEeGJIUx3WrlwgmAHYj
         6xEE2cZ9nMxdp7AKLvE/Z8CZl/HWClQlGcoVR6qBqBiGkZGjVUA9jzYDxgNBZGVpQKkY
         Dvp2b5bHGNKNmc816t2FIm7N/m/TWh8g0L8la5PSmUOX0mbB1xAm1qdhCUuEoNpraD87
         ReKg==
X-Gm-Message-State: AOAM532qtUQRD+VYk7Z950jOxMXWoldk4dffYDBt+2zYtDKyblU8uyGg
        V2B7/oiBUkOgzgAyETuIoiJLpoNtLQ280bYdH6JUCakYjKc=
X-Google-Smtp-Source: ABdhPJz2xWCjMzBCKVzUJzgm9ahN7zENBQ1u1vFP3JTy5HZ5Pb1OqaQ3T3TEaS+BIng0poL4C7xN9EVDj4ts/0eRkZY=
X-Received: by 2002:a65:67d6:: with SMTP id b22mr640890pgs.430.1631055348535;
 Tue, 07 Sep 2021 15:55:48 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Kggd7mUF9MWdJsLtAQMv=KXtwaNvj6BqfM+NMyffE86iHBoQ@mail.gmail.com>
 <20210907125201.0cc77658@natsu> <20210907141835.259010e3@natsu>
In-Reply-To: <20210907141835.259010e3@natsu>
From:   Ryan Patterson <ryan.goat@gmail.com>
Date:   Tue, 7 Sep 2021 18:55:37 -0400
Message-ID: <CA+Kggd6AghdZt6YpBL24xC5TtMKqUiaHyoiyRLd2+dVJhVOP7w@mail.gmail.com>
Subject: Re: mdadm resync causes stable system to crash every 2 or 3 hours
To:     Roman Mamedov <rm@romanrm.net>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Sep 7, 2021 at 5:18 AM Roman Mamedov <rm@romanrm.net> wrote:
>
> On Tue, 7 Sep 2021 12:52:01 +0500
> Roman Mamedov <rm@romanrm.net> wrote:
>
> > On Mon, 6 Sep 2021 20:44:31 -0400
> > Ryan Patterson <ryan.goat@gmail.com> wrote:
> >
> > > My file server is usually very stable.  The past week I had two mdadm
> > > arrays that required recync operations.
> > > * newly created raid6 array (14 x 16TB seagate exos)
> > > * existing raid 6 array, after a reboot resync on hot spare (14 x 4TB
> > > seagate barracuda)
> > >
> > > During both resync operations (they ran one at a time) the system
> > > would routinely experience a major error and require a hard reboot,
> > > every two or three hours.  I saw several errors, such as:
> > > * kernel watchdog soft lockups [md127_raid6:364]
> > > * general protection faults (I have a few saved with the full exception stack)
> > > * exceptions in iommu routines (again I have the full error with
> > > exception stack saved)
> > > * full system lockup
> >
> > So in other words the server is very stable, unless asked to do full-speed
> > reads from all disks at the same time.
> >
> > I'd suggest to check or improve cooling on the HBA cards, and then try a
> > different PSU.
>
> Also the motherboard chipset cooling, since that's a lot of PCI-E traffic.
> Maybe the CPU cooling as well, or at least check the CPU temperatures during
> this load.
>
> And since you have full logs and backtraces, there's no point in waiting to
> post those, just go ahead. Maybe they will point to something other than
> suspect hardware, or at least to which part of hardware to suspect.
>
> --
> With respect,
> Roman

Thanks for the suggestions.  Hardware overheating might be my problem.
I have several (loud) case fans blowing away.  But the HBA cards and
mobo southbridge are only passively cooled.  Maybe I could mount fans
on each cards' headsink.  I'll investigate.

The power supply is not an off the shelf job.  So I don't convientanly
have a replacement to try.  I might have to bite the bullet and buy a
second.

I forgot to put in my original note that I ran memtest86 on this
machine for four full cycles with no faults found.  Also nothing is
overclocked.

Here are some of the errors I recorded.  Maybe somebody can see a
pattern in them...

[Thu Sep  2 22:05:25 2021] md: resync of RAID array md127
[Thu Sep  2 23:58:58 2021] perf: interrupt took too long (2570 >
2500), lowering kernel.perf_event_max_sample_rate to 77750
[Fri Sep  3 02:14:38 2021] general protection fault, probably for
non-canonical address 0x1000000000000: 0000 [#1] SMP PTI
[Fri Sep  3 02:14:38 2021] CPU: 3 PID: 371 Comm: md127_raid6 Not
tainted 5.10.0-8-amd64 #1 Debian 5.10.46-4
[Fri Sep  3 02:14:38 2021] Hardware name: Gigabyte Technology Co.,
Ltd. Z87X-UD4H/Z87X-UD4H-CF, BIOS F9 03/18/2014
[Fri Sep  3 02:14:38 2021] RIP: 0010:bio_associate_blkg+0x17/0x70
[Fri Sep  3 02:14:38 2021] Code: dc fe ff ff 48 89 c3 e9 05 ff ff ff
0f 1f 80 00 00 00 00 0f 1f 44 00 00 48 83 ec 08 48 8b 47 48 48 85 c0
74 17 48 85 ff 74 3d <48> 8b 70 28 e8 d0 fc ff ff 48 83 c4 08 e9 b7 c1
cc ff 48 89 3c 24
[Fri Sep  3 02:14:38 2021] RSP: 0018:ffffbde280747b58 EFLAGS: 00010286
[Fri Sep  3 02:14:38 2021] RAX: 0001000000000000 RBX: ffff95f8334a8000
RCX: 0000000000000000
[Fri Sep  3 02:14:38 2021] RDX: 0000000000000001 RSI: 00000000000000c0
RDI: ffff95f8334a8c60
[Fri Sep  3 02:14:38 2021] RBP: ffff95f700dfb400 R08: 0000000000000001
R09: 00000000fffffffd
[Fri Sep  3 02:14:38 2021] R10: 0000000000000000 R11: ffff95f8334a8c60
R12: 0000000000000b80
[Fri Sep  3 02:14:38 2021] R13: 0000000000000000 R14: ffff95f741a09000
R15: ffff95f8334a8000
[Fri Sep  3 02:14:38 2021] FS:  0000000000000000(0000)
GS:ffff95fe1f2c0000(0000) knlGS:0000000000000000
[Fri Sep  3 02:14:38 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Fri Sep  3 02:14:38 2021] CR2: 00007f3cbf016514 CR3: 00000005c740a001
CR4: 00000000001706e0
[Fri Sep  3 02:14:38 2021] Call Trace:
[Fri Sep  3 02:14:38 2021]  ops_run_io+0x43d/0xd20 [raid456]
[Fri Sep  3 02:14:38 2021]  ? irq_init_percpu_irqstack+0x80/0x100
[Fri Sep  3 02:14:38 2021]  handle_stripe+0xd9e/0x1fd0 [raid456]
[Fri Sep  3 02:14:38 2021]
handle_active_stripes.constprop.0+0x3af/0x590 [raid456]
[Fri Sep  3 02:14:38 2021]  raid5d+0x375/0x5a0 [raid456]
[Fri Sep  3 02:14:38 2021]  md_thread+0x94/0x160 [md_mod]
[Fri Sep  3 02:14:38 2021]  ? add_wait_queue_exclusive+0x70/0x70
[Fri Sep  3 02:14:38 2021]  ? md_write_inc+0x50/0x50 [md_mod]
[Fri Sep  3 02:14:38 2021]  kthread+0x11b/0x140
[Fri Sep  3 02:14:38 2021]  ? __kthread_bind_mask+0x60/0x60
[Fri Sep  3 02:14:38 2021]  ret_from_fork+0x22/0x30
[Fri Sep  3 02:14:38 2021] Modules linked in: ipt_REJECT
nf_reject_ipv4 xt_multiport nft_compat nft_counter nf_tables nfnetlink
rfkill nls_ascii nls_cp437 vfat fat snd_hda_codec_realtek
snd_hda_codec_generic mei_hdcp intel_rapl_msr snd_hda_codec_hdmi led
trig_audio snd_hda_intel snd_intel_dspcfg soundwire_intel
soundwire_generic_allocation snd_soc_core snd_compress
soundwire_cadence snd_hda_codec snd_hda_core snd_hwdep soundwire_bus
snd_pcm intel_rapl_common x86_pkg_temp_thermal intel_powerclamp
coretemp
 kvm_intel iTCO_wdt snd_timer kvm sg mei_me mei snd intel_pmc_bxt
soundcore irqbypass iTCO_vendor_support at24 watchdog evdev pcspkr
efi_pstore rapl intel_cstate intel_uncore sunrpc msr fuse configfs
efivarfs ip_tables x_tables autofs4 ext4 crc16 mbcache
 jbd2 btrfs blake2b_generic dm_crypt dm_mod raid10 raid1 raid0
multipath linear raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_pq libcrc32c crc32c_generic md_mod sd_mod
t10_pi crc_t10dif crct10dif_generic hid_generic usbhid
hid
[Fri Sep  3 02:14:38 2021]  i915 crct10dif_pclmul crct10dif_common
crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel i2c_algo_bit
drm_kms_helper libaes mxm_wmi crypto_simd ahci libahci mpt3sas
i2c_i801 cryptd xhci_pci glue_helper i2c_smbus cec xh
ci_hcd libata drm raid_class ehci_pci scsi_transport_sas lpc_ich
ehci_hcd e1000e scsi_mod usbcore ptp pps_core usb_common fan wmi video
button
[Fri Sep  3 02:14:38 2021] ---[ end trace 5cc209277d97aabd ]---
[Fri Sep  3 02:14:38 2021] RIP: 0010:bio_associate_blkg+0x17/0x70
[Fri Sep  3 02:14:38 2021] Code: dc fe ff ff 48 89 c3 e9 05 ff ff ff
0f 1f 80 00 00 00 00 0f 1f 44 00 00 48 83 ec 08 48 8b 47 48 48 85 c0
74 17 48 85 ff 74 3d <48> 8b 70 28 e8 d0 fc ff ff 48 83 c4 08 e9 b7 c1
cc ff 48 89 3c 24
[Fri Sep  3 02:14:38 2021] RSP: 0018:ffffbde280747b58 EFLAGS: 00010286
[Fri Sep  3 02:14:38 2021] RAX: 0001000000000000 RBX: ffff95f8334a8000
RCX: 0000000000000000
[Fri Sep  3 02:14:38 2021] RDX: 0000000000000001 RSI: 00000000000000c0
RDI: ffff95f8334a8c60
[Fri Sep  3 02:14:38 2021] RBP: ffff95f700dfb400 R08: 0000000000000001
R09: 00000000fffffffd
[Fri Sep  3 02:14:38 2021] R10: 0000000000000000 R11: ffff95f8334a8c60
R12: 0000000000000b80
[Fri Sep  3 02:14:38 2021] R13: 0000000000000000 R14: ffff95f741a09000
R15: ffff95f8334a8000
[Fri Sep  3 02:14:38 2021] FS:  0000000000000000(0000)
GS:ffff95fe1f2c0000(0000) knlGS:0000000000000000
[Fri Sep  3 02:14:38 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Fri Sep  3 02:14:38 2021] CR2: 00007f3cbf016514 CR3: 000000010828e003
CR4: 00000000001706e0
[Fri Sep  3 02:14:38 2021] ------------[ cut here ]------------
[Fri Sep  3 02:14:38 2021] WARNING: CPU: 3 PID: 371 at
kernel/exit.c:725 do_exit+0x47/0xaa0
[Fri Sep  3 02:14:38 2021] Modules linked in: ipt_REJECT
nf_reject_ipv4 xt_multiport nft_compat nft_counter nf_tables nfnetlink
rfkill nls_ascii nls_cp437 vfat fat snd_hda_codec_realtek
snd_hda_codec_generic mei_hdcp intel_rapl_msr snd_hda_codec_hdmi led
trig_audio snd_hda_intel snd_intel_dspcfg soundwire_intel
soundwire_generic_allocation snd_soc_core snd_compress
soundwire_cadence snd_hda_codec snd_hda_core snd_hwdep soundwire_bus
snd_pcm intel_rapl_common x86_pkg_temp_thermal intel_powerclamp
coretemp
 kvm_intel iTCO_wdt snd_timer kvm sg mei_me mei snd intel_pmc_bxt
soundcore irqbypass iTCO_vendor_support at24 watchdog evdev pcspkr
efi_pstore rapl intel_cstate intel_uncore sunrpc msr fuse configfs
efivarfs ip_tables x_tables autofs4 ext4 crc16 mbcache
 jbd2 btrfs blake2b_generic dm_crypt dm_mod raid10 raid1 raid0
multipath linear raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_pq libcrc32c crc32c_generic md_mod sd_mod
t10_pi crc_t10dif crct10dif_generic hid_generic usbhid
hid
[Fri Sep  3 02:14:38 2021]  i915 crct10dif_pclmul crct10dif_common
crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel i2c_algo_bit
drm_kms_helper libaes
mxm_wmi crypto_simd ahci libahci mpt3sas i2c_i801 cryptd xhci_pci
glue_helper i2c_smbus cec xh
ci_hcd libata drm raid_class ehci_pci scsi_transport_sas lpc_ich
ehci_hcd e1000e scsi_mod usbcore ptp pps_core usb_common fan wmi video
button
[Fri Sep  3 02:14:38 2021] CPU: 3 PID: 371 Comm: md127_raid6 Tainted:
G      D           5.10.0-8-amd64 #1 Debian 5.10.46-4
[Fri Sep  3 02:14:38 2021] Hardware name: Gigabyte Technology Co.,
Ltd. Z87X-UD4H/Z87X-UD4H-CF, BIOS F9 03/18/2014
[Fri Sep  3 02:14:38 2021] RIP: 0010:do_exit+0x47/0xaa0
[Fri Sep  3 02:14:38 2021] Code: ec 40 65 48 8b 04 25 28 00 00 00 48
89 44 24 38 31 c0 48 8b 83 b8 0b 00 00 48 85 c0 74 0e 48 8b 10 48 39
d0 0f 84 64 04 00 00 <
0f> 0b 65 8b 0d d0 b5 38 68 89 c8 25 00 ff ff 00 89 44 24 0c 0f 85
[Fri Sep  3 02:14:38 2021] RSP: 0018:ffffbde280747ee0 EFLAGS: 00010216
[Fri Sep  3 02:14:38 2021] RAX: ffffbde280747e50 RBX: ffff95f7b8619780
RCX: ffff95fe1f2d8a08
[Fri Sep  3 02:14:38 2021] RDX: ffff95f769981fc8 RSI: 0000000000000027
RDI: 000000000000000b
[Fri Sep  3 02:14:38 2021] RBP: 000000000000000b R08: 0000000000000000
R09: ffffbde280747798
[Fri Sep  3 02:14:38 2021] R10: ffffbde280747790 R11: ffffffff992cb3e8
R12: 000000000000000b
[Fri Sep  3 02:14:38 2021] R13: 0000000000000000 R14: ffff95f7b8619780
R15: 0000000000000000
[Fri Sep  3 02:14:38 2021] FS:  0000000000000000(0000)
GS:ffff95fe1f2c0000(0000) knlGS:0000000000000000
[Fri Sep  3 02:14:38 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Fri Sep  3 02:14:38 2021] CR2: 00007f3cbf016514 CR3: 000000010828e003
CR4: 00000000001706e0
[Fri Sep  3 02:14:38 2021] Call Trace:
[Fri Sep  3 02:14:38 2021]  ? md_write_inc+0x50/0x50 [md_mod]
[Fri Sep  3 02:14:38 2021]  ? kthread+0x11b/0x140
[Fri Sep  3 02:14:38 2021]  rewind_stack_do_exit+0x17/0x20
[Fri Sep  3 02:14:38 2021] RIP: 0000:0x0
[Fri Sep  3 02:14:38 2021] Code: Unable to access opcode bytes at RIP
0xffffffffffffffd6.
[Fri Sep  3 02:14:38 2021] RSP: 0000:0000000000000000 EFLAGS: 00000000
ORIG_RAX: 0000000000000000
[Fri Sep  3 02:14:38 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: 0000000000000000
[Fri Sep  3 02:14:38 2021] RDX: 0000000000000000 RSI: 0000000000000000
RDI: 0000000000000000
[Fri Sep  3 02:14:38 2021] RBP: 0000000000000000 R08: 0000000000000000
R09: 0000000000000000
[Fri Sep  3 02:14:38 2021] R10: 0000000000000000 R11: 0000000000000000
R12: 0000000000000000
[Fri Sep  3 02:14:38 2021] R13: 0000000000000000 R14: 0000000000000000
R15: 0000000000000000
[Fri Sep  3 02:14:38 2021] ---[ end trace 5cc209277d97aabe ]---

Message from syslogd@wxyz at Sep  3 07:30:26 ...
 kernel:[ 3191.941392] watchdog: BUG: soft lockup - CPU#2 stuck for
22s! [md127_raid6:364]

Message from syslogd@wxyz at Sep  3 07:30:26 ...
 kernel:[ 3191.941392] watchdog: BUG: soft lockup - CPU#2 stuck for
22s! [md127_raid6:364]

[Fri Sep  3 09:05:56 2021] ------------[ cut here ]------------
[Fri Sep  3 09:05:56 2021] WARNING: CPU: 7 PID: 284 at
drivers/iommu/intel/iommu.c:2440 __domain_mapping.cold+0x4e/0x55
[Fri Sep  3 09:05:56 2021] Modules linked in: xfs ipt_REJECT
nf_reject_ipv4 xt_multiport nft_compat nft_counter nf_tables nfnetlink
rfkill nls_ascii nls_cp437 v
fat fat intel_rapl_msr mei_hdcp snd_hda_codec_realtek
snd_hda_codec_generic ledtrig_audio snd_hda_codec_hdmi snd_hda_intel
snd_intel_dspcfg soundwire_intel inte
l_rapl_common soundwire_generic_allocation snd_soc_core snd_compress
x86_pkg_temp_thermal intel_powerclamp soundwire_cadence snd_hda_codec
snd_hda_core coretemp
 snd_hwdep soundwire_bus snd_pcm snd_timer kvm_intel snd iTCO_wdt
intel_pmc_bxt iTCO_vendor_support watchdog soundcore kvm sg mei_me mei
at24 irqbypass rapl int
el_cstate intel_uncore pcspkr evdev efi_pstore sunrpc msr fuse
configfs efivarfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2
btrfs blake2b_generic dm_cry
pt dm_mod raid10 raid1 raid0 multipath linear raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq libcrc32c crc32c_generic md_mod sd
_mod t10_pi crc_t10dif crct10dif_generic hid_generic usbhid
[Fri Sep  3 09:05:56 2021]  hid i915 crct10dif_pclmul crct10dif_common
crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel xhci_pci
ahci libahci i2c_algo_
bit mxm_wmi xhci_hcd drm_kms_helper libaes crypto_simd libata cryptd
glue_helper mpt3sas cec ehci_pci ehci_hcd drm i2c_i801 i2c_smbus
raid_class usbcore scsi_tr
ansport_sas e1000e lpc_ich scsi_mod ptp pps_core usb_common fan wmi video button
[Fri Sep  3 09:05:56 2021] CPU: 7 PID: 284 Comm: kworker/7:1H Tainted:
G        W         5.10.0-8-amd64 #1 Debian 5.10.46-4
[Fri Sep  3 09:05:56 2021] Hardware name: Gigabyte Technology Co.,
Ltd. Z87X-UD4H/Z87X-UD4H-CF, BIOS F9 03/18/2014
[Fri Sep  3 09:05:56 2021] Workqueue: kblockd blk_mq_run_work_fn
[Fri Sep  3 09:05:56 2021] RIP: 0010:__domain_mapping.cold+0x4e/0x55
[Fri Sep  3 09:05:56 2021] Code: 68 d6 fd ff 8b 05 bd 97 f2 00 4c 8b
0c 24 4c 8b 5c 24 08 4c 8b 54 24 10 85 c0 4c 8b 44 24 18 74 09 83 e8
01 89 05 9d 97 f2 00 <
0f> 0b e9 4e 29 d6 ff 4c 89 ea 4c 89 f6 48 c7 c7 70 dd b4 b0 e8 29
[Fri Sep  3 09:05:56 2021] RSP: 0018:ffffa62d80787b28 EFLAGS: 00010246
[Fri Sep  3 09:05:56 2021] RAX: 0000000000000000 RBX: 00000001720a0003
RCX: 0000000000000000
[Fri Sep  3 09:05:56 2021] RDX: 0000000000000000 RSI: ffff968f1f3d8a00
RDI: ffff968f1f3d8a00
[Fri Sep  3 09:05:56 2021] RBP: ffff96883feee068 R08: 0000000000000073
R09: ffff96883feee000
[Fri Sep  3 09:05:56 2021] R10: 00000000001720a0 R11: ffff968819832100
R12: 0000000000000001
[Fri Sep  3 09:05:56 2021] R13: ffff9689b51af180 R14: 00000000000df60d
R15: 0000000000000003
[Fri Sep  3 09:05:56 2021] FS:  0000000000000000(0000)
GS:ffff968f1f3c0000(0000) knlGS:0000000000000000
[Fri Sep  3 09:05:56 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Fri Sep  3 09:05:56 2021] CR2: 0000562a47c025b8 CR3: 000000018a00a002
CR4: 00000000001706e0
[Fri Sep  3 09:05:56 2021] Call Trace:
[Fri Sep  3 09:05:56 2021]  domain_mapping+0x1b/0xa0
[Fri Sep  3 09:05:56 2021]  intel_map_sg+0x120/0x220
[Fri Sep  3 09:05:56 2021]  dma_map_sg_attrs+0x45/0x50
[Fri Sep  3 09:05:56 2021]  scsi_dma_map+0x35/0x40 [scsi_mod]
[Fri Sep  3 09:05:56 2021]  _base_build_sg_scmd+0x68/0x2d0 [mpt3sas]
[Fri Sep  3 09:05:56 2021]  scsih_qcmd+0x38c/0x4b0 [mpt3sas]
[Fri Sep  3 09:05:56 2021]  scsi_queue_rq+0x31f/0xa60 [scsi_mod]
[Fri Sep  3 09:05:56 2021]  blk_mq_dispatch_rq_list+0x11a/0x7f0
[Fri Sep  3 09:05:56 2021]  ? asm_exc_xen_hypervisor_callback+0x20/0x20
[Fri Sep  3 09:05:56 2021]  ? elv_rb_del+0x1f/0x30
[Fri Sep  3 09:05:56 2021]  ? deadline_remove_request+0x55/0xb0
[Fri Sep  3 09:05:56 2021]  __blk_mq_do_dispatch_sched+0xb8/0x2c0
[Fri Sep  3 09:05:56 2021]  __blk_mq_sched_dispatch_requests+0x13f/0x190
[Fri Sep  3 09:05:56 2021]  blk_mq_sched_dispatch_requests+0x30/0x60
[Fri Sep  3 09:05:56 2021]  __blk_mq_run_hw_queue+0x47/0xe0
[Fri Sep  3 09:05:56 2021]  process_one_work+0x1b6/0x350
[Fri Sep  3 09:05:56 2021]  worker_thread+0x53/0x3e0
[Fri Sep  3 09:05:56 2021]  ? process_one_work+0x350/0x350
[Fri Sep  3 09:05:56 2021]  kthread+0x11b/0x140
[Fri Sep  3 09:05:56 2021]  ? __kthread_bind_mask+0x60/0x60
[Fri Sep  3 09:05:56 2021]  ret_from_fork+0x22/0x30
[Fri Sep  3 09:05:56 2021] ---[ end trace 3b8b2da3617ea49e ]---
[Fri Sep  3 09:05:56 2021] DMAR: DRHD: handling fault status reg 3
[Fri Sep  3 09:05:56 2021] DMAR: [DMA Write] Request device [01:00.0]
PASID ffffffff fault addr df60d000 [fault reason 05] PTE Write access
is not set
[Fri Sep  3 09:05:56 2021] DMAR: ERROR: DMA PTE for vPFN 0xdf60d
already set (to 1000000000000 not 1a4388003)
[Fri Sep  3 09:05:56 2021] ------------[ cut here ]------------

[Fri Sep  3 06:40:40 2021] md: resync of RAID array md127
[Fri Sep  3 07:30:00 2021] rcu: INFO: rcu_sched self-detected stall on CPU
[Fri Sep  3 07:30:00 2021] rcu:         2-....: (5249 ticks this GP)
idle=0c2/1/0x4000000000000000 softirq=56412/56412 fqs=2624
[Fri Sep  3 07:30:00 2021]      (t=5250 jiffies g=91613 q=8034)
[Fri Sep  3 07:30:00 2021] NMI backtrace for cpu 2
[Fri Sep  3 07:30:00 2021] CPU: 2 PID: 364 Comm: md127_raid6 Not
tainted 5.10.0-8-amd64 #1 Debian 5.10.46-4
[Fri Sep  3 07:30:00 2021] Hardware name: Gigabyte Technology Co.,
Ltd. Z87X-UD4H/Z87X-UD4H-CF, BIOS F9 03/18/2014
[Fri Sep  3 07:30:00 2021] Call Trace:
[Fri Sep  3 07:30:00 2021]  <IRQ>
[Fri Sep  3 07:30:00 2021]  dump_stack+0x6b/0x83
[Fri Sep  3 07:30:00 2021]  nmi_cpu_backtrace.cold+0x32/0x69
[Fri Sep  3 07:30:00 2021]  ? lapic_can_unplug_cpu+0x80/0x80
[Fri Sep  3 07:30:00 2021]  nmi_trigger_cpumask_backtrace+0xd7/0xe0
[Fri Sep  3 07:30:00 2021]  rcu_dump_cpu_stacks+0xa2/0xd0
[Fri Sep  3 07:30:00 2021]  rcu_sched_clock_irq.cold+0x1ff/0x3d6
[Fri Sep  3 07:30:00 2021]  update_process_times+0x8c/0xc0
[Fri Sep  3 07:30:00 2021]  tick_sched_handle+0x22/0x60
[Fri Sep  3 07:30:00 2021]  tick_sched_timer+0x7c/0xb0
[Fri Sep  3 07:30:00 2021]  ? tick_do_update_jiffies64.part.0+0xc0/0xc0
[Fri Sep  3 07:30:00 2021]  __hrtimer_run_queues+0x12a/0x270
[Fri Sep  3 07:30:00 2021]  hrtimer_interrupt+0x110/0x2c0
[Fri Sep  3 07:30:00 2021]  __sysvec_apic_timer_interrupt+0x5f/0xd0
[Fri Sep  3 07:30:00 2021]  asm_call_irq_on_stack+0x12/0x20
[Fri Sep  3 07:30:00 2021]  </IRQ>
[Fri Sep  3 07:30:00 2021]  sysvec_apic_timer_interrupt+0x72/0x80
[Fri Sep  3 07:30:00 2021]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[Fri Sep  3 07:30:00 2021] RIP:
0010:native_queued_spin_lock_slowpath+0x1a2/0x1d0
[Fri Sep  3 07:30:00 2021] Code: 83 e0 03 83 ee 01 48 c1 e0 05 48 63
f6 48 05 80 c8 02 00 48 03 04 f5 00 89 97 a9 48 89 10 8b 42 08 85 c0
75 09 f3 90 8b 42 08
[Fri Sep  3 07:30:00 2021] RSP: 0018:ffffa90180533c30 EFLAGS: 00000246
[Fri Sep  3 07:30:00 2021] RAX: 0000000000000000 RBX: ffff89241ed21500
RCX: 00000000000c0000
[Fri Sep  3 07:30:00 2021] RDX: ffff892adf2ac880 RSI: 0000000000000003
RDI: ffff89241ed21568
[Fri Sep  3 07:30:00 2021] RBP: ffff8923e22fc800 R08: 00000000000c0000
R09: 00000000fffffffd
[Fri Sep  3 07:30:00 2021] R10: 0000000000000000 R11: 0000000000000000
R12: ffff89241ed21568
[Fri Sep  3 07:30:00 2021] R13: ffffa90180533dc0 R14: ffff8923e22fc800
R15: 0000000000000000
[Fri Sep  3 07:30:00 2021]  _raw_spin_lock+0x1a/0x20
[Fri Sep  3 07:30:00 2021]  handle_stripe+0x57c/0x1fd0 [raid456]
[Fri Sep  3 07:30:00 2021]
handle_active_stripes.constprop.0+0x3af/0x590 [raid456]
[Fri Sep  3 07:30:00 2021]  raid5d+0x375/0x5a0 [raid456]
[Fri Sep  3 07:30:00 2021]  md_thread+0x94/0x160 [md_mod]
[Fri Sep  3 07:30:00 2021]  ? add_wait_queue_exclusive+0x70/0x70
[Fri Sep  3 07:30:00 2021]  ? md_write_inc+0x50/0x50 [md_mod]
[Fri Sep  3 07:30:00 2021]  kthread+0x11b/0x140
[Fri Sep  3 07:30:00 2021]  ? __kthread_bind_mask+0x60/0x60
[Fri Sep  3 07:30:00 2021]  ret_from_fork+0x22/0x30
[Fri Sep  3 07:30:25 2021] watchdog: BUG: soft lockup - CPU#2 stuck
for 22s! [md127_raid6:364]
[Fri Sep  3 07:30:25 2021] Modules linked in: ipt_REJECT
nf_reject_ipv4 xt_multiport nft_compat nft_counter nf_tables nfnetlink
rfkill nls_ascii nls_cp437 vfa
_hda_codec_hdmi snd_hda_intel snd_intel_dspcfg soundwire_intel
intel_rapl_common soundwire_generic_allocation snd_soc_core
x86_pkg_temp_thermal snd_compress s
m_intel snd_pcm kvm snd_timer snd irqbypass iTCO_wdt intel_pmc_bxt
soundcore mei_me mei rapl sg iTCO_vendor_support watchdog intel_cstate
intel_uncore pcspkr
 jbd2 btrfs blake2b_generic dm_crypt dm_mod raid10 raid1 raid0
multipath linear raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_p
hid
[Fri Sep  3 07:30:25 2021]  i915 crct10dif_pclmul crct10dif_common
crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_algo_bit
drm_kms_helper xhci_pci cec xhci
bata raid_class cryptd glue_helper usbcore scsi_transport_sas i2c_i801
i2c_smbus scsi_mod ptp lpc_ich pps_core usb_common fan wmi video
button
[Fri Sep  3 07:30:25 2021] CPU: 2 PID: 364 Comm: md127_raid6 Not
tainted 5.10.0-8-amd64 #1 Debian 5.10.46-4
[Fri Sep  3 07:30:25 2021] Hardware name: Gigabyte Technology Co.,
Ltd. Z87X-UD4H/Z87X-UD4H-CF, BIOS F9 03/18/2014
[Fri Sep  3 07:30:25 2021] RIP:
0010:native_queued_spin_lock_slowpath+0x1a2/0x1d0
[Fri Sep  3 07:30:25 2021] Code: 83 e0 03 83 ee 01 48 c1 e0 05 48 63
f6 48 05 80 c8 02 00 48 03 04 f5 00 89 97 a9 48 89 10 8b 42 08 85 c0
75 09 f3 90 8b 42 08
[Fri Sep  3 07:30:25 2021] RSP: 0018:ffffa90180533c30 EFLAGS: 00000246
[Fri Sep  3 07:30:25 2021] RAX: 0000000000000000 RBX: ffff89241ed21500
RCX: 00000000000c0000
[Fri Sep  3 07:30:25 2021] RDX: ffff892adf2ac880 RSI: 0000000000000003
RDI: ffff89241ed21568
[Fri Sep  3 07:30:25 2021] RBP: ffff8923e22fc800 R08: 00000000000c0000
R09: 00000000fffffffd
[Fri Sep  3 07:30:25 2021] R10: 0000000000000000 R11: 0000000000000000
R12: ffff89241ed21568
[Fri Sep  3 07:30:25 2021] R13: ffffa90180533dc0 R14: ffff8923e22fc800
R15: 0000000000000000
[Fri Sep  3 07:30:25 2021] FS:  0000000000000000(0000)
GS:ffff892adf280000(0000) knlGS:0000000000000000
[Fri Sep  3 07:30:25 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Fri Sep  3 07:30:25 2021] CR2: 000055b5eb31cd98 CR3: 00000002c060a003
CR4: 00000000001706e0
[Fri Sep  3 07:30:25 2021] Call Trace:
[Fri Sep  3 07:30:25 2021]  _raw_spin_lock+0x1a/0x20
[Fri Sep  3 07:30:25 2021]  handle_stripe+0x57c/0x1fd0 [raid456]
[Fri Sep  3 07:30:25 2021]
handle_active_stripes.constprop.0+0x3af/0x590 [raid456]
[Fri Sep  3 07:30:25 2021]  raid5d+0x375/0x5a0 [raid456]
[Fri Sep  3 07:30:25 2021]  md_thread+0x94/0x160 [md_mod]
[Fri Sep  3 07:30:25 2021]  ? add_wait_queue_exclusive+0x70/0x70
[Fri Sep  3 07:30:25 2021]  ? md_write_inc+0x50/0x50 [md_mod]
[Fri Sep  3 07:30:25 2021]  kthread+0x11b/0x140
[Fri Sep  3 07:30:25 2021]  ? __kthread_bind_mask+0x60/0x60
[Fri Sep  3 07:30:25 2021]  ret_from_fork+0x22/0x30
[Fri Sep  3 07:30:53 2021] watchdog: BUG: soft lockup - CPU#2 stuck
for 22s! [md127_raid6:364]
[Fri Sep  3 07:30:53 2021] Modules linked in: ipt_REJECT
nf_reject_ipv4 xt_multiport nft_compat nft_counter nf_tables nfnetlink
rfkill nls_ascii nls_cp437 vfa
_hda_codec_hdmi snd_hda_intel snd_intel_dspcfg soundwire_intel
intel_rapl_common soundwire_generic_allocation snd_soc_core
x86_pkg_temp_thermal snd_compress s
m_intel snd_pcm kvm snd_timer snd irqbypass iTCO_wdt intel_pmc_bxt
soundcore mei_me mei rapl sg iTCO_vendor_support watchdog intel_cstate
intel_uncore pcspkr
 jbd2 btrfs blake2b_generic dm_crypt dm_mod raid10 raid1 raid0
multipath linear raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_p
hid
[Fri Sep  3 07:30:53 2021]  i915 crct10dif_pclmul crct10dif_common
crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_algo_bit
drm_kms_helper xhci_pci cec xhci
bata raid_class cryptd glue_helper usbcore scsi_transport_sas i2c_i801
i2c_smbus scsi_mod ptp lpc_ich pps_core usb_common fan wmi video
button
[Fri Sep  3 07:30:53 2021] CPU: 2 PID: 364 Comm: md127_raid6 Tainted:
G             L    5.10.0-8-amd64 #1 Debian 5.10.46-4
[Fri Sep  3 07:30:53 2021] Hardware name: Gigabyte Technology Co.,
Ltd. Z87X-UD4H/Z87X-UD4H-CF, BIOS F9 03/18/2014
[Fri Sep  3 07:30:53 2021] RIP:
0010:native_queued_spin_lock_slowpath+0x1a2/0x1d0
[Fri Sep  3 07:30:53 2021] Code: 83 e0 03 83 ee 01 48 c1 e0 05 48 63
f6 48 05 80 c8 02 00 48 03 04 f5 00 89 97 a9 48 89 10 8b 42 08 85 c0
75 09 f3 90 8b 42 08
[Fri Sep  3 07:30:53 2021] RSP: 0018:ffffa90180533c30 EFLAGS: 00000246
[Fri Sep  3 07:30:53 2021] RAX: 0000000000000000 RBX: ffff89241ed21500
RCX: 00000000000c0000
[Fri Sep  3 07:30:53 2021] RDX: ffff892adf2ac880 RSI: 0000000000000003
RDI: ffff89241ed21568
[Fri Sep  3 07:30:53 2021] RBP: ffff8923e22fc800 R08: 00000000000c0000
R09: 00000000fffffffd
[Fri Sep  3 07:30:53 2021] R10: 0000000000000000 R11: 0000000000000000
R12: ffff89241ed21568
[Fri Sep  3 07:30:53 2021] R13: ffffa90180533dc0 R14: ffff8923e22fc800
R15: 0000000000000000
[Fri Sep  3 07:30:53 2021] FS:  0000000000000000(0000)
GS:ffff892adf280000(0000) knlGS:0000000000000000
[Fri Sep  3 07:30:53 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Fri Sep  3 07:30:53 2021] CR2: 000055b5eb31cd98 CR3: 00000002c060a003
CR4: 00000000001706e0
[Fri Sep  3 07:30:53 2021] Call Trace:
[Fri Sep  3 07:30:53 2021]  _raw_spin_lock+0x1a/0x20
[Fri Sep  3 07:30:53 2021]  handle_stripe+0x57c/0x1fd0 [raid456]
[Fri Sep  3 07:30:53 2021]
handle_active_stripes.constprop.0+0x3af/0x590 [raid456]
[Fri Sep  3 07:30:53 2021]  raid5d+0x375/0x5a0 [raid456]
[Fri Sep  3 07:30:53 2021]  md_thread+0x94/0x160 [md_mod]
[Fri Sep  3 07:30:53 2021]  ? add_wait_queue_exclusive+0x70/0x70
[Fri Sep  3 07:30:53 2021]  ? md_write_inc+0x50/0x50 [md_mod]
[Fri Sep  3 07:30:53 2021]  kthread+0x11b/0x140
[Fri Sep  3 07:30:53 2021]  ? __kthread_bind_mask+0x60/0x60
[Fri Sep  3 07:30:53 2021]  ret_from_fork+0x22/0x30
[Fri Sep  3 07:31:03 2021] rcu: INFO: rcu_sched self-detected stall on CPU
[Fri Sep  3 07:31:03 2021] rcu:         2-....: (21002 ticks this GP)
idle=0c2/1/0x4000000000000000 softirq=56412/56412 fqs=10500
[Fri Sep  3 07:31:03 2021]      (t=21003 jiffies g=91613 q=27314)
[Fri Sep  3 07:31:03 2021] NMI backtrace for cpu 2
[Fri Sep  3 07:31:03 2021] CPU: 2 PID: 364 Comm: md127_raid6 Tainted:
G             L    5.10.0-8-amd64 #1 Debian 5.10.46-4
[Fri Sep  3 07:31:03 2021] Hardware name: Gigabyte Technology Co.,
Ltd. Z87X-UD4H/Z87X-UD4H-CF, BIOS F9 03/18/2014
[Fri Sep  3 07:31:03 2021] Call Trace:
[Fri Sep  3 07:31:03 2021]  <IRQ>
[Fri Sep  3 07:31:03 2021]  dump_stack+0x6b/0x83
[Fri Sep  3 07:31:03 2021]  nmi_cpu_backtrace.cold+0x32/0x69
[Fri Sep  3 07:31:03 2021]  ? lapic_can_unplug_cpu+0x80/0x80
[Fri Sep  3 07:31:03 2021]  nmi_trigger_cpumask_backtrace+0xd7/0xe0
[Fri Sep  3 07:31:03 2021]  rcu_dump_cpu_stacks+0xa2/0xd0
[Fri Sep  3 07:31:03 2021]  rcu_sched_clock_irq.cold+0x1ff/0x3d6
[Fri Sep  3 07:31:03 2021]  update_process_times+0x8c/0xc0
[Fri Sep  3 07:31:03 2021]  tick_sched_handle+0x22/0x60
[Fri Sep  3 07:31:03 2021]  tick_sched_timer+0x7c/0xb0
[Fri Sep  3 07:31:03 2021]  ? tick_do_update_jiffies64.part.0+0xc0/0xc0
[Fri Sep  3 07:31:03 2021]  __hrtimer_run_queues+0x12a/0x270
[Fri Sep  3 07:31:03 2021]  hrtimer_interrupt+0x110/0x2c0
[Fri Sep  3 07:31:03 2021]  __sysvec_apic_timer_interrupt+0x5f/0xd0
[Fri Sep  3 07:31:03 2021]  asm_call_irq_on_stack+0x12/0x20
[Fri Sep  3 07:31:03 2021]  </IRQ>
[Fri Sep  3 07:31:03 2021]  sysvec_apic_timer_interrupt+0x72/0x80
[Fri Sep  3 07:31:03 2021]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[Fri Sep  3 07:31:03 2021] RIP:
0010:native_queued_spin_lock_slowpath+0x1a2/0x1d0
[Fri Sep  3 07:31:03 2021] Code: 83 e0 03 83 ee 01 48 c1 e0 05 48 63
f6 48 05 80 c8 02 00 48 03 04 f5 00 89 97 a9 48 89 10 8b 42 08 85 c0
75 09 f3 90 8b 42 08
[Fri Sep  3 07:31:03 2021] RSP: 0018:ffffa90180533c30 EFLAGS: 00000246
[Fri Sep  3 07:31:03 2021] RAX: 0000000000000000 RBX: ffff89241ed21500
RCX: 00000000000c0000
[Fri Sep  3 07:31:03 2021] RDX: ffff892adf2ac880 RSI: 0000000000000003
RDI: ffff89241ed21568
[Fri Sep  3 07:31:03 2021] RBP: ffff8923e22fc800 R08: 00000000000c0000
R09: 00000000fffffffd
[Fri Sep  3 07:31:03 2021] R10: 0000000000000000 R11: 0000000000000000
R12: ffff89241ed21568
[Fri Sep  3 07:31:03 2021] R13: ffffa90180533dc0 R14: ffff8923e22fc800
R15: 0000000000000000
[Fri Sep  3 07:31:03 2021]  _raw_spin_lock+0x1a/0x20
[Fri Sep  3 07:31:03 2021]  handle_stripe+0x57c/0x1fd0 [raid456]
[Fri Sep  3 07:31:03 2021]
handle_active_stripes.constprop.0+0x3af/0x590 [raid456]
[Fri Sep  3 07:31:03 2021]  raid5d+0x375/0x5a0 [raid456]
[Fri Sep  3 07:31:03 2021]  md_thread+0x94/0x160 [md_mod]
[Fri Sep  3 07:31:03 2021]  ? add_wait_queue_exclusive+0x70/0x70
[Fri Sep  3 07:31:03 2021]  ? md_write_inc+0x50/0x50 [md_mod]
[Fri Sep  3 07:31:03 2021]  kthread+0x11b/0x140
[Fri Sep  3 07:31:03 2021]  ? __kthread_bind_mask+0x60/0x60
[Fri Sep  3 07:31:03 2021]  ret_from_fork+0x22/0x30
[Fri Sep  3 07:31:29 2021] watchdog: BUG: soft lockup - CPU#2 stuck
for 23s! [md127_raid6:364]
[Fri Sep  3 07:31:29 2021] Modules linked in: ipt_REJECT
nf_reject_ipv4 xt_multiport nft_compat nft_counter nf_tables nfnetlink
rfkill nls_ascii nls_cp437 vfa
_hda_codec_hdmi snd_hda_intel snd_intel_dspcfg soundwire_intel
intel_rapl_common soundwire_generic_allocation snd_soc_core
x86_pkg_temp_thermal snd_compress s
m_intel snd_pcm kvm snd_timer snd irqbypass iTCO_wdt intel_pmc_bxt
soundcore mei_me mei rapl sg iTCO_vendor_support watchdog intel_cstate
intel_uncore pcspkr
 jbd2 btrfs blake2b_generic dm_crypt dm_mod raid10 raid1 raid0
multipath linear raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_p
hid
[Fri Sep  3 07:31:29 2021]  i915 crct10dif_pclmul crct10dif_common
crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_algo_bit
drm_kms_helper xhci_pci cec xhci
bata raid_class cryptd glue_helper usbcore scsi_transport_sas i2c_i801
i2c_smbus scsi_mod ptp lpc_ich pps_core usb_common fan wmi video
button
[Fri Sep  3 07:31:29 2021] CPU: 2 PID: 364 Comm: md127_raid6 Tainted:
G             L    5.10.0-8-amd64 #1 Debian 5.10.46-4

_____________
Ryan Patterson
May the wings of liberty never lose a feather.
