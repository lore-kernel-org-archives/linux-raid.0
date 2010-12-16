From: Neil Brown <neilb@suse.de>
Subject: Re: raid1 module is not ready to take IO request
Date: Thu, 16 Dec 2010 22:29:58 +1100
Message-ID: <20101216222958.1d29de22@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D176B3CE2F@irsmsx503.ger.corp.intel.com>
	<20101216085222.77efd1ef@notabene.brown>
	<66C59AD0932712458090B447266D638C010C23F0C2@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66C59AD0932712458090B447266D638C010C23F0C2@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 16 Dec 2010 10:32:24 +0000 "Hawrylewicz Czarnowski, Przemyslaw"
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> > -----Original Message-----
> > From: Neil Brown [mailto:neilb@suse.de]
> > Sent: Wednesday, December 15, 2010 10:52 PM
> > To: Labun, Marcin
> > Cc: linux-raid@vger.kernel.org; Hawrylewicz Czarnowski, Przemyslaw
> > Subject: Re: raid1 module is not ready to take IO request
> > 
> > I cannot imagine how this would happen.
> > It should not be possible to call do_md_stop while there are any requests
> > still in flight.
> It is not the problem. Oops is generated at start of a device during assembly. I have made some assembly tests and sometimes I wasn't able to finish a test with approx. 10 assemblies. 
> 
> > Are you generating any IO between assembling the RAID1 and stopping it?  If
> > so, how?
> > 
> > Can you get me the full oops message?
> > 
> > Thanks,
> 
> Here you are. Oops and some other traces. The one which try to read md device is one of udev's tools.

udisk-part-id is just opening the device.  That automagic partition table
reading code is sending a read request to the device and that is what is
causing the problem.  It shouldn't be too hard to find out how to lock
against that, though I'm somewhat surprised that it isn't already locked out.

I'll try to have a look next week.

NeilBrown



