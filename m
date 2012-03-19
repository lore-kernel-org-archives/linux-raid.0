From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Kernel oops adding bitmap
Date: Mon, 19 Mar 2012 11:44:45 -0500
Message-ID: <4F67627D.8050205@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The following command oopsed.

mdadm -G --bitmap=internal /dev/md0

The array is a two disk raid1 and hosts the root filesystem.

Is it not possible/allowed to add a bitmap to an active/mounted array?

[  339.521575] scsi_verify_blk_ioctl: 662 callbacks suppressed
[  339.531128] mdadm: sending ioctl 1261 to a partition!
[  339.539999] mdadm: sending ioctl 1261 to a partition!
[  339.549504] mdadm: sending ioctl 1261 to a partition!
[  339.558273] mdadm: sending ioctl 1261 to a partition!
[  339.570764] md0: bitmap file is out of date (0 < 47) -- forcing full
recovery
[  339.574628] mdadm: sending ioctl 800c0910 to a partition!
[  339.574635] mdadm: sending ioctl 800c0910 to a partition!
[  339.574646] mdadm: sending ioctl 1261 to a partition!
[  339.574650] mdadm: sending ioctl 1261 to a partition!
[  339.580825] mdadm: sending ioctl 800c0910 to a partition!
[  339.580832] mdadm: sending ioctl 800c0910 to a partition!
[  339.634433] created bitmap (1 pages) for device md0
[  341.719752] BUG: unable to handle kernel NULL pointer dereference at
0000000000000010
[  341.720673] IP: [<ffffffff81473cc0>] bitmap_endwrite+0x130/0x250
[  341.720673] PGD 0
[  341.720673] Oops: 0000 [#1] SMP
[  341.720673] CPU 1
[  341.720673] Modules linked in: lockd it87 hwmon_vid ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter nf_conntrack_ipv4
nf_defrag_ipv4 xt_state ip6_tables nf_conntrack keyspan
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device microcode edac_core sp5100_tco snd_pcm edac_mce_amd
i2c_piix4 r8169 k10temp mii serio_raw snd_timer snd soundcore
snd_page_alloc shpchp uinput sunrpc raid456 async_raid6_recov async_pq
raid6_pq async_xor xor async_memcpy async_tx pata_acpi ata_generic raid0
raid1 firewire_ohci firewire_core crc_itu_t pata_atiixp mvsas libsas
scsi_transport_sas wmi radeon ttm drm_kms_helper drm i2c_algo_bit
i2c_core [last unloaded: scsi_wait_scan]
[  341.720673]
[  341.720673] Pid: 0, comm: swapper/1 Not tainted 3.2.9-1.fc16.x86_64
#1 Gigabyte Technology Co., Ltd. GA-MA790GPT-UD3H/GA-MA790GPT-UD3H
[  341.720673] RIP: 0010:[<ffffffff81473cc0>]  [<ffffffff81473cc0>]
bitmap_endwrite+0x130/0x250
[  341.867091] RSP: 0018:ffff880227c43b90  EFLAGS: 00010046
[  341.867091] RAX: 0000000000000000 RBX: ffff8802110edd00 RCX:
0000000000000000
[  341.867091] RDX: 00000000000000a4 RSI: 00000000000008a4 RDI:
0000000000000000
[  341.867091] RBP: ffff880227c43bf0 R08: 0000000000000000 R09:
000000000000000b
[  341.867091] R10: 0000000000000000 R11: 0000000000000001 R12:
0000000001485d40
[  341.867091] R13: ffff8802110edd3c R14: 0000000000000202 R15:
0000000000000008
[  341.867091] FS:  00007fa3e76bd7c0(0000) GS:ffff880227c40000(0000)
knlGS:0000000000000000

This is all I got over the serial console.

--Larkin
