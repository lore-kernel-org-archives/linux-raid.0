From: Jose Manuel dos Santos Calhariz <jose.spam@netvisao.pt>
Subject: linux-image-2.6.32-5-686: kernel BUG at ...
 build/source_i386_none/drivers/md/raid5.c:2764!
Date: Fri, 22 Jun 2012 13:19:53 +0100
Message-ID: <20120622121953.GA25149@calhariz.com>
Reply-To: jose.spam@netvisao.pt
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


In another day during the periodic mdadm RAID check:=20
 - the linux kernel gave a kernel BUG,=20
 - tried to kick out a failed disk and=20
 - stopped accepting I/O to the affected raid. =20

The affected programs were in state D.  The only way to recover was to
do a reboot.  After reboot the problematic disk was replaced.

I reported the bug to Debian and is there all the information about it:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D675969

I was asked to report the BUG here in case someone knows what happened.

Here is a summary of the more relevant information:

This machine have 2 x RAID6 with 6 disks each, for a total of 12 disks.=20

I have 5 systems with a similar setup and only one failed, maybe
because of the failing disk.  I will use one of the systems to try to
reproduce the bug, before triyng a new kernel.


The proprietary module is the openafs filesystem v1.6.1 backported
=66rom Debian testing.

The kernel bug is:


build/source_i386_none/drivers/md/raid5.c:2764!

(...)
Jun  3 01:35:53 afs04 kernel: raid5:md2: read error corrected (8 sectors at=
 73343216 on cciss/c1d3p1)
Jun  3 01:35:53 afs04 kernel: raid5:md2: read error corrected (8 sectors at=
 73343224 on cciss/c1d3p1)
Jun  3 01:35:53 afs04 kernel: raid5:md2: read error corrected (8 sectors at=
 73343232 on cciss/c1d3p1)
Jun  3 01:35:53 afs04 kernel: raid5:md2: read error corrected (8 sectors at=
 73343240 on cciss/c1d3p1)
Jun  3 01:35:56 afs04 kernel: cciss: cmd f6000de0 has CHECK CONDITION sense=
 key =3D 0x3
Jun  3 01:35:56 afs04 kernel: end_request: I/O error, dev cciss/c1d3, secto=
r 73343280
Jun  3 01:35:56 afs04 kernel: raid5:md2: read error NOT corrected!! (sector=
 73343248 on cciss/c1d3p1).
Jun  3 01:35:56 afs04 kernel: raid5: Disk failure on cciss/c1d3p1, disablin=
g device.
Jun  3 01:35:56 afs04 kernel: raid5: Operation continuing on 5 devices.
Jun  3 01:35:56 afs04 kernel: raid5:md2: read error NOT corrected!! (sector=
 73343256 on cciss/c1d3p1).
Jun  3 01:35:56 afs04 kernel: raid5:md2: read error NOT corrected!! (sector=
 73343264 on cciss/c1d3p1).
Jun  3 01:35:56 afs04 kernel: raid5:md2: read error NOT corrected!! (sector=
 73343272 on cciss/c1d3p1).
Jun  3 01:35:56 afs04 kernel: raid5:md2: read error NOT corrected!! (sector=
 73343280 on cciss/c1d3p1).
Jun  3 01:35:56 afs04 kernel: raid5:md2: read error NOT corrected!! (sector=
 73343288 on cciss/c1d3p1).
