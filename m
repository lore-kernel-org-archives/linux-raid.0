From: Sebastian Reichel <elektranox@gmail.com>
Subject: Re: power outage while raid5->raid6 was in progress
Date: Thu, 8 Jul 2010 10:48:37 +0200
Message-ID: <20100708084837.GA7410@earth.universe>
References: <20100707204110.GB1207@earth.universe>
 <20100708084450.7abb19d8@notabene.brown>
 <20100707231316.GA6496@earth.universe>
 <20100708112144.1b70d6da@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100708112144.1b70d6da@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 08, 2010 at 11:21:44AM +1000, Neil Brown wrote:
> On Thu, 8 Jul 2010 01:13:16 +0200
> Sebastian Reichel <elektranox@gmail.com> wrote:
>=20
> > On Thu, Jul 08, 2010 at 08:44:50AM +1000, Neil Brown wrote:
> > > On Wed, 7 Jul 2010 22:41:10 +0200
> > > Sebastian Reichel <elektranox@gmail.com> wrote:
> > >=20
> > > > Hi,
> > > >=20
> > > > I have some problems with my raid. I tried updating from 5 disks ra=
id5 to 8 disks
> > > > raid6 as described on http://neil.brown.name/blog/20090817000931#2.=
 The command I
> > > > used was: mdadm --grow /dev/md0 --level=3D6 --raid-disk=3D8
> > > >=20
> > > > While the rebuild was in progress my system hung, so I had to force=
 power down it.
> > > > After rebooting the system I reassembled the raid. You can see the =
resulting mess
> > > > below. How can I recover from this state?
> > >=20
> > > Please report the output of
> > >=20
> > >   mdadm -E /dev/sd[efghijkl]1
> > >=20
> > > then I'll see what can be done.
> >=20
> > thank you for having a look at it :)
>=20
>=20
> It appears that the RAID5 -> RAID6 conversion (which is instantaneous, but
> results in a non-standard RAID6 parity layout) happened, but the=20
> 6disk -> 8disk reshape which would have been combined with producing a
> more standard RAID6 parity layout did not even begin.
> I don't know why that would be.  Do you remember seeing the reshape being
> under-way in /proc/mdstat at all??
>
> If you didn't them I am very confused and the following is not at all
> reliable.  If you didn't and you only assumed a reshape was happening, th=
en
> read on.
>=20
> [...]
>=20
> But if you are sure the reshape actually started the first time, don't do
> any of this.  Rather try to find some earlier kernel logs that show the
> reshape starting, and maybe show what caused the crash.

Yes, I saw the reshape via /proc/mdstat, it already passed 30% iirc.
Here are the interesting parts of the kernel log:

