From: Zhilong Liu <zlliu@suse.com>
Subject: Re: report a bug that panic when grow size for external bitmap
Date: Tue, 29 Aug 2017 10:37:28 +0800
Message-ID: <6eaf97d4-bd8c-e33c-a9c7-37d0fe2086ce@suse.com>
References: <ad8c69c7-f1e0-b6ab-dc87-a81aa7bca391@suse.com>
 <87y3q3gq8g.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y3q3gq8g.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, Neil;
     Thanks for your pointing and sorry for the incorrect dmesg for last 
mail.

Here update the pure steps and paste the dmesg.

ENV:
OS: 4.13-rc7 upstream
linux-apta:~/mdadm-test # df -T /mnt/
Filesystem     Type 1K-blocks     Used Available Use% Mounted on
/dev/sda2      ext4  44248848 24416952  18778472  57% /

Reproduce: 100%

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
linux-apta:~/mdadm-test # cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 loop2[2](S) loop1[1] loop0[0]
       18944 blocks super 1.2 [2/2] [UU]
       bitmap: 3/3 pages [12KB], 4KB chunk, file: /mnt/3

unused devices: <none>
linux-apta:~/mdadm-test # dmesg -c
[  181.378209] md/raid1:md0: not clean -- starting background reconstruction
[  181.378211] md/raid1:md0: active with 2 out of 2 mirrors
[  181.379354] md0: detected capacity change from 0 to 19398656
[  181.379773] md: resync of RAID array md0
[  190.396162] md: md0: resync done.

linux-apta:~/mdadm-test # ./mdadm --grow /dev/md0 --size 128
Segmentation fault
linux-apta:~/mdadm-test # cat /sys/block/md0/md/component_size
18944                         "here is incorrect also."
linux-apta:~/mdadm-test # dmesg -c
[  208.027505] ------------[ cut here ]------------
[  208.027508] kernel BUG at drivers/md/bitmap.c:298!
[  208.027511] invalid opcode: 0000 [#1] SMP
[  208.027516] Modules linked in: raid1(E) md_mod(E) loop(E) uinput(E) 
af_packet(E) iscsi_ibft(E) iscsi_boot_sysfs(E) snd_hda_codec_generic(E) 
snd_hda_intel(E) snd_hda_codec(E) snd_hda_core(E) snd_hwdep(E) 
snd_pcm(E) snd_timer(E) snd(E) virtio_balloon(E) virtio_net(E) 
soundcore(E) i2c_piix4(E) crct10dif_pclmul(E) crc32_pclmul(E) 
crc32c_intel(E) ghash_clmulni_intel(E) pcbc(E) ppdev(E) parport_pc(E) 
parport(E) joydev(E) pvpanic(E) aesni_intel(E) aes_x86_64(E) 
crypto_simd(E) glue_helper(E) cryptd(E) button(E) pcspkr(E) ext4(E) 
crc16(E) mbcache(E) jbd2(E) hid_generic(E) usbhid(E) ata_generic(E) 
sd_mod(E) virtio_scsi(E) virtio_console(E) floppy(E) ata_piix(E) qxl(E) 
drm_kms_helper(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) 
fb_sys_fops(E) ttm(E) serio_raw(E) ahci(E) libahci(E) drm(E) ehci_pci(E) 
libata(E)
[  208.027565]  uhci_hcd(E) ehci_hcd(E) usbcore(E) virtio_pci(E) 
virtio_ring(E) virtio(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) 
scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E) autofs4(E)
[  208.027579] CPU: 2 PID: 9592 Comm: mdadm Tainted: G E   
4.13.0-rc7-up-latest #1
[  208.027581] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS Bochs 01/01/2011
[  208.027584] task: ffff8800714286c0 task.stack: ffffc90000a68000
[  208.027595] RIP: 0010:write_page+0x304/0x310 [md_mod]
[  208.027597] RSP: 0018:ffffc90000a6bbd8 EFLAGS: 00010246
[  208.027600] RAX: 000fffffc0000000 RBX: ffff88006c65a300 RCX: 
0000000000000001
[  208.027602] RDX: 0000000000000000 RSI: ffffea0001cbe100 RDI: 
ffff88006c65a300
[  208.027603] RBP: ffffc90000a6bc30 R08: ffff880072f84000 R09: 
ffff88006b8033a0
[  208.027605] R10: 0000000000000003 R11: 0000000000000020 R12: 
ffff88006c65a300
[  208.027607] R13: 0000000000000000 R14: ffffea0001cbe100 R15: 
0000000000000001
[  208.027610] FS:  00007fe15ce1a700(0000) GS:ffff88007fd00000(0000) 
knlGS:0000000000000000
[  208.027612] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  208.027614] CR2: 00000000018fc888 CR3: 0000000072fd4000 CR4: 
00000000000406e0
[  208.027625] Call Trace:
[  208.027634]  ? __put_page+0x46/0x80
[  208.027642]  bitmap_unplug+0xac/0x100 [md_mod]
[  208.027648]  bitmap_resize+0x6ca/0x7f0 [md_mod]
[  208.027653]  raid1_resize+0x4e/0xb0 [raid1]
[  208.027659]  update_size+0x9e/0x120 [md_mod]
[  208.027665]  md_ioctl+0xdcc/0x1830 [md_mod]
[  208.027671]  ? layout_show+0x40/0x60 [md_mod]
[  208.027677]  blkdev_ioctl+0x475/0x8b0
[  208.027681]  ? mntput+0x24/0x40
[  208.027685]  block_ioctl+0x41/0x50
[  208.027689]  do_vfs_ioctl+0x96/0x5b0
[  208.027693]  ? ____fput+0xe/0x10
[  208.027697]  ? task_work_run+0x88/0xb0
[  208.027700]  SyS_ioctl+0x79/0x90
[  208.027704]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[  208.027706] RIP: 0033:0x7fe15c7534b7
[  208.027708] RSP: 002b:00007ffe88a37788 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  208.027711] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 
00007fe15c7534b7
[  208.027713] RDX: 00007ffe88a37850 RSI: 0000000040480923 RDI: 
0000000000000003
[  208.027715] RBP: 00007ffe88a37730 R08: 00000000004711e0 R09: 
0000000000000004
[  208.027717] R10: 00000000004631fe R11: 0000000000000246 R12: 
00000000ffffffff
[  208.027718] R13: 0000000000000000 R14: 00000000018f45b0 R15: 
0000000000000001
[  208.027721] Code: 85 c0 0f 8f 3a ff ff ff 48 8b 53 68 49 8b 85 f0 00 
00 00 48 03 43 58 48 01 d6 48 39 f0 0f 87 1f ff ff ff 48 01 fa e9 8c fe 
ff ff <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 4f 20
[  208.027762] RIP: write_page+0x304/0x310 [md_mod] RSP: ffffc90000a6bbd8
[  208.027765] ---[ end trace dfbe72f2783c5398 ]---


