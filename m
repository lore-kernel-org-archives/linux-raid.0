From: Zhilong Liu <zlliu@suse.com>
Subject: Re: report a bug that panic when grow size for external bitmap
Date: Tue, 29 Aug 2017 12:39:35 +0800
Message-ID: <ba801ebe-9c0c-d911-2b18-936495fe0ed3@suse.com>
References: <ad8c69c7-f1e0-b6ab-dc87-a81aa7bca391@suse.com>
 <87y3q3gq8g.fsf@notabene.neil.brown.name>
 <6eaf97d4-bd8c-e33c-a9c7-37d0fe2086ce@suse.com>
 <87mv6jgj8z.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87mv6jgj8z.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 08/29/2017 11:12 AM, NeilBrown wrote:
> On Tue, Aug 29 2017, Zhilong Liu wrote:
>
>> Hi, Neil;
>>       Thanks for your pointing and sorry for the incorrect dmesg for last
>> mail.
>>
>> Here update the pure steps and paste the dmesg.
>>
>> ENV:
>> OS: 4.13-rc7 upstream
>> linux-apta:~/mdadm-test # df -T /mnt/
>> Filesystem     Type 1K-blocks     Used Available Use% Mounted on
>> /dev/sda2      ext4  44248848 24416952  18778472  57% /
>>
>> Reproduce: 100%
>>
>> Steps:
>> linux-apta:~/mdadm-test # ./mdadm -CR /dev/md0 -l1 -b /mnt/3 -n2 -x1
>> /dev/loop[0-2] --force
>> mdadm: Note: this array has metadata at the start and
>>       may not be suitable as a boot device.  If you plan to
>>       store '/boot' on this device please ensure that
>>       your boot-loader understands md/v1.x metadata, or use
>>       --metadata=0.90
>> mdadm: Defaulting to version 1.2 metadata
>> mdadm: array /dev/md0 started.
>> linux-apta:~/mdadm-test # cat /proc/mdstat
>> Personalities : [raid1]
>> md0 : active raid1 loop2[2](S) loop1[1] loop0[0]
>>         18944 blocks super 1.2 [2/2] [UU]
>>         bitmap: 3/3 pages [12KB], 4KB chunk, file: /mnt/3
>>
>> unused devices: <none>
>> linux-apta:~/mdadm-test # dmesg -c
>> [  181.378209] md/raid1:md0: not clean -- starting background reconstruction
>> [  181.378211] md/raid1:md0: active with 2 out of 2 mirrors
>> [  181.379354] md0: detected capacity change from 0 to 19398656
>> [  181.379773] md: resync of RAID array md0
>> [  190.396162] md: md0: resync done.
>>
>> linux-apta:~/mdadm-test # ./mdadm --grow /dev/md0 --size 128
>> Segmentation fault
>> linux-apta:~/mdadm-test # cat /sys/block/md0/md/component_size
>> 18944                         "here is incorrect also."
>> linux-apta:~/mdadm-test # dmesg -c
>> [  208.027505] ------------[ cut here ]------------
>> [  208.027508] kernel BUG at drivers/md/bitmap.c:298!
> Thanks.  Less confusing now.
>
> The problem is that when the bitmap is resized, new pages are allocated
> to store the on-disk copy, but these are not read from the file, the
> contents are set from the in-memory bitmap.
> So read_page() isn't called and particularly
>
> 	bh = alloc_page_buffers(page, 1<<inode->i_blkbits, 0);
>          ...
> 	attach_page_buffers(page, bh);
>
> doesn't happen.
>
> Maybe something like this will work.
> Can you test it?

Another panic happens when I built with the below patch.

Steps:
1. patching the codes to bitmap.c
2. rebuilt the kernel source code.
3. reboot and test.

linux-apta:~/mdadm-test # ./mdadm -CR /dev/md0 -l1 -b /mnt/3 -n2 -x1 
/dev/loop[0-2] --force
mdadm: Note: this array has metadata at the start and
     may not be suitable as a boot device.  If you plan to
     store '/boot' on this device please ensure that
     your boot-loader understands md/v1.x metadata, or use
     --metadata=0.90
