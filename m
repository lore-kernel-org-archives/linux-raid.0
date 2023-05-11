Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD59EC77B7C
	for <linux-raid@archiver.kernel.org>; Thu, 11 May 2023 14:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbjEKO5I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 May 2023 10:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237973AbjEKO5B (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 May 2023 10:57:01 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2F111545
        for <linux-raid@vger.kernel.org>; Thu, 11 May 2023 07:56:37 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f41dceb9d4so59333715e9.1
        for <linux-raid@vger.kernel.org>; Thu, 11 May 2023 07:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683816944; x=1686408944;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:to:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SHISDe7xEsiWzkjucvuMHZlMu4m/4g7Y8OnuQcgfyUY=;
        b=d46MZrLF/HXeBhF5CQGN4Va5Smm+o0zz9Sb0DXpypEeSMfvbwwUuy5tPeisb/uPiBZ
         tvcP1P/lpU9CgyX7NezSULlBWZCCDEOQLEiwYJ/IG+qRxJDoc62gLOsAuPLTRTG9zEO0
         U/RJ2iEz5kbvWSq9HKXB/jqxeC6QmCvLZF54VuDQ9ttj4Us1ScobkHeiQyjDt3VUm7ts
         zx/XfQbolUmWb21GBY7E/T1Rn5UL/ryFbtSOr0BBlrOgKcUHg5fmQcWKpgdX/boio2Cj
         KyY1p47Nbll83fwLnOdzjOlZz9/iA8KDBkt58JdPJ7jqqFXkx8XJs2BaQ9b4ho3E8b5X
         IEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683816944; x=1686408944;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SHISDe7xEsiWzkjucvuMHZlMu4m/4g7Y8OnuQcgfyUY=;
        b=L8V/1yJ7eOGXGiUOh81I9hc5dqCtDWj4t7d3dvZ7tiVULpI1MXNVpU0+B9AK5cj/0V
         DIgZohohjNOhkjxPbKxpyHzZ5xkzXEA5iEnQ0+cjQZO1B5r3+oxZMkdn3UQko616kwJE
         6/dCSRe0UTeiFKwYCpj3AZFOxFi++ADxfjcvXcXyXIQLdeQjFyvWfP+qjhSyRhXT5emf
         4Nk/2bRRWmjtJoY2zFXB0JPWDmMDKs24S5YAN2bPUbPRIQPbIVho01tmzhC4mX9C/pul
         +lx3PBM8hCiTB8FFXvAaUSg4PVkjj3/nxgCzoOAJGLpIIsi9eJEOdmS68DTdTwsZn1VG
         NPUg==
X-Gm-Message-State: AC+VfDyn7u+/hSS8IzrHzBkuapj5ukoG8oJ+Vd+taD5RsblOjSsExLvv
        cpOGi2+uX45g/hLHoLqhlPNa7xaMmRO9Ig==
X-Google-Smtp-Source: ACHHUZ5j6HgTvFWu4Sbo8wZfqb4IxSFTLP77rXEtG5FA75Cg0dec0zEkb7gPTx7ChwLLP+v3kiVpgA==
X-Received: by 2002:a1c:7507:0:b0:3f1:7bac:d411 with SMTP id o7-20020a1c7507000000b003f17bacd411mr15840276wmc.39.1683816943368;
        Thu, 11 May 2023 07:55:43 -0700 (PDT)
Received: from MaartenXPS ([80.69.25.243])
        by smtp.gmail.com with ESMTPSA id d10-20020a1c730a000000b003f325f0e020sm25797249wmb.47.2023.05.11.07.55.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 May 2023 07:55:42 -0700 (PDT)
From:   <maartenvanmalland@gmail.com>
To:     "'Yu Kuai'" <yukuai1@huaweicloud.com>,
        <linux-raid@vger.kernel.org>, "'yukuai \(C\)'" <yukuai3@huawei.com>
References: <04df01d98265$be3a9b80$3aafd280$@gmail.com> <319dc433-af3d-1ba1-04af-690c4f2576c0@huaweicloud.com>
In-Reply-To: <319dc433-af3d-1ba1-04af-690c4f2576c0@huaweicloud.com>
Subject: RE: Raid 5 journal bug (crash)
Date:   Thu, 11 May 2023 16:55:40 +0200
Message-ID: <0ae601d98418$a7f4cc60$f7de6520$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQOMlgYA6zkUE1b4+JE7spfRuugz1wGHgRcJq+LIv7A=
Content-Language: nl
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Okay, I haven't much experience with addr2line but I think you mean this =
one:

# addr2line -f -e =
/lib/modules/6.1.0-7-amd64/kernel/drivers/md/raid456.ko =
0010:blk_cgroup_bio_start+0x46
cmp_stripe

If you want something else, please let me know.

Kind regards,

Maarten

-----Original Message-----
From: Yu Kuai <yukuai1@huaweicloud.com>=20
Sent: dinsdag 9 mei 2023 13:40
To: maartenvanmalland@gmail.com; linux-raid@vger.kernel.org; yukuai (C) =
<yukuai3@huawei.com>
Subject: Re: Raid 5 journal bug (crash)

Hi,

=E5=9C=A8 2023/05/09 19:02, maartenvanmalland@gmail.com =
=E5=86=99=E9=81=93:
> Hi,
>=20
> I'm pretty sure I hit a bug in the raid5 code somewhere. (I also have =
a rather obscure storage config, so please bear with me.)
>=20
> The (relevant) storage config is as follows:
>=20
> 2 x nvme (mdadm raid1) -> lvm2  -> volume for journal of ext4, volume =
for bcache caching and also a volume for raid5 journal.
> 6 x sata (mdadm raid5) -> bcache -> lvm2 -> ext4 volume with external =
journal
>=20
> Surprisingly, this boots just fine =F0=9F=98=89. However, since I =
enabled the raid5 journal on the nvme drives, the system hangs randomly =
with the following kernel output:
>=20
> kernel: [14785.293972] BUG: kernel NULL pointer dereference, address: =
0000000000000050
> kernel: [14785.293984] #PF: supervisor read access in kernel mode
> kernel: [14785.293992] #PF: error_code(0x0000) - not-present page
> kernel: [14785.293997] PGD 0 P4D 0
> kernel: [14785.294004] Oops: 0000 [#1] PREEMPT SMP PTI
> kernel: [14785.294010] CPU: 4 PID: 543 Comm: md3_raid5 Tainted: P      =
     O       6.1.0-7-amd64 #1  Debian 6.1.20-2
> kernel: [14785.294018] Hardware name: System manufacturer System =
Product Name/WS X299 PRO_SE, BIOS 3701 05/24/2022
> kernel: [14785.294022] RIP: 0010:blk_cgroup_bio_start+0x46/0xb0

It'll be much helpful if you can provide addr2line result.

Thanks,
Kuai
> kernel: [14785.294033] Code: 00 00 0f 45 c2 89 c5 e8 b8 5c be ff 48 c7 =
c7 ad 6d 1a 8a e8 dc 14 53 00 48 8b 43 48 0f b7 4b 14 65 8b 35 f5 a5 d2 =
76 48 63 d6 <48> 8b 40 50 48 03 04 d5 a0 7a 1c 8a 48 63 d5 f6 c5 01 75 =
0e 80 cd
> kernel: [14785.294039] RSP: 0000:ffffaf9500db7cb8 EFLAGS: 00010282
> kernel: [14785.294045] RAX: 0000000000000000 RBX: ffffa03544df28b8 =
RCX: 0000000000000000
> kernel: [14785.294050] RDX: 0000000000000004 RSI: 0000000000000004 =
RDI: ffffffff8a15820e
> kernel: [14785.294054] RBP: 0000000000000001 R08: 0000000000040001 =
R09: ffffaf9500db7d38
> kernel: [14785.294058] R10: 0000000000000007 R11: ffffffffc08ff6a0 =
R12: 0000000000000000
> kernel: [14785.294062] R13: 8000000000000000 R14: ffffa03582724b1c =
R15: 0000000000000008
> kernel: [14785.294066] FS:  0000000000000000(0000) =
GS:ffffa053dfb00000(0000) knlGS:0000000000000000
> kernel: [14785.294072] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
> kernel: [14785.294076] CR2: 0000000000000050 CR3: 0000000dae210005 =
CR4: 00000000003726e0
> kernel: [14785.294081] Call Trace:
> kernel: [14785.294086]  <TASK>
> kernel: [14785.294092]  submit_bio_noacct_nocheck+0x38/0x370
> kernel: [14785.294099]  ? bio_associate_blkg+0x28/0x60
> kernel: [14785.294106]  ? bio_init+0x6d/0xc0
> kernel: [14785.294117]  handle_active_stripes.constprop.0+0x349/0x560 =
[raid456]
> kernel: [14785.294152]  raid5d+0x49c/0x760 [raid456]
> kernel: [14785.294173]  ? __schedule+0x359/0xa20
> kernel: [14785.294183]  ? _raw_spin_lock_irqsave+0x23/0x50
> kernel: [14785.294191]  ? preempt_count_add+0x6a/0xa0
> kernel: [14785.294197]  ? _raw_spin_lock_irqsave+0x23/0x50
> kernel: [14785.294206]  ? unregister_md_personality+0x70/0x70 [md_mod]
> kernel: [14785.294230]  md_thread+0xa7/0x180 [md_mod]
> kernel: [14785.294253]  ? dequeue_task_stop+0x70/0x70
> kernel: [14785.294262]  kthread+0xe6/0x110
> kernel: [14785.294270]  ? kthread_complete_and_exit+0x20/0x20
> kernel: [14785.294278]  ret_from_fork+0x1f/0x30
> kernel: [14785.294292]  </TASK>
> kernel: [14785.294295] Modules linked in: brd veth xt_conntrack =
xt_MASQUERADE nf_conntrack_netlink xt_addrtype br_netfilter =
snd_seq_dummy snd_hrtimer vhost_net vhost vhost_iotlb tap tun =
cpufreq_conservative cpufreq_userspace cpufreq_powersave =
cpufreq_ondemand nvidia_uvm(PO) xfrm_user xfrm_algo rdma_ucm ib_uverbs =
rdma_cm iw_cm scsi_transport_iscsi ib_cm ib_core nvme_fabrics overlay =
nvidia_modeset(PO) qrtr bridge stp llc bonding tls nft_log xt_NFLOG =
nfnetlink_log xt_geoip(O) nft_chain_nat xt_nat nf_nat nf_conntrack =
nf_defrag_ipv6 nf_defrag_ipv4 xt_tcpudp nft_compat nf_tables nfnetlink =
binfmt_misc nls_ascii nls_cp437 vfat fat xfs intel_rapl_msr =
intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common =
isst_if_common nfit libnvdimm squashfs x86_pkg_temp_thermal nvidia(PO) =
intel_powerclamp coretemp kvm_intel zfs(PO) kvm ftdi_sio usbserial =
snd_hda_codec_realtek ghash_clmulni_intel snd_hda_codec_generic =
snd_hda_codec_hdmi zunicode(PO) snd_hda_intel zzstd(O) snd_intel_dspcfg =
aesni_intel
> kernel: [14785.294429]  eeepc_wmi snd_intel_sdw_acpi zlua(O) =
crypto_simd asus_wmi snd_hda_codec zavl(PO) cryptd ipmi_ssif =
platform_profile snd_hda_core icp(PO) rapl battery snd_hwdep =
sparse_keymap intel_cstate zcommon(PO) snd_pcm_oss ledtrig_audio =
znvpair(PO) intel_uncore snd_mixer_oss rfkill wmi_bmof =
intel_wmi_thunderbolt mei_me joydev spl(O) sha512_ssse3 snd_pcm mei =
ioatdma sha512_generic acpi_ipmi ipmi_si acpi_tad evdev tcp_bbr sch_fq =
vfio_pci vfio_pci_core vfio_virqfd vfio_iommu_type1 vfio irqbypass =
vmwgfx snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq =
snd_seq_device snd_timer snd soundcore sg ipmi_watchdog ipmi_poweroff =
ipmi_devintf ipmi_msghandler msr nfsd drbd auth_rpcgss lru_cache nfs_acl =
parport_pc lockd ppdev grace lp parport fuse sunrpc loop efi_pstore =
configfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 btrfs =
blake2b_generic zstd_compress efivarfs raid10 multipath linear z3fold =
lz4 lz4_compress dm_snapshot dm_bufio i915 drm_buddy video =
drm_display_helper cec rc_core sr_mod
> kernel: [14785.294590]  cdrom hid_generic usbhid uas hid usb_storage =
raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor =
raid6_pq libcrc32c crc32c_generic raid0 bcache dm_mod sd_mod raid1 =
md_mod nvme nvme_core t10_pi ast crc64_rocksoft drm_vram_helper ahci =
crc64 atlantic drm_ttm_helper igb libahci crc_t10dif xhci_pci ttm macsec =
dca drm_kms_helper libata crct10dif_generic xhci_hcd crc32_pclmul ptp =
i2c_i801 usbcore crct10dif_pclmul drm mxm_wmi scsi_mod crc32c_intel =
pps_core i2c_smbus i2c_algo_bit crct10dif_common usb_common scsi_common =
wmi button [last unloaded: brd]
> kernel: [14785.294688] CR2: 0000000000000050
> kernel: [14785.294693] ---[ end trace 0000000000000000 ]---
> kernel: [14787.059673] RIP: 0010:blk_cgroup_bio_start+0x46/0xb0
> kernel: [14787.059682] Code: 00 00 0f 45 c2 89 c5 e8 b8 5c be ff 48 c7 =
c7 ad 6d 1a 8a e8 dc 14 53 00 48 8b 43 48 0f b7 4b 14 65 8b 35 f5 a5 d2 =
76 48 63 d6 <48> 8b 40 50 48 03 04 d5 a0 7a 1c 8a 48 63 d5 f6 c5 01 75 =
0e 80 cd
> kernel: [14787.059684] RSP: 0000:ffffaf9500db7cb8 EFLAGS: 00010282
> kernel: [14787.059687] RAX: 0000000000000000 RBX: ffffa03544df28b8 =
RCX: 0000000000000000
> kernel: [14787.059688] RDX: 0000000000000004 RSI: 0000000000000004 =
RDI: ffffffff8a15820e
> kernel: [14787.059689] RBP: 0000000000000001 R08: 0000000000040001 =
R09: ffffaf9500db7d38
> kernel: [14787.059691] R10: 0000000000000007 R11: ffffffffc08ff6a0 =
R12: 0000000000000000
> kernel: [14787.059692] R13: 8000000000000000 R14: ffffa03582724b1c =
R15: 0000000000000008
> kernel: [14787.059693] FS:  0000000000000000(0000) =
GS:ffffa053dfb00000(0000) knlGS:0000000000000000
> kernel: [14787.059695] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
> kernel: [14787.059697] CR2: 0000000000000050 CR3: 000000048199e006 =
CR4: 00000000003726e0
> kernel: [14787.059698] note: md3_raid5[543] exited with irqs disabled
> kernel: [14787.059788] note: md3_raid5[543] exited with preempt_count =
1
> kernel: [14787.059794] ------------[ cut here ]------------
> kernel: [14787.059796] WARNING: CPU: 4 PID: 543 at kernel/exit.c:814 =
do_exit+0x8ff/0xb10
> kernel: [14787.059803] Modules linked in: brd veth xt_conntrack =
xt_MASQUERADE nf_conntrack_netlink xt_addrtype br_netfilter =
snd_seq_dummy snd_hrtimer vhost_net vhost vhost_iotlb tap tun =
cpufreq_conservative cpufreq_userspace cpufreq_powersave =
cpufreq_ondemand nvidia_uvm(PO) xfrm_user xfrm_algo rdma_ucm ib_uverbs =
rdma_cm iw_cm scsi_transport_iscsi ib_cm ib_core nvme_fabrics overlay =
nvidia_modeset(PO) qrtr bridge stp llc bonding tls nft_log xt_NFLOG =
nfnetlink_log xt_geoip(O) nft_chain_nat xt_nat nf_nat nf_conntrack =
nf_defrag_ipv6 nf_defrag_ipv4 xt_tcpudp nft_compat nf_tables nfnetlink =
binfmt_misc nls_ascii nls_cp437 vfat fat xfs intel_rapl_msr =
intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common =
isst_if_common nfit libnvdimm squashfs x86_pkg_temp_thermal nvidia(PO) =
intel_powerclamp coretemp kvm_intel zfs(PO) kvm ftdi_sio usbserial =
snd_hda_codec_realtek ghash_clmulni_intel snd_hda_codec_generic =
snd_hda_codec_hdmi zunicode(PO) snd_hda_intel zzstd(O) snd_intel_dspcfg =
aesni_intel
> kernel: [14787.059873]  eeepc_wmi snd_intel_sdw_acpi zlua(O) =
crypto_simd asus_wmi snd_hda_codec zavl(PO) cryptd ipmi_ssif =
platform_profile snd_hda_core icp(PO) rapl battery snd_hwdep =
sparse_keymap intel_cstate zcommon(PO) snd_pcm_oss ledtrig_audio =
znvpair(PO) intel_uncore snd_mixer_oss rfkill wmi_bmof =
intel_wmi_thunderbolt mei_me joydev spl(O) sha512_ssse3 snd_pcm mei =
ioatdma sha512_generic acpi_ipmi ipmi_si acpi_tad evdev tcp_bbr sch_fq =
vfio_pci vfio_pci_core vfio_virqfd vfio_iommu_type1 vfio irqbypass =
vmwgfx snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq =
snd_seq_device snd_timer snd soundcore sg ipmi_watchdog ipmi_poweroff =
ipmi_devintf ipmi_msghandler msr nfsd drbd auth_rpcgss lru_cache nfs_acl =
parport_pc lockd ppdev grace lp parport fuse sunrpc loop efi_pstore =
configfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 btrfs =
blake2b_generic zstd_compress efivarfs raid10 multipath linear z3fold =
lz4 lz4_compress dm_snapshot dm_bufio i915 drm_buddy video =
drm_display_helper cec rc_core sr_mod
> kernel: [14787.059934]  cdrom hid_generic usbhid uas hid usb_storage =
raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor =
raid6_pq libcrc32c crc32c_generic raid0 bcache dm_mod sd_mod raid1 =
md_mod nvme nvme_core t10_pi ast crc64_rocksoft drm_vram_helper ahci =
crc64 atlantic drm_ttm_helper igb libahci crc_t10dif xhci_pci ttm macsec =
dca drm_kms_helper libata crct10dif_generic xhci_hcd crc32_pclmul ptp =
i2c_i801 usbcore crct10dif_pclmul drm mxm_wmi scsi_mod crc32c_intel =
pps_core i2c_smbus i2c_algo_bit crct10dif_common usb_common scsi_common =
wmi button [last unloaded: brd]
> kernel: [14787.059971] CPU: 4 PID: 543 Comm: md3_raid5 Tainted: P      =
D    O       6.1.0-7-amd64 #1  Debian 6.1.20-2
> kernel: [14787.059973] Hardware name: System manufacturer System =
Product Name/WS X299 PRO_SE, BIOS 3701 05/24/2022
> kernel: [14787.059975] RIP: 0010:do_exit+0x8ff/0xb10
> kernel: [14787.059977] Code: 06 ff ff ff 48 89 df e8 3f 47 0f 00 e9 4e =
f9 ff ff 0f 0b e9 51 f7 ff ff 4c 89 e6 bf 05 06 00 00 e8 06 eb 00 00 e9 =
2a f8 ff ff <0f> 0b e9 74 f7 ff ff 48 8b bb e0 0b 00 00 e8 2e db ff ff =
48 85 c0
> kernel: [14787.059978] RSP: 0000:ffffaf9500db7ed8 EFLAGS: 00010286
> kernel: [14787.059980] RAX: 0000000000000000 RBX: ffffa034e42c8000 =
RCX: 0000000000000000
> kernel: [14787.059981] RDX: 0000000000000001 RSI: 0000000000002710 =
RDI: 00000000ffffffff
> kernel: [14787.059983] RBP: ffffa034e42e0000 R08: 0000000000000000 =
R09: ffffaf9500db7dd0
> kernel: [14787.059984] R10: 0000000000000003 R11: ffffa0545ff6eb28 =
R12: 0000000000000009
> kernel: [14787.059985] R13: ffffa035827c5ac0 R14: 0000000000000000 =
R15: 0000000000000000
> kernel: [14787.059986] FS:  0000000000000000(0000) =
GS:ffffa053dfb00000(0000) knlGS:0000000000000000
> kernel: [14787.059988] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
> kernel: [14787.059989] CR2: 0000000000000050 CR3: 000000048199e006 =
CR4: 00000000003726e0
> kernel: [14787.059991] Call Trace:
> kernel: [14787.059993]  <TASK>
> kernel: [14787.059996]  make_task_dead+0x8d/0x90
> kernel: [14787.059999]  rewind_stack_and_make_dead+0x17/0x20
> kernel: [14787.060003] RIP: 0000:0x0
> kernel: [14787.060007] Code: Unable to access opcode bytes at =
0xffffffffffffffd6.
> kernel: [14787.060008] RSP: 0000:0000000000000000 EFLAGS: 00000000 =
ORIG_RAX: 0000000000000000
> kernel: [14787.060010] RAX: 0000000000000000 RBX: 0000000000000000 =
RCX: 0000000000000000
> kernel: [14787.059981] RDX: 0000000000000001 RSI: 0000000000002710 =
RDI: 00000000ffffffff
> kernel: [14787.059983] RBP: ffffa034e42e0000 R08: 0000000000000000 =
R09: ffffaf9500db7dd0
> kernel: [14787.059984] R10: 0000000000000003 R11: ffffa0545ff6eb28 =
R12: 0000000000000009
> kernel: [14787.059985] R13: ffffa035827c5ac0 R14: 0000000000000000 =
R15: 0000000000000000
> kernel: [14787.059986] FS:  0000000000000000(0000) =
GS:ffffa053dfb00000(0000) knlGS:0000000000000000
> kernel: [14787.059988] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
> kernel: [14787.059989] CR2: 0000000000000050 CR3: 000000048199e006 =
CR4: 00000000003726e0
> kernel: [14787.059991] Call Trace:
> kernel: [14787.059993]  <TASK>
> kernel: [14787.059996]  make_task_dead+0x8d/0x90
> kernel: [14787.059999]  rewind_stack_and_make_dead+0x17/0x20
> kernel: [14787.060003] RIP: 0000:0x0
> kernel: [14787.060007] Code: Unable to access opcode bytes at =
0xffffffffffffffd6.
> kernel: [14787.060008] RSP: 0000:0000000000000000 EFLAGS: 00000000 =
ORIG_RAX: 0000000000000000
> kernel: [14787.060010] RAX: 0000000000000000 RBX: 0000000000000000 =
RCX: 0000000000000000
> kernel: [14787.060011] RDX: 0000000000000000 RSI: 0000000000000000 =
RDI: 0000000000000000
> kernel: [14787.060012] RBP: 0000000000000000 R08: 0000000000000000 =
R09: 0000000000000000
> kernel: [14787.060013] R10: 0000000000000000 R11: 0000000000000000 =
R12: 0000000000000000
> kernel: [14787.060014] R13: 0000000000000000 R14: 0000000000000000 =
R15: 0000000000000000
> kernel: [14787.060017]  </TASK>
> kernel: [14787.060018] ---[ end trace 0000000000000000 ]---
>=20
> For now I've reverted to an internal bitmap for the raid5 and all is =
stable again. If you need more information, please let me know!
>=20
> Kind regards,
>=20
> Maarten
>=20
> .
>=20