Jul  6 21:09:14 mars kernel: [ 7716.935683] RAID5 conf printout:
Jul  6 21:09:14 mars kernel: [ 7716.935688]  --- rd:5 wd:5
Jul  6 21:09:14 mars kernel: [ 7716.935691]  disk 0, o:1, dev:sdk1
Jul  6 21:09:14 mars kernel: [ 7716.935693]  disk 1, o:1, dev:sde1
Jul  6 21:09:14 mars kernel: [ 7716.935695]  disk 2, o:1, dev:sdl1
Jul  6 21:09:14 mars kernel: [ 7716.935696]  disk 3, o:1, dev:sdj1
Jul  6 21:09:14 mars kernel: [ 7716.935698]  disk 4, o:1, dev:sdi1
Jul  6 21:10:04 mars kernel: [ 7766.940183] raid5: device sdk1 operational =
as raid disk 0
Jul  6 21:10:04 mars kernel: [ 7766.940186] raid5: device sdi1 operational =
as raid disk 4
Jul  6 21:10:04 mars kernel: [ 7766.940189] raid5: device sdj1 operational =
as raid disk 3
Jul  6 21:10:04 mars kernel: [ 7766.940191] raid5: device sdl1 operational =
as raid disk 2
Jul  6 21:10:04 mars kernel: [ 7766.940193] raid5: device sde1 operational =
as raid disk 1
Jul  6 21:10:04 mars kernel: [ 7766.940840] raid5: allocated 6386kB for md0
Jul  6 21:10:04 mars kernel: [ 7766.952476] 0: w=3D1 pa=3D0 pr=3D6 m=3D2 a=
=3D18 r=3D6 op1=3D0 op2=3D0
Jul  6 21:10:04 mars kernel: [ 7766.952480] 4: w=3D2 pa=3D0 pr=3D6 m=3D2 a=
=3D18 r=3D6 op1=3D0 op2=3D0
Jul  6 21:10:04 mars kernel: [ 7766.952482] 3: w=3D3 pa=3D0 pr=3D6 m=3D2 a=
=3D18 r=3D6 op1=3D0 op2=3D0
Jul  6 21:10:04 mars kernel: [ 7766.952485] 2: w=3D4 pa=3D0 pr=3D6 m=3D2 a=
=3D18 r=3D6 op1=3D0 op2=3D0
Jul  6 21:10:04 mars kernel: [ 7766.952487] 1: w=3D5 pa=3D0 pr=3D6 m=3D2 a=
=3D18 r=3D6 op1=3D0 op2=3D0
Jul  6 21:10:04 mars kernel: [ 7766.952490] raid5: raid level 6 set md0 act=
ive with 5 out of 6 devices, algorithm 18
Jul  6 21:10:04 mars kernel: [ 7766.952516] RAID5 conf printout:
Jul  6 21:10:04 mars kernel: [ 7766.952517]  --- rd:6 wd:5
Jul  6 21:10:04 mars kernel: [ 7766.952520]  disk 0, o:1, dev:sdk1
Jul  6 21:10:04 mars kernel: [ 7766.952522]  disk 1, o:1, dev:sde1
Jul  6 21:10:04 mars kernel: [ 7766.952523]  disk 2, o:1, dev:sdl1
Jul  6 21:10:04 mars kernel: [ 7766.952525]  disk 3, o:1, dev:sdj1
Jul  6 21:10:04 mars kernel: [ 7766.952527]  disk 4, o:1, dev:sdi1
Jul  6 21:10:04 mars kernel: [ 7766.952536] ------------[ cut here ]-------=
-----
Jul  6 21:10:04 mars kernel: [ 7766.952542] WARNING: at /build/buildd-linux=
-2.6_2.6.34-1~experimental.2-amd64-zn0ozk/linux-2.6-2.6.34/debian/build/sou=
rce_amd64_none/fs/sysfs/dir.c:451 sysfs_add_one+0xcc/0xe3()
Jul  6 21:10:04 mars kernel: [ 7766.952545] Hardware name: System Product N=
ame
Jul  6 21:10:04 mars kernel: [ 7766.952547] sysfs: cannot create duplicate =
filename '/devices/virtual/block/md0/md/stripe_cache_size'
Jul  6 21:10:04 mars kernel: [ 7766.952549] Modules linked in: ip6t_LOG xt_=
hl nf_conntrack_ipv6 ipt_REJECT ipt_LOG xt_limit xt_tcpudp ipt_addrtype ipt=
_MASQUERADE iptable_nat xt_state ip6table_filter ip6_tables nf_nat_irc nf_c=
onntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrac=
k_ftp nf_conntrack iptable_filter ip_tables x_tables nfsd nfs lockd fscache=
 nfs_acl auth_rpcgss sunrpc pppoe pppox ppp_generic xfs exportfs rr272x_1x(=
P) hwmon_vid loop sha256_generic aes_x86_64 aes_generic cbc dm_crypt dm_mod=
 arc4 ecb dvb_pll ath5k hfcpci mac80211 stv0299 b2c2_flexcop_pci mISDN_core=
 ath b2c2_flexcop hisax dvb_core snd_pcm cx24123 snd_timer crc_ccitt cfg802=
11 cx24113 isdn snd rfkill s5h1420 soundcore i2c_nforce2 evdev pcspkr led_c=
lass snd_page_alloc edac_core edac_mce_amd i2c_core k8temp slhc tpm_tis tpm=
 tpm_bios processor button asus_atk0110 ext3 jbd mbcache raid456 md_mod asy=
nc_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx ohci_h=
cd sd_mod crc_t10dif ata_generic fan firewire_ohci
Jul  6 21:10:04 mars kernel: ehci_hcd pata_amd firewire_core crc_itu_t ther=
mal thermal_sys sata_nv usbcore nls_base libata forcedeth scsi_mod [last un=
loaded: scsi_wait_scan]
Jul  6 21:10:04 mars kernel: [ 7766.952622] Pid: 6844, comm: mdadm Tainted:=
 P        W  2.6.34-1-amd64 #1
