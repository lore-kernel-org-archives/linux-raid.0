From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: grow fails with 2.6.34 git
Date: Wed, 14 Apr 2010 15:48:02 -0700
Message-ID: <v2p4877c76c1004141548m6d3da932hd14543da1b730af9@mail.gmail.com>
References: <hq5efu$mqb$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hq5efu$mqb$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: James Braid <jamesb@loreland.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 14, 2010 at 3:10 PM, James Braid <jamesb@loreland.org> wrot=
e:
> Trying to grow a 4 disk RAID 5 array to a 6 disk RAID 6 array - runni=
ng
> 2.6.34-rc2 (also tried with latest git, same sysfs errors)
>
> Using mdadm from git.
>
> Here's the error I get when I try to perform the grow:
>
> # ./mdadm --grow --backup-file=3D/root/backup.md4 --level=3D6 --raid-=
devices=3D6
> /dev/md4
> mdadm: Need to backup 768K of critical section..
> mdadm: /dev/md4: Cannot get array details from sysfs
>
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md4 : active raid6 sde[0] sdg[5](S) sdh[6](S) sdc[3] sdd[2] sdf[1]
> =A0 =A0 =A04395415488 blocks level 6, 64k chunk, algorithm 18 [5/4] [=
UUUU_]
>
> unused devices: <none>
>
> dmesg reports lots of sysfs errors:
>
> [ =A0922.249484] ------------[ cut here ]------------
> [ =A0922.249549] WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0xcc/0x=
e3()
> [ =A0922.249609] Hardware name: GA-MA785GT-UD3H
> [ =A0922.249673] sysfs: cannot create duplicate filename
> '/devices/virtual/block/md4/md/stripe_cache_size'
> [ =A0922.249783] Modules linked in: ppdev lp parport sco bridge stp b=
nep
> rfcomm l2cap crc16 dahdi_echocan_oslec echo powernow_k8 cpufreq_users=
pace
> cpufreq_stats cpufreq_powersave cpufreq_conservative uinput fuse ext3=
 jbd
> mbcache it87 hwmon_vid raid456 async_raid6_recov async_pq raid6_pq as=
ync_xor
> xor async_memcpy async_tx md_mod btusb bluetooth pl2303 rfkill usbser=
ial
> snd_hda_codec_nvhdmi snd_hda_codec_realtek snd_hda_intel snd_hda_code=
c
> snd_pcm_oss snd_hwdep snd_mixer_oss ata_generic snd_pcm snd_seq_midi
> ide_pci_generic snd_rawmidi snd_seq_midi_event snd_seq snd_timer
> snd_seq_device r8169 firewire_ohci wcopenpci snd edac_core ahci i2c_p=
iix4
> ohci_hcd k10temp soundcore mii atiixp firewire_core edac_mce_amd tpm_=
tis
> libata nvidia(P) ide_core agpgart wctdm tpm dahdi snd_page_alloc tpm_=
bios
> i2c_core floppy processor button crc_itu_t crc_ccitt evdev xfs export=
fs
> sd_mod crc_t10dif dm_mod thermal fan thermal_sys ehci_hcd usb_storage
> usbcore nls_base scsi_mod
> [ =A0922.254181] Pid: 10642, comm: mdadm Tainted: P =A0 =A0 =A0 =A0W =
2.6.34-rc2-amd64
> #2
> [ =A0922.254241] Call Trace:
> [ =A0922.254302] =A0[<ffffffff8104548d>] ? warn_slowpath_common+0x76/=
0x8c
> [ =A0922.254366] =A0[<ffffffff810454f5>] ? warn_slowpath_fmt+0x40/0x4=
5
> [ =A0922.254427] =A0[<ffffffff811363d9>] ? sysfs_add_one+0xcc/0xe3
> [ =A0922.254490] =A0[<ffffffff811355e6>] ? sysfs_add_file_mode+0x4b/0=
x7d
> [ =A0922.254553] =A0[<ffffffff8113750c>] ? internal_create_group+0xdd=
/0x16b
> [ =A0922.259781] =A0[<ffffffffa0d50f12>] ? run+0x4fa/0x685 [raid456]
> [ =A0922.259853] =A0[<ffffffffa0d08b20>] ? level_store+0x3b7/0x42e [m=
d_mod]
> [ =A0922.259922] =A0[<ffffffffa0d05b1f>] ? md_attr_store+0x77/0x96 [m=
d_mod]
> [ =A0922.259988] =A0[<ffffffff811350ae>] ? sysfs_write_file+0xe3/0x11=
f
> [ =A0922.260061] =A0[<ffffffff810e5e34>] ? vfs_write+0xa4/0x101
> [ =A0922.260122] =A0[<ffffffff810e5f44>] ? sys_write+0x45/0x6b
> [ =A0922.260183] =A0[<ffffffff810089c2>] ? system_call_fastpath+0x16/=
0x1b
> [ =A0922.260243] ---[ end trace f9f1fcb8cad24d01 ]---
> [ =A0922.260381] raid5: failed to create sysfs attributes for md4
>
> After the grow failed, I stopped the array and restarted it. At that =
point
> it appears to be continuing with the grow process? Is this correct?
>
> # mdadm --stop /dev/md4
> mdadm: stopped /dev/md4
>
> # mdadm --assemble /dev/md4
> mdadm: /dev/md4 has been started with 4 drives (out of 5) and 2 spare=
s.
>
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md4 : active raid6 sde[0] sdh[5] sdg[6](S) sdc[3] sdd[2] sdf[1]
> =A0 =A0 =A04395415488 blocks level 6, 64k chunk, algorithm 18 [5/4] [=
UUUU_]
> =A0 =A0 =A0[>....................] =A0recovery =3D =A00.0% (147712/14=
65138496)
> finish=3D661.1min speed=3D36928K/sec
>
> unused devices: <none>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Yes, that /extremely/ slow growth progress is normal for this
conversion.  Every critical section must be backed up synced, and only
then will it proceed.  You may notice an incorrect number of disks
relative to the expected number.  That will go away the next time the
array is assembled.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