> 
> Dec  3 16:38:30 localhost kernel: [81508.801522] md124: detected capacity change from 0 to 9437184
> Dec  3 16:38:30 localhost kernel: [81508.801572] BUG: unable to handle kernel NULL pointer dereference at 0000002c
> Dec  3 16:38:30 localhost kernel: [81508.801576] IP: [<c05a5260>] _raw_spin_lock_irq+0x10/0x30
> Dec  3 16:38:30 localhost kernel: [81508.801583] *pdpt = 0000000030e93001 *pde = 0000000000000000 
> Dec  3 16:38:30 localhost kernel: [81508.801587] Oops: 0002 [#1] SMP 
> Dec  3 16:38:30 localhost kernel: [81508.801589] last sysfs file: /sys/devices/virtual/block/loop3/uevent
> Dec  3 16:38:30 localhost kernel: [81508.801592] Modules linked in: raid1 md_mod snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device binfmt_misc nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq speedstep_lib af_packet mperf loop dm_mod snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm firewire_ohci firewire_core snd_timer shpchp crc_itu_t iTCO_wdt e1000e pci_hotplug sg intel_agp intel_gtt i2c_i801 snd pcspkr soundcore iTCO_vendor_support snd_page_alloc serio_raw button usbhid uhci_hcd ehci_hcd sd_mod usbcore edd fan ata_generic ahci libahci pata_marvell libata scsi_mod thermal processor thermal_sys [last unloaded: md_mod]
> Dec  3 16:38:30 localhost kernel: [81508.801632] 
> Dec  3 16:38:30 localhost kernel: [81508.801635] Pid: 1948, comm: udisks-part-id Not tainted 2.6.37-rc3-pae-mdadm #2 DP35DP/        
> Dec  3 16:38:30 localhost kernel: [81508.801638] EIP: 0060:[<c05a5260>] EFLAGS: 00010082 CPU: 1
> Dec  3 16:38:30 localhost kernel: [81508.801640] EIP is at _raw_spin_lock_irq+0x10/0x30
> Dec  3 16:38:30 localhost kernel: [81508.801642] EAX: 00000100 EBX: 00000000 ECX: 0000002c EDX: f14f9ec0
> Dec  3 16:38:30 localhost kernel: [81508.801644] ESI: 0000002c EDI: f14f9ec0 EBP: f0da5978 ESP: f0da5978
> Dec  3 16:38:30 localhost kernel: [81508.801646]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Dec  3 16:38:30 localhost kernel: [81508.801648] Process udisks-part-id (pid: 1948, ti=f0da4000 task=f0dd9110 task.ti=f0da4000)
> Dec  3 16:38:30 localhost kernel: [81508.801650] Stack:
> Dec  3 16:38:30 localhost kernel: [81508.801651]  f0da59a8 f8483945 00000202 d99cbe10 f14f9ec0 00000000 f14f9ec0 f0da59a0
> Dec  3 16:38:30 localhost kernel: [81508.801656]  c032f7a8 f6854c00 f14f9ec0 f14f9ec0 f0da5a08 f84842e6 00000000 00000000
> Dec  3 16:38:30 localhost kernel: [81508.801661]  00000000 00000000 00000000 00000000 00000000 00000000 f14f9ec0 f6854c00
> Dec  3 16:38:30 localhost kernel: [81508.801666] Call Trace:
> Dec  3 16:38:30 localhost kernel: [81508.801670]  [<f8483945>] ? wait_barrier+0x15/0xc0 [raid1]
> Dec  3 16:38:30 localhost udevd-work[405]: 'udisks-part-id /dev/md124' unexpected exit with status 0x0009
> Dec  3 16:38:30 localhost kernel: [81508.801675]  [<c032f7a8>] ? end_bio_bh_io_sync+0x28/0x50
> Dec  3 16:38:30 localhost kernel: [81508.801678]  [<f84842e6>] ? make_request+0x76/0x740 [raid1]
> Dec  3 16:38:30 localhost kernel: [81508.801684]  [<f84a6e78>] ? md_make_request+0x98/0x1b0 [md_mod]
> Dec  3 16:38:30 localhost kernel: [81508.801689]  [<c03d14ab>] ? generic_make_request+0x12b/0x5d0
> Dec  3 16:38:30 localhost kernel: [81508.801693]  [<c03d19ad>] ? submit_bio+0x5d/0xe0
> Dec  3 16:38:30 localhost kernel: [81508.801696]  [<c033416b>] ? bio_alloc_bioset+0x3b/0xc0
> Dec  3 16:38:30 localhost kernel: [81508.801699]  [<c032f74d>] ? submit_bh+0xcd/0x100
> Dec  3 16:38:30 localhost kernel: [81508.801702]  [<c03310af>] ? block_read_full_page+0x20f/0x320
> Dec  3 16:38:30 localhost kernel: [81508.801705]  [<c0307fc3>] ? mem_cgroup_charge_common+0x53/0x70
> Dec  3 16:38:30 localhost kernel: [81508.801708]  [<c0335ed0>] ? blkdev_get_block+0x0/0x60>
> Dec  3 16:38:30 localhost kernel: [81508.801712]  [<c02dc9ae>] ? __inc_zone_page_state+0x1e/0x20
> Dec  3 16:38:30 localhost kernel: [81508.801716]  [<c02c6599>] ? add_to_page_cache_locked+0xa9/0x130
> Dec  3 16:38:30 localhost kernel: [81508.801718]  [<c0335a2f>] ? blkdev_readpage+0xf/0x20
> Dec  3 16:38:30 localhost kernel: [81508.801721]  [<c02c68eb>] ? do_read_cache_page+0x5b/0x140
> Dec  3 16:38:30 localhost kernel: [81508.801724]  [<c0335a20>] ? blkdev_readpage+0x0/0x20
> Dec  3 16:38:30 localhost kernel: [81508.801724]  [<c0335a20>] ? blkdev_readpage+0x0/0x20
> Dec  3 16:38:30 localhost kernel: [81508.801726]  [<c02c6a1f>] ? read_cache_page_async+0x1f/0x30
> Dec  3 16:38:30 localhost kernel: [81508.801729]  [<c02c6a42>] ? read_cache_page+0x12/0x20
> Dec  3 16:38:30 localhost kernel: [81508.801732]  [<c0359d68>] ? read_dev_sector+0x38/0x90
> Dec  3 16:38:30 localhost kernel: [81508.801735]  [<c035f943>] ? read_lba+0xc3/0x170
> Dec  3 16:38:30 localhost kernel: [81508.801738]  [<c035ff0b>] ? find_valid_gpt+0x9b/0x5f0
> Dec  3 16:38:30 localhost kernel: [81508.801741]  [<c0360460>] ? efi_partition+0x0/0x410
> Dec  3 16:38:30 localhost kernel: [81508.801743]  [<c03604c4>] ? efi_partition+0x64/0x410
> Dec  3 16:38:30 localhost kernel: [81508.801746]  [<c03eb511>] ? string+0x31/0xb0
> Dec  3 16:38:30 localhost kernel: [81508.801749]  [<c03ec562>] ? vsnprintf+0x1c2/0x3d0
> Dec  3 16:38:30 localhost kernel: [81508.801751]  [<c03eb511>] ? string+0x31/0xb0
> Dec  3 16:38:30 localhost kernel: [81508.801754]  [<c03ec662>] ? vsnprintf+0x2c2/0x3d0
> Dec  3 16:38:30 localhost kernel: [81508.801756]  [<c03ec80a>] ? snprintf+0x1a/0x20
> Dec  3 16:38:30 localhost kernel: [81508.801759]  [<c0360460>] ? efi_partition+0x0/0x410
> Dec  3 16:38:30 localhost kernel: [81508.801761]  [<c035aaff>] ? rescan_partitions+0x19f/0x570
> Dec  3 16:38:30 localhost kernel: [81508.801764]  [<c03d7b50>] ? exact_match+0x0/0x10
> Dec  3 16:38:30 localhost kernel: [81508.801767]  [<c033644e>] ? __blkdev_get+0x1fe/0x330
> Dec  3 16:38:30 localhost kernel: [81508.801770]  [<c033658a>] ? blkdev_get+0xa/0x10
> Dec  3 16:38:30 localhost kernel: [81508.801773]  [<c033664e>] ? blkdev_open+0xbe/0x110
> Dec  3 16:38:30 localhost kernel: [81508.801776]  [<c030a515>] ? __dentry_open+0xc5/0x280
> Dec  3 16:38:30 localhost kernel: [81508.801779]  [<c030b62e>] ? nameidata_to_filp+0x5e/0x70
> Dec  3 16:38:30 localhost kernel: [81508.801782]  [<c0336590>] ? blkdev_open+0x0/0x110
> Dec  3 16:38:30 localhost kernel: [81508.801785]  [<c031791f>] ? do_last+0x3ef/0x620
> Dec  3 16:38:30 localhost kernel: [81508.801788]  [<c0317d08>] ? do_filp_open+0x1b8/0x4c0
> Dec  3 16:38:30 localhost kernel: [81508.801792]  [<c02f1195>] ? free_pages_and_swap_cache+0x85/0xa0
> Dec  3 16:38:30 localhost kernel: [81508.801795]  [<c030b695>] ? do_sys_open+0x55/0x100
> Dec  3 16:38:30 localhost kernel: [81508.801799]  [<c0471330>] ? write_null+0x0/0x10
> Dec  3 16:38:30 localhost kernel: [81508.801801]  [<c030b769>] ? sys_open+0x29/0x40
> Dec  3 16:38:30 localhost kernel: [81508.801805]  [<c0202e18>] ? sysenter_do_call+0x12/0x28
> Dec  3 16:38:30 localhost kernel: [81508.801807] Code: d8 f0 83 28 01 79 05 e8 93 fd ff ff 89 c8 5b 5d c3 8d 76 00 8d bc 27 00 00 00 00 55 89 c1 89 e5 fa 90 8d 74 26 00 b8 00 01 00 00 <f0> 66 0f c1 01 38 e0 74 06 f3 90 8a 01 eb f6 5d c3 eb 0d 90 90 
> Dec  3 16:38:30 localhost kernel: [81508.801835] EIP: [<c05a5260>] _raw_spin_lock_irq+0x10/0x30 SS:ESP 0068:f0da5978
> Dec  3 16:38:30 localhost kernel: [81508.801839] CR2: 000000000000002c
> Dec  3 16:38:30 localhost kernel: [81508.801842] ---[ end trace bfbe74e7cba9431c ]---
> Dec  3 16:38:30 localhost kernel: [81508.803228] md/raid1:md124: not clean -- starting background reconstruction
> Dec  3 16:38:30 localhost kernel: [81508.803232] md/raid1:md124: active with 2 out of 2 mirrors
> Dec  3 16:38:38 localhost kernel: [81516.880645] md: md126: resync done.
> Dec  3 16:38:38 localhost kernel: [81516.888723] RAID1 conf printout:
> Dec  3 16:38:38 localhost kernel: [81516.888728]  --- wd:2 rd:2
> Dec  3 16:38:38 localhost kernel: [81516.888732]  disk 0, wo:0, o:1, dev:loop3
> Dec  3 16:38:38 localhost kernel: [81516.888735]  disk 1, wo:0, o:1, dev:loop4
> Dec  3 16:41:07 localhost udevd-work[31871]: '/sbin/mdadm --detail --export /dev/md125' unexpected exit with status 0x0009
> Dec  3 16:41:30 localhost udevd[485]: worker [31872] unexpectedly returned with status 0x0100
> Dec  3 16:41:30 localhost udevd[485]: worker [31872] failed while handling '/devices/virtual/block/md124'
> 
> As Marcin said, the "first aid" is to reject such "early bio". I made such change to avoid oops:
> 
> >From 692a892fb38674d7a748ecc48624851f59f2d2e5 Mon Sep 17 00:00:00 2001
> From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
> Date: Fri, 10 Dec 2010 12:53:54 +0100
> Subject: [PATCH] raid1: oops on early access to newly created array
> 
> Early access to device (by udev in general) generates oops on wait_barrier()
> as mddev->private is not configured yet. This case is handled and EIO is
> returned for such early bio.
> 
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
> ---
>  drivers/md/raid1.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 45f8324..cb7518c 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -778,6 +778,11 @@ static int make_request(mddev_t *mddev, struct bio * bio)
>  	 * Continue immediately if no resync is active currently.
>  	 */
>  
> +	if (unlikely(!conf)) {
> +		bio_io_error(bio);
> +		return 0;
> +	}
> +
>  	md_write_start(mddev, bio); /* wait on superblock update early */
>  
>  	if (bio_data_dir(bio) == WRITE &&