Jul  6 21:10:04 mars kernel: [ 7766.952624] Call Trace:
Jul  6 21:10:04 mars kernel: [ 7766.952630]  [<ffffffff81045655>] ? warn_sl=
owpath_common+0x76/0x8c
Jul  6 21:10:04 mars kernel: [ 7766.952635]  [<ffffffff810456bd>] ? warn_sl=
owpath_fmt+0x40/0x45
Jul  6 21:10:04 mars kernel: [ 7766.952638]  [<ffffffff81138209>] ? sysfs_a=
dd_one+0xcc/0xe3
Jul  6 21:10:04 mars kernel: [ 7766.952642]  [<ffffffff81137416>] ? sysfs_a=
dd_file_mode+0x4b/0x7d
Jul  6 21:10:04 mars kernel: [ 7766.952646]  [<ffffffff8113933c>] ? interna=
l_create_group+0xdd/0x16b
Jul  6 21:10:04 mars kernel: [ 7766.952652]  [<ffffffffa01a0f67>] ? run+0x4=
fa/0x685 [raid456]
Jul  6 21:10:04 mars kernel: [ 7766.952660]  [<ffffffffa0181b20>] ? level_s=
tore+0x3b7/0x42e [md_mod]
Jul  6 21:10:04 mars kernel: [ 7766.952667]  [<ffffffffa017eb1f>] ? md_attr=
_store+0x77/0x96 [md_mod]
Jul  6 21:10:04 mars kernel: [ 7766.952670]  [<ffffffff81136ede>] ? sysfs_w=
rite_file+0xe3/0x11f
Jul  6 21:10:04 mars kernel: [ 7766.952674]  [<ffffffff810e7bc6>] ? vfs_wri=
te+0xa4/0x101
Jul  6 21:10:04 mars kernel: [ 7766.952677]  [<ffffffff810e7cd6>] ? sys_wri=
te+0x45/0x6b
Jul  6 21:10:04 mars kernel: [ 7766.952680]  [<ffffffff810089c2>] ? system_=
call_fastpath+0x16/0x1b
Jul  6 21:10:04 mars kernel: [ 7766.952682] ---[ end trace 2d8a2ef8dd7ca7b7=
 ]---
Jul  6 21:10:04 mars kernel: [ 7766.952687] raid5: failed to create sysfs a=
ttributes for md0
Jul  6 21:21:10 mars kernel: [ 8432.471242] md: md0 stopped.
[...]
Jul  6 21:25:23 mars kernel: [ 8685.659605] raid5: raid level 6 set md0 act=
ive with 5 out of 6 devices, algorithm 18
Jul  6 21:25:23 mars kernel: [ 8685.659631] RAID5 conf printout:
Jul  6 21:25:23 mars kernel: [ 8685.659632]  --- rd:6 wd:5
Jul  6 21:25:23 mars kernel: [ 8685.659634]  disk 0, o:1, dev:sdk1
Jul  6 21:25:23 mars kernel: [ 8685.659636]  disk 1, o:1, dev:sde1
Jul  6 21:25:23 mars kernel: [ 8685.659638]  disk 2, o:1, dev:sdl1
Jul  6 21:25:23 mars kernel: [ 8685.659640]  disk 3, o:1, dev:sdj1
Jul  6 21:25:23 mars kernel: [ 8685.659641]  disk 4, o:1, dev:sdi1
Jul  6 21:25:23 mars kernel: [ 8685.659677] md0: detected capacity change f=
rom 0 to 6001196793856
Jul  6 21:25:23 mars kernel: [ 8685.659813]  md0: unknown partition table
[...]
Jul  6 21:28:16 mars kernel: [ 8858.893402] md: recovery of RAID array md0
Jul  6 21:28:16 mars kernel: [ 8858.893405] md: minimum _guaranteed_  speed=
: 1000 KB/sec/disk.
Jul  6 21:28:16 mars kernel: [ 8858.893407] md: using maximum available idl=
e IO bandwidth (but not more than 200000 KB/sec) for recovery.
Jul  6 21:28:16 mars kernel: [ 8858.893422] md: using 128k window, over a t=
otal of 1465135936 blocks.
[...]
Jul  6 21:31:18 mars kernel: [ 9040.089434] rr272x_1x:Device error informat=
ion 0x1000000
Jul  6 21:31:18 mars kernel: [ 9040.089440] rr272x_1x:Task file error, Stat=
usReg=3D0x41, ErrReg=3D0x4, LBA[0-3]=3D0x17fbec6,LBA[4-7]=3D0x0.
[...] (more of these messages)
Jul  6 23:54:20 mars kernel: [17622.164846] sd 8:0:6:0: [sdk] Unhandled err=
or code
Jul  6 23:54:20 mars kernel: [17622.164848] sd 8:0:6:0: [sdk] Result: hostb=
yte=3DDID_ABORT driverbyte=3DDRIVER_INVALID
Jul  6 23:54:20 mars kernel: [17622.164851] sd 8:0:6:0: [sdk] CDB: Read(10)=
: 28 00 49 ff 72 3f 00 00 38 00
Jul  6 23:54:20 mars kernel: [17622.164858] end_request: I/O error, dev sdk=
, sector 1241477695
Jul  6 23:54:20 mars kernel: [17622.181377] raid5:md0: read error corrected=
 (8 sectors at 1241477632 on sdk1)
