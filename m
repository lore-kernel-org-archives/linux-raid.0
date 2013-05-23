From: Robert Goliasz <r.goliasz@digital-science.com>
Subject: Attempt to change raid1 to raid0 results in division error in kernel
Date: Thu, 23 May 2013 11:44:00 +0100
Message-ID: <20130523104400.GA827@gbl-macbook>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=e89a8f234ce55eb46d04dd605c4d
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--e89a8f234ce55eb46d04dd605c4d
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

When attempting to change raid level from 1 to 0 (I was doing some testing
trying to convert a raid1 array to a raid10 one), I got a division error.

I'm on Debian sid, output of uname -a is:

  Linux gbl-macbook 3.2.0-4-amd64 #1 SMP Debian 3.2.35-2 x86_64 GNU/Linux

I had the following raid set up (using devices on LVM):

  gbl-macbook# cat /proc/mdstat=20
  Personalities : [raid1] [raid0] [raid10]=20
  md0 : active raid1 md1[2] md2[1]
        409280 blocks super 1.2 [2/2] [UU]
       =20
  md2 : active raid0 dm-8[1] dm-7[0]
        1022976 blocks super 1.2 512k chunks
       =20
  md1 : active raid0 dm-6[1] dm-5[0]
        1022976 blocks super 1.2 512k chunks
       =20
  unused devices: <none>

/dev/md0 was a mounted ext4 filesystem.

I attempted to run this:

  gbl-macbook# mdadm --grow /dev/md0 -l 0
  zsh: segmentation fault  mdadm --grow /dev/md0 -l 0
  gbl-macbook#=20

