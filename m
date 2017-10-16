From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [PATCH] md: ensure sectors is nonzero when change component size
Date: Mon, 16 Oct 2017 15:31:20 +0800
Message-ID: <31970279-37d7-e8bc-b37f-955f23434f7f@suse.com>
References: <1507797051-18545-1-git-send-email-zlliu@suse.com>
 <20171012173743.nocrm6ejov3pvhjd@kernel.org>
 <111b18f3-4db6-bf53-3a9f-15db452192ba@suse.com>
 <20171013190558.svbyj35i7xtls4wr@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171013190558.svbyj35i7xtls4wr@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids



On 10/14/2017 03:05 AM, Shaohua Li wrote:
> On Fri, Oct 13, 2017 at 10:47:29AM +0800, Zhilong Liu wrote:
>>
>> On 10/13/2017 01:37 AM, Shaohua Li wrote:
>>> On Thu, Oct 12, 2017 at 04:30:51PM +0800, Zhilong Liu wrote:
>>>> Against the raids which chunk_size is meaningful, the component_size
>>>> must be >= chunk_size when require resize. If "new_size < chunk_size"
>>>> has required, the "mddev->pers->resize" will set sectors as '0', and
>>>> then the raids isn't meaningful any more due to mddev->dev_sectors is
>>>> '0'.
>>>>
>>>> Cc: Neil Brown <neilb@suse.com>
>>>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>>> Not sure about this, does size 0 disk really harm?
>>>
>>  From my site, I think changing the component size as '0' should be avoided.
>> When resize changing required and new_size < current_chunk_size, such as
>> raid5:
>>
>> raid5.c: raid5_resize()
>> ...
>> 7727         sectors &= ~((sector_t)conf->chunk_sectors - 1);
>> ...
>>
>> 'sectors' got '0'.
>>
>> then:
>> ...
>> 7743         mddev->dev_sectors = sectors;
>> ...
>>
>> the dev_sectors(the component size) got '0'.
>> same scenario happens in raid10.
>>
>> So, it's really not meaningful if changing the raid component_size to '0',
>> md
>> should give this scenario a test, otherwise, it's a trouble thing to restore
>> after
>> doing such invalid re-size.
> Yes, I understand how it could be 0. My question is what's wrong with a size-0
> disk? For example, if you don't setup file for a loop block device, its size is
> 0.
I'm sorry I'm not very clear with your question, I try to describe more 
on this scenario.
the 0-component_size isn't a 0-size disk. resize doesn't change 
raid_member_disk size
to 0.

For example: mdadm -CR /dev/md0 -b internal -l5 -n2 -x1 /dev/sd[b-d]
if set the component_size to 0, how would the 'internal bitmap' be? And 
if I want to make
a file-system on this raid, how would it be? it's out of my control.

I would continue to provide infos for you if any questions needs further 
discussion.

Hope this information is useful for you.
Here is piece of dmesg for the following steps:
1. mdadm -CR /dev/md0 -b internal -l5 -n2 -x1 /dev/sd[b-d]
2. mdadm -G /dev/md0 --size 511
3. mkfs.ext3 /dev/md0
the mkfs would be stuck all time, cannot kill the mkfs process and have to
force to reboot, then lots of same call trace prints in dmesg.

