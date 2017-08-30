From: Zhilong Liu <zlliu@suse.com>
Subject: Re: report a bug that panic when grow size for external bitmap
Date: Wed, 30 Aug 2017 12:57:52 +0800
Message-ID: <9ea2f09a-cc5e-4491-b10c-a869345bff14@suse.com>
References: <ad8c69c7-f1e0-b6ab-dc87-a81aa7bca391@suse.com>
 <87y3q3gq8g.fsf@notabene.neil.brown.name>
 <6eaf97d4-bd8c-e33c-a9c7-37d0fe2086ce@suse.com>
 <87mv6jgj8z.fsf@notabene.neil.brown.name>
 <ba801ebe-9c0c-d911-2b18-936495fe0ed3@suse.com>
 <87k21mhcqw.fsf@notabene.neil.brown.name>
 <73429dce-a22d-149e-656a-13af228c093f@suse.com>
 <87ziahg0jo.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ziahg0jo.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 08/30/2017 12:08 PM, NeilBrown wrote:
> On Wed, Aug 30 2017, Zhilong Liu wrote:
>
>> Hi, Neil;
>>       I have tested the following patch, I still got the call-trace after
>> I built with it.
>> If you need other infos, I would append.
> Ok, one more try.  If this doesn't work I do the testing myself to
> avoid the back-and-forth.

Hi,
     call-trace prints again during resize step, I have pasted the steps 
and dmesg.

My upstream head commit is : 36fde05f3fb51edea879636db590d70e11f16c82
Built the source code based on SLES 12 SP2 Kconfig.

Steps:
linux-apta:~/mdadm-test # ./mdadm -CR /dev/md0 -l1 -b /mnt/3 -n2 -x1 
/dev/loop[0-2] --force
mdadm: Note: this array has metadata at the start and
     may not be suitable as a boot device.  If you plan to
     store '/boot' on this device please ensure that
     your boot-loader understands md/v1.x metadata, or use
     --metadata=0.90
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
linux-apta:~/mdadm-test #
linux-apta:~/mdadm-test # dmesg -c
[  318.995314] md/raid1:md0: not clean -- starting background reconstruction
[  318.995316] md/raid1:md0: active with 2 out of 2 mirrors
[  318.996924] md0: detected capacity change from 0 to 19398656
[  318.997538] md: resync of RAID array md0
linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 loop2[2](S) loop1[1] loop0[0]
       18944 blocks super 1.2 [2/2] [UU]
       [==============>......]  resync = 73.6% (14720/18944) 
finish=0.0min speed=2453K/sec
       bitmap: 3/3 pages [12KB], 4KB chunk, file: /mnt/3

unused devices: <none>
linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 loop2[2](S) loop1[1] loop0[0]
       18944 blocks super 1.2 [2/2] [UU]
       [==================>..]  resync = 94.7% (18432/18944) 
finish=0.0min speed=2304K/sec
       bitmap: 3/3 pages [12KB], 4KB chunk, file: /mnt/3

unused devices: <none>
linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 loop2[2](S) loop1[1] loop0[0]
       18944 blocks super 1.2 [2/2] [UU]
       bitmap: 3/3 pages [12KB], 4KB chunk, file: /mnt/3

