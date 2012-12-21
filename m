From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Expanding raid0
Date: Fri, 21 Dec 2012 18:32:53 +0100 (CET)
Message-ID: <12155358.8.1356111173286.JavaMail.root@zimbra>
References: <CAFn++Q4XMw9DLpg=d_WhkteW=qQ_cFct_kr4THfpcgZuYjyX+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFn++Q4XMw9DLpg=d_WhkteW=qQ_cFct_kr4THfpcgZuYjyX+w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kubes <pkubat.mlist@freepricealerts.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

well, I guess it should work, in theory. I just tried with loopback dev=
ices (1GB each). This is on Ubuntu Precise 12.04.1, kernel 3.2.0-35-gen=
eric. Got an OOPS, which triggered a panic (kernel.panic_on_oops =3D 1)=
 which triggered a reboot (kernel.panic =3D 1). It might work, but not =
here - other RAID stuff works well on this box

See below for logs

roy

root@smilla:/raid/tmp/testraid# mdadm --create /dev/md1 --level=3D0 --c=
hunk=3D256 --raid-devices=3D2 /dev/loop0 /dev/loop1
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
root@smilla:/raid/tmp/testraid# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [r=
aid1] [raid10]=20
md1 : active raid0 loop1[1] loop0[0]
      2096640 blocks super 1.2 256k chunks
     =20
root@smilla:/raid/tmp/testraid# mkfs.xfs /dev/md1
=2E..
(copy 200MB into the filesystem)

root@smilla:/mnt/raidtest# mdadm -G /dev/md1 --raid-disks=3D3 --add /de=
v/loop2
mdadm: level of /dev/md1 changed to raid4
mdadm: added /dev/loop2
mdadm: Need to backup 1536K of critical section..
mdadm: Cannot start reshape for /dev/md1
mdadm: aborting level change
root@smilla:/mnt/raidtest# Timeout, server 192.168.10.254 not respondin=
g.

seems like an OOPS was triggered

Dec 21 18:25:53 smilla kernel: [ 4742.265318] md/raid:md1: device loop1=
 operational as raid disk 1
Dec 21 18:25:53 smilla kernel: [ 4742.265321] md/raid:md1: device loop0=
 operational as raid disk 0
Dec 21 18:25:53 smilla kernel: [ 4742.265587] md/raid:md1: allocated 32=
28kB
Dec 21 18:25:53 smilla kernel: [ 4742.284092] md/raid:md1: raid level 4=
 active with 2 out of 3 devices, algorithm 5