Jul  6 23:54:20 mars kernel: [17622.181503] raid5:md0: read error corrected=
 (8 sectors at 1241477640 on sdk1)
Jul  6 23:54:20 mars kernel: [17622.181507] raid5:md0: read error corrected=
 (8 sectors at 1241477648 on sdk1)
Jul  6 23:54:20 mars kernel: [17622.181510] raid5:md0: read error corrected=
 (8 sectors at 1241477656 on sdk1)
Jul  6 23:54:20 mars kernel: [17622.181512] raid5:md0: read error corrected=
 (8 sectors at 1241477664 on sdk1)
Jul  6 23:54:20 mars kernel: [17622.181515] raid5:md0: read error corrected=
 (8 sectors at 1241477672 on sdk1)
Jul  6 23:54:20 mars kernel: [17622.181518] raid5:md0: read error corrected=
 (8 sectors at 1241477680 on sdk1)
[...] (more sdk failures)
Jul  6 23:58:38 mars kernel: [17880.544030] INFO: task md0_resync:13565 blo=
cked for more than 120 seconds.
Jul  6 23:58:38 mars kernel: [17880.544109] md0_resync    D ffff88007cdf950=
0     0 13565      2 0x00000000
Jul  6 23:58:38 mars kernel: [17880.544114]  ffff88007cdf9500 0000000000000=
046 0000000000000086 ffff88007400a800
Jul  6 23:58:38 mars kernel: [17880.544117]  ffff88007ce25400 0000000000015=
200 0000000000015200 0000000000015200
Jul  6 23:58:38 mars kernel: [17880.544120]  ffff88006baf5fd8 0000000000015=
200 ffff88007cdf9500 ffff88006baf5fd8
Jul  6 23:58:38 mars kernel: [17880.544124] Call Trace:
Jul  6 23:58:38 mars kernel: [17880.544145]  [<ffffffffa019bdef>] ? unplug_=
slaves+0x70/0xa6 [raid456]
Jul  6 23:58:38 mars kernel: [17880.544150]  [<ffffffffa019c17e>] ? get_act=
ive_stripe+0x26f/0x54b [raid456]
Jul  6 23:58:38 mars kernel: [17880.544154]  [<ffffffff81040b38>] ? default=
_wake_function+0x0/0xf
Jul  6 23:58:38 mars kernel: [17880.544159]  [<ffffffffa019ef3b>] ? sync_re=
quest+0x245/0x2d1 [raid456]
Jul  6 23:58:38 mars kernel: [17880.544166]  [<ffffffffa01809d4>] ? is_mdde=
v_idle+0xa2/0xf5 [md_mod]
Jul  6 23:58:38 mars kernel: [17880.544172]  [<ffffffffa018113a>] ? md_do_s=
ync+0x713/0xb0f [md_mod]
Jul  6 23:58:38 mars kernel: [17880.544177]  [<ffffffff8105d495>] ? autorem=
ove_wake_function+0x0/0x2a
Jul  6 23:58:38 mars kernel: [17880.544182]  [<ffffffffa0181c89>] ? md_thre=
ad+0xf2/0x110 [md_mod]
Jul  6 23:58:38 mars kernel: [17880.544188]  [<ffffffffa0181b97>] ? md_thre=
ad+0x0/0x110 [md_mod]
Jul  6 23:58:38 mars kernel: [17880.544190]  [<ffffffff8105d061>] ? kthread=
+0x75/0x7d
Jul  6 23:58:38 mars kernel: [17880.544194]  [<ffffffff810097e4>] ? kernel_=
thread_helper+0x4/0x10
Jul  6 23:58:38 mars kernel: [17880.544197]  [<ffffffff8105cfec>] ? kthread=
+0x0/0x7d
Jul  6 23:58:38 mars kernel: [17880.544199]  [<ffffffff810097e0>] ? kernel_=
thread_helper+0x0/0x10

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkw1kOUACgkQH0JwilpTmKjXrgCfUIIU2ylLSh3D3ytcEfJIEGAA
GeMAn1QXoQ4uEsfJUDtTSG85B3EHjz98
=neyj
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
