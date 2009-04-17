From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Strange md(_resync?) related paging errors on 2.6.29
Date: Fri, 17 Apr 2009 09:43:02 +0200
Message-ID: <20090417074301.GA21290@darkside.22.kls.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--PmA2V3Z32TCmWXqI
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

starting with 2.6.29 (I'm using the Debian 2.6.29-1-686-bigmem kernel
image) I get strange paging-related errors that seem to be somehow
connected to md, maybe especially to md_resync. I got no other errors
where md was not involved, that's why I'm mailing to linux-raid@ only
at first.
All the actions described below succeeded when falling back to 2.6.28,
so it's most likely not hardware-related on the one hand and probably
caused by some change from .28 to .29 - even though I have no idea
which one that could be.

I attached 4 files:
=3D=3D> /proc/mdstat <=3D=3D
Just to give a slight sketch about my raid configuration.

=3D=3D> md-oops.2.6.29.md0_resync <=3D=3D
This Oops I got after /usr/share/mdadm/checkarray -a which basically
does an echo check > sync_action for md*.

=3D=3D> md-bug.2.6.29.cmp <=3D=3D
This BUG I got while I ran a manual cmp -l over 2 component devices of
either md[0123] (I don't remember exactly how far the for-loop went) and
while simultaneously a 3rd mirror got synched into md9.

=3D=3D> md-bug.2.6.29.md1_resync <=3D=3D
This BUG I got right after rebooting from the one before while I
manually issued sequential data-checks to the raids.


best regards
   Mario
--=20
But after a while I learned the trick of speaking fast. You don't have
to think any faster; just use twice as many words to say everything.
                                -- Paul Graham

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=mdstat
Content-Transfer-Encoding: quoted-printable

Personalities : [raid1]=20
md9 : active raid1 sdd1[0] sdh1[2] sdf1[1]
      1465135936 blocks [3/3] [UUU]
      bitmap: 0/175 pages [0KB], 4096KB chunk

md8 : active raid1 sdc1[0] sde1[1]
      1465135936 blocks [2/2] [UU]
      bitmap: 0/175 pages [0KB], 4096KB chunk

md6 : active raid1 sda8[0] sdb8[1]
      58596992 blocks [3/2] [UU_]
      bitmap: 224/224 pages [896KB], 128KB chunk

md5 : active raid1 sda7[0] sdb7[1]
      293491328 blocks [3/2] [UU_]
      bitmap: 126/140 pages [504KB], 1024KB chunk

md4 : active raid1 sda6[0] sdb6[1]
      78132032 blocks [3/2] [UU_]
      bitmap: 150/150 pages [600KB], 256KB chunk

md3 : active raid1 sda5[0] sdb5[1]
      29302464 blocks [3/2] [UU_]
      bitmap: 224/224 pages [896KB], 64KB chunk

md2 : active raid1 sda3[0] sdb3[1]
      8297472 blocks [3/2] [UU_]
     =20
md1 : active raid1 sda2[0] sdb2[1]
      979840 blocks [3/2] [UU_]
     =20
md0 : active raid1 sda1[0] sdb1[1]
      240832 blocks [3/2] [UU_]
     =20
unused devices: <none>

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="md-oops.2.6.29.md0_resync"
Content-Transfer-Encoding: quoted-printable

[252270.424359] md: data-check of RAID array md0
[252270.426460] md: delaying data-check of md1 until md0 has finished (they=
 share one or more physical units)
[252270.427772] md: delaying data-check of md2 until md0 has finished (they=
 share one or more physical units)
[252270.495245] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[252270.498777] md: delaying data-check of md3 until md2 has finished (they=
 share one or more physical units)
[252270.498781] md: delaying data-check of md1 until md2 has finished (they=
 share one or more physical units)
[252270.498785] md: delaying data-check of md2 until md0 has finished (they=
 share one or more physical units)
[252270.599708] md: using maximum available idle IO bandwidth (but not more=
 than 200000 KB/sec) for data-check.
[252270.629181] md: using 128k window, over a total of 240832 blocks.
[252270.665819] BUG: unable to handle kernel <6>md: delaying data-check of =
md5 until md2 has finished (they share one or more physical units)
[252270.679819] md: delaying data-check of md6 until md5 has finished (they=
 share one or more physical units)
[252270.682241] md: data-check of RAID array md8
[252270.682243] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[252270.682244] md: using maximum available idle IO bandwidth (but not more=
 than 200000 KB/sec) for data-check.
[252270.682246] md: using 128k window, over a total of 1465135936 blocks.
[252270.687100] md: md8: data-check done.
[252270.708249] md: delaying data-check of md6 until md5 has finished (they=
 share one or more physical units)
[252270.708252] md: delaying data-check of md5 until md6 has finished (they=
 share one or more physical units)
[252270.708256] md: delaying data-check of md6 until md2 has finished (they=
 share one or more physical units)
[252270.708259] md: delaying data-check of md2 until md6 has finished (they=
 share one or more physical units)
[252270.708261] md: delaying data-check of md5 until md6 has finished (they=
 share one or more physical units)
[252270.708264] md: delaying data-check of md1 until md6 has finished (they=
 share one or more physical units)
[252270.708267] md: delaying data-check of md3 until md6 has finished (they=
 share one or more physical units)
[252270.708294] md: delaying data-check of md6 until md0 has finished (they=
 share one or more physical units)
[252270.710565] md: data-check of RAID array md9
[252270.710567] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[252270.710568] md: using maximum available idle IO bandwidth (but not more=
 than 200000 KB/sec) for data-check.
[252270.710570] md: using 128k window, over a total of 1465135936 blocks.
[252270.710781] md: md9: data-check done.
[252270.732565] md: delaying data-check of md6 until md0 has finished (they=
 share one or more physical units)
[252270.732567] md: delaying data-check of md3 until md6 has finished (they=
 share one or more physical units)
[252270.732570] md: delaying data-check of md1 until md6 has finished (they=
 share one or more physical units)
[252270.732572] md: delaying data-check of md5 until md6 has finished (they=
 share one or more physical units)
[252270.732574] md: delaying data-check of md2 until md6 has finished (they=
 share one or more physical units)
[252271.289771] NULL pointer dereference at 00000a0a
[252271.300536] md: delaying data-check of md4 until md6 has finished (they=
 share one or more physical units)
[252271.300541] md: delaying data-check of md6 until md0 has finished (they=
 share one or more physical units)
[252271.300544] md: delaying data-check of md2 until md6 has finished (they=
 share one or more physical units)
[252271.300546] md: delaying data-check of md5 until md6 has finished (they=
 share one or more physical units)
[252271.300549] md: delaying data-check of md1 until md6 has finished (they=
 share one or more physical units)
[252271.300551] md: delaying data-check of md3 until md6 has finished (they=
 share one or more physical units)
[252271.477414] IP: [<c0173c40>] put_page+0x6/0x80
[252271.491110] *pdpt =3D 0000000033508001 *pde =3D 0000000000000000=20
[252271.508729] Oops: 0000 [#1] SMP=20
[252271.512116] last sysfs file: /sys/devices/virtual/block/md9/md/sync_act=
ion
[252271.512116] Modules linked in: tcp_diag i915 drm binfmt_misc ipt_ULOG i=
net_diag ipx p8023 xt_multiport iptable_filter ip_tables x_tables iTCO_wdt =
acpi_cpufreq cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_cons=
ervative microcode ipcomp6 xfrm6_tunnel tunnel6 esp6 ah6 ipcomp xfrm_ipcomp=
 esp4 ah4 xfrm_user cts arc4 authenc tea xor seqiv salsa20_generic anubis r=
md256 lzo lzo_decompress lzo_compress ccm lrw ecb gcm crc32c cast5 seed ans=
i_cprng fcrypt michael_mic cast6 wp512 tgr192 rmd128 khazad rmd320 pcbc sha=
512_generic md4 deflate zlib_deflate zlib_inflate ctr twofish twofish_commo=
n camellia serpent blowfish des_generic cbc xcbc rmd160 sha256_generic sha1=
_generic hmac crypto_null af_key xfs exportfs ext3 jbd fuse ipv6 sg eeprom =
coretemp w83627ehf hwmon_vid i2c_dev floppy tuner_simple tuner_types snd_hd=
a_codec_realtek tuner tvaudio snd_hda_intel msp3400 snd_hda_codec snd_bt87x=
 snd_hwdep snd_pcm_oss bttv snd_mixer_oss snd_pcm ir_common snd_seq_dummy s=
nd_seq_oss i2c_algo_bit snd_seq_midi snd_rawmidi v4l2_common snd_seq_midi_e=
vent videodev v4l1_compat snd_seq snd_timer snd_seq_device videobuf_dma_sg =
videobuf_core btcx_risc snd tveeprom ppdev i2c_i801 psmouse parport_pc soun=
dcore pcspkr i2c_core evdev snd_page_alloc serio_raw parport button ext2 mb=
cache aes_i586 aes_generic xts gf128mul dm_crypt dm_snapshot raid1 md_mod s=
d_mod crc_t10dif ide_cd_mod cdrom ata_generic ide_pci_generic ahci jmicron =
libata firewire_ohci firewire_core crc_itu_t uhci_hcd atl1 mii ide_core scs=
i_mod ehci_hcd usbcore intel_agp agpgart thermal processor fan thermal_sys =
dm_mirror dm_region_hash dm_log dm_mod
[252271.512116]=20
[252271.512116] Pid: 3327, comm: md0_resync Not tainted (2.6.29-1-686-bigme=
m #1) P5E-V HDMI
[252271.512116] EIP: 0060:[<c0173c40>] EFLAGS: 00010206 CPU: 0
[252271.512116] EIP is at put_page+0x6/0x80
[252271.512116] EAX: 00000a0a EBX: 00000001 ECX: 00000003 EDX: f6145e80
[252271.512116] ESI: 00000024 EDI: 00000a0a EBP: d7c21238 ESP: c3935dd8
[252271.512116]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[252271.512116] Process md0_resync (pid: 3327, ti=3Dc3934000 task=3Deb45681=
0 task.ti=3Dc3934000)
[252271.512116] Stack:
[252271.512116]  00000001 00000024 d7c21200 d7c21238 f83a7baa 00011200 f614=
5e80 eb1b7bc0
[252271.512116]  f5ecea00 00075980 00011210 f5ecea1c c016ebaf 00000010 c02f=
b920 c0128005
[252271.512116]  00000000 00000000 00075980 00000000 00075980 00000000 c393=
5e78 f83a7e54
[252271.512116] Call Trace:
[252271.512116]  [<f83a7baa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[252271.512116]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[252271.512116]  [<c0128005>] try_to_wake_up+0x14e/0x157
[252271.512116]  [<f83a7e54>] sync_request+0x1fd/0x5ee [raid1]
[252271.512116]  [<c0122990>] __wake_up+0x29/0x39
[252271.512116]  [<f8561d5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[252271.512116]  [<c0128005>] try_to_wake_up+0x14e/0x157
[252271.512116]  [<f85625e3>] md_thread+0xdd/0xf4 [md_mod]
[252271.512116]  [<c012291b>] complete+0x28/0x36
[252271.512116]  [<f8562506>] md_thread+0x0/0xf4 [md_mod]
[252271.512116]  [<c013cd4b>] kthread+0x38/0x5d
[252271.512116]  [<c013cd13>] kthread+0x0/0x5d
[252271.512116]  [<c0108933>] kernel_thread_helper+0x7/0x10
[252271.512116] Code: 20 74 0d 89 d8 e8 f9 fe ff ff f0 80 23 fb eb 09 80 e1=
 04 75 04 f0 80 0b 04 5b c3 b8 7c 3a 17 c0 e9 01 6e fc ff 55 57 89 c7 56 53=
 <8b> 00 f6 c4 60 74 1c f6 c4 40 74 03 8b 7f 0c 8d 47 04 f0 ff 08=20
[252272.405611] EIP: [<c0173c40>] put_page+0x6/0x80 SS:ESP 0068:c3935dd8
[252272.460990] ---[ end trace f1a1364895d919f1 ]---

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="md-bug.2.6.29.cmp"
Content-Transfer-Encoding: quoted-printable

[292215.144935] md: bind<sdh1>
[292215.233026] RAID1 conf printout:
[292215.242957]  --- wd:2 rd:3
[292215.251325]  disk 0, wo:0, o:1, dev:sdd1
[292215.251327]  disk 1, wo:0, o:1, dev:sdf1
[292215.251329]  disk 2, wo:1, o:1, dev:sdh1
[292215.267147] md: recovery of RAID array md9
[292215.267149] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[292215.267151] md: using maximum available idle IO bandwidth (but not more=
 than 200000 KB/sec) for recovery.
[292215.267155] md: using 128k window, over a total of 1465135936 blocks.
[294021.604537] BUG: Bad page state in process cmp  pfn:19197
[294021.621040] ------------[ cut here ]------------
[294021.624962] kernel BUG at /build/buildd-linux-2.6_2.6.29-2-i386-SgPO4R/=
linux-2.6-2.6.29/debian/build/source_i386_none/mm/page_alloc.c:423!
[294021.624962] invalid opcode: 0000 [#1] SMP=20
[294021.624962] last sysfs file: /sys/devices/virtual/thermal/cooling_devic=
e1/cur_state
[294021.624962] Modules linked in: iptable_nat nf_nat nf_conntrack_ipv4 nf_=
conntrack nf_defrag_ipv4 iptable_mangle ebtable_filter ebtables tcp_diag i9=
15 drm binfmt_misc ipt_ULOG inet_diag ipx p8023 xt_multiport iptable_filter=
 ip_tables x_tables iTCO_wdt acpi_cpufreq cpufreq_powersave cpufreq_userspa=
ce cpufreq_stats cpufreq_conservative microcode ipcomp6 xfrm6_tunnel tunnel=
6 esp6 ah6 ipcomp xfrm_ipcomp esp4 ah4 xfrm_user cts arc4 authenc tea xor s=
eqiv salsa20_generic anubis rmd256 lzo lzo_decompress lzo_compress ccm lrw =
ecb gcm crc32c cast5 seed ansi_cprng fcrypt michael_mic cast6 wp512 tgr192 =
rmd128 khazad rmd320 pcbc sha512_generic md4 deflate zlib_deflate zlib_infl=
ate ctr twofish twofish_common camellia serpent blowfish des_generic cbc xc=
bc rmd160 sha256_generic sha1_generic hmac crypto_null af_key xfs exportfs =
ext3 jbd fuse ipv6 sg eeprom coretemp w83627ehf hwmon_vid i2c_dev floppy sn=
d_hda_codec_realtek tuner_simple snd_hda_intel tuner_types snd_hda_codec sn=
d_bt87x tuner snd_pcm_oss snd_mixer_oss snd_hwdep tvaudio snd_pcm snd_seq_d=
ummy snd_seq_oss msp3400 snd_seq_midi snd_rawmidi bttv snd_seq_midi_event s=
nd_seq ir_common snd_timer snd_seq_device i2c_algo_bit i2c_i801 v4l2_common=
 videodev v4l1_compat videobuf_dma_sg videobuf_core btcx_risc tveeprom snd =
soundcore snd_page_alloc i2c_core psmouse parport_pc ppdev pcspkr evdev ser=
io_raw parport button ext2 mbcache aes_i586 aes_generic xts gf128mul dm_cry=
pt dm_snapshot raid1 md_mod sd_mod crc_t10dif ide_cd_mod cdrom ata_generic =
ide_pci_generic firewire_ohci firewire_core uhci_hcd ahci libata crc_itu_t =
atl1 mii jmicron ide_core scsi_mod ehci_hcd usbcore intel_agp agpgart therm=
al processor fan thermal_sys dm_mirror dm_region_hash dm_log dm_mod
[294021.904989]=20
[294021.904989] Pid: 32289, comm: cmp Not tainted (2.6.29-1-686-bigmem #1) =
P5E-V HDMI
[294021.904989] EIP: 0060:[<c01705e4>] EFLAGS: 00010082 CPU: 0
[294022.205044] EIP is at __free_one_page+0x104/0x1a0
[294022.205044] EAX: fffffffe EBX: 40040000 ECX: c1071780 EDX: 00000000
[294022.205044] ESI: 000000bd EDI: c10717a0 EBP: c03d342c ESP: e6a29b38
[294022.205044]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[294022.205044] Process cmp (pid: 32289, ti=3De6a28000 task=3Df59cf030 task=
=2Eti=3De6a28000)
[294022.205044] Stack:
[294022.205044]  00000000 c03d2be0 00000001 00000003 00000001 00000005 c03d=
2be0 c03d2c0c
[294022.205044]  00000b00 c01706d9 00000020 c03d2be0 00000000 c0170f12 0000=
0000 00000000
[294022.205044]  00000202 00000000 00000030 de5de330 de5de300 f84bca5c f646=
1960 cc8e6340
[294022.205044] Call Trace:
[294022.205044]  [<c01706d9>] free_pages_bulk+0x59/0x6d
[294022.205044]  [<c0170f12>] free_hot_cold_page+0x116/0x153
[294022.205044]  [<f84bca5c>] r1buf_pool_free+0x41/0x73 [raid1]
[294022.205044]  [<c016eb85>] mempool_free+0x61/0x64
[294022.205044]  [<f84bcc4c>] put_buf+0x5a/0x65 [raid1]
[294022.205044]  [<f84bd314>] end_sync_write+0xcf/0xe5 [raid1]
[294022.205044]  [<f84bd245>] end_sync_write+0x0/0xe5 [raid1]
[294022.205044]  [<c01ab759>] bio_endio+0x28/0x2a
[294022.505098]  [<c01f4d99>] __end_that_request_first+0x11e/0x217
[294022.505098]  [<c01f4ea3>] end_that_request_data+0x11/0x3f
[294022.505098]  [<c01f5693>] blk_end_io+0x18/0x62
[294022.505098]  [<c01f5702>] blk_end_request+0x9/0xc
[294022.505098]  [<f83a8989>] scsi_io_completion+0x19b/0x3ce [scsi_mod]
[294022.505098]  [<f83a3504>] scsi_finish_command+0xaa/0xc2 [scsi_mod]
[294022.505098]  [<c01f8e0b>] blk_done_softirq+0x5b/0x67
[294022.505098]  [<c0131432>] __do_softirq+0x8c/0x130
[294022.505098]  [<c013151b>] do_softirq+0x45/0x53
[294022.505098]  [<c013163f>] irq_exit+0x35/0x62
[294022.505098]  [<c011661e>] smp_apic_timer_interrupt+0x71/0x7b
[294022.505098]  [<c01087e0>] apic_timer_interrupt+0x28/0x30
[294022.505098]  [<c012d9ef>] vprintk+0x286/0x2b2
[294022.505098]  [<c0128005>] try_to_wake_up+0x14e/0x157
[294022.505098]  [<c01438ed>] getnstimeofday+0x51/0xd3
[294022.726343]  [<c02f2016>] printk+0xe/0x18
[294022.726343]  [<c017049b>] bad_page+0x95/0xda
[294022.726343]  [<c017130c>] get_page_from_freelist+0x31b/0x3f3
[294022.726343]  [<c0171630>] __alloc_pages_internal+0x98/0x398
[294022.726343]  [<c01730a7>] __do_page_cache_readahead+0xa2/0x175
[294022.805152]  [<c016e213>] generic_file_aio_read+0x262/0x59a
[294022.805152]  [<c019015d>] do_sync_read+0xc0/0x107
[294022.805152]  [<c014103d>] sched_clock_cpu+0x136/0x147
[294022.805152]  [<c01240bc>] pick_next_task_fair+0x80/0x87
[294022.805152]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[294022.805152]  [<c01b16a7>] inotify_inode_queue_event+0x45/0xc6
[294022.805152]  [<c01d9864>] security_file_permission+0xc/0xd
[294022.805152]  [<c019009d>] do_sync_read+0x0/0x107
[294022.805152]  [<c0190a0e>] vfs_read+0x7b/0xd3
[294022.805152]  [<c0190afe>] sys_read+0x3c/0x63
[294022.805152]  [<c010805b>] sysenter_do_call+0x12/0x2f
[294022.805152]  [<c02f0000>] check_tsc_warp+0x110/0x14e
[294022.805152] Code: c1 e8 1e 89 da c1 ea 1e 39 d0 75 29 f7 c3 00 00 04 00=
 74 21 8b 14 24 39 51 0c 75 19 80 e7 40 89 d0 0f 44 c1 8b 40 04 85 c0 74 4f=
 <0f> 0b eb fe 83 3c 24 09 76 af 8b 0c 24 89 4f 0c 0f ba 2f 12 8b=20
[294022.805152] EIP: [<c01705e4>] __free_one_page+0x104/0x1a0 SS:ESP 0068:e=
6a29b38
[294022.805152] ---[ end trace 0de3113d6bf88c65 ]---
[294022.805152] Kernel panic - not syncing: Fatal exception in interrupt
[294023.105205] ------------[ cut here ]------------
[294023.105205] WARNING: at /build/buildd-linux-2.6_2.6.29-2-i386-SgPO4R/li=
nux-2.6-2.6.29/debian/build/source_i386_none/kernel/smp.c:329 smp_call_func=
tion_many+0x34/0x1c5()
[294023.105205] Hardware name: P5E-V HDMI
[294023.105205] Modules linked in: iptable_nat nf_nat nf_conntrack_ipv4 nf_=
conntrack nf_defrag_ipv4 iptable_mangle ebtable_filter ebtables tcp_diag i9=
15 drm binfmt_misc ipt_ULOG inet_diag ipx p8023 xt_multiport iptable_filter=
 ip_tables x_tables iTCO_wdt acpi_cpufreq cpufreq_powersave cpufreq_userspa=
ce cpufreq_stats

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="md-bug.2.6.29.md1_resync"
Content-Transfer-Encoding: quoted-printable

[  433.350481] md: data-check of RAID array md0
[  433.363268] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  433.380739] md: using maximum available idle IO bandwidth (but not more =
than 200000 KB/sec) for data-check.
[  433.409913] md: using 128k window, over a total of 240832 blocks.
[  433.437590] md: delaying data-check of md1 until md0 has finished (they =
share one or more physical units)
[  437.277537] md: md0: data-check done.
[  437.309185] md: data-check of RAID array md1
[  437.322175] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  437.339746] md: using maximum available idle IO bandwidth (but not more =
than 200000 KB/sec) for data-check.
[  437.368953] md: using 128k window, over a total of 979840 blocks.
[  450.036459] BUG: Bad page state in process md1_resync  pfn:110c99
[  450.054812] page:c3219320 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:40c
[  450.078622] Pid: 10385, comm: md1_resync Not tainted 2.6.29-1-686-bigmem=
 #1
[  450.099624] Call Trace:
[  450.107014]  [<c01704cc>] bad_page+0xc6/0xda
[  450.119892]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.134781]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.150467]  [<c0173caa>] put_page+0x70/0x80
[  450.163357]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.180910]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.195172]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.209161]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.225804]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.225820]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.225846]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.225858]  [<c012291b>] complete+0x28/0x36
[  450.225885]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.225896]  [<c013cd4b>] kthread+0x38/0x5d
[  450.225898]  [<c013cd13>] kthread+0x0/0x5d
[  450.225901]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.225905] BUG: Bad page state in process md1_resync  pfn:110c98
[  450.225907] page:c3219300 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:40d
[  450.225910] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.225911] Call Trace:
[  450.225914]  [<c01704cc>] bad_page+0xc6/0xda
[  450.225916]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.225919]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.225921]  [<c0173caa>] put_page+0x70/0x80
[  450.225943]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.225945]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.225948]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.225965]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.225996]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.226019]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.226044]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.226047]  [<c012291b>] complete+0x28/0x36
[  450.226071]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.226074]  [<c013cd4b>] kthread+0x38/0x5d
[  450.226076]  [<c013cd13>] kthread+0x0/0x5d
[  450.226078]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.226081] BUG: Bad page state in process md1_resync  pfn:110c97
[  450.226083] page:c32192e0 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:40e
[  450.226085] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.226086] Call Trace:
[  450.226088]  [<c01704cc>] bad_page+0xc6/0xda
[  450.226091]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.226093]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.226096]  [<c0173caa>] put_page+0x70/0x80
[  450.226117]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.226120]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.226122]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.226139]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.226169]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.226184]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.226208]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.226210]  [<c012291b>] complete+0x28/0x36
[  450.226235]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.226238]  [<c013cd4b>] kthread+0x38/0x5d
[  450.226240]  [<c013cd13>] kthread+0x0/0x5d
[  450.226242]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.226245] BUG: Bad page state in process md1_resync  pfn:110c96
[  450.226247] page:c32192c0 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:40f
[  450.226249] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.226250] Call Trace:
[  450.226252]  [<c01704cc>] bad_page+0xc6/0xda
[  450.226255]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.226257]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.226260]  [<c0173caa>] put_page+0x70/0x80
[  450.226281]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.226283]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.226285]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.226303]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.226333]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.226348]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.226372]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.226374]  [<c012291b>] complete+0x28/0x36
[  450.226398]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.226401]  [<c013cd4b>] kthread+0x38/0x5d
[  450.226404]  [<c013cd13>] kthread+0x0/0x5d
[  450.226406]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.226408] BUG: Bad page state in process md1_resync  pfn:110c95
[  450.226410] page:c32192a0 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:410
[  450.226413] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.226414] Call Trace:
[  450.226416]  [<c01704cc>] bad_page+0xc6/0xda
[  450.226419]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.226421]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.226423]  [<c0173caa>] put_page+0x70/0x80
[  450.226444]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.226447]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.226449]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.226466]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.226496]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.226510]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.226534]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.226537]  [<c012291b>] complete+0x28/0x36
[  450.226561]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.226563]  [<c013cd4b>] kthread+0x38/0x5d
[  450.226566]  [<c013cd13>] kthread+0x0/0x5d
[  450.226568]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.226570] BUG: Bad page state in process md1_resync  pfn:110c94
[  450.226572] page:c3219280 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:411
[  450.226574] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.226576] Call Trace:
[  450.226578]  [<c01704cc>] bad_page+0xc6/0xda
[  450.226580]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.226583]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.226585]  [<c0173caa>] put_page+0x70/0x80
[  450.226606]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.226609]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.226611]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.226628]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.226658]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.226672]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.226696]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.226698]  [<c012291b>] complete+0x28/0x36
[  450.226723]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.226725]  [<c013cd4b>] kthread+0x38/0x5d
[  450.226728]  [<c013cd13>] kthread+0x0/0x5d
[  450.226730]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.226733] BUG: Bad page state in process md1_resync  pfn:110c93
[  450.226735] page:c3219260 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:412
[  450.226737] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.226738] Call Trace:
[  450.226740]  [<c01704cc>] bad_page+0xc6/0xda
[  450.226743]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.226745]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.226748]  [<c0173caa>] put_page+0x70/0x80
[  450.226769]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.226771]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.226773]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.226790]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.226821]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.226835]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.226859]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.226861]  [<c012291b>] complete+0x28/0x36
[  450.226885]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.226888]  [<c013cd4b>] kthread+0x38/0x5d
[  450.226890]  [<c013cd13>] kthread+0x0/0x5d
[  450.226893]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.226895] BUG: Bad page state in process md1_resync  pfn:110c92
[  450.226897] page:c3219240 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:413
[  450.226899] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.226900] Call Trace:
[  450.226903]  [<c01704cc>] bad_page+0xc6/0xda
[  450.226905]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.226907]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.226910]  [<c0173caa>] put_page+0x70/0x80
[  450.226931]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.226934]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.226936]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.226953]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.226982]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.226997]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.227021]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.227023]  [<c012291b>] complete+0x28/0x36
[  450.227047]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.227050]  [<c013cd4b>] kthread+0x38/0x5d
[  450.227052]  [<c013cd13>] kthread+0x0/0x5d
[  450.227054]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.227057] BUG: Bad page state in process md1_resync  pfn:110c91
[  450.227059] page:c3219220 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:414
[  450.227061] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.227062] Call Trace:
[  450.227065]  [<c01704cc>] bad_page+0xc6/0xda
[  450.227067]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.227069]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.227072]  [<c0173caa>] put_page+0x70/0x80
[  450.227093]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.227095]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.227097]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.227115]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.227144]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.227159]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.227182]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.227184]  [<c012291b>] complete+0x28/0x36
[  450.227208]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.227211]  [<c013cd4b>] kthread+0x38/0x5d
[  450.227213]  [<c013cd13>] kthread+0x0/0x5d
[  450.227216]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.227218] BUG: Bad page state in process md1_resync  pfn:110c90
[  450.227220] page:c3219200 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:415
[  450.227222] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.227224] Call Trace:
[  450.227226]  [<c01704cc>] bad_page+0xc6/0xda
[  450.227228]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.227231]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.227233]  [<c0173caa>] put_page+0x70/0x80
[  450.227254]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.227256]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.227259]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.227276]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.227306]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.227321]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.227344]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.227347]  [<c012291b>] complete+0x28/0x36
[  450.227370]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.227373]  [<c013cd4b>] kthread+0x38/0x5d
[  450.227375]  [<c013cd13>] kthread+0x0/0x5d
[  450.227378]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.227380] BUG: Bad page state in process md1_resync  pfn:110c8f
[  450.227382] page:c32191e0 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:416
[  450.227384] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.227386] Call Trace:
[  450.227388]  [<c01704cc>] bad_page+0xc6/0xda
[  450.227390]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.227392]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.227395]  [<c0173caa>] put_page+0x70/0x80
[  450.227416]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.227418]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.227421]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.227437]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.227467]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.227481]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.227505]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.227507]  [<c012291b>] complete+0x28/0x36
[  450.227531]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.227534]  [<c013cd4b>] kthread+0x38/0x5d
[  450.227536]  [<c013cd13>] kthread+0x0/0x5d
[  450.227538]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.227541] BUG: Bad page state in process md1_resync  pfn:110c8e
[  450.227543] page:c32191c0 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:417
[  450.227545] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.227546] Call Trace:
[  450.227548]  [<c01704cc>] bad_page+0xc6/0xda
[  450.227551]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.227553]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.227555]  [<c0173caa>] put_page+0x70/0x80
[  450.227576]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.227579]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.227581]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.227598]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.227627]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.227641]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.227665]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.227667]  [<c012291b>] complete+0x28/0x36
[  450.227691]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.227694]  [<c013cd4b>] kthread+0x38/0x5d
[  450.227696]  [<c013cd13>] kthread+0x0/0x5d
[  450.227698]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.227701] BUG: Bad page state in process md1_resync  pfn:110c8d
[  450.227703] page:c32191a0 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:418
[  450.227705] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.227706] Call Trace:
[  450.227708]  [<c01704cc>] bad_page+0xc6/0xda
[  450.227711]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.227713]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.227715]  [<c0173caa>] put_page+0x70/0x80
[  450.227736]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.227739]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.227741]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.227757]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.227787]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.227802]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.227825]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.227827]  [<c012291b>] complete+0x28/0x36
[  450.227851]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.227854]  [<c013cd4b>] kthread+0x38/0x5d
[  450.227856]  [<c013cd13>] kthread+0x0/0x5d
[  450.227858]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.227861] BUG: Bad page state in process md1_resync  pfn:110c8c
[  450.227863] page:c3219180 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:419
[  450.227865] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.227866] Call Trace:
[  450.227868]  [<c01704cc>] bad_page+0xc6/0xda
[  450.227871]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.227873]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.227875]  [<c0173caa>] put_page+0x70/0x80
[  450.227896]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.227899]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.227901]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.227917]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.227947]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.227961]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.227985]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.227987]  [<c012291b>] complete+0x28/0x36
[  450.228021]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.228024]  [<c013cd4b>] kthread+0x38/0x5d
[  450.228027]  [<c013cd13>] kthread+0x0/0x5d
[  450.228029]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.228031] BUG: Bad page state in process md1_resync  pfn:110c8b
[  450.228033] page:c3219160 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:41a
[  450.228035] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.228036] Call Trace:
[  450.228039]  [<c01704cc>] bad_page+0xc6/0xda
[  450.228041]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.228043]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.228046]  [<c0173caa>] put_page+0x70/0x80
[  450.228066]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.228068]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.228071]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.228087]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.228117]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.228131]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.228154]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.228157]  [<c012291b>] complete+0x28/0x36
[  450.228180]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.228183]  [<c013cd4b>] kthread+0x38/0x5d
[  450.228185]  [<c013cd13>] kthread+0x0/0x5d
[  450.228187]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  450.228189] BUG: Bad page state in process md1_resync  pfn:110c8a
[  450.228191] page:c3219140 flags:80010008 count:0 mapcount:0 mapping:f4da=
9558 index:41b
[  450.228193] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  450.228195] Call Trace:
[  450.228197]  [<c01704cc>] bad_page+0xc6/0xda
[  450.228199]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  450.228202]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  450.228204]  [<c0173caa>] put_page+0x70/0x80
[  450.228224]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  450.228227]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  450.228229]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  450.228245]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  450.228274]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  450.228288]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  450.228311]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  450.228314]  [<c012291b>] complete+0x28/0x36
[  450.228337]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  450.228340]  [<c013cd4b>] kthread+0x38/0x5d
[  450.228342]  [<c013cd13>] kthread+0x0/0x5d
[  450.228344]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  455.419838] md: md2 switched to read-write mode.
[  456.104441] BUG: Bad page state in process md1_resync  pfn:cef0c
[  456.122748] page:c29de180 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1d08 index:c
[  456.146007] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.169252] Call Trace:
[  456.176636]  [<c01704cc>] bad_page+0xc6/0xda
[  456.176639]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.176642]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.176644]  [<c0173caa>] put_page+0x70/0x80
[  456.176679]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.176682]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.176684]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.176704]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.176707]  [<c0122990>] __wake_up+0x29/0x39
[  456.176745]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.176762]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.176789]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.176792]  [<c012291b>] complete+0x28/0x36
[  456.176818]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.176821]  [<c013cd4b>] kthread+0x38/0x5d
[  456.176824]  [<c013cd13>] kthread+0x0/0x5d
[  456.176826]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.176829] BUG: Bad page state in process md1_resync  pfn:ce8cf
[  456.176831] page:c29d19e0 flags:80010008 count:0 mapcount:0 mapping:ef0f=
6b1c index:4a
[  456.176833] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.176835] Call Trace:
[  456.176837]  [<c01704cc>] bad_page+0xc6/0xda
[  456.176840]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.176842]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.176845]  [<c0173caa>] put_page+0x70/0x80
[  456.176868]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.176871]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.176873]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.176892]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.176894]  [<c0122990>] __wake_up+0x29/0x39
[  456.176930]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.176946]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.176972]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.176975]  [<c012291b>] complete+0x28/0x36
[  456.177001]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.177004]  [<c013cd4b>] kthread+0x38/0x5d
[  456.177006]  [<c013cd13>] kthread+0x0/0x5d
[  456.177008]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.177011] BUG: Bad page state in process md1_resync  pfn:cef0b
[  456.177013] page:c29de160 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1d08 index:d
[  456.177015] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.177016] Call Trace:
[  456.177018]  [<c01704cc>] bad_page+0xc6/0xda
[  456.177021]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.177023]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.177026]  [<c0173caa>] put_page+0x70/0x80
[  456.177050]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.177052]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.177054]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.177073]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.177076]  [<c0122990>] __wake_up+0x29/0x39
[  456.177123]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.177141]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.177168]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.177170]  [<c012291b>] complete+0x28/0x36
[  456.177197]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.177199]  [<c013cd4b>] kthread+0x38/0x5d
[  456.177202]  [<c013cd13>] kthread+0x0/0x5d
[  456.177204]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.177206] BUG: Bad page state in process md1_resync  pfn:ce8ce
[  456.177208] page:c29d19c0 flags:80010008 count:0 mapcount:0 mapping:ef0f=
6b1c index:4b
[  456.177210] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.177211] Call Trace:
[  456.177214]  [<c01704cc>] bad_page+0xc6/0xda
[  456.177216]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.177218]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.177221]  [<c0173caa>] put_page+0x70/0x80
[  456.177244]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.177247]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.177249]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.177268]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.177270]  [<c0122990>] __wake_up+0x29/0x39
[  456.177305]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.177321]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.177347]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.177349]  [<c012291b>] complete+0x28/0x36
[  456.177375]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.177378]  [<c013cd4b>] kthread+0x38/0x5d
[  456.177381]  [<c013cd13>] kthread+0x0/0x5d
[  456.177383]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.177385] BUG: Bad page state in process md1_resync  pfn:cef0a
[  456.177387] page:c29de140 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1d08 index:e
[  456.177389] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.177391] Call Trace:
[  456.177393]  [<c01704cc>] bad_page+0xc6/0xda
[  456.177395]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.177398]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.177400]  [<c0173caa>] put_page+0x70/0x80
[  456.177424]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.177426]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.177428]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.177447]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.177449]  [<c0122990>] __wake_up+0x29/0x39
[  456.177484]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.177500]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.177526]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.177529]  [<c012291b>] complete+0x28/0x36
[  456.177555]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.177558]  [<c013cd4b>] kthread+0x38/0x5d
[  456.177560]  [<c013cd13>] kthread+0x0/0x5d
[  456.177562]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.177564] BUG: Bad page state in process md1_resync  pfn:ce8cd
[  456.177566] page:c29d19a0 flags:80010008 count:0 mapcount:0 mapping:ef0f=
6b1c index:4c
[  456.177568] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.177570] Call Trace:
[  456.177572]  [<c01704cc>] bad_page+0xc6/0xda
[  456.177574]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.177577]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.177579]  [<c0173caa>] put_page+0x70/0x80
[  456.177602]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.177605]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.177607]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.177638]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.177641]  [<c0122990>] __wake_up+0x29/0x39
[  456.177677]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.177693]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.177719]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.177721]  [<c012291b>] complete+0x28/0x36
[  456.177748]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.177750]  [<c013cd4b>] kthread+0x38/0x5d
[  456.177753]  [<c013cd13>] kthread+0x0/0x5d
[  456.177755]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.177757] BUG: Bad page state in process md1_resync  pfn:cef09
[  456.177759] page:c29de120 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1d08 index:f
[  456.177761] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.177763] Call Trace:
[  456.177765]  [<c01704cc>] bad_page+0xc6/0xda
[  456.177767]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.177770]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.177772]  [<c0173caa>] put_page+0x70/0x80
[  456.177796]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.177798]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.177800]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.177819]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.177822]  [<c0122990>] __wake_up+0x29/0x39
[  456.177856]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.177873]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.177898]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.177901]  [<c012291b>] complete+0x28/0x36
[  456.177927]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.177929]  [<c013cd4b>] kthread+0x38/0x5d
[  456.177932]  [<c013cd13>] kthread+0x0/0x5d
[  456.177934]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.177936] BUG: Bad page state in process md1_resync  pfn:ce8cc
[  456.177938] page:c29d1980 flags:80010008 count:0 mapcount:0 mapping:ef0f=
6b1c index:4d
[  456.177940] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.177941] Call Trace:
[  456.177944]  [<c01704cc>] bad_page+0xc6/0xda
[  456.177946]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.177948]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.177951]  [<c0173caa>] put_page+0x70/0x80
[  456.177974]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.177977]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.177979]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.177997]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.178012]  [<c0122990>] __wake_up+0x29/0x39
[  456.178052]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.178082]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.178109]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.178111]  [<c012291b>] complete+0x28/0x36
[  456.178137]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.178149]  [<c013cd4b>] kthread+0x38/0x5d
[  456.178151]  [<c013cd13>] kthread+0x0/0x5d
[  456.178153]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.178156] BUG: Bad page state in process md1_resync  pfn:cef08
[  456.178158] page:c29de100 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1d08 index:10
[  456.178160] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.178161] Call Trace:
[  456.178163]  [<c01704cc>] bad_page+0xc6/0xda
[  456.178166]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.178168]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.178171]  [<c0173caa>] put_page+0x70/0x80
[  456.178194]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.178197]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.178199]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.178218]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.178220]  [<c0122990>] __wake_up+0x29/0x39
[  456.178254]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.178270]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.178295]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.178297]  [<c012291b>] complete+0x28/0x36
[  456.178323]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.178326]  [<c013cd4b>] kthread+0x38/0x5d
[  456.178328]  [<c013cd13>] kthread+0x0/0x5d
[  456.178331]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.178333] BUG: Bad page state in process md1_resync  pfn:ce8cb
[  456.178335] page:c29d1960 flags:80010008 count:0 mapcount:0 mapping:ef0f=
6b1c index:4e
[  456.178337] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.178338] Call Trace:
[  456.178340]  [<c01704cc>] bad_page+0xc6/0xda
[  456.178343]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.178345]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.178347]  [<c0173caa>] put_page+0x70/0x80
[  456.178370]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.178373]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.178375]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.178393]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.178396]  [<c0122990>] __wake_up+0x29/0x39
[  456.178430]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.178446]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.178471]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.178474]  [<c012291b>] complete+0x28/0x36
[  456.178499]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.178502]  [<c013cd4b>] kthread+0x38/0x5d
[  456.178504]  [<c013cd13>] kthread+0x0/0x5d
[  456.178506]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.178509] BUG: Bad page state in process md1_resync  pfn:cef07
[  456.178511] page:c29de0e0 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1d08 index:11
[  456.178513] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.178514] Call Trace:
[  456.178516]  [<c01704cc>] bad_page+0xc6/0xda
[  456.178519]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.178521]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.178524]  [<c0173caa>] put_page+0x70/0x80
[  456.178547]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.178549]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.178551]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.178570]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.178572]  [<c0122990>] __wake_up+0x29/0x39
[  456.178607]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.178622]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.178648]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.178650]  [<c012291b>] complete+0x28/0x36
[  456.178676]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.178679]  [<c013cd4b>] kthread+0x38/0x5d
[  456.178681]  [<c013cd13>] kthread+0x0/0x5d
[  456.178684]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.178686] BUG: Bad page state in process md1_resync  pfn:ce8ca
[  456.178688] page:c29d1940 flags:80010008 count:0 mapcount:0 mapping:ef0f=
6b1c index:4f
[  456.178690] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.178691] Call Trace:
[  456.178693]  [<c01704cc>] bad_page+0xc6/0xda
[  456.178696]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.178707]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.178710]  [<c0173caa>] put_page+0x70/0x80
[  456.178733]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.178736]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.178738]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.178756]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.178759]  [<c0122990>] __wake_up+0x29/0x39
[  456.178792]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.178808]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.178833]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.178835]  [<c012291b>] complete+0x28/0x36
[  456.178861]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.178864]  [<c013cd4b>] kthread+0x38/0x5d
[  456.178866]  [<c013cd13>] kthread+0x0/0x5d
[  456.178868]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.178871] BUG: Bad page state in process md1_resync  pfn:cef06
[  456.178873] page:c29de0c0 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1d08 index:12
[  456.178875] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.178876] Call Trace:
[  456.178878]  [<c01704cc>] bad_page+0xc6/0xda
[  456.178881]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.178883]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.178886]  [<c0173caa>] put_page+0x70/0x80
[  456.178909]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.178911]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.178913]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.178931]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.178934]  [<c0122990>] __wake_up+0x29/0x39
[  456.178968]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.178984]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.179009]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.179011]  [<c012291b>] complete+0x28/0x36
[  456.179038]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.179040]  [<c013cd4b>] kthread+0x38/0x5d
[  456.179043]  [<c013cd13>] kthread+0x0/0x5d
[  456.179045]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.179047] BUG: Bad page state in process md1_resync  pfn:ce8c9
[  456.179049] page:c29d1920 flags:80010008 count:0 mapcount:0 mapping:ef0f=
6b1c index:50
[  456.179051] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.179052] Call Trace:
[  456.179055]  [<c01704cc>] bad_page+0xc6/0xda
[  456.179057]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.179059]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.179062]  [<c0173caa>] put_page+0x70/0x80
[  456.179085]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.179087]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.179089]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.179108]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.179110]  [<c0122990>] __wake_up+0x29/0x39
[  456.179145]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.179161]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.179186]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.179189]  [<c012291b>] complete+0x28/0x36
[  456.179215]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.179217]  [<c013cd4b>] kthread+0x38/0x5d
[  456.179220]  [<c013cd13>] kthread+0x0/0x5d
[  456.179222]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.179224] BUG: Bad page state in process md1_resync  pfn:cec27
[  456.179226] page:c29d84e0 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1744 index:bf6
[  456.179228] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.179230] Call Trace:
[  456.179232]  [<c01704cc>] bad_page+0xc6/0xda
[  456.179234]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.179237]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.179239]  [<c0173caa>] put_page+0x70/0x80
[  456.179262]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.179264]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.179275]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.179297]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.179299]  [<c0122990>] __wake_up+0x29/0x39
[  456.179334]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.179350]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.179375]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.179378]  [<c012291b>] complete+0x28/0x36
[  456.179404]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.179407]  [<c013cd4b>] kthread+0x38/0x5d
[  456.179409]  [<c013cd13>] kthread+0x0/0x5d
[  456.179411]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.179413] BUG: Bad page state in process md1_resync  pfn:106dbb
[  456.179415] page:c30db760 flags:80010008 count:0 mapcount:0 mapping:f4d8=
2930 index:3f7
[  456.179417] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.179426] Call Trace:
[  456.179429]  [<c01704cc>] bad_page+0xc6/0xda
[  456.179431]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.179434]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.179436]  [<c0173caa>] put_page+0x70/0x80
[  456.179460]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.179462]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.179464]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.179483]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.179485]  [<c0122990>] __wake_up+0x29/0x39
[  456.179533]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.179548]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.179574]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.179576]  [<c012291b>] complete+0x28/0x36
[  456.179602]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.179605]  [<c013cd4b>] kthread+0x38/0x5d
[  456.179607]  [<c013cd13>] kthread+0x0/0x5d
[  456.179609]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.179611] BUG: Bad page state in process md1_resync  pfn:ce8c8
[  456.179614] page:c29d1900 flags:80010008 count:0 mapcount:0 mapping:ef0f=
6b1c index:51
[  456.179616] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.179617] Call Trace:
[  456.179619]  [<c01704cc>] bad_page+0xc6/0xda
[  456.179622]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.179624]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.179627]  [<c0173caa>] put_page+0x70/0x80
[  456.179650]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.179652]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.179654]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.179674]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.179676]  [<c0122990>] __wake_up+0x29/0x39
[  456.179710]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.179726]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.179751]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.179754]  [<c012291b>] complete+0x28/0x36
[  456.179779]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.179782]  [<c013cd4b>] kthread+0x38/0x5d
[  456.179784]  [<c013cd13>] kthread+0x0/0x5d
[  456.179787]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.179789] BUG: Bad page state in process md1_resync  pfn:cec26
[  456.179791] page:c29d84c0 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1744 index:bf7
[  456.179793] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.179794] Call Trace:
[  456.179796]  [<c01704cc>] bad_page+0xc6/0xda
[  456.179799]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.179801]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.179804]  [<c0173caa>] put_page+0x70/0x80
[  456.179826]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.179829]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.179831]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.179849]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.179860]  [<c0122990>] __wake_up+0x29/0x39
[  456.179898]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.179914]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.179940]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.179942]  [<c012291b>] complete+0x28/0x36
[  456.179968]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.179971]  [<c013cd4b>] kthread+0x38/0x5d
[  456.179973]  [<c013cd13>] kthread+0x0/0x5d
[  456.179975]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.179977] BUG: Bad page state in process md1_resync  pfn:106dba
[  456.179979] page:c30db740 flags:80010008 count:0 mapcount:0 mapping:f4d8=
2930 index:3f8
[  456.179981] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.179983] Call Trace:
[  456.179985]  [<c01704cc>] bad_page+0xc6/0xda
[  456.179987]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.179990]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.179992]  [<c0173caa>] put_page+0x70/0x80
[  456.180027]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.180030]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.180032]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.180050]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.180052]  [<c0122990>] __wake_up+0x29/0x39
[  456.180086]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.180102]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.180128]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.180130]  [<c012291b>] complete+0x28/0x36
[  456.180156]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.180159]  [<c013cd4b>] kthread+0x38/0x5d
[  456.180161]  [<c013cd13>] kthread+0x0/0x5d
[  456.180164]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.180166] BUG: Bad page state in process md1_resync  pfn:ce8c7
[  456.180168] page:c29d18e0 flags:80010008 count:0 mapcount:0 mapping:ef0f=
6b1c index:52
[  456.180170] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.180171] Call Trace:
[  456.180173]  [<c01704cc>] bad_page+0xc6/0xda
[  456.180176]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.180178]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.180181]  [<c0173caa>] put_page+0x70/0x80
[  456.180203]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.180206]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.180208]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.180227]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.180229]  [<c0122990>] __wake_up+0x29/0x39
[  456.180263]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.180279]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.180304]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.180306]  [<c012291b>] complete+0x28/0x36
[  456.180332]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.180334]  [<c013cd4b>] kthread+0x38/0x5d
[  456.180337]  [<c013cd13>] kthread+0x0/0x5d
[  456.180339]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.180341] BUG: Bad page state in process md1_resync  pfn:cec25
[  456.180343] page:c29d84a0 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1744 index:bf8
[  456.180345] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.180346] Call Trace:
[  456.180349]  [<c01704cc>] bad_page+0xc6/0xda
[  456.180351]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.180353]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.180356]  [<c0173caa>] put_page+0x70/0x80
[  456.180378]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.180381]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.180383]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.180402]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.180404]  [<c0122990>] __wake_up+0x29/0x39
[  456.180438]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.180465]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.180492]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.180494]  [<c012291b>] complete+0x28/0x36
[  456.180520]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.180523]  [<c013cd4b>] kthread+0x38/0x5d
[  456.180525]  [<c013cd13>] kthread+0x0/0x5d
[  456.180528]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.180530] BUG: Bad page state in process md1_resync  pfn:106db9
[  456.180532] page:c30db720 flags:80010008 count:0 mapcount:0 mapping:f4d8=
2930 index:3f9
[  456.180534] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.180535] Call Trace:
[  456.180537]  [<c01704cc>] bad_page+0xc6/0xda
[  456.180540]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.180542]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.180545]  [<c0173caa>] put_page+0x70/0x80
[  456.180567]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.180570]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.180572]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.180591]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.180593]  [<c0122990>] __wake_up+0x29/0x39
[  456.180627]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.180643]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.180668]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.180671]  [<c012291b>] complete+0x28/0x36
[  456.180696]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.180699]  [<c013cd4b>] kthread+0x38/0x5d
[  456.180701]  [<c013cd13>] kthread+0x0/0x5d
[  456.180703]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.180705] BUG: Bad page state in process md1_resync  pfn:ce8c6
[  456.180707] page:c29d18c0 flags:80010008 count:0 mapcount:0 mapping:ef0f=
6b1c index:53
[  456.180709] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.180711] Call Trace:
[  456.180713]  [<c01704cc>] bad_page+0xc6/0xda
[  456.180715]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.180718]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.180720]  [<c0173caa>] put_page+0x70/0x80
[  456.180743]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.180746]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.180748]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.180766]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.180768]  [<c0122990>] __wake_up+0x29/0x39
[  456.180803]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.180819]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.180853]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.180855]  [<c012291b>] complete+0x28/0x36
[  456.180882]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.180884]  [<c013cd4b>] kthread+0x38/0x5d
[  456.180887]  [<c013cd13>] kthread+0x0/0x5d
[  456.180889]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.180891] BUG: Bad page state in process md1_resync  pfn:cec24
[  456.180893] page:c29d8480 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1744 index:bf9
[  456.180895] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.180897] Call Trace:
[  456.180899]  [<c01704cc>] bad_page+0xc6/0xda
[  456.180901]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.180904]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.180906]  [<c0173caa>] put_page+0x70/0x80
[  456.180929]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.180937]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.180940]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.180962]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.180964]  [<c0122990>] __wake_up+0x29/0x39
[  456.181000]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.181025]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.181051]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.181054]  [<c012291b>] complete+0x28/0x36
[  456.181079]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.181082]  [<c013cd4b>] kthread+0x38/0x5d
[  456.181084]  [<c013cd13>] kthread+0x0/0x5d
[  456.181086]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.181088] BUG: Bad page state in process md1_resync  pfn:106db8
[  456.181090] page:c30db700 flags:80010008 count:0 mapcount:0 mapping:f4d8=
2930 index:3fa
[  456.181092] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.181094] Call Trace:
[  456.181096]  [<c01704cc>] bad_page+0xc6/0xda
[  456.181098]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.181101]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.181103]  [<c0173caa>] put_page+0x70/0x80
[  456.181126]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.181129]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.181131]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.181149]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.181151]  [<c0122990>] __wake_up+0x29/0x39
[  456.181185]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.181201]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.181226]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.181228]  [<c012291b>] complete+0x28/0x36
[  456.181255]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.181257]  [<c013cd4b>] kthread+0x38/0x5d
[  456.181260]  [<c013cd13>] kthread+0x0/0x5d
[  456.181262]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.181264] BUG: Bad page state in process md1_resync  pfn:ce8e4
[  456.181266] page:c29d1c80 flags:80010008 count:0 mapcount:0 mapping:ef0f=
6b1c index:54
[  456.181268] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.181269] Call Trace:
[  456.181271]  [<c01704cc>] bad_page+0xc6/0xda
[  456.181274]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.181276]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.181279]  [<c0173caa>] put_page+0x70/0x80
[  456.181302]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.181304]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.181306]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.181324]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.181327]  [<c0122990>] __wake_up+0x29/0x39
[  456.181360]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.181376]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.181401]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.181403]  [<c012291b>] complete+0x28/0x36
[  456.181430]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.181433]  [<c013cd4b>] kthread+0x38/0x5d
[  456.181435]  [<c013cd13>] kthread+0x0/0x5d
[  456.181437]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.181439] BUG: Bad page state in process md1_resync  pfn:cec23
[  456.181441] page:c29d8460 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1744 index:bfa
[  456.181443] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.181444] Call Trace:
[  456.181447]  [<c01704cc>] bad_page+0xc6/0xda
[  456.181449]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.181451]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.181454]  [<c0173caa>] put_page+0x70/0x80
[  456.181477]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.181479]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.181482]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.181500]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.181502]  [<c0122990>] __wake_up+0x29/0x39
[  456.181536]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.181552]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.181578]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.181580]  [<c012291b>] complete+0x28/0x36
[  456.181616]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.181619]  [<c013cd4b>] kthread+0x38/0x5d
[  456.181621]  [<c013cd13>] kthread+0x0/0x5d
[  456.181623]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.181625] BUG: Bad page state in process md1_resync  pfn:106db7
[  456.181627] page:c30db6e0 flags:80010008 count:0 mapcount:0 mapping:f4d8=
2930 index:3fb
[  456.181629] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.181631] Call Trace:
[  456.181633]  [<c01704cc>] bad_page+0xc6/0xda
[  456.181635]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.181638]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.181640]  [<c0173caa>] put_page+0x70/0x80
[  456.181663]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.181665]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.181667]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.181686]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.181688]  [<c0122990>] __wake_up+0x29/0x39
[  456.181721]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.181737]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.181762]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.181764]  [<c012291b>] complete+0x28/0x36
[  456.181789]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.181792]  [<c013cd4b>] kthread+0x38/0x5d
[  456.181794]  [<c013cd13>] kthread+0x0/0x5d
[  456.181797]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.181799] BUG: Bad page state in process md1_resync  pfn:ce902
[  456.181801] page:c29d2040 flags:80010008 count:0 mapcount:0 mapping:ef0f=
6b1c index:55
[  456.181803] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.181804] Call Trace:
[  456.181806]  [<c01704cc>] bad_page+0xc6/0xda
[  456.181809]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.181811]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.181813]  [<c0173caa>] put_page+0x70/0x80
[  456.181836]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.181838]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.181841]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.181859]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.181861]  [<c0122990>] __wake_up+0x29/0x39
[  456.181894]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.181910]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.181935]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.181937]  [<c012291b>] complete+0x28/0x36
[  456.181962]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.181965]  [<c013cd4b>] kthread+0x38/0x5d
[  456.181967]  [<c013cd13>] kthread+0x0/0x5d
[  456.181970]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.181972] BUG: Bad page state in process md1_resync  pfn:cec22
[  456.181974] page:c29d8440 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1744 index:bfb
[  456.181976] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.181977] Call Trace:
[  456.181980]  [<c01704cc>] bad_page+0xc6/0xda
[  456.181982]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.181984]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.181987]  [<c0173caa>] put_page+0x70/0x80
[  456.182009]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.182012]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.182014]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.182032]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.182034]  [<c0122990>] __wake_up+0x29/0x39
[  456.182068]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.182083]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.182108]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.182110]  [<c012291b>] complete+0x28/0x36
[  456.182136]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.182139]  [<c013cd4b>] kthread+0x38/0x5d
[  456.182141]  [<c013cd13>] kthread+0x0/0x5d
[  456.182143]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.182145] BUG: Bad page state in process md1_resync  pfn:106db6
[  456.182147] page:c30db6c0 flags:80010008 count:0 mapcount:0 mapping:f4d8=
2930 index:3fc
[  456.182149] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.182151] Call Trace:
[  456.182153]  [<c01704cc>] bad_page+0xc6/0xda
[  456.182155]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.182158]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.182160]  [<c0173caa>] put_page+0x70/0x80
[  456.182183]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.182185]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.182187]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.182205]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.182207]  [<c0122990>] __wake_up+0x29/0x39
[  456.182241]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.182256]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.182281]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.182283]  [<c012291b>] complete+0x28/0x36
[  456.182309]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.182311]  [<c013cd4b>] kthread+0x38/0x5d
[  456.182314]  [<c013cd13>] kthread+0x0/0x5d
[  456.182316]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.182318] BUG: Bad page state in process md1_resync  pfn:ce901
[  456.182320] page:c29d2020 flags:80010008 count:0 mapcount:0 mapping:ef0f=
6b1c index:56
[  456.182322] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.182323] Call Trace:
[  456.182326]  [<c01704cc>] bad_page+0xc6/0xda
[  456.182328]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.182330]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.182333]  [<c0173caa>] put_page+0x70/0x80
[  456.182355]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.182358]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.182360]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.182378]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.182380]  [<c0122990>] __wake_up+0x29/0x39
[  456.182414]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.182429]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.182454]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.182456]  [<c012291b>] complete+0x28/0x36
[  456.182482]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.182485]  [<c013cd4b>] kthread+0x38/0x5d
[  456.182487]  [<c013cd13>] kthread+0x0/0x5d
[  456.182489]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.182491] BUG: Bad page state in process md1_resync  pfn:cec21
[  456.182493] page:c29d8420 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1744 index:bfc
[  456.182495] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.182496] Call Trace:
[  456.182499]  [<c01704cc>] bad_page+0xc6/0xda
[  456.182501]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.182504]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.182506]  [<c0173caa>] put_page+0x70/0x80
[  456.182529]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.182531]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.182533]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.182551]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.182553]  [<c0122990>] __wake_up+0x29/0x39
[  456.182587]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.182602]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.182628]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.182630]  [<c012291b>] complete+0x28/0x36
[  456.182655]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.182658]  [<c013cd4b>] kthread+0x38/0x5d
[  456.182660]  [<c013cd13>] kthread+0x0/0x5d
[  456.182663]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.182665] BUG: Bad page state in process md1_resync  pfn:106db5
[  456.182667] page:c30db6a0 flags:80010008 count:0 mapcount:0 mapping:f4d8=
2930 index:3fd
[  456.182669] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.182670] Call Trace:
[  456.182672]  [<c01704cc>] bad_page+0xc6/0xda
[  456.182675]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.182677]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.182680]  [<c0173caa>] put_page+0x70/0x80
[  456.182702]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.182704]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.182706]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.182724]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.182727]  [<c0122990>] __wake_up+0x29/0x39
[  456.182760]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.182775]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.182801]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.182803]  [<c012291b>] complete+0x28/0x36
[  456.182829]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.182832]  [<c013cd4b>] kthread+0x38/0x5d
[  456.182834]  [<c013cd13>] kthread+0x0/0x5d
[  456.182836]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.182838] BUG: Bad page state in process md1_resync  pfn:1244e6
[  456.182840] page:c3489cc0 flags:80010008 count:0 mapcount:0 mapping:f4c4=
0ef4 index:5c
[  456.182842] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.182844] Call Trace:
[  456.182846]  [<c01704cc>] bad_page+0xc6/0xda
[  456.182848]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.182851]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.182853]  [<c0173caa>] put_page+0x70/0x80
[  456.182876]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.182878]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.182880]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.182898]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.182901]  [<c0122990>] __wake_up+0x29/0x39
[  456.182934]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.182949]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.182974]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.182976]  [<c012291b>] complete+0x28/0x36
[  456.183002]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.183005]  [<c013cd4b>] kthread+0x38/0x5d
[  456.183007]  [<c013cd13>] kthread+0x0/0x5d
[  456.183009]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.183011] BUG: Bad page state in process md1_resync  pfn:cec20
[  456.183013] page:c29d8400 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1744 index:bfd
[  456.183015] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.183016] Call Trace:
[  456.183019]  [<c01704cc>] bad_page+0xc6/0xda
[  456.183021]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.183024]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.183026]  [<c0173caa>] put_page+0x70/0x80
[  456.183049]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.183051]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.183054]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.183071]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.183074]  [<c0122990>] __wake_up+0x29/0x39
[  456.183107]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.183123]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.183148]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.183150]  [<c012291b>] complete+0x28/0x36
[  456.183175]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.183178]  [<c013cd4b>] kthread+0x38/0x5d
[  456.183180]  [<c013cd13>] kthread+0x0/0x5d
[  456.183183]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.183184] BUG: Bad page state in process md1_resync  pfn:106db4
[  456.183186] page:c30db680 flags:80010008 count:0 mapcount:0 mapping:f4d8=
2930 index:3fe
[  456.183188] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.183190] Call Trace:
[  456.183192]  [<c01704cc>] bad_page+0xc6/0xda
[  456.183195]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.183197]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.183199]  [<c0173caa>] put_page+0x70/0x80
[  456.183222]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.183224]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.183226]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.183244]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.183247]  [<c0122990>] __wake_up+0x29/0x39
[  456.183280]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.183296]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.183321]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.183324]  [<c012291b>] complete+0x28/0x36
[  456.183349]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.183352]  [<c013cd4b>] kthread+0x38/0x5d
[  456.183354]  [<c013cd13>] kthread+0x0/0x5d
[  456.183356]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.183358] BUG: Bad page state in process md1_resync  pfn:1244e5
[  456.183360] page:c3489ca0 flags:80010008 count:0 mapcount:0 mapping:f4c4=
0ef4 index:5d
[  456.183362] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.183364] Call Trace:
[  456.183366]  [<c01704cc>] bad_page+0xc6/0xda
[  456.183369]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.183371]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.183373]  [<c0173caa>] put_page+0x70/0x80
[  456.183396]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.183398]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.183400]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.183419]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.183421]  [<c0122990>] __wake_up+0x29/0x39
[  456.183455]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.183470]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.183495]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.183497]  [<c012291b>] complete+0x28/0x36
[  456.183523]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.183526]  [<c013cd4b>] kthread+0x38/0x5d
[  456.183528]  [<c013cd13>] kthread+0x0/0x5d
[  456.183530]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.183532] BUG: Bad page state in process md1_resync  pfn:cec1f
[  456.183534] page:c29d83e0 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1744 index:bfe
[  456.183536] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.183537] Call Trace:
[  456.183540]  [<c01704cc>] bad_page+0xc6/0xda
[  456.183542]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.183545]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.183547]  [<c0173caa>] put_page+0x70/0x80
[  456.183570]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.183572]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.183574]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.183592]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.183594]  [<c0122990>] __wake_up+0x29/0x39
[  456.183628]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.183644]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.183668]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.183671]  [<c012291b>] complete+0x28/0x36
[  456.183697]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.183699]  [<c013cd4b>] kthread+0x38/0x5d
[  456.183702]  [<c013cd13>] kthread+0x0/0x5d
[  456.183704]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.183706] BUG: Bad page state in process md1_resync  pfn:106db3
[  456.183708] page:c30db660 flags:80010008 count:0 mapcount:0 mapping:f4d8=
2930 index:3ff
[  456.183710] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.183712] Call Trace:
[  456.183714]  [<c01704cc>] bad_page+0xc6/0xda
[  456.183716]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.183719]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.183721]  [<c0173caa>] put_page+0x70/0x80
[  456.183744]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.183746]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.183749]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.183767]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.183769]  [<c0122990>] __wake_up+0x29/0x39
[  456.183803]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.183818]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.183843]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.183846]  [<c012291b>] complete+0x28/0x36
[  456.183871]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.183874]  [<c013cd4b>] kthread+0x38/0x5d
[  456.183876]  [<c013cd13>] kthread+0x0/0x5d
[  456.183879]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.183881] BUG: Bad page state in process md1_resync  pfn:1244e4
[  456.183883] page:c3489c80 flags:80010008 count:0 mapcount:0 mapping:f4c4=
0ef4 index:5e
[  456.183885] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.183886] Call Trace:
[  456.183888]  [<c01704cc>] bad_page+0xc6/0xda
[  456.183891]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.183893]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.183896]  [<c0173caa>] put_page+0x70/0x80
[  456.183918]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.183921]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.183923]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.183941]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.183943]  [<c0122990>] __wake_up+0x29/0x39
[  456.183976]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.183992]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.184031]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.184033]  [<c012291b>] complete+0x28/0x36
[  456.184059]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.184062]  [<c013cd4b>] kthread+0x38/0x5d
[  456.184064]  [<c013cd13>] kthread+0x0/0x5d
[  456.184066]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  456.184068] BUG: Bad page state in process md1_resync  pfn:cec1e
[  456.184070] page:c29d83c0 flags:80010008 count:0 mapcount:0 mapping:f4e1=
1744 index:bff
[  456.184073] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  456.184074] Call Trace:
[  456.184076]  [<c01704cc>] bad_page+0xc6/0xda
[  456.184079]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  456.184081]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  456.184084]  [<c0173caa>] put_page+0x70/0x80
[  456.184106]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  456.184109]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  456.184111]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  456.184129]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  456.184132]  [<c0122990>] __wake_up+0x29/0x39
[  456.184165]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  456.184181]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  456.184206]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  456.184208]  [<c012291b>] complete+0x28/0x36
[  456.184234]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  456.184237]  [<c013cd4b>] kthread+0x38/0x5d
[  456.184239]  [<c013cd13>] kthread+0x0/0x5d
[  456.184241]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  471.129662] BUG: Bad page state in process md1_resync  pfn:19059
[  471.147658] page:c1320b20 flags:4000000c count:0 mapcount:0 mapping:f4c3=
b230 index:59805bb
[  471.148683] BUG: Bad page state in process md9_resync  pfn:28162
[  471.148686] page:c1502c40 flags:40000000 count:-51 mapcount:0 mapping:(n=
ull) index:10d1a
[  471.148690] Pid: 4320, comm: md9_resync Tainted: G    B      2.6.29-1-68=
6-bigmem #1
[  471.148691] Call Trace:
[  471.148697]  [<c01704cc>] bad_page+0xc6/0xda
[  471.148700]  [<c017130c>] get_page_from_freelist+0x31b/0x3f3
[  471.148703]  [<c0106c5f>] __switch_to_xtra+0x116/0x143
[  471.148706]  [<c01716d0>] __alloc_pages_internal+0x138/0x398
[  471.148741]  [<f83cab1d>] r1buf_pool_alloc+0x8f/0x164 [raid1]
[  471.148744]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  471.148747]  [<c012800e>] default_wake_function+0x0/0x8
[  471.148768]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  471.148805]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  471.148822]  [<c0128005>] try_to_wake_up+0x14e/0x157
[  471.148849]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  471.148851]  [<c012291b>] complete+0x28/0x36
[  471.148878]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  471.148881]  [<c013cd4b>] kthread+0x38/0x5d
[  471.148884]  [<c013cd13>] kthread+0x0/0x5d
[  471.148886]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  471.485084] Pid: 10385, comm: md1_resync Tainted: G    B      2.6.29-1-6=
86-bigmem #1
[  471.508275] Call Trace:
[  471.508281]  [<c01704cc>] bad_page+0xc6/0xda
[  471.508284]  [<c0170cb7>] free_pages_check+0x8d/0xac
[  471.508287]  [<c0170e1e>] free_hot_cold_page+0x22/0x153
[  471.508290]  [<c0173caa>] put_page+0x70/0x80
[  471.508323]  [<f83cabaa>] r1buf_pool_alloc+0x11c/0x164 [raid1]
[  471.508326]  [<c016ebaf>] mempool_alloc+0x27/0xcb
[  471.508328]  [<c01ac3f2>] bio_add_page+0x28/0x2e
[  471.508348]  [<f83cae54>] sync_request+0x1fd/0x5ee [raid1]
[  471.508381]  [<f84ecd5b>] md_do_sync+0x6d4/0xb60 [md_mod]
[  471.508398]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  471.508423]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  471.508426]  [<c012291b>] complete+0x28/0x36
[  471.508452]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  471.508455]  [<c013cd4b>] kthread+0x38/0x5d
[  471.508458]  [<c013cd13>] kthread+0x0/0x5d
[  471.508460]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  475.564635] ------------[ cut here ]------------
[  475.568239] kernel BUG at /build/buildd-linux-2.6_2.6.29-2-i386-SgPO4R/l=
inux-2.6-2.6.29/debian/build/source_i386_none/mm/page_alloc.c:423!
[  475.568239] invalid opcode: 0000 [#1] SMP=20
[  475.568239] last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
[  475.568239] Modules linked in: tcp_diag i915 drm binfmt_misc ipt_ULOG in=
et_diag ipx p8023 xt_multiport iptable_filter ip_tables x_tables iTCO_wdt a=
cpi_cpufreq cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conse=
rvative microcode ipcomp6 xfrm6_tunnel tunnel6 esp6 ah6 ipcomp xfrm_ipcomp =
esp4 ah4 xfrm_user cts arc4 authenc tea xor seqiv salsa20_generic anubis rm=
d256 lzo lzo_decompress lzo_compress ccm lrw ecb gcm crc32c cast5 seed ansi=
_cprng fcrypt michael_mic cast6 wp512 tgr192 rmd128 khazad rmd320 pcbc sha5=
12_generic md4 deflate zlib_deflate zlib_inflate ctr twofish twofish_common=
 camellia serpent blowfish des_generic cbc xcbc rmd160 sha256_generic sha1_=
generic hmac crypto_null af_key xfs exportfs ext3 jbd fuse ipv6 sg eeprom c=
oretemp w83627ehf hwmon_vid i2c_dev floppy tuner_simple tuner_types tuner t=
vaudio msp3400 snd_hda_codec_realtek bttv ir_common snd_hda_intel snd_hda_c=
odec snd_bt87x i2c_algo_bit snd_hwdep snd_pcm_oss snd_mixer_oss v4l2_common=
 snd_pcm snd_seq_dummy videodev snd_seq_oss v4l1_compat snd_seq_midi snd_ra=
wmidi videobuf_dma_sg videobuf_core snd_seq_midi_event snd_seq psmouse btcx=
_risc snd_timer serio_raw tveeprom snd_seq_device pcspkr snd evdev i2c_i801=
 soundcore ppdev i2c_core snd_page_alloc parport_pc parport button ext2 mbc=
ache aes_i586 aes_generic xts gf128mul dm_crypt dm_snapshot raid1 md_mod sd=
_mod crc_t10dif ide_cd_mod cdrom ata_generic ide_pci_generic ahci libata fi=
rewire_ohci firewire_core crc_itu_t uhci_hcd atl1 mii jmicron ide_core scsi=
_mod ehci_hcd usbcore intel_agp agpgart thermal processor fan thermal_sys d=
m_mirror dm_region_hash dm_log dm_mod
[  475.692503]=20
[  475.692503] Pid: 1474, comm: md1_raid1 Tainted: G    B      (2.6.29-1-68=
6-bigmem #1) P5E-V HDMI
[  475.692503] EIP: 0060:[<c01705e4>] EFLAGS: 00010086 CPU: 0
[  475.692503] EIP is at __free_one_page+0x104/0x1a0
[  475.692503] EAX: fffffffa EBX: 40040000 ECX: c1071940 EDX: 00000000
[  475.692503] ESI: 000000cb EDI: c1071960 EBP: c03d342c ESP: f5cbfe30
[  475.692503]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  475.692503] Process md1_raid1 (pid: 1474, ti=3Df5cbe000 task=3Df65c8030 =
task.ti=3Df5cbe000)
[  475.692503] Stack:
[  475.692503]  00000000 c03d2be0 00000001 00000003 00000001 00000008 c03d2=
be0 c03d2c0c
[  475.692503]  00000b00 c01706d9 00000020 c03d2be0 00000000 c0170f12 00000=
000 00000000
[  475.692503]  00000202 00000000 000000a8 cc9e1d30 cc9e1d00 f83caa5c f64cb=
c60 e439a2c0
[  475.692503] Call Trace:
[  475.692503]  [<c01706d9>] free_pages_bulk+0x59/0x6d
[  475.692503]  [<c0170f12>] free_hot_cold_page+0x116/0x153
[  475.692503]  [<f83caa5c>] r1buf_pool_free+0x41/0x73 [raid1]
[  475.692503]  [<c016eb85>] mempool_free+0x61/0x64
[  475.692503]  [<f83cac4c>] put_buf+0x5a/0x65 [raid1]
[  475.692503]  [<f83cc21c>] raid1d+0x692/0xc7b [raid1]
[  475.692503]  [<c01240bc>] pick_next_task_fair+0x80/0x87
[  475.692503]  [<c0131432>] __do_softirq+0x8c/0x130
[  475.692503]  [<c013164a>] irq_exit+0x40/0x62
[  475.692503]  [<c0109e7d>] do_IRQ+0x64/0x77
[  475.692503]  [<c02f2b6f>] schedule_timeout+0x14/0xbb
[  475.692503]  [<c011c582>] default_spin_lock_flags+0x5/0x7
[  475.692503]  [<c02f3b71>] _spin_lock_irqsave+0x25/0x2b
[  475.692503]  [<f84ed5e3>] md_thread+0xdd/0xf4 [md_mod]
[  475.692503]  [<c013d012>] autoremove_wake_function+0x0/0x2d
[  475.692503]  [<f84ed506>] md_thread+0x0/0xf4 [md_mod]
[  475.692503]  [<c013cd4b>] kthread+0x38/0x5d
[  475.692503]  [<c013cd13>] kthread+0x0/0x5d
[  475.692503]  [<c0108933>] kernel_thread_helper+0x7/0x10
[  475.692503] Code: c1 e8 1e 89 da c1 ea 1e 39 d0 75 29 f7 c3 00 00 04 00 =
74 21 8b 14 24 39 51 0c 75 19 80 e7 40 89 d0 0f 44 c1 8b 40 04 85 c0 74 4f =
<0f> 0b eb fe 83 3c 24 09 76 af 8b 0c 24 89 4f 0c 0f ba 2f 12 8b=20
[  475.692503] EIP: [<c01705e4>] __free_one_page+0x104/0x1a0 SS:ESP 0068:f5=
cbfe30
[  475.692503] ---[ end trace b94fbbe2525f50ca ]---

--ZGiS0Q5IWpPtfppv--

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUBSegzBRS+e2HeSPbpAQLu3wf+Kup5HZZXFPxI7XpoBS4O3fBZJ2afEKre
ucXdJ7Otd1aXbMjVkQbeNSzCQRuvKZMBA9fXMV8bRBNt5Nm/pk8Oeg4r6JdN02VC
4HiUN/FzHjk6O2IiRMkslke0vhe28BZYFjJTJryKkxOUazTESEajT2ZEOqPre3QF
PFg7g1buLCp2UdTVq1yCKqg8DAdjKbZU2S0sEtu8Jns1FDHGH+3uNFjWwkIJQyma
aYBUD1jLt1tRzrVKTxeIW9fT4gvvCf+vkzGB3SyWmzrf5cOskdk+OrNXe2llsylp
3YwX0eDWDdzjl5PF1aSFMHzvATu4L9MOXqkbEryTGxNN4s2BvJH+Qw==
=3gFQ
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