Jun  3 01:35:56 afs04 kernel: ------------[ cut here ]------------
Jun  3 01:35:56 afs04 kernel: kernel BUG at /tmp/buildd/linux-2.6-2.6.32/de=
bian/build/source_i386_none/drivers/md/raid5.c:2764!
Jun  3 01:35:56 afs04 kernel: invalid opcode: 0000 [#1] SMP=20
Jun  3 01:35:56 afs04 kernel: last sysfs file: /sys/devices/pci0000:00/0000=
:00:1c.0/0000:02:01.0/cciss0/c0d0/block/cciss!c0d0/removable
Jun  3 01:35:56 afs04 kernel: Modules linked in: btrfs zlib_deflate crc32c =
libcrc32c ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs reiserfs ext4 =
jbd2 crc16 openafs(P) lp parport_pc parport joydev st sd_mod crc_t10dif ext=
2 loop tun xt_multiport xfs exportfs 8021q garp stp ip6table_filter ip6_tab=
les iptable_filter ip_tables x_tables ide_generic ide_gd_mod ide_cd_mod ide=
_core snd_pcm snd_timer hpilo snd soundcore snd_page_alloc hpwdt e752x_edac=
 shpchp rng_core i6300esb edac_core pci_hotplug pcspkr container processor =
evdev button psmouse serio_raw ext3 jbd mbcache dm_mod raid456 md_mod async=
_raid6_recov async_pq usbhid hid raid6_pq async_xor xor async_memcpy async_=
tx sg sr_mod cdrom ata_generic thermal uhci_hcd cciss tg3 floppy ata_piix e=
hci_hcd libata e1000 usbcore libphy scsi_mod nls_base thermal_sys [last unl=
oaded: openafs]
Jun  3 01:35:56 afs04 kernel:=20
Jun  3 01:35:56 afs04 kernel: Pid: 743, comm: md2_raid6 Tainted: P         =
  (2.6.32-5-686 #1) ProLiant DL360 G4
Jun  3 01:35:56 afs04 kernel: EIP: 0060:[<f818c811>] EFLAGS: 00010297 CPU: 3
Jun  3 01:35:56 afs04 kernel: EIP is at handle_stripe+0x89d/0x173e [raid456]
Jun  3 01:35:56 afs04 kernel: EAX: 00000005 EBX: 00000002 ECX: 00000003 EDX=
: 00000001
Jun  3 01:35:56 afs04 kernel: ESI: f6394000 EDI: 00000003 EBP: f6394028 ESP=
: f58d5e6c
Jun  3 01:35:56 afs04 kernel:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jun  3 01:35:56 afs04 kernel: Process md2_raid6 (pid: 743, ti=3Df58d4000 ta=
sk=3Df6569980 task.ti=3Df58d4000)
Jun  3 01:35:56 afs04 kernel: Stack:
Jun  3 01:35:56 afs04 kernel:  e6fde3e6 c2988138 00000006 f61c8e00 00000006=
 0002d995 00020003 00000000
Jun  3 01:35:56 afs04 kernel: <0> c2988138 f4cbc86c f65699ac 000f0e67 00000=
000 f639431c 00000005 fffffffc
Jun  3 01:35:56 afs04 kernel: <0> f4cbc86c c1025461 00000000 00000000 00000=
002 00000005 00988100 c127a45c
Jun  3 01:35:56 afs04 kernel: Call Trace:
Jun  3 01:35:56 afs04 kernel:  [<c1025461>] ? check_preempt_wakeup+0x196/0x=
202
Jun  3 01:35:56 afs04 kernel:  [<f818d9fb>] ? raid5d+0x349/0x389 [raid456]
Jun  3 01:35:56 afs04 kernel:  [<c103b623>] ? del_timer_sync+0xa/0x14
Jun  3 01:35:56 afs04 kernel:  [<c103b6cb>] ? process_timeout+0x0/0x5
Jun  3 01:35:56 afs04 kernel:  [<f816206e>] ? md_thread+0xe1/0xf8 [md_mod]
Jun  3 01:35:56 afs04 kernel:  [<c104433a>] ? autoremove_wake_function+0x0/=
0x2d
Jun  3 01:35:56 afs04 kernel:  [<f8161f8d>] ? md_thread+0x0/0xf8 [md_mod]
Jun  3 01:35:56 afs04 kernel:  [<c1044108>] ? kthread+0x61/0x66
Jun  3 01:35:56 afs04 kernel:  [<c10440a7>] ? kthread+0x0/0x66
Jun  3 01:35:56 afs04 kernel:  [<c1003d47>] ? kernel_thread_helper+0x7/0x10
Jun  3 01:35:56 afs04 kernel: Code: e9 9b 01 00 00 83 7c 24 7c 02 74 04 0f =
0b eb fe f6 46 28 10 c7 46 3c 00 00 00 00 0f 85 7f 01 00 00 8b 44 24 38 39 =
44 24 70 7d 04 <0f> 0b eb fe 83 7c 24 7c 02 75 20 6b 84 24 a8 00 00 00 78 f=
f 44=20
Jun  3 01:35:56 afs04 kernel: EIP: [<f818c811>] handle_stripe+0x89d/0x173e =
[raid456] SS:ESP 0068:f58d5e6c
Jun  3 01:35:56 afs04 kernel: ---[ end trace b6f4aa295d5e4948 ]---
Jun  3 01:35:56 afs04 mdadm[2376]: Fail event detected on md device /dev/md=
2, component device /dev/cciss/c1d3p1
Jun  3 02:59:50 afs04 kernel: md: md3: data-check done.
Jun  3 06:16:21 afs04 kernel: afs: Lost contact with volume location server=
 193.136.128.36 in cell ist.utl.pt
Jun  3 06:16:21 afs04 kernel: afs: Lost contact with volume location server=
 193.136.128.36 in cell ist.utl.pt
Jun  3 06:17:18 afs04 kernel: afs: Lost contact with file server 193.136.12=
8.36 in cell ist.utl.pt (all multi-homed ip addresses down for the server)
Jun  3 06:17:18 afs04 kernel: afs: Lost contact with file server 193.136.12=
8.36 in cell ist.utl.pt (all multi-homed ip addresses down for the server)
Jun  3 07:35:21 afs04 kernel: cciss: cmd f6000000 has CHECK CONDITION sense=
 key =3D 0x3
Jun  3 07:35:21 afs04 kernel: end_request: I/O error, dev cciss/c1d3, secto=
r 128
Jun  3 07:35:21 afs04 kernel: __ratelimit: 21 callbacks suppressed
Jun  3 07:35:21 afs04 kernel: Buffer I/O error on device cciss/c1d3, logica=
l block 16
Jun  3 07:35:22 afs04 kernel: cciss: cmd f6000000 has CHECK CONDITION sense=
 key =3D 0x3
Jun  3 07:35:22 afs04 kernel: end_request: I/O error, dev cciss/c1d3, secto=
r 128
Jun  3 07:35:22 afs04 kernel: Buffer I/O error on device cciss/c1d3, logica=
l block 16
Jun  3 07:35:23 afs04 kernel: cciss: cmd f6000000 has CHECK CONDITION sense=
 key =3D 0x3
Jun  3 07:35:23 afs04 kernel: end_request: I/O error, dev cciss/c1d3, secto=
r 128
Jun  3 07:35:23 afs04 kernel: Buffer I/O error on device cciss/c1d3, logica=
l block 16
(...)


     TIA
Jose Calhariz

--=20
--
Ambi=E7=E3o: um supremo desejo de ser vilipendiado por seus inimigos enquan=
to voc=EA est=E1 vivo e ser ridicularizado pelos amigos quando estiver morto

--Ambrose Bierce

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJP5GLoAAoJEDSKd41ohe+PsgMP/226QCLgUAxXBz1zmp9u9EB3
YofjUOdBbP5kfQZ0vWGqCm1XXguxGqymwFCFMI5zJqEuTG4LuUQWUSTXzWkIydFp
4w021sAf2TKxtv0iEi9eNdX2i7PespIaUXHVo6gx1W0YJnjETfKeTB8JjF/CeO93
W51guClpQVXnzG5YOkMfKFoLuzfJy4YfhUK8g40UlsJujJR36aGcMYSgvjUJa0jY
PQ7mtIPpBumQBlBwDgBzvVCHspfOka1ROFU0VlHV1NuVQnXBGn43BdTT+mha/4iy
9bNlRrw5TW476sH2aXydqQjZgXl21sCQHmLsgx0JZSWuJRRt7yzzv0Ft2pLABICN
G6RUBtLS/hlHwu8TrjGfWP8WaIN9TZrwS4kqgSKc+UoNcRWk8a/OE6NEO6hu00UQ
vlJQ0jaQvTeM6OFyavR4wLGHlRQQa0QBErJMZ3TrS5ALiod1LL8jztGG3z3IPctL
hlkRg2RJBLPv9CWGMByGT4IjsZC+PTtxKF2l1z1M8wh0vWOdEmpuqW8vle18DdcT
jLh/5XVebx63L55dbXRyoE1Q2Z0DFdCfpxzLUHil2ZZczGuSOyY8GLq2CSzaCYBR
UFHZ641QR8gH7s2kYKBTCbQnLHBZXLe/XleiTFHce+cpKuqj8Lfvil72502RXwt6
Ae7VtjNhmY2LQgP0Iivk
=EFKo
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