All my terminals have shown the following alert:

  Message from syslogd@gbl-macbook at May 23 11:26:11 ...
   kernel:[569106.802042] divide error: 0000 [#1] SMP=20
 =20
  Message from syslogd@gbl-macbook at May 23 11:26:11 ...
   kernel:[569106.802393] Stack:
 =20
  Message from syslogd@gbl-macbook at May 23 11:26:11 ...
   kernel:[569106.802430] Call Trace:
 =20
  Message from syslogd@gbl-macbook at May 23 11:26:11 ...
   kernel:[569106.802519] Code: 4c 24 18 49 8b 6c 24 18 48 89 4c 24 18 eb 6=
b 48 8b 7d 30 48 8d 74 24 38 e8 d4 16 af e0 49 63 8c 24 bc 00 00 00 48 8b 4=
5 10 31 d2 <48> f7 f1 48 0f af c1 48 89 45 10 4d 8b 6c 24 18 eb 2f 49 8b 7d=
=20
 =20
Here's the relevant output from dmesg:

  [569106.729859] RAID1 conf printout:
  [569106.729870]  --- wd:1 rd:2
  [569106.729878]  disk 0, wo:0, o:1, dev:md1
  [569106.734368] md: unbind<md2>
  [569106.795283] md: export_rdev(md2)
  [569106.802042] divide error: 0000 [#1] SMP=20
  [569106.802053] CPU 0=20
  [569106.802057] Modules linked in: raid10 raid0 ext4 jbd2 mbcache raid1 m=
d_mod b43 bcma asix usbnet mii nls_cp437 vfat fat nls_utf8 hfsplus usb_stor=
age cdc_acm snd_usb_audio snd_usbmidi_lib ip6table_filter ip6_tables iptabl=
e_filter ip_tables ebtable_nat ebtables x_tables parport_pc ppdev lp parpor=
t rfcomm bnep pci_stub cpufreq_stats vboxpci(O) cpufreq_userspace cpufreq_p=
owersave cpufreq_conservative vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt=
_misc uinput nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc loop firewir=
e_sbp2 fuse kvm_intel kvm uvcvideo videodev v4l2_compat_ioctl32 media snd_h=
da_codec_hdmi btusb bluetooth crc16 bcm5974 snd_hda_codec_cirrus joydev snd=
_hda_intel snd_hda_codec snd_pcm_oss snd_hwdep snd_mixer_oss snd_pcm snd_pa=
ge_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi arc4 snd_seq snd_seq_d=
evice snd_timer coretemp mac80211 cfg80211 rfkill ssb rng_core applesmc pcm=
cia i2c_i801 pcmcia_core crc32c_intel snd iTCO_wdt acpi_cpufreq soundcore g=
hash_clmulni_intel aesni_intel aes_x86_64 aes_generic evdev i2c_core iTCO_v=
endor_support mperf cryptd input_polldev pcspkr fglrx(P) battery video ac a=
pple_bl(O) button processor power_supply thermal_sys xfs hid_microsoft dm_m=
od sg sr_mod sd_mod cdrom crc_t10dif ata_generic hid_apple usbhid hid uhci_=
hcd ata_piix libata firewire_ohci scsi_mod firewire_core crc_itu_t sdhci_pc=
i ehci_hcd sdhci mmc_core tg3 usbcore libphy usb_common [last unloaded: bcm=
a]
  [569106.802283]=20
  [569106.802290] Pid: 30710, comm: mdadm Tainted: P           O 3.2.0-4-am=
d64 #1 Debian 3.2.35-2 Apple Inc. MacBookPro8,2/Mac-94245A3940C91C80
  [569106.802302] RIP: 0010:[<ffffffffa065745b>]  [<ffffffffa065745b>] crea=
te_strip_zones+0x71/0x491 [raid0]
  [569106.802320] RSP: 0018:ffff8801a8a77d48  EFLAGS: 00010246
  [569106.802325] RAX: 00000000001f3600 RBX: ffff88012ccf5920 RCX: 00000000=
00000000
  [569106.802331] RDX: 0000000000000000 RSI: fffffffffffffffb RDI: ffff8802=
5151540c
  [569106.802337] RBP: ffff880254d2f000 R08: 00000000fffffffd R09: ffff8802=
5151ffff
  [569106.802343] R10: ffffffff81600000 R11: ffffffff81600000 R12: ffff8804=
2f058c00
  [569106.802349] R13: ffff8801beb09000 R14: 0000000000000005 R15: ffff8804=
2f058c18
  [569106.802356] FS:  00007f6027661700(0000) GS:ffff88046fa00000(0000) knl=
GS:0000000000000000
  [569106.802363] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  [569106.802368] CR2: 000000000041f820 CR3: 00000001916d0000 CR4: 00000000=
000406f0
  [569106.802375] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000=
00000000
  [569106.802381] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000=
00000400
  [569106.802388] Process mdadm (pid: 30710, threadinfo ffff8801a8a76000, t=
ask ffff880116fee380)
  [569106.802393] Stack:
  [569106.802397]  00000000fffffff4 0000000000000001 0000000000000001 ffff8=
8042f058c18
  [569106.802408]  0000000000000000 ffff8801a8a77e10 ffff8801a8a77e28 ffff8=
8010031646d
  [569106.802419]  30646961722d646d ffff880100000000 ffff88046fdfcc08 00000=
04081109b2e
  [569106.802430] Call Trace:
  [569106.802442]  [<ffffffffa0657b11>] ? raid0_takeover+0x1c3/0x1e5 [raid0=
]
  [569106.802456]  [<ffffffffa066d409>] ? level_store+0x21b/0x52b [md_mod]
  [569106.802470]  [<ffffffffa066ec77>] ? md_attr_store+0x9a/0xbc [md_mod]
  [569106.802483]  [<ffffffff8114e4e7>] ? sysfs_write_file+0xe0/0x11c
  [569106.802494]  [<ffffffff810f9cc5>] ? vfs_write+0xa2/0xe9
  [569106.802502]  [<ffffffff810f9ea2>] ? sys_write+0x45/0x6b
  [569106.802515]  [<ffffffff81352012>] ? system_call_fastpath+0x16/0x1b
  [569106.802519] Code: 4c 24 18 49 8b 6c 24 18 48 89 4c 24 18 eb 6b 48 8b =
7d 30 48 8d 74 24 38 e8 d4 16 af e0 49 63 8c 24 bc 00 00 00 48 8b 45 10 31 =
d2 <48> f7 f1 48 0f af c1 48 89 45 10 4d 8b 6c 24 18 eb 2f 49 8b 7d=20
  [569106.802594] RIP  [<ffffffffa065745b>] create_strip_zones+0x71/0x491 [=
raid0]
  [569106.802604]  RSP <ffff8801a8a77d48>
  [569106.802688] ---[ end trace dc1acf1d4fa82dd5 ]---

Afterwards, my mounted filesystem (/dev/md0) disappeared (it's no longer
mounted), and all operations related to software raid seem to fail:

  gbl-macbook# umount /dev/md0
  ^C^C^C^C
  <hangs forever>

  11:41:38 goblin@gbl-macbook:~ % cat /proc/mdstat=20
  <hangs forever but is Ctrl-Cable>

I haven't attempted to re-produce this yet.

--=20
Robert Goliasz
Infrastructure Engineer

--=20
***************************************************************************=
*****=20
 =20
DISCLAIMER: This e-mail is confidential and should not be used by anyone=20
who is
not the original intended recipient. If you have received this e-mail in=20
error
please inform the sender and delete it from your mailbox or any other=20
storage
mechanism. Neither Macmillan Publishers Limited nor any of its agents accep=
t
liability for any statements made which are clearly the sender's own and no=
t
expressly made on behalf of Macmillan Publishers Limited or one of its=20
agents.
Please note that neither Macmillan Publishers Limited nor any of its agents
accept any responsibility for viruses that may be contained in this e-mail=
=20
or
its attachments and it is your responsibility to scan the e-mail and=20
attachments (if any). No contracts may be concluded on behalf of Macmillan=
=20
Publishers Limited or its agents by means of e-mail communication.=20
Macmillan=20
Publishers Limited Registered in England and Wales with registered number=
=20
785998=20
Registered Office Brunel Road, Houndmills, Basingstoke RG21 6XS  =20
***************************************************************************=
*****


--e89a8f234ce55eb46d04dd605c4d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iF4EAREIAAYFAlGd8vAACgkQd2qCTldmJReyPQEAimY1s0G1vckjCkfkPOn2h0hm
8hbPRSezB/1pz8fISSgA/R014GTbio6dnCTZCOX9OaVNbu7qK4CDIjjKWAHNZMWj
=R/7D
-----END PGP SIGNATURE-----

--e89a8f234ce55eb46d04dd605c4d--
