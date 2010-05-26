From: Ralph Loader <suckfish@ihug.co.nz>
Subject: Crash shutting down md.
Date: Wed, 26 May 2010 20:16:34 +1200
Message-ID: <20100526201634.97910c3c.suckfish@ihug.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

My system crashed a couple of times stopping a md device.  It was linear mode combining loop0 (1MB) and sda6 (50G).

I ran fdisk on it before stopping, and there was one 50G partition md127p1.

The kernel is fedora kernel-2.6.34-11.fc14.x86_64.

Cheers,
Ralph.


May 26 19:18:31 i kernel: md: md127 stopped.
May 26 19:18:31 i kernel: md: unbind<sda6>
May 26 19:18:31 i kernel: md: export_rdev(sda6)
May 26 19:18:31 i kernel: md: unbind<loop0>
May 26 19:18:31 i kernel: md: export_rdev(loop0)
May 26 19:18:31 i kernel: md127: detected capacity change from 52428931072 to 0
May 26 19:18:31 i kernel: general protection fault: 0000 [#1] SMP 
May 26 19:18:31 i kernel: last sysfs file: /sys/devices/virtual/block/md127/uevent
May 26 19:18:31 i kernel: CPU 1 
May 26 19:18:31 i kernel: Modules linked in: linear ipt_MASQUERADE nf_nat_h323 nf_conntrack_h323 nf_nat_pptp nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_proto_gre nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp iptable_nat nf_nat k8temp it87 hwmon_vid cpufreq_ondemand powernow_k8 freq_table ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 kvm_amd kvm uinput arc4 snd_hda_codec_atihdmi ecb snd_hda_codec_realtek rt73usb snd_hda_intel crc_itu_t snd_hda_codec uvcvideo snd_usb_audio snd_usb_lib rt2x00usb videodev rt2x00lib snd_hwdep i2c_piix4 v4l1_compat snd_seq r8169 snd_rawmidi e100 snd_pcm v4l2_compat_ioctl32 snd_seq_device snd_timer snd mac80211 edac_core edac_mce_amd cfg80211 mii ftdi_sio k10temp usbserial wm
 i rfkill shpchp soundcore snd_page_alloc serio_raw microcode ata_generic pata_acpi pata_atiixp radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
May 26 19:18:31 i kernel:
May 26 19:18:31 i kernel: Pid: 10, comm: events/1 Not tainted 2.6.34-11.fc14.x86_64 #1 GA-MA790GP-DS4H/GA-MA790GP-DS4H
May 26 19:18:31 i kernel: RIP: 0010:[<ffffffff8122f6dc>]  [<ffffffff8122f6dc>] strcmp+0x6/0x21
May 26 19:18:31 i kernel: RSP: 0018:ffff88021f369cf0  EFLAGS: 00010282
May 26 19:18:31 i kernel: RAX: 000000000000006c RBX: ffff88021b373398 RCX: 0000000000000000
May 26 19:18:31 i kernel: RDX: ffffffff81a76058 RSI: 6b6b6b6b6b6b6b6b RDI: ffffffff8177ecf1
May 26 19:18:31 i kernel: RBP: ffff88021f369cf0 R08: ffffffff81a76058 R09: 0000000000000000
May 26 19:18:31 i kernel: R10: 0000000000000046 R11: ffff88021f362480 R12: 6b6b6b6b6b6b6b6b
May 26 19:18:31 i kernel: R13: ffff8801f8289920 R14: ffff88021b3732e0 R15: ffff88021f369fd8
May 26 19:18:31 i kernel: FS:  00007fb8ddf33700(0000) GS:ffff880002e00000(0000) knlGS:0000000000000000
May 26 19:18:31 i kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 26 19:18:31 i kernel: CR2: 00007fb8dda105a0 CR3: 00000001d6110000 CR4: 00000000000006e0
May 26 19:18:31 i kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 26 19:18:31 i kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 26 19:18:31 i kernel: Process events/1 (pid: 10, threadinfo ffff88021f368000, task ffff88021f362480)
May 26 19:18:31 i kernel: Stack:
May 26 19:18:31 i kernel: ffff88021f369d10 ffffffff81179e83 ffff88021b3732e0 6b6b6b6b6b6b6b6b
May 26 19:18:31 i kernel: <0> ffff88021f369d30 ffffffff81179ec3 ffff8801fd9adee0 ffff8801f82898d8
May 26 19:18:31 i kernel: <0> ffff88021f369d60 ffffffff8117bd9a ffff8801f8289c50 ffff8801f82898d8
May 26 19:18:31 i kernel: Call Trace:
May 26 19:18:31 i kernel: [<ffffffff81179e83>] sysfs_find_dirent+0x21/0x36
May 26 19:18:31 i kernel: [<ffffffff81179ec3>] sysfs_get_dirent+0x2b/0x4a
May 26 19:18:31 i kernel: [<ffffffff8117bd9a>] sysfs_remove_group+0x2a/0xca
May 26 19:18:31 i kernel: [<ffffffff81388eb0>] mddev_delayed_delete+0x4f/0x9d
May 26 19:18:31 i kernel: [<ffffffff810667cd>] worker_thread+0x272/0x36b
May 26 19:18:31 i kernel: [<ffffffff81066775>] ? worker_thread+0x21a/0x36b
May 26 19:18:31 i kernel: [<ffffffff81047d79>] ? finish_task_switch+0x70/0xd8
May 26 19:18:31 i kernel: [<ffffffff81047d09>] ? finish_task_switch+0x0/0xd8
May 26 19:18:31 i kernel: [<ffffffff81388e61>] ? mddev_delayed_delete+0x0/0x9d
May 26 19:18:31 i kernel: [<ffffffff8106ad9e>] ? autoremove_wake_function+0x0/0x39
May 26 19:18:31 i kernel: [<ffffffff8106655b>] ? worker_thread+0x0/0x36b
May 26 19:18:31 i kernel: [<ffffffff8106a8f4>] kthread+0x9a/0xa2
May 26 19:18:31 i kernel: [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
May 26 19:18:31 i kernel: [<ffffffff814835d0>] ? restore_args+0x0/0x30
May 26 19:18:31 i kernel: [<ffffffff8106a85a>] ? kthread+0x0/0xa2
May 26 19:18:31 i kernel: [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
May 26 19:18:31 i kernel: Code: c1 80 39 00 75 f8 eb 0d 48 ff c1 48 ff ca 75 05 c6 01 00 eb 0e 40 8a 3e 48 ff c6 40 84 ff 40 88 39 75 e5 c9 c3 55 48 89 e5 8a 07 <8a> 16 48 ff c7 48 ff c6 38 d0 74 07 19 c0 83 c8 01 eb 06 84 c0 
May 26 19:18:31 i kernel: RIP  [<ffffffff8122f6dc>] strcmp+0x6/0x21
May 26 19:18:31 i kernel: RSP <ffff88021f369cf0>
May 26 19:18:31 i kernel: ---[ end trace c9a55db1a178d3ce ]---