Dec 21 18:25:53 smilla kernel: [ 4742.285250] RAID conf printout:
Dec 21 18:25:53 smilla kernel: [ 4742.285252]  --- level:4 rd:3 wd:2
Dec 21 18:25:53 smilla kernel: [ 4742.285254]  disk 0, o:1, dev:loop0
Dec 21 18:25:53 smilla kernel: [ 4742.285255]  disk 1, o:1, dev:loop1
Dec 21 18:25:54 smilla kernel: [ 4742.987274] md: bind<loop2>
Dec 21 18:25:55 smilla kernel: [ 4743.426366] md/raid0:md1: bad disk nu=
mber -1 - aborting!
Dec 21 18:25:55 smilla kernel: [ 4743.444444] md/raid0:md1: bad disk nu=
mber -1 - aborting!
Dec 21 18:25:56 smilla kernel: [ 4743.451231] BUG: unable to handle ker=
nel NULL pointer dereference at 0000000000000010
Dec 21 18:25:56 smilla kernel: [ 4743.452474] IP: [<ffffffffa0275369>] =
raid0_make_request+0x69/0x1c0 [raid0]
Dec 21 18:25:56 smilla kernel: [ 4743.453608] PGD 137668067 PUD 1314240=
67 PMD 0=20
Dec 21 18:25:56 smilla kernel: [ 4743.454283] Oops: 0000 [#1] SMP=20
Dec 21 18:25:56 smilla kernel: [ 4743.454283] CPU 0=20
Dec 21 18:25:56 smilla kernel: [ 4743.454283] Modules linked in: xfs eb=
table_nat ebtables ipt_MASQUERADE iptable_nat xt_CHECKSUM iptable_mangl=
e kvm_amd kvm dm_crypt xt_hl ip6t_rt ib_iser rdma_cm nf_conntrack_ipv6 =
nf_defrag_ipv6 ib_cm iw_cm ib_sa ib_mad ib_core ipt_REJECT ib_addr iscs=
i_tcp libiscsi_tcp libiscsi scsi_transport_iscsi xt_limit xt_tcpudp xt_=
addrtype xt_state ip6table_filter ip6_tables nf_conntrack_netbios_ns nf=
_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4=
 nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables snd_hd=
a_codec_via snd_hda_intel snd_hda_codec snd_hwdep snd_pcm bridge stp sn=
d_seq_midi snd_rawmidi snd_seq_midi_event arc4 snd_seq rt61pci crc_itu_=
t rt2x00pci rt2x00lib mac80211 snd_timer snd_seq_device cfg80211 eeprom=
_93cx6 sp5100_tco snd soundcore psmouse snd_page_alloc uvcvideo i2c_pii=
x4 videodev v4l2_compat_ioctl32 serio_raw edac_core k10temp edac_mce_am=
d ext2 mac_hid w83627ehf hwmon_vid lp parport raid10 raid1 raid0 multip=
ath linear btrfs zlib_deflate lib
Dec 21 18:25:56 smilla kernel: crc32c raid456 async_pq async_xor xor as=
ync_memcpy async_raid6_recov raid6_pq async_tx radeon ttm drm_kms_helpe=
r drm i2c_algo_bit sata_sil24 pata_atiixp usbhid hid r8169
Dec 21 18:25:56 smilla kernel: [ 4743.454283]=20
Dec 21 18:25:56 smilla kernel: [ 4743.454283] Pid: 16410, comm: blkid N=
ot tainted 3.2.0-35-generic #55-Ubuntu To Be Filled By O.E.M. To Be Fil=
led By O.E.M./M3A UCC
Dec 21 18:25:56 smilla kernel: [ 4743.454283] RIP: 0010:[<ffffffffa0275=
369>]  [<ffffffffa0275369>] raid0_make_request+0x69/0x1c0 [raid0]
Dec 21 18:25:56 smilla kernel: [ 4743.454283] RSP: 0018:ffff8800be3918c=
8  EFLAGS: 00010202
Dec 21 18:25:56 smilla kernel: [ 4743.454283] RAX: 0000000000000001 RBX=
: ffff88002bcabc00 RCX: 0000000000000190
Dec 21 18:25:56 smilla kernel: [ 4743.454283] RDX: 0000000000000001 RSI=
: 0000000000000200 RDI: 0000000000000000
Dec 21 18:25:56 smilla kernel: [ 4743.454283] RBP: ffff8800be3918e8 R08=
: 0000000000000200 R09: 0000000000000100
Dec 21 18:25:56 smilla kernel: [ 4743.454283] R10: ffff8801877acf08 R11=
: 0000000000000000 R12: ffff88021f0566c0
Dec 21 18:25:56 smilla kernel: [ 4743.454283] R13: 0000000000000200 R14=
: 0000000000000000 R15: 0000000000001200
Dec 21 18:25:56 smilla kernel: [ 4743.454283] FS:  00007f4ed3929740(000=
0) GS:ffff88022fc00000(0000) knlGS:0000000000000000
Dec 21 18:25:56 smilla kernel: [ 4743.454283] CS:  0010 DS: 0000 ES: 00=
00 CR0: 0000000080050033
Dec 21 18:25:56 smilla kernel: [ 4743.454283] CR2: 0000000000000010 CR3=
: 00000001014f4000 CR4: 00000000000006f0
Dec 21 18:25:56 smilla kernel: [ 4743.454283] DR0: 0000000000000000 DR1=
: 0000000000000000 DR2: 0000000000000000
Dec 21 18:25:56 smilla kernel: [ 4743.454283] DR3: 0000000000000000 DR6=
: 00000000ffff0ff0 DR7: 0000000000000400
Dec 21 18:25:56 smilla kernel: [ 4743.454283] Process blkid (pid: 16410=
, threadinfo ffff8800be390000, task ffff88021dcddc00)
Dec 21 18:25:56 smilla kernel: [ 4743.454283] Stack:
Dec 21 18:25:56 smilla kernel: [ 4743.454283]  0000000000000001 0000000=
000000190 ffff88002bcabc00 ffff88021f0566c0
Dec 21 18:25:56 smilla kernel: [ 4743.454283]  ffff8800be391948 fffffff=
f814e5cb0 0000000000011210 ffff8800be391968
Dec 21 18:25:56 smilla kernel: [ 4743.454283]  ffff88021dcddc00 0000000=
000000010 ffff8800be391928 ffffffff8111b0a5
Dec 21 18:25:56 smilla kernel: [ 4743.454283] Call Trace:
Dec 21 18:25:56 smilla kernel: [ 4743.454283]  [<ffffffff814e5cb0>] md_=
make_request+0xd0/0x200
Dec 21 18:25:56 smilla kernel: [ 4743.454283]  [<ffffffff8111b0a5>] ? m=
empool_alloc_slab+0x15/0x20
Dec 21 18:25:56 smilla kernel: [ 4743.454283]  [<ffffffff812f2044>] gen=
eric_make_request.part.50+0x74/0xb0
Dec 21 18:25:56 smilla kernel: [ 4743.454283]  [<ffffffff812f2458>] gen=
eric_make_request+0x68/0x70
Dec 21 18:25:56 smilla kernel: [ 4743.454283]  [<ffffffff812f24e5>] sub=
mit_bio+0x85/0x110


----- Opprinnelig melding -----
> All,
>=20
> I have yet to find THE definitive word (via any search and forums) if
> this is possible; expanding a raid0 set by adding drives. (Please, I
> know there is no redundancy, and that is fine as these volumes are
> really Amazon WS EBS volumes, so we only strip for speed improvements=
)
>=20
>=20
>=20
> It seem this works:
> more /proc/diskstats
> mdadm --create /dev/md0 --chunk=3D256 --level=3D0 --raid-devices=3D2
> /dev/sd[b-c]
> mdadm --detail /dev/md0
> mkfs.xfs /dev/md0
> mount /dev/md0 /mnt
> vi /mnt/test
> umount /dev/md0
>=20
> mdadm --grow /dev/md0 --level=3D0 --backup-file=3D/tmp/grow
> --raid-devices=3D3 --add /dev/sdd <=3D changes to raid4
> mdadm --detail /dev/md0
> mdadm --grow /dev/md0 --level=3D0 --backup-file=3D/tmp/grow <=3D=3D c=
hanges to
> raid0
> mdadm --detail /dev/md0
>=20
> Can someone please confirm this correct and that raid0 can be
> expanded, or is there a better means to expand an raid0 raid set?
>=20
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

--=20
Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
roy@karlsbakk.net
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
