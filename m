From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: kernel BUG when umounting xfs on read-only md
Date: Sun, 20 Sep 2009 20:06:08 +0200
Message-ID: <slrnhbcrol.eul.Mario.Holbe@darkside.dyn.samba-tng.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

umounting a ro-mounted xfs on a readonly md leads to a kernel BUG and a
subsequent stall of this md (which, in turn, stalls reboots etc.).

I'm writing this here because it does only happen with md in the chain,
without md everything works well. And it's md that BUGs :) Though, I'm
not sure if xfs behaves wrong here: ext2/3, for example, work well in
this scenario.

I reproduced this on a grml Live-CD (www.grml.org) but it happens
equally on 2.6.30. First without md, then with md in the chain.

root@grml ~ # uname -a
Linux grml 2.6.28-grml #1 SMP PREEMPT Mon May 4 07:40:22 UTC 2009 i686 GNU/Linux
root@grml ~ # dd if=/dev/zero of=/tmp/foo bs=1k count=100k
102400+0 records in
102400+0 records out
104857600 bytes (105 MB) copied, 0.39794 s, 264 MB/s
root@grml ~ # losetup /dev/loop1 /tmp/foo
root@grml ~ # mkfs.xfs /dev/loop1
meta-data=/dev/loop1             isize=256    agcount=4, agsize=6400 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=25600, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
root@grml ~ # blockdev --setro /dev/loop1
root@grml ~ # mount -o ro /dev/loop1 /mnt
[  270.367361] Filesystem "loop1": Disabling barriers, underlying device is readonly
[  270.367381] XFS mounting filesystem loop1
root@grml ~ # umount /mnt
[  270.367601] Ending clean XFS mount for filesystem: loop1
root@grml ~ # blockdev --setrw /dev/loop1
root@grml ~ # mdadm --create -e 1.1 -l raid1 -n 2 -a md /dev/md0 /dev/loop1 missing
[  369.769110] md: bind<loop1>
[  369.769130] md: md0: raid array is not clean -- starting background reconstruction
[  369.774871] raid1: raid set md0 active with 1 out of 2 mirrors
[  369.782725]  md0: unknown partition table
mdadm: array /dev/md0 started.
root@grml ~ # mkfs.xfs /dev/md0
meta-data=/dev/md0               isize=256    agcount=4, agsize=6400 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=25598, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
root@grml ~ # mdadm --readonly /dev/md0
[  396.353127] md: md0 switched to read-only mode.
root@grml ~ # blockdev --report /dev/md0
RO    RA   SSZ   BSZ   StartSec     Size    Device
ro   256   512   512          0     204784  /dev/md0
root@grml ~ # mount -o ro /dev/md0 /mnt
[  404.625550] Filesystem "md0": Disabling barriers, underlying device is readonly
[  404.625575] XFS mounting filesystem md0
root@grml ~ # umount /mnt
[  404.625818] Ending clean XFS mount for filesystem: md0
[  428.033209] ------------[ cut here ]------------
[  428.033213] kernel BUG at drivers/md/md.c:5631!
[  428.033215] invalid opcode: 0000 [#1] PREEMPT SMP 
[  428.033219] last sysfs file: /sys/devices/virtual/block/loop1/removable
[  428.033221] Modules linked in: af_packet wmi video output sbs sbshc pci_slot container battery ac fuse ipv6 button evdev snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device i2c_i801 rtc_cmos pcspkr i2c_core rtc_core snd rtc_lib soundcore snd_page_alloc loop aufs exportfs usbhid usb_storage libusual nls_iso8859_1 nls_cp437 ntfs firewire_ohci firewire_core crc_itu_t uhci_hcd ohci1394 ieee1394 atl1 mii ehci_hcd usbcore intel_agp thermal processor fan squashfs sqlzma unlzma
[  428.033266] 
[  428.033269] Pid: 8068, comm: umount Not tainted (2.6.28-grml #1) P5E-VM HDMI
[  428.033271] EIP: 0060:[<c03a6faa>] EFLAGS: 00010246 CPU: 1
[  428.033277] EIP is at md_write_start+0x1d/0x13e
[  428.033279] EAX: 00000001 EBX: f6085800 ECX: 00031ff0 EDX: f69b0180
[  428.033281] ESI: 00000001 EDI: f69b0180 EBP: f617dcb0 ESP: f617dc8c
[  428.033283]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  428.033285] Process umount (pid: 8068, ti=f617c000 task=f6983140 task.ti=f617c000)
[  428.033287] Stack:
[  428.033288]  c05e2684 c05e2684 001200d2 f617dcec f589e738 f6e2f2d0 00000000 00000001
[  428.033294]  f69b0180 f617dd14 c039e84d f617dcc0 00000041 f69b0180 f699e800 f6085800
[  428.033301]  f6e2f2d0 00000041 f617dce8 c0157da9 0189e738 f478edd0 c2d420c0 00000003
[  428.033307] Call Trace:
[  428.033309]  [<c039e84d>] ? make_request+0x25/0x616
[  428.033314]  [<c0157da9>] ? find_lock_page+0x13/0x47
[  428.033322]  [<c011f706>] ? __wake_up+0x31/0x3b
[  428.033325]  [<c02b7cdc>] ? generic_make_request+0x470/0x4a6
[  428.033330]  [<f9054d9d>] ? di_read_unlock+0x3e/0x41 [aufs]
[  428.033345]  [<c0159915>] ? mempool_alloc_slab+0xe/0x10
[  428.033348]  [<c0159b64>] ? mempool_alloc+0x2c/0xcb
[  428.033351]  [<c0159915>] ? mempool_alloc_slab+0xe/0x10
[  428.033354]  [<c0159b64>] ? mempool_alloc+0x2c/0xcb
[  428.033357]  [<c02b7de5>] ? submit_bio+0xd3/0xdb
[  428.033360]  [<c01984f3>] ? bio_add_page+0x2a/0x31
[  428.033363]  [<c029cb4f>] ? _xfs_buf_ioapply+0x1e2/0x206
[  428.033368]  [<c0288377>] ? xlog_state_sync_all+0x19a/0x1ab
[  428.033372]  [<c029d658>] ? xfs_buf_iorequest+0x38/0x5f
[  428.033375]  [<c02a0cb4>] ? xfs_bdstrat_cb+0x1b/0x3d
[  428.033378]  [<c029a4ca>] ? xfs_bwrite+0x4e/0xa0
[  428.033381]  [<c0295b50>] ? xfs_syncsub+0x102/0x1fb
[  428.033384]  [<c02911ee>] ? xfs_mru_cache_flush+0x5a/0x5e
[  428.033387]  [<c0295c82>] ? xfs_sync+0x39/0x3d
[  428.033390]  [<c02a2144>] ? xfs_fs_sync_super+0x2c/0xc2
[  428.033393]  [<c01aa672>] ? quota_sync_sb+0x26/0xd7
[  428.033397]  [<c01aa745>] ? sync_dquots+0x22/0xf8
[  428.033399]  [<c017d5bf>] ? __fsync_super+0x17/0x66
[  428.033403]  [<c017d619>] ? fsync_super+0xb/0x19
[  428.033406]  [<c017d86e>] ? generic_shutdown_super+0x1c/0xd3
[  428.033409]  [<c017d93b>] ? kill_block_super+0x16/0x2a
[  428.033412]  [<c017d9f1>] ? deactivate_super+0x51/0x64
[  428.033414]  [<c018d423>] ? mntput_no_expire+0xc3/0xee
[  428.033418]  [<c018d8e3>] ? sys_umount+0x278/0x29c
[  428.033421]  [<c018d914>] ? sys_oldumount+0xd/0xf
[  428.033423]  [<c0103b12>] ? syscall_call+0x7/0xb
[  428.033427]  [<c0440000>] ? dump_stack+0x3/0x61
[  428.033430] Code: 8a 30 01 00 00 20 83 c4 20 5b 5e 5f 5d c3 55 89 e5 57 56 53 89 c3 83 ec 18 f6 42 14 01 0f 84 21 01 00 00 8b 40 1c 83 f8 01 75 04 <0f> 0b eb fe 31 ff 83 f8 02 75 30 c7 43 1c 00 00 00 00 8d 83 30 
[  428.033467] EIP: [<c03a6faa>] md_write_start+0x1d/0x13e SS:ESP 0068:f617dc8c
[  428.033472] ---[ end trace 046ff64aa79e75c9 ]---
[1]    8068 segmentation fault  umount /mnt

With dm_crypt on top of md, umount doesnt segfault but stalls.


regards
   Mario
-- 
Gemuese schmeckt am besten, wenn man es kurz vor dem Verzehr durch ein
Schnitzel ersetzt!