... ... ...
[   18.376342] async_tx: api initialized (async)
[   18.418992] md/raid:md0: not clean -- starting background reconstruction
[   18.419010] md/raid:md0: device sdc operational as raid disk 1
[   18.419011] md/raid:md0: device sdb operational as raid disk 0
[   18.419360] md/raid:md0: raid level 5 active with 2 out of 2 devices, 
algorithm 2
[   18.420881] random: nonblocking pool is initialized
[   18.421869] md: resync of RAID array md0
[   18.421880] md: md0: resync done.
[   18.504658] md: resync of RAID array md0
[   18.504666] md: md0: resync done.
[   18.504671] ------------[ cut here ]------------
[   18.504680] WARNING: CPU: 3 PID: 1396 at ../drivers/md/md.c:7571 
md_seq_show+0x7ad/0x7c0 [md_mod]()
[   18.504702] Modules linked in: raid456 async_raid6_recov async_memcpy 
libcrc32c async_pq async_xor async_tx md_mod sd_mod iscsi_tcp 
libiscsi_tcp libiscsi scsi_transport_iscsi af_packet iscsi_ibft 
iscsi_boot_sysfs softdog ppdev joydev serio_raw parport_pc parport 
pvpanic pcspkr i2c_piix4 processor button ata_generic btrfs xor raid6_pq 
cirrus ata_piix virtio_net virtio_balloon virtio_blk ahci drm_kms_helper 
syscopyarea libahci sysfillrect sysimgblt fb_sys_fops ttm drm uhci_hcd 
ehci_hcd usbcore virtio_pci virtio_ring virtio libata usb_common floppy 
sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod 
autofs4
[   18.504703] Supported: Yes
[   18.504704] CPU: 3 PID: 1396 Comm: mdadm Not tainted 4.4.73-5-default #1
[   18.504705] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS Bochs 01/01/2011
[   18.504707]  0000000000000000 ffffffff8131fe80 0000000000000000 
ffffffffa04ad656
[   18.504708]  ffffffff8107df61 ffff880036866700 ffff88003b9ab800 
0000000000000003
[   18.504710]  0000000000000000 00000000000c3000 ffffffffa049f87d 
ffffffff811c2bad
[   18.504710] Call Trace:
[   18.504721]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[   18.504724]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[   18.504726]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[   18.504729]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[   18.504733]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[   18.504738]  [<ffffffffa049f87d>] md_seq_show+0x7ad/0x7c0 [md_mod]
[   18.504747]  [<ffffffff8122761c>] seq_read+0x22c/0x370
[   18.504751]  [<ffffffff8126b8a9>] proc_reg_read+0x39/0x70
[   18.504754]  [<ffffffff81204eb3>] __vfs_read+0x23/0x130
[   18.504756]  [<ffffffff81205a3a>] vfs_read+0x7a/0x120
[   18.504758]  [<ffffffff81206b42>] SyS_read+0x42/0xa0
[   18.504761]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[   18.506306] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d

[   18.506307] Leftover inexact backtrace:

[   18.506309] ---[ end trace 6a7e8bf93781c207 ]---
[   18.566273] md: resync of RAID array md0
[   18.566282] md: md0: resync done.
[   18.566284] ------------[ cut here ]------------
[   18.566294] WARNING: CPU: 3 PID: 1396 at ../drivers/md/md.c:7571 
md_seq_show+0x7ad/0x7c0 [md_mod]()
[   18.566316] Modules linked in: raid456 async_raid6_recov async_memcpy 
libcrc32c async_pq async_xor async_tx md_mod sd_mod iscsi_tcp 
libiscsi_tcp libiscsi scsi_transport_iscsi af_packet iscsi_ibft 
iscsi_boot_sysfs softdog ppdev joydev serio_raw parport_pc parport 
pvpanic pcspkr i2c_piix4 processor button ata_generic btrfs xor raid6_pq 
cirrus ata_piix virtio_net virtio_balloon virtio_blk ahci drm_kms_helper 
syscopyarea libahci sysfillrect sysimgblt fb_sys_fops ttm drm uhci_hcd 
ehci_hcd usbcore virtio_pci virtio_ring virtio libata usb_common floppy 
sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod 
autofs4
[   18.566316] Supported: Yes
[   18.566318] CPU: 3 PID: 1396 Comm: mdadm Tainted: G W          
4.4.73-5-default #1
[   18.566319] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS Bochs 01/01/2011
[   18.566321]  0000000000000000 ffffffff8131fe80 0000000000000000 
ffffffffa04ad656
[   18.566322]  ffffffff8107df61 ffff880036866700 ffff88003b9ab800 
0000000000000003
[   18.566324]  0000000000000000 00000000000c3000 ffffffffa049f87d 
0000000000001000
[   18.566324] Call Trace:
[   18.566334]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[   18.566338]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[   18.566340]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[   18.566343]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[   18.566347]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[   18.566352]  [<ffffffffa049f87d>] md_seq_show+0x7ad/0x7c0 [md_mod]
[   18.566361]  [<ffffffff8122761c>] seq_read+0x22c/0x370
[   18.566365]  [<ffffffff8126b8a9>] proc_reg_read+0x39/0x70
[   18.566367]  [<ffffffff81204eb3>] __vfs_read+0x23/0x130
[   18.566369]  [<ffffffff81205a3a>] vfs_read+0x7a/0x120
[   18.566371]  [<ffffffff81206b42>] SyS_read+0x42/0xa0
[   18.566375]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[   18.567902] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d

[   18.567903] Leftover inexact backtrace:

[   18.567905] ---[ end trace 6a7e8bf93781c208 ]---
[   18.641350] md: resync of RAID array md0
[   18.641360] md: md0: resync done.

Thanks,
-Zhilong

> Thanks,
> Shaohua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

