Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB038C001DF
	for <linux-raid@archiver.kernel.org>; Mon,  7 Aug 2023 01:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjHGBC5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Aug 2023 21:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjHGBCz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 6 Aug 2023 21:02:55 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E4B170A
        for <linux-raid@vger.kernel.org>; Sun,  6 Aug 2023 18:02:52 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RJyjP4PnZz4f3xst
        for <linux-raid@vger.kernel.org>; Mon,  7 Aug 2023 09:02:49 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAHl6m1QtBkO91yAA--.65483S3;
        Mon, 07 Aug 2023 09:02:47 +0800 (CST)
Subject: Re: NULL pointer dereference with MD write-back journal, where
 journal device is RAID-1
To:     Corey Hickey <bugfood-ml@fatooh.org>,
        'Linux RAID' <linux-raid@vger.kernel.org>
References: <7c57f3a8-36e9-4805-b1ea-a4fd3406f7bb@fatooh.org>
Cc:     "yukuai (C)" <yukuai3@huawei.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f8b858cc-8762-6b53-43ec-7f509a971f16@huaweicloud.com>
Date:   Mon, 7 Aug 2023 09:02:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7c57f3a8-36e9-4805-b1ea-a4fd3406f7bb@fatooh.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHl6m1QtBkO91yAA--.65483S3
X-Coremail-Antispam: 1UD129KBjvAXoW3uF4DAry8WFykGrW5KF1xKrg_yoW8Jw4xGo
        W7ur47Zr48Gr1UJw18JFn7Jr1DAr18AFZrAr1DAF1UWFy7JF1jkryUtr4rGrnIyrn8J343
        AryqqF1xKw1UJ3Z7n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUU5R7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK
        8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7
        CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
        rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
        IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI
        7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
        Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY
        6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
        AIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi，

在 2023/08/07 6:48, Corey Hickey 写道:
> Hello,
> 
> I have encountered a reproducible NULL pointer dereference when using
> the write-back journal feature for RAID-5. This _seems_ to happen
> only when the journal device is itself a RAID-1.
> 
> https://docs.kernel.org/driver-api/md/raid5-cache.html
> 
> This report supersedes a report I sent to Debian earlier:
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1043078
> 
> Steps to reproduce, including example commands:
> 
> 1. Create a RAID-1 for the journal device.
> $ sudo mdadm --create /dev/md101 -n 2 -l 1 
> /dev/disk/by-id/ata-Samsung_SSD_850_PRO_256GB_S251NX0H60631*
> 
> 2. Create a RAID-5 with the journal included. I'm using '-z 10G' for
> testing in order to reduce the initial sync time.
> $ sudo mdadm --create /dev/md10 -n 3 -l 5 -z 10G --write-journal 
> /dev/md101 /dev/disk/by-id/ata-ST32000645NS_Z1K0*
> 
> 3. Enable write-back (completes once re-sync is finished).
> $ until echo write-back | sudo tee /sys/block/md10/md/journal_mode ; do 
> sleep 5 ; done
> 
> 4. Write to the disk (may take a few attempts).
> $ sudo dd if=/dev/zero of=/dev/md10 iflag=fullblock bs=1M count=10240
> 
> Notes:
> * The bug does not always manifest immediately but for me, it nearly
>    always manifests on the first or second 'dd' run.
> * The bug is not limited to buffered I/O: writes via 'oflag=direct'
>    can cause the bug as well.
> * I was not able to reproduce the bug on 10 attempts when I used a
>    single non-RAID SSD as the journal.
> * The bug can manifest while the journal RAID-1 is resyncing or not;
>    the resync does not seem relevant.
> 
> My SSDs are attached to an onboard SATA controller:
> 
> $ lspci | grep 06:00
> 06:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9235 PCIe 2.0 
> x2 4-port SATA 6 Gb/s Controller (rev 11)
> 
> My hard disks are attached to an external SATA-->USB enclosure,
> but I this is not relevant--I had the same problem with hard disks
> attached to internal SATA controllers in earlier tests.
> 
> I'm using Debian Sid on Linux 6.4.8. The kernel is compiled locally
> and installed via:
> --------------------------------------------------------------------
> wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.4.8.tar.xz
> tar xf linux-6.4.8.tar.xz
> cd linux-6.4.8
> cp -p "/boot/config-$(uname -r)" .config
> make oldconfig # and accept all defaults
> make -j 12 bindeb-pkg
> sudo dpkg -i linux-image-6.4.8_6.4.8-3_amd64.deb
> --------------------------------------------------------------------
> 
> Here are the errors reported by the kernel:
> --------------------------------------------------------------------
> [ 2566.222104] BUG: kernel NULL pointer dereference, address: 
> 0000000000000157
> [ 2566.222111] #PF: supervisor read access in kernel mode
> [ 2566.222114] #PF: error_code(0x0000) - not-present page
> [ 2566.222117] PGD 0 P4D 0
> [ 2566.222121] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [ 2566.222125] CPU: 1 PID: 5415 Comm: md10_raid5 Not tainted 6.4.8 #3
> [ 2566.222129] Hardware name: ASUS System Product Name/ROG CROSSHAIR VII 
> HERO (WI-FI), BIOS 4603 09/13/2021
> [ 2566.222132] RIP: 0010:submit_bio_noacct+0x182/0x5c0