mdadm: Defaulting to version 1.2 metadata
Segmentation fault
linux-apta:~/mdadm-test # dmesg -c
[   46.416567] md/raid1:md0: not clean -- starting background reconstruction
[   46.416570] md/raid1:md0: active with 2 out of 2 mirrors
[   46.417003] ------------[ cut here ]------------
[   46.417004] kernel BUG at drivers/md/bitmap.c:371!
[   46.417007] invalid opcode: 0000 [#1] SMP
[   46.417009] Modules linked in: raid1(E) md_mod(E) loop(E) uinput(E) 
af_packet(E) iscsi_ibft(E) iscsi_boot_sysfs(E) crct10dif_pclmul(E) 
snd_hda_codec_generic(E) crc32_pclmul(E) snd_hda_intel(E) 
snd_hda_codec(E) snd_hda_core(E) crc32c_intel(E) snd_hwdep(E) 
ghash_clmulni_intel(E) snd_pcm(E) pcbc(E) snd_timer(E) snd(E) 
aesni_intel(E) ppdev(E) parport_pc(E) aes_x86_64(E) virtio_balloon(E) 
joydev(E) virtio_net(E) soundcore(E) i2c_piix4(E) pcspkr(E) 
crypto_simd(E) parport(E) button(E) glue_helper(E) cryptd(E) pvpanic(E) 
ext4(E) crc16(E) mbcache(E) jbd2(E) hid_generic(E) usbhid(E) 
ata_generic(E) sd_mod(E) virtio_console(E) virtio_scsi(E) ata_piix(E) 
ahci(E) libahci(E) serio_raw(E) libata(E) ehci_pci(E) virtio_pci(E) 
virtio_ring(E) virtio(E) qxl(E) drm_kms_helper(E) syscopyarea(E) 
sysfillrect(E) sysimgblt(E)
[   46.417040]  uhci_hcd(E) fb_sys_fops(E) ehci_hcd(E) ttm(E) usbcore(E) 
drm(E) floppy(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) 
scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E) autofs4(E)
[   46.417050] CPU: 2 PID: 1858 Comm: mdadm Tainted: G E   
4.13.0-rc7-up-latest #1
[   46.417051] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS Bochs 01/01/2011
[   46.417053] task: ffff880071544240 task.stack: ffffc90000c28000
[   46.417061] RIP: 0010:read_page+0x1dd/0x1e0 [md_mod]
[   46.417062] RSP: 0000:ffffc90000c2bbc0 EFLAGS: 00010246
[   46.417064] RAX: 000fffffc0000000 RBX: 0000000000000000 RCX: 
0000000000000350
[   46.417065] RDX: ffff88006e88b000 RSI: 0000000000000000 RDI: 
ffff88006e0aea00
[   46.417066] RBP: ffffc90000c2bc20 R08: ffffea0001c80e80 R09: 
00000000000554a0
[   46.417068] R10: 0000000000000010 R11: 000000007203a000 R12: 
ffff88006e88b000
[   46.417069] R13: ffff88006e88b000 R14: 0000000000000350 R15: 
ffff8800711f6610
[   46.417071] FS:  00007f666fc9f700(0000) GS:ffff88007fd00000(0000) 
knlGS:0000000000000000
[   46.417073] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   46.417074] CR2: 0000000000446710 CR3: 0000000071e3e000 CR4: 
00000000000406e0
[   46.417081] Call Trace:
[   46.417088]  bitmap_create+0x264/0x990 [md_mod]
[   46.417091]  ? raid1_run+0x1d0/0x2e0 [raid1]
[   46.417096]  md_run+0x5d2/0xb00 [md_mod]
[   46.417100]  ? locks_dispose_list+0x36/0x50
[   46.417102]  ? flock_lock_inode+0x124/0x280
[   46.417107]  do_md_run+0x14/0xb0 [md_mod]
[   46.417111]  md_ioctl+0x13ed/0x1830 [md_mod]
[   46.417114]  ? kzfree+0x2d/0x30
[   46.417119]  blkdev_ioctl+0x475/0x8b0
[   46.417121]  ? mntput+0x24/0x40
[   46.417125]  block_ioctl+0x41/0x50
[   46.417127]  do_vfs_ioctl+0x96/0x5b0
[   46.417130]  ? ____fput+0xe/0x10
[   46.417133]  ? task_work_run+0x88/0xb0
[   46.417135]  SyS_ioctl+0x79/0x90
[   46.417138]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[   46.417140] RIP: 0033:0x7f666f5d84b7
[   46.417141] RSP: 002b:00007ffd3df6a228 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[   46.417143] RAX: ffffffffffffffda RBX: 00000000018e6700 RCX: 
00007f666f5d84b7
[   46.417144] RDX: 00007ffd3df6a540 RSI: 00000000400c0930 RDI: 
0000000000000004
[   46.417145] RBP: 0000000000000000 R08: 0000000000001000 R09: 
00007f666f893678
[   46.417146] R10: 0000000000000000 R11: 0000000000000246 R12: 
0000000000000000
[   46.417148] R13: 0000000000000004 R14: 00007ffd3df6a720 R15: 
00000000018e6640
[   46.417149] Code: ff ff 48 8b 55 a0 89 d9 be 00 10 00 00 48 c7 c7 c8 
4d 4a a0 31 c0 48 c1 e2 0c e8 62 24 c4 e0 e9 59 ff ff ff bb fb ff ff ff 
eb d7 <0f> 0b 90 66 66 66 66 90 55 48 89 e5 41 57 4c 8d 7f 18 41 56 45
[   46.417176] RIP: read_page+0x1dd/0x1e0 [md_mod] RSP: ffffc90000c2bbc0
[   46.417178] ---[ end trace 0c4d19ffd8ced9b8 ]---


