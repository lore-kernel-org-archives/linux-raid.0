From: James Braid <jamesb@loreland.org>
Subject: grow fails with 2.6.34 git
Date: Wed, 14 Apr 2010 23:10:06 +0100
Message-ID: <hq5efu$mqb$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Trying to grow a 4 disk RAID 5 array to a 6 disk RAID 6 array - running 
2.6.34-rc2 (also tried with latest git, same sysfs errors)

Using mdadm from git.

Here's the error I get when I try to perform the grow:

# ./mdadm --grow --backup-file=/root/backup.md4 --level=6 
--raid-devices=6 /dev/md4
mdadm: Need to backup 768K of critical section..
mdadm: /dev/md4: Cannot get array details from sysfs

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md4 : active raid6 sde[0] sdg[5](S) sdh[6](S) sdc[3] sdd[2] sdf[1]
       4395415488 blocks level 6, 64k chunk, algorithm 18 [5/4] [UUUU_]

unused devices: <none>

dmesg reports lots of sysfs errors:

[  922.249484] ------------[ cut here ]------------
[  922.249549] WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0xcc/0xe3()
[  922.249609] Hardware name: GA-MA785GT-UD3H
[  922.249673] sysfs: cannot create duplicate filename 
'/devices/virtual/block/md4/md/stripe_cache_size'
[  922.249783] Modules linked in: ppdev lp parport sco bridge stp bnep 
rfcomm l2cap crc16 dahdi_echocan_oslec echo powernow_k8 
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative 
uinput fuse ext3 jbd mbcache it87 hwmon_vid raid456 async_raid6_recov 
async_pq raid6_pq async_xor xor async_memcpy async_tx md_mod btusb 
bluetooth pl2303 rfkill usbserial snd_hda_codec_nvhdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_hwdep 
snd_mixer_oss ata_generic snd_pcm snd_seq_midi ide_pci_generic 
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device r8169 
firewire_ohci wcopenpci snd edac_core ahci i2c_piix4 ohci_hcd k10temp 
soundcore mii atiixp firewire_core edac_mce_amd tpm_tis libata nvidia(P) 
ide_core agpgart wctdm tpm dahdi snd_page_alloc tpm_bios i2c_core floppy 
processor button crc_itu_t crc_ccitt evdev xfs exportfs sd_mod 
crc_t10dif dm_mod thermal fan thermal_sys ehci_hcd usb_storage usbcore 
nls_base scsi_mod
[  922.254181] Pid: 10642, comm: mdadm Tainted: P        W 
2.6.34-rc2-amd64 #2
[  922.254241] Call Trace:
[  922.254302]  [<ffffffff8104548d>] ? warn_slowpath_common+0x76/0x8c
[  922.254366]  [<ffffffff810454f5>] ? warn_slowpath_fmt+0x40/0x45
[  922.254427]  [<ffffffff811363d9>] ? sysfs_add_one+0xcc/0xe3
[  922.254490]  [<ffffffff811355e6>] ? sysfs_add_file_mode+0x4b/0x7d
[  922.254553]  [<ffffffff8113750c>] ? internal_create_group+0xdd/0x16b
[  922.259781]  [<ffffffffa0d50f12>] ? run+0x4fa/0x685 [raid456]
[  922.259853]  [<ffffffffa0d08b20>] ? level_store+0x3b7/0x42e [md_mod]
[  922.259922]  [<ffffffffa0d05b1f>] ? md_attr_store+0x77/0x96 [md_mod]
[  922.259988]  [<ffffffff811350ae>] ? sysfs_write_file+0xe3/0x11f
[  922.260061]  [<ffffffff810e5e34>] ? vfs_write+0xa4/0x101
[  922.260122]  [<ffffffff810e5f44>] ? sys_write+0x45/0x6b
[  922.260183]  [<ffffffff810089c2>] ? system_call_fastpath+0x16/0x1b
[  922.260243] ---[ end trace f9f1fcb8cad24d01 ]---
[  922.260381] raid5: failed to create sysfs attributes for md4

After the grow failed, I stopped the array and restarted it. At that 
point it appears to be continuing with the grow process? Is this correct?

# mdadm --stop /dev/md4
mdadm: stopped /dev/md4

# mdadm --assemble /dev/md4
mdadm: /dev/md4 has been started with 4 drives (out of 5) and 2 spares.

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md4 : active raid6 sde[0] sdh[5] sdg[6](S) sdc[3] sdd[2] sdf[1]
       4395415488 blocks level 6, 64k chunk, algorithm 18 [5/4] [UUUU_]
       [>....................]  recovery =  0.0% (147712/1465138496) 
finish=661.1min speed=36928K/sec

unused devices: <none>

