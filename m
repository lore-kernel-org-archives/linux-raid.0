From: Martin Svec <martin.svec@zoner.cz>
Subject: Re: RAID5 hangs in break_stripe_batch_list
Date: Tue, 17 Nov 2015 14:08:23 +0100
Message-ID: <564B26C7.5060409@zoner.cz>
References: <5649C0E9.2030204@zoner.cz> <20151117000409.GA92153@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151117000409.GA92153@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
List-Id: linux-raid.ids

Dne 17.11.2015 v 1:04 Shaohua Li napsal(a):
> On Mon, Nov 16, 2015 at 12:41:29PM +0100, Martin Svec wrote:
>> Hello,
>>
>> yesterday we had an issue with RAID5 in kernel 4.1.13. The device became unresponsive and RAID
>> module reported the following error:
>>
>> Nov 15 03:44:20 lio-203 kernel: [385878.345689] ------------[ cut here ]------------
>> Nov 15 03:44:20 lio-203 kernel: [385878.345704] WARNING: CPU: 2 PID: 601 at drivers/md/raid5.c:4233
>> break_stripe_batch_list+0x1f4/0x2f0 [raid456]()
>> Nov 15 03:44:20 lio-203 kernel: [385878.345706] Modules linked in: target_core_pscsi
>> target_core_file cpufreq_stats cpufreq_userspace cpufreq_powersave cpufreq_conservative
>> x86_pkg_temp_thermal intel_powerclamp intel_rapl iosf_mbi coretemp kvm_intel raid0 kvm
>> crct10dif_pclmul crc32_pclmul sr_mod iTCO_wdt mgag200 cdrom iTCO_vendor_support ttm dcdbas
>> drm_kms_helper aesni_intel snd_pcm ipmi_devintf drm aes_x86_64 snd_timer lrw gf128mul snd
>> glue_helper joydev evdev soundcore sb_edac i2c_algo_bit ipmi_si ablk_helper 8250_fintek wmi
>> ipmi_msghandler cryptd acpi_power_meter edac_core pcspkr ioatdma mei_me mei lpc_ich dca shpchp
>> mfd_core processor thermal_sys raid456 async_raid6_recov async_memcpy button async_pq async_xor xor
>> async_tx raid6_pq md_mod target_core_iblock iscsi_target_mod target_core_mod configfs autofs4 ext4
>> crc16 mbcache jbd2 dm_mod hid_generic uas usbhid usb_storage hid sg sd_mod bnx2x xhci_pci ehci_pci
>> ptp xhci_hcd ehci_hcd pps_core mdio usbcore megaraid_sas crc32c_generic usb_common crc32c_intel
>> scsi_mod libcrc32c
>> Nov 15 03:44:20 lio-203 kernel: [385878.345748] CPU: 2 PID: 601 Comm: md31_raid5 Not tainted
>> 4.1.13-zoner+ #9
>> Nov 15 03:44:20 lio-203 kernel: [385878.345749] Hardware name: Dell Inc. PowerEdge R730xd/0H21J3,
>> BIOS 1.3.6 06/03/2015
>> Nov 15 03:44:20 lio-203 kernel: [385878.345751]  0000000000000000 ffffffffa03ee3c4 ffffffff81574205
>> 0000000000000000
>> Nov 15 03:44:20 lio-203 kernel: [385878.345753]  ffffffff81072e51 ffff88007501ca50 ffff88007501cad8
>> ffff88006d55d618
>> Nov 15 03:44:20 lio-203 kernel: [385878.345755]  0000000000000000 ffff8802707f83c8 ffffffffa03e4964
>> 0000000000000001
>> Nov 15 03:44:20 lio-203 kernel: [385878.345756] Call Trace:
>> Nov 15 03:44:20 lio-203 kernel: [385878.345764]  [<ffffffff81574205>] ? dump_stack+0x40/0x50
>> Nov 15 03:44:20 lio-203 kernel: [385878.345768]  [<ffffffff81072e51>] ? warn_slowpath_common+0x81/0xb0
>> Nov 15 03:44:20 lio-203 kernel: [385878.345772]  [<ffffffffa03e4964>] ?
>> break_stripe_batch_list+0x1f4/0x2f0 [raid456]
>> Nov 15 03:44:20 lio-203 kernel: [385878.345776]  [<ffffffffa03e86cc>] ? handle_stripe+0x80c/0x2650
>> [raid456]
>> Nov 15 03:44:20 lio-203 kernel: [385878.345781]  [<ffffffff8101d756>] ? native_sched_clock+0x26/0x90
>> Nov 15 03:44:20 lio-203 kernel: [385878.345784]  [<ffffffffa03ea696>] ?
>> handle_active_stripes.isra.46+0x186/0x4e0 [raid456]
>> Nov 15 03:44:20 lio-203 kernel: [385878.345787]  [<ffffffffa03ddab6>] ?
>> raid5_wakeup_stripe_thread+0x96/0x1b0 [raid456]
>> Nov 15 03:44:20 lio-203 kernel: [385878.345790]  [<ffffffffa03eb75d>] ? raid5d+0x49d/0x700 [raid456]
>> Nov 15 03:44:20 lio-203 kernel: [385878.345795]  [<ffffffffa014f166>] ? md_thread+0x126/0x130 [md_mod]
>> Nov 15 03:44:20 lio-203 kernel: [385878.345798]  [<ffffffff810b1e80>] ? wait_woken+0x90/0x90
>> Nov 15 03:44:20 lio-203 kernel: [385878.345801]  [<ffffffffa014f040>] ? find_pers+0x70/0x70 [md_mod]
>> Nov 15 03:44:20 lio-203 kernel: [385878.345805]  [<ffffffff810913d3>] ? kthread+0xd3/0xf0
>> Nov 15 03:44:20 lio-203 kernel: [385878.345807]  [<ffffffff81091300>] ?
>> kthread_create_on_node+0x180/0x180
>> Nov 15 03:44:20 lio-203 kernel: [385878.345811]  [<ffffffff8157a622>] ? ret_from_fork+0x42/0x70
>> Nov 15 03:44:20 lio-203 kernel: [385878.345813]  [<ffffffff81091300>] ?
>> kthread_create_on_node+0x180/0x180
>> Nov 15 03:44:20 lio-203 kernel: [385878.345814] ---[ end trace 298194e8d69e6c62 ]---
>>
>> Unfortunately I'm not able to reproduce the bug, but it seems to be related to high write load. Note
>> that the same issue is also reported here: https://bugzilla.redhat.com/show_bug.cgi?id=1258153 .
>>
>> The setup consists of RAID0 over two RAID5 arrays. Each RAID5 has 6x 960 GB SSD and chunk size 32k.
>> RAID0 has chunk size 160k. Only one of the two RAIDs was affected. After machine reboot, I manually
>> triggered check of both RAID5 arrays and no parity errors were found. Kernel is vanilla stable 4.1.13.
>>
>> Probably there's something wrong with the stripe batching added in 4.1 series? Is there any way to
>> turn the stripe batching off until the bug will be fixed?
> do you have the full dmesg? I'd like to check what triggers the batch break,
> which would be helpful for debugging.

Yes, but I see nothing suspicious before the break_stripe_batch_list warning:

http://pastebin.ca/3258125 ... tail of full dmesg.
http://pastebin.ca/3258121 ... all log entries since last reboot, without the iSCSI
connection/session stuff.

Top-level array is an iblock backend of LIO iSCSI storage with some iSCSI session debug messages
enabled. That's why the log is full of them. However, everything before the RAID5 warning is common
harmless activity of MSFT/ESXi initiators. Subsequent target errors are probably caused by the
unresponsive RAID array and iSCSI session cleanup attempts (Cc'ing target-devel).

The only non-default settings of RAID5 arrays are chunk_size=32k and group_thread_cnt=2.

Thank you,

Martin Svec