Can you provide addr2line result? This will be helpful to locate the
problem.

Thanks,
Kuai

> [ 2566.222139] Code: ff ff ff 4c 8b 63 48 4d 85 e4 74 0f 48 63 05 e5 ef 
> 41 01 4d 8b a4 c4 d0 00 00 00 41 89 ed 41 83 e5 01 0f 1f 44 00 00 49 63 
> c5 <41> 80 bc 04 56 01 00 00 00 0f 85 fc 00 00 00 41 80 bc 04 54 01 00
> [ 2566.222142] RSP: 0018:ffffa41d46e5bd00 EFLAGS: 00010202
> [ 2566.222146] RAX: 0000000000000001 RBX: ffff93275b6668b8 RCX: 
> 0000000000000000
> [ 2566.222148] RDX: ffff932741380640 RSI: ffffffffb323f686 RDI: 
> 00000000ffffffff
> [ 2566.222151] RBP: 0000000000040001 R08: 0000000000000000 R09: 
> 0000000000000000
> [ 2566.222153] R10: 0000000000000001 R11: 0000000000000000 R12: 
> 0000000000000000
> [ 2566.222155] R13: 0000000000000001 R14: 000000001dcb2a80 R15: 
> 0000000000000000
> [ 2566.222157] FS:  0000000000000000(0000) GS:ffff93363ea40000(0000) 
> knlGS:0000000000000000
> [ 2566.222160] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2566.222162] CR2: 0000000000000157 CR3: 0000000140b8e000 CR4: 
> 00000000003506e0
> [ 2566.222165] Call Trace:
> [ 2566.222167]  <TASK>
> [ 2566.222171]  ? __die+0x23/0x70
> [ 2566.222176]  ? page_fault_oops+0x17d/0x4c0
> [ 2566.222180]  ? update_load_avg+0x7e/0x780
> [ 2566.222185]  ? exc_page_fault+0x7f/0x180
> [ 2566.222190]  ? asm_exc_page_fault+0x26/0x30
> [ 2566.222196]  ? submit_bio_noacct+0x182/0x5c0
> [ 2566.222201]  handle_active_stripes.isra.0+0x377/0x550 [raid456]
> [ 2566.222220]  raid5d+0x487/0x750 [raid456]
> [ 2566.222234]  ? __schedule+0x3e7/0xb80
> [ 2566.222240]  ? _raw_spin_lock_irqsave+0x27/0x60
> [ 2566.222245]  ? preempt_count_add+0x6e/0xa0
> [ 2566.222248]  ? _raw_spin_lock_irqsave+0x27/0x60
> [ 2566.222254]  ? __pfx_md_thread+0x10/0x10 [md_mod]
> [ 2566.222273]  md_thread+0xae/0x190 [md_mod]
> [ 2566.222293]  ? __pfx_autoremove_wake_function+0x10/0x10
> [ 2566.222299]  kthread+0xf7/0x130
> [ 2566.222304]  ? __pfx_kthread+0x10/0x10
> [ 2566.222309]  ret_from_fork+0x2c/0x50
> [ 2566.222316]  </TASK>
> [ 2566.222318] Modules linked in: twofish_generic twofish_avx_x86_64 
> twofish_x86_64_3way twofish_x86_64 twofish_common essiv authenc dm_crypt 
> cpufreq_conservative cpufreq_userspace cpufreq_powersave rpcsec_gss_krb5 
> nfsv4 dns_resolver nfs fscache netfs bridge stp llc binfmt_misc amdgpu 
> eeepc_wmi intel_rapl_msr asus_wmi intel_rapl_common battery edac_mce_amd 
> hid_pl sparse_keymap platform_profile hid_dr snd_hda_codec_realtek 
> sp5100_tco drm_buddy rfkill ff_memless gpu_sched drm_suballoc_helper 
> kvm_amd snd_hda_codec_generic drm_display_helper ledtrig_audio 
> snd_hda_codec_hdmi cec rc_core drm_ttm_helper kvm snd_hda_intel 
> snd_intel_dspcfg ttm snd_intel_sdw_acpi asus_wmi_sensors irqbypass 
> drm_kms_helper snd_hda_codec rapl video acpi_cpufreq snd_hda_core 
> mxm_wmi pcspkr wmi_bmof k10temp watchdog ccp snd_hwdep rng_core button 
> sg cpufreq_ondemand lm90 snd_intel8x0 snd_ac97_codec ac97_bus 
> snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore evdev nfsd 
> psmouse i2c_dev sidewinder gameport joydev auth_rpcgss parport_pc 
> nfs_acl ppdev
> [ 2566.222390]  lockd lp grace parport drm fuse loop efi_pstore dm_mod 
> configfs sunrpc ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 btrfs 
> efivarfs raid10 raid456 async_raid6_recov async_memcpy async_pq 
> async_xor async_tx xor raid6_pq libcrc32c crc32c_generic multipath 
> linear hid_generic raid0 bcache raid1 md_mod uas usb_storage sd_mod 
> usbhid crc32_pclmul crc32c_intel t10_pi hid crc64_rocksoft_generic 
> crc64_rocksoft crc_t10dif crct10dif_generic crct10dif_pclmul crc64 
> ghash_clmulni_intel crct10dif_common sha512_ssse3 sha512_generic ahci 
> xhci_pci libahci xhci_hcd aesni_intel crypto_simd libata cryptd usbcore 
> igb e1000e i2c_piix4 scsi_mod i2c_algo_bit dca usb_common scsi_common 
> gpio_amdpt wmi gpio_generic
> [ 2566.222451] CR2: 0000000000000157
> [ 2566.222454] ---[ end trace 0000000000000000 ]---
> [ 2566.436029] RIP: 0010:submit_bio_noacct+0x182/0x5c0
> [ 2566.436038] Code: ff ff ff 4c 8b 63 48 4d 85 e4 74 0f 48 63 05 e5 ef 
> 41 01 4d 8b a4 c4 d0 00 00 00 41 89 ed 41 83 e5 01 0f 1f 44 00 00 49 63 
> c5 <41> 80 bc 04 56 01 00 00 00 0f 85 fc 00 00 00 41 80 bc 04 54 01 00
> [ 2566.436041] RSP: 0018:ffffa41d46e5bd00 EFLAGS: 00010202
> [ 2566.436044] RAX: 0000000000000001 RBX: ffff93275b6668b8 RCX: 
> 0000000000000000
> [ 2566.436047] RDX: ffff932741380640 RSI: ffffffffb323f686 RDI: 
> 00000000ffffffff
> [ 2566.436049] RBP: 0000000000040001 R08: 0000000000000000 R09: 
> 0000000000000000
> [ 2566.436051] R10: 0000000000000001 R11: 0000000000000000 R12: 
> 0000000000000000
> [ 2566.436053] R13: 0000000000000001 R14: 000000001dcb2a80 R15: 
> 0000000000000000
> [ 2566.436055] FS:  0000000000000000(0000) GS:ffff93363ea40000(0000) 
> knlGS:0000000000000000
> [ 2566.436058] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2566.436060] CR2: 0000000000000157 CR3: 0000000140b8e000 CR4: 
> 00000000003506e0
> [ 2566.436063] note: md10_raid5[5415] exited with irqs disabled
> [ 2566.436109] ------------[ cut here ]------------
> [ 2566.436112] WARNING: CPU: 1 PID: 5415 at kernel/exit.c:818 
> do_exit+0x8ef/0xb20
> [ 2566.436119] Modules linked in: twofish_generic twofish_avx_x86_64 
> twofish_x86_64_3way twofish_x86_64 twofish_common essiv authenc dm_crypt 
> cpufreq_conservative cpufreq_userspace cpufreq_powersave rpcsec_gss_krb5 
> nfsv4 dns_resolver nfs fscache netfs bridge stp llc binfmt_misc amdgpu 
> eeepc_wmi intel_rapl_msr asus_wmi intel_rapl_common battery edac_mce_amd 
> hid_pl sparse_keymap platform_profile hid_dr snd_hda_codec_realtek 
> sp5100_tco drm_buddy rfkill ff_memless gpu_sched drm_suballoc_helper 
> kvm_amd snd_hda_codec_generic drm_display_helper ledtrig_audio 
> snd_hda_codec_hdmi cec rc_core drm_ttm_helper kvm snd_hda_intel 
> snd_intel_dspcfg ttm snd_intel_sdw_acpi asus_wmi_sensors irqbypass 
> drm_kms_helper snd_hda_codec rapl video acpi_cpufreq snd_hda_core 
> mxm_wmi pcspkr wmi_bmof k10temp watchdog ccp snd_hwdep rng_core button 
> sg cpufreq_ondemand lm90 snd_intel8x0 snd_ac97_codec ac97_bus 
> snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore evdev nfsd 
> psmouse i2c_dev sidewinder gameport joydev auth_rpcgss parport_pc 
> nfs_acl ppdev
> [ 2566.436188]  lockd lp grace parport drm fuse loop efi_pstore dm_mod 
> configfs sunrpc ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 btrfs 
> efivarfs raid10 raid456 async_raid6_recov async_memcpy async_pq 
> async_xor async_tx xor raid6_pq libcrc32c crc32c_generic multipath 
> linear hid_generic raid0 bcache raid1 md_mod uas usb_storage sd_mod 
> usbhid crc32_pclmul crc32c_intel t10_pi hid crc64_rocksoft_generic 
> crc64_rocksoft crc_t10dif crct10dif_generic crct10dif_pclmul crc64 
> ghash_clmulni_intel crct10dif_common sha512_ssse3 sha512_generic ahci 
> xhci_pci libahci xhci_hcd aesni_intel crypto_simd libata cryptd usbcore 
> igb e1000e i2c_piix4 scsi_mod i2c_algo_bit dca usb_common scsi_common 
> gpio_amdpt wmi gpio_generic
> [ 2566.436250] CPU: 1 PID: 5415 Comm: md10_raid5 Tainted: G      
> D            6.4.8 #3
> [ 2566.436254] Hardware name: ASUS System Product Name/ROG CROSSHAIR VII 
> HERO (WI-FI), BIOS 4603 09/13/2021
> [ 2566.436256] RIP: 0010:do_exit+0x8ef/0xb20
> [ 2566.436260] Code: e9 12 ff ff ff 48 8b bb 98 09 00 00 31 f6 e8 88 d9 
> ff ff e9 a0 fd ff ff 4c 89 e6 bf 05 06 00 00 e8 f6 0b 01 00 e9 59 f8 ff 
> ff <0f> 0b e9 88 f7 ff ff 0f 0b e9 45 f7 ff ff 48 89 df e8 fb e0 11 00
> [ 2566.436263] RSP: 0018:ffffa41d46e5bed8 EFLAGS: 00010286
> [ 2566.436266] RAX: 0000000000000000 RBX: ffff9327df5a6600 RCX: 
> 0000000000000000
> [ 2566.436269] RDX: 0000000000000001 RSI: 0000000000002710 RDI: 
> 00000000ffffffff
> [ 2566.436271] RBP: ffff9327c0afb600 R08: 0000000000000000 R09: 
> ffffa41d46e5bde0
> [ 2566.436273] R10: 0000000000000003 R11: ffff93363f2f7fe8 R12: 
> 0000000000000009
> [ 2566.436275] R13: ffff9327df4deb40 R14: 0000000000000000 R15: 
> 0000000000000000
> [ 2566.436277] FS:  0000000000000000(0000) GS:ffff93363ea40000(0000) 
> knlGS:0000000000000000
> [ 2566.436280] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2566.436282] CR2: 0000000000000157 CR3: 0000000140b8e000 CR4: 
> 00000000003506e0
> [ 2566.436284] Call Trace:
> [ 2566.436287]  <TASK>
> [ 2566.436288]  ? do_exit+0x8ef/0xb20
> [ 2566.436292]  ? __warn+0x81/0x130
> [ 2566.436298]  ? do_exit+0x8ef/0xb20
> [ 2566.436301]  ? report_bug+0x191/0x1c0
> [ 2566.436308]  ? handle_bug+0x3c/0x80
> [ 2566.436312]  ? exc_invalid_op+0x17/0x70
> [ 2566.436316]  ? asm_exc_invalid_op+0x1a/0x20
> [ 2566.436321]  ? do_exit+0x8ef/0xb20
> [ 2566.436325]  ? do_exit+0x70/0xb20
> [ 2566.436329]  make_task_dead+0x81/0x170
> [ 2566.436333]  rewind_stack_and_make_dead+0x17/0x20
> [ 2566.436338] RIP: 0000:0x0
> [ 2566.436344] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> [ 2566.436346] RSP: 0000:0000000000000000 EFLAGS: 00000000 ORIG_RAX: 
> 0000000000000000
> [ 2566.436349] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
> 0000000000000000
> [ 2566.436350] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
> 0000000000000000
> [ 2566.436352] RBP: 0000000000000000 R08: 0000000000000000 R09: 
> 0000000000000000
> [ 2566.436354] R10: 0000000000000000 R11: 0000000000000000 R12: 
> 0000000000000000
> [ 2566.436355] R13: 0000000000000000 R14: 0000000000000000 R15: 
> 0000000000000000
> [ 2566.436359]  </TASK>
> [ 2566.436361] ---[ end trace 0000000000000000 ]---
> --------------------------------------------------------------------
> 
> Thank you,
> Corey