Thanks for your confirmation;
-Zhilong

On 08/29/2017 08:41 AM, NeilBrown wrote:
> On Mon, Aug 28 2017, Zhilong Liu wrote:
>
>> Hi, Neil;
>>      Here report a new bug with latest 4.13-rc7 and latest mdadm when I'm
>> testing for grow size; please refer to the following detail call-trace
>> stack.
>> I found that there is no testing covered "--grow --size",  thus I
>> simulate the testing steps as:
>
> Thanks for the report - but something doesn't make sense here.
>
>
>> Steps:
>> ./test setup
>> ./mdadm -CR /dev/md0 -b /mnt/3 -l1 -n2 -x1 /dev/loop[0-2]
>>
>> linux-apta:~/mdadm-test # ./mdadm --grow /dev/md0 --size=128
>> Segmentation fault
>> linux-apta:~/mdadm-test # dmesg -c
>> [ 3215.648121] md: md0: resync done.
> This presumably marks when the array was created and finished resync.
>
>> [ 3220.651913] md0: detected capacity change from 19398656 to 65536
> 5 seconds later this shows the array being resized to 64K.  Did you do
> that and not tell me?
>
>
>> [ 3236.930481] md0: bitmap file is out of date (0 < 20) -- forcing full
>> recovery
>> [ 3236.930488] md0: bitmap file is out of date, doing full recovery
> 16 seconds later something happens to the bitmap.  It looks like the
> bitmap was removed and re-added. Is that possible?
>
>
>> [ 3241.272597] ------------[ cut here ]------------
> Another 5 seconds later it crashes.
>
> I think you must have performed some other steps that you didn't
> mention.
> Please give a complete description of the steps you used which produced
> the problem.
>
> Thanks,
> NeilBrown
>
>
>> [ 3241.272600] kernel BUG at drivers/md/bitmap.c:298!
>> [ 3241.272603] invalid opcode: 0000 [#1] SMP
>> [ 3241.272607] Modules linked in: raid1(E) md_mod(E) loop(E) uinput(E)
>> af_packet(E) iscsi_ibft(E) iscsi_boot_sysfs(E) hid_generic(E) usbhid(E)
>> crct10dif_pclmul(E) snd_hda_codec_generic(E) crc32_pclmul(E)
>> crc32c_intel(E) ghash_clmulni_intel(E) pcbc(E) snd_hda_intel(E)
>> snd_hda_codec(E) snd_hda_core(E) snd_hwdep(E) snd_pcm(E) snd_timer(E)
>> aesni_intel(E) snd(E) aes_x86_64(E) ppdev(E) parport_pc(E)
>> crypto_simd(E) virtio_balloon(E) virtio_net(E) joydev(E) i2c_piix4(E)
>> soundcore(E) parport(E) pcspkr(E) glue_helper(E) pvpanic(E) cryptd(E)
>> ext4(E) crc16(E) mbcache(E) jbd2(E) ata_generic(E) sd_mod(E)
>> virtio_scsi(E) virtio_console(E) ata_piix(E) ahci(E) libahci(E)
>> serio_raw(E) ehci_pci(E) uhci_hcd(E) ehci_hcd(E) usbcore(E) libata(E)
>> virtio_pci(E) virtio_ring(E) qxl(E) virtio(E) drm_kms_helper(E)
>> syscopyarea(E)
>> [ 3241.272648]  sysfillrect(E) sysimgblt(E) fb_sys_fops(E) ttm(E) drm(E)
>> floppy(E) button(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E)
>> scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E) autofs4(E)
>> [ 3241.272661] CPU: 2 PID: 9673 Comm: mdadm Tainted: G E
>> 4.13.0-rc7-up-latest #1
>> [ 3241.272663] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>> BIOS Bochs 01/01/2011
>> [ 3241.272665] task: ffff8800745e4480 task.stack: ffffc90000b58000
>> [ 3241.272674] RIP: 0010:write_page+0x304/0x310 [md_mod]
>> [ 3241.272676] RSP: 0018:ffffc90000b5bbd8 EFLAGS: 00010246
>> [ 3241.272678] RAX: 000fffffc0000000 RBX: ffff880075e5c200 RCX:
>> 0000000000000001
>> [ 3241.272680] RDX: 0000000000000000 RSI: ffffea0000daa880 RDI:
>> ffff880075e5c200
>> [ 3241.272681] RBP: ffffc90000b5bc30 R08: 000000000000000f R09:
>> ffff88006be74000
>> [ 3241.272683] R10: 0000000000000003 R11: 0000000000000020 R12:
>> ffff880075e5c200
>> [ 3241.272685] R13: 0000000000000000 R14: ffffea0000daa880 R15:
>> 0000000000000001
>> [ 3241.272687] FS:  00007f7c88094700(0000) GS:ffff88007fd00000(0000)
>> knlGS:0000000000000000
>> [ 3241.272689] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 3241.272691] CR2: 0000000002487888 CR3: 000000006bd3f000 CR4:
>> 00000000000406e0
>> [ 3241.272700] Call Trace:
>> [ 3241.272708]  ? bitmap_checkpage+0x81/0x110 [md_mod]
>> [ 3241.272713]  bitmap_unplug+0xac/0x100 [md_mod]
>> [ 3241.272719]  bitmap_resize+0x6ca/0x7f0 [md_mod]
>> [ 3241.272723]  raid1_resize+0x4e/0xb0 [raid1]
>> [ 3241.272728]  update_size+0x9e/0x120 [md_mod]
>> [ 3241.272733]  md_ioctl+0xdcc/0x1830 [md_mod]
>> [ 3241.272738]  ? layout_show+0x40/0x60 [md_mod]
>> [ 3241.272744]  blkdev_ioctl+0x475/0x8b0
>> [ 3241.272748]  ? mntput+0x24/0x40
>> [ 3241.272751]  block_ioctl+0x41/0x50
>> [ 3241.272754]  do_vfs_ioctl+0x96/0x5b0
>> [ 3241.272758]  ? ____fput+0xe/0x10
>> [ 3241.272762]  ? task_work_run+0x88/0xb0
>> [ 3241.272764]  SyS_ioctl+0x79/0x90
>> [ 3241.272767]  entry_SYSCALL_64_fastpath+0x1a/0xa5
>> [ 3241.272769] RIP: 0033:0x7f7c879cd4b7
>> [ 3241.272771] RSP: 002b:00007ffe079996b8 EFLAGS: 00000246 ORIG_RAX:
>> 0000000000000010
>> [ 3241.272773] RAX: ffffffffffffffda RBX: 0000000000000004 RCX:
>> 00007f7c879cd4b7
>> [ 3241.272775] RDX: 00007ffe07999780 RSI: 0000000040480923 RDI:
>> 0000000000000003
>> [ 3241.272777] RBP: 00007ffe07999660 R08: 0000000000471240 R09:
>> 0000000000000004
>> [ 3241.272778] R10: 000000000046325e R11: 0000000000000246 R12:
>> 0000000000000003
>> [ 3241.272780] R13: 0000000000000000 R14: 000000000247f5b0 R15:
>> 0000000000000001
>> [ 3241.272782] Code: 85 c0 0f 8f 3a ff ff ff 48 8b 53 68 49 8b 85 f0 00
>> 00 00 48 03 43 58 48 01 d6 48 39 f0 0f 87 1f ff ff ff 48 01 fa e9 8c fe
>> ff ff <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 4f 20
>> [ 3241.272816] RIP: write_page+0x304/0x310 [md_mod] RSP: ffffc90000b5bbd8
>> [ 3241.272819] ---[ end trace 0bc7d755f3e87fb7 ]---
>>
>>
>> Thanks,
>> -Zhilong