Thanks,
-Zhilong

>
> Thanks,
> NeilBrown
>
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 40f3cd7eab0f..52fe93fa4598 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -368,12 +368,7 @@ static int read_page(struct file *file, unsigned long index,
>   	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
>   		 (unsigned long long)index << PAGE_SHIFT);
>   
> -	bh = alloc_page_buffers(page, 1<<inode->i_blkbits, 0);
> -	if (!bh) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> -	attach_page_buffers(page, bh);
> +	bh = page_buffers(page);
>   	block = index << (PAGE_SHIFT - inode->i_blkbits);
>   	while (bh) {
>   		if (count == 0)
> @@ -771,12 +766,18 @@ static inline struct page *filemap_get_page(struct bitmap_storage *store,
>   }
>   
>   static int bitmap_storage_alloc(struct bitmap_storage *store,
> -				unsigned long chunks, int with_super,
> +				unsigned long chunks,
> +				struct file *file,
> +				int with_super,
>   				int slot_number)
>   {
>   	int pnum, offset = 0;
>   	unsigned long num_pages;
>   	unsigned long bytes;
> +	struct inode *inode = NULL;
> +
> +	if (file)
> +		inode = file_inode(file);
>   
>   	bytes = DIV_ROUND_UP(chunks, 8);
>   	if (with_super)
> @@ -804,12 +805,21 @@ static int bitmap_storage_alloc(struct bitmap_storage *store,
>   	}
>   
>   	for ( ; pnum < num_pages; pnum++) {
> -		store->filemap[pnum] = alloc_page(GFP_KERNEL|__GFP_ZERO);
> -		if (!store->filemap[pnum]) {
> +		struct page *p = alloc_page(GFP_KERNEL|__GFP_ZERO);
> +		store->filemap[pnum] = p;
> +		if (!p) {
>   			store->file_pages = pnum;
>   			return -ENOMEM;
>   		}
> -		store->filemap[pnum]->index = pnum + offset;
> +		if (inode) {
> +			struct buffer_head *bh;
> +			bh = alloc_page_buffers(p, 1 << inode->i_blkbits, 0);
> +			if (bh)
> +				attach_page_buffers(p, bh);
> +			else
> +				return -ENOMEM;
> +		}
> +		p->index = pnum + offset;
>   	}
>   	store->file_pages = pnum;
>   
> @@ -2091,7 +2101,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>   	chunks = DIV_ROUND_UP_SECTOR_T(blocks, 1 << chunkshift);
>   	memset(&store, 0, sizeof(store));
>   	if (bitmap->mddev->bitmap_info.offset || bitmap->mddev->bitmap_info.file)
> -		ret = bitmap_storage_alloc(&store, chunks,
> +		ret = bitmap_storage_alloc(&store, chunks, bitmap->mddev->bitmap_info.file,
>   					   !bitmap->mddev->bitmap_info.external,
>   					   mddev_is_clustered(bitmap->mddev)
>   					   ? bitmap->cluster_slot : 0);