unused devices: <none>
linux-apta:~/mdadm-test # dmesg -c
[  328.092135] md: md0: resync done.
linux-apta:~/mdadm-test # ./mdadm --grow /dev/md0 --size 128
Segmentation fault
linux-apta:~/mdadm-test # dmesg -c
[  343.105208] ------------[ cut here ]------------
[  343.105210] kernel BUG at fs/buffer.c:3097!
[  343.105213] invalid opcode: 0000 [#1] SMP
[  343.105217] Modules linked in: raid1(E) md_mod(E) loop(E) uinput(E) 
af_packet(E) iscsi_ibft(E) iscsi_boot_sysfs(E) hid_generic(E) usbhid(E) 
snd_hda_codec_generic(E) snd_hda_intel(E) snd_hda_codec(E) 
snd_hda_core(E) snd_hwdep(E) snd_pcm(E) snd_timer(E) snd(E) 
crct10dif_pclmul(E) crc32_pclmul(E) crc32c_intel(E) 
ghash_clmulni_intel(E) pcbc(E) aesni_intel(E) ppdev(E) parport_pc(E) 
soundcore(E) virtio_net(E) virtio_balloon(E) aes_x86_64(E) parport(E) 
joydev(E) crypto_simd(E) glue_helper(E) i2c_piix4(E) cryptd(E) 
pvpanic(E) pcspkr(E) button(E) ext4(E) crc16(E) mbcache(E) jbd2(E) 
ata_generic(E) sd_mod(E) virtio_scsi(E) virtio_console(E) ata_piix(E) 
ahci(E) libahci(E) uhci_hcd(E) virtio_pci(E) virtio_ring(E) virtio(E) 
qxl(E) drm_kms_helper(E) syscopyarea(E) ehci_pci(E) sysfillrect(E) 
sysimgblt(E) fb_sys_fops(E)
[  343.105275]  ehci_hcd(E) ttm(E) serio_raw(E) usbcore(E) drm(E) 
libata(E) floppy(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) 
scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E) autofs4(E)
[  343.105290] CPU: 2 PID: 9465 Comm: mdadm Tainted: G E   
4.13.0-rc7-git-latest+ #1
[  343.105292] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS Bochs 01/01/2011
[  343.105294] task: ffff88007155cc80 task.stack: ffffc900009cc000
[  343.105301] RIP: 0010:submit_bh_wbc+0x16a/0x170
[  343.105303] RSP: 0018:ffffc900009cfb80 EFLAGS: 00010246
[  343.105306] RAX: 0000000000000024 RBX: ffff880004df56e8 RCX: 
0000000000000000
[  343.105308] RDX: ffff880004df56e8 RSI: 0000000000000800 RDI: 
0000000000000001
[  343.105310] RBP: ffffc900009cfbb0 R08: 0000000000000000 R09: 
ffff880072bc2e60
[  343.105312] R10: 0000000000000020 R11: ffff880004df5478 R12: 
ffff880036bdb900
[  343.105314] R13: 0000000000000000 R14: ffff880036bdb9a0 R15: 
0000000000000001
[  343.105317] FS:  00007f995f3ae700(0000) GS:ffff88007fd00000(0000) 
knlGS:0000000000000000
[  343.105319] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  343.105321] CR2: 0000000002665888 CR3: 0000000071949000 CR4: 
00000000000406e0
[  343.105332] Call Trace:
[  343.105338]  submit_bh+0x13/0x20
[  343.105349]  write_page+0x74/0x310 [md_mod]
[  343.105354]  ? __put_page+0x46/0x80
[  343.105361]  bitmap_unplug+0xac/0x100 [md_mod]
[  343.105367]  bitmap_resize+0x7ab/0x8c0 [md_mod]
[  343.105372]  raid1_resize+0x4e/0xb0 [raid1]
[  343.105378]  update_size+0x9e/0x120 [md_mod]
[  343.105384]  md_ioctl+0xdcc/0x1830 [md_mod]
[  343.105390]  ? layout_show+0x40/0x60 [md_mod]
[  343.105396]  blkdev_ioctl+0x475/0x8b0
[  343.105400]  ? mntput+0x24/0x40
[  343.105403]  block_ioctl+0x41/0x50
[  343.105406]  do_vfs_ioctl+0x96/0x5b0
[  343.105410]  ? ____fput+0xe/0x10
[  343.105415]  ? task_work_run+0x88/0xb0
[  343.105418]  SyS_ioctl+0x79/0x90
[  343.105422]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[  343.105424] RIP: 0033:0x7f995ece74b7
[  343.105426] RSP: 002b:00007ffc9d8a9218 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  343.105429] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 
00007f995ece74b7
[  343.105431] RDX: 00007ffc9d8a92e0 RSI: 0000000040480923 RDI: 
0000000000000003
[  343.105433] RBP: 00007ffc9d8a91c0 R08: 00000000004711e0 R09: 
0000000000000004
[  343.105435] R10: 00000000004631fe R11: 0000000000000246 R12: 
00000000ffffffff
[  343.105437] R13: 0000000000000000 R14: 000000000265d5b0 R15: 
0000000000000001
[  343.105439] Code: 00 48 83 c4 08 31 c0 5b 41 5c 41 5d 41 5e 41 5f 5d 
c3 83 ff 01 0f 85 0f ff ff ff f0 80 63 01 f7 e9 05 ff ff ff 0f 0b 0f 0b 
0f 0b <0f> 0b 0f 0b 0f 0b 66 66 66 66 90 55 48 89 e5 41 57 49 89 ff 48
[  343.105477] RIP: submit_bh_wbc+0x16a/0x170 RSP: ffffc900009cfb80
[  343.105481] ---[ end trace a94f1a7f3a7a6566 ]---


Thanks,
-Zhilong

> Thanks,
> NeilBrown
>
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 40f3cd7eab0f..05ba9c7d33b4 100644
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
> @@ -616,9 +611,16 @@ static int bitmap_read_sb(struct bitmap *bitmap)
>   	}
>   
>   	if (bitmap->storage.file) {
> -		loff_t isize = i_size_read(bitmap->storage.file->f_mapping->host);
> +		struct inode *inode = bitmap->storage.file->f_mapping->host;
> +		loff_t isize = i_size_read(inode);
>   		int bytes = isize > PAGE_SIZE ? PAGE_SIZE : isize;
> +		struct buffer_head *bh;
>   
> +		bh = alloc_page_buffers(sb_page, 1 << inode->i_blkbits, 0);
> +		if (bh)
> +			attach_page_buffers(sb_page, bh);
> +		else
> +			return -ENOMEM;
>   		err = read_page(bitmap->storage.file, 0,
>   				bitmap, bytes, sb_page);
>   	} else {
> @@ -771,12 +773,18 @@ static inline struct page *filemap_get_page(struct bitmap_storage *store,
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
> @@ -801,15 +809,33 @@ static int bitmap_storage_alloc(struct bitmap_storage *store,
>   		store->filemap[0] = store->sb_page;
>   		pnum = 1;
>   		store->sb_page->index = offset;
> +		if (inode) {
> +			struct buffer_head *bh;
> +			struct page *p = store->sb_page;
> +			bh = alloc_page_buffers(p, 1 << inode->i_blkbits, 0);
> +			if (bh)
> +				attach_page_buffers(p, bh);
> +			else
> +				return -ENOMEM;
> +		}
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
> @@ -2091,7 +2117,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>   	chunks = DIV_ROUND_UP_SECTOR_T(blocks, 1 << chunkshift);
>   	memset(&store, 0, sizeof(store));
>   	if (bitmap->mddev->bitmap_info.offset || bitmap->mddev->bitmap_info.file)
> -		ret = bitmap_storage_alloc(&store, chunks,
> +		ret = bitmap_storage_alloc(&store, chunks, bitmap->mddev->bitmap_info.file,
>   					   !bitmap->mddev->bitmap_info.external,
>   					   mddev_is_clustered(bitmap->mddev)
>   					   ? bitmap->cluster_slot : 0);

