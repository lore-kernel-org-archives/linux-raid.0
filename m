From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: make_request bug: can't convert block across chunks or bigger
 than 512k 2554601336 124
Date: Mon, 11 Apr 2016 08:05:25 -0400
Message-ID: <1460376325.27740.289.camel@interlinx.bc.ca>
References: <1460114831.27740.186.camel@interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-WiLQOaFkdN+GBDN6AVCr"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1460114831.27740.186.camel@interlinx.bc.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-WiLQOaFkdN+GBDN6AVCr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-04-08 at 07:27 -0400, Brian J. Murrell wrote:
> So I've had this raid configuration set up and running for many many
> months if not years:

My apologies if I come across as being impatient, but I wonder if
anyone can shed any light on this. =C2=A0My array is currently broken and
I'd like to get it back in order before I lose it completely. =C2=A0Murphy'=
s
law and all.

> /dev/md1:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Version : 1.2
> =C2=A0 Creation Time : Sat Dec 26 19:49:41 2015
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Raid Level : raid0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Array Size : 1953524736 (1863.03 GiB 2000.4=
1 GB)
> =C2=A0=C2=A0=C2=A0Raid Devices : 2
> =C2=A0 Total Devices : 2
> =C2=A0=C2=A0=C2=A0=C2=A0Persistence : Superblock is persistent
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0Update Time : Sat Dec 26 19:49:41 2015
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0State : clean
> =C2=A0Active Devices : 2
> Working Devices : 2
> =C2=A0Failed Devices : 0
> =C2=A0 Spare Devices : 0
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Chunk Size : 512K
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Name : =
linux.interlinx.bc.ca:1=C2=A0=C2=A0(local to host
> linux.interlinx.bc.ca)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0UUID : =
f27ae74d:e2997e50:9df158ee:c5ed3cbb
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Events : 0
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0Number=C2=A0=C2=A0=C2=A0Major=C2=A0=C2=A0=C2=A0Mi=
nor=C2=A0=C2=A0=C2=A0RaidDevice State
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A08=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A016=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0active s=
ync=C2=A0=C2=A0=C2=A0/dev/sdb
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A08=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A032=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0active s=
ync=C2=A0=C2=A0=C2=A0/dev/sdc
>=20
> /dev/md0:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Version : 0.90
> =C2=A0 Creation Time : Mon Jan 26 19:51:38 2009
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Raid Level : raid1
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Array Size : 1953514496 (1863.02 GiB 2000.4=
0 GB)
> =C2=A0 Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
> =C2=A0=C2=A0=C2=A0Raid Devices : 2
> =C2=A0 Total Devices : 2
> Preferred Minor : 0
> =C2=A0=C2=A0=C2=A0=C2=A0Persistence : Superblock is persistent
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0Update Time : Fri Apr=C2=A0=C2=A08 00:00:42 2016
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0State : activ=
e, degraded
> =C2=A0Active Devices : 1
> Working Devices : 1
> =C2=A0Failed Devices : 1
> =C2=A0 Spare Devices : 0
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0UUID : =
2f8fc5e0:a0eb646a:2303d005:33f25f21
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Events : 0.5031387
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0Number=C2=A0=C2=A0=C2=A0Major=C2=A0=C2=A0=C2=A0Mi=
nor=C2=A0=C2=A0=C2=A0RaidDevice State
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A08=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A048=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0active s=
ync=C2=A0=C2=A0=C2=A0/dev/sdd
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0re=
moved
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A02=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A09=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0fa=
ulty spare=C2=A0=C2=A0=C2=A0/dev/md1
>=20
> Now out of the blue (or seemingly out of the blue, nothing really
> comes
> out of the blue) I am starting to get the md0 array faulting with:
>=20
> [37722.335880] md/raid0:md1: make_request bug: can't convert block
> across chunks or bigger than 512k 2554601336 124
> [37722.335887] md/raid1:md0: md1: rescheduling sector 2554601336
> [37722.376776] md/raid1:md0: redirecting sector 2554601336 to other
> mirror: md1
> [37722.386455] md/raid0:md1: make_request bug: can't convert block
> across chunks or bigger than 512k 2554601336 124
> [37722.386461] md/raid1:md0: md1: rescheduling sector 2554601336
> [37722.412059] md/raid1:md0: redirecting sector 2554601336 to other
> mirror: sdd
> [37722.735049] md/raid0:md1: make_request bug: can't convert block
> across chunks or bigger than 512k 2554608496 124
> [37722.735056] md/raid1:md0: md1: rescheduling sector 2554608496
> [37722.789926] md/raid1:md0: redirecting sector 2554608496 to other
> mirror: md1
> [37722.798689] md/raid0:md1: make_request bug: can't convert block
> across chunks or bigger than 512k 2554608496 124
> [37722.798696] md/raid1:md0: md1: rescheduling sector 2554608496
> [37722.859314] md/raid1:md0: redirecting sector 2554608496 to other
> mirror: sdd
> [37724.819090] md/raid0:md1: make_request bug: can't convert block
> across chunks or bigger than 512k 2554606584 12
> [37724.819096] md/raid1:md0: md1: rescheduling sector 2554606584
> [37727.455279] md/raid1:md0: redirecting sector 2554606584 to other
> mirror: sdd
> [37752.406865] md/raid0:md1: make_request bug: can't convert block
> across chunks or bigger than 512k 1748150224 124
> [37752.521219] md/raid1:md0: Disk failure on md1, disabling device.
> [37752.521222] md/raid1:md0: Operation continuing on 1 devices.
> [37752.580186] RAID1 conf printout:
> [37752.580190]=C2=A0=C2=A0--- wd:1 rd:2
> [37752.580194]=C2=A0=C2=A0disk 0, wo:0, o:1, dev:sdd
> [37752.580197]=C2=A0=C2=A0disk 1, wo:1, o:0, dev:md1
> [37752.580199] RAID1 conf printout:
> [37752.580201]=C2=A0=C2=A0--- wd:1 rd:2
> [37752.580203]=C2=A0=C2=A0disk 0, wo:0, o:1, dev:sdd
> [37752.580228] BUG: unable to handle kernel paging request at
> 000000001dff2107
> [37752.584011] IP: [<ffffffffa001909a>] close_write+0x6a/0xa0 [raid1]
> [37752.584011] PGD 20f667067 PUD 20f669067 PMD 0=C2=A0
> [37752.584011] Oops: 0000 [#1] SMP=C2=A0
> [37752.584011] CPU 0=C2=A0
> [37752.584011] Modules linked in: iptable_mangle iptable_filter
> ipt_MASQUERADE xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4
> nf_conntrack nf_defrag_ipv4 ip_tables x_tables autofs4 nfsd nfs lockd
> fscache auth_rpcgss nfs_acl sunrpc snd_hda_codec_realtek
> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm radeon snd_seq_midi ttm
> drm_kms_helper snd_rawmidi ftdi_sio snd_seq_midi_event snd_seq
> snd_timer drm ppdev snd_seq_device pl2303 usbserial serio_raw
> i2c_algo_bit mac_hid asus_atk0110 snd parport_pc parport soundcore
> snd_page_alloc edac_core edac_mce_amd i2c_piix4 k8temp shpchp 8021q
> garp stp pata_atiixp r8169 raid10 raid456 async_pq async_xor xor
> async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0
> multipath linear
> [37752.584011]=C2=A0
> [37752.584011] Pid: 267, comm: md0_raid1 Not tainted 3.2.0-101-
> generic #141-Ubuntu System manufacturer System Product Name/M2A-VM
> [37752.584011] RIP: 0010:[<ffffffffa001909a>]=C2=A0=C2=A0[<ffffffffa00190=
9a>]
> close_write+0x6a/0xa0 [raid1]
> [37752.584011] RSP: 0018:ffff88020def9dc0=C2=A0=C2=A0EFLAGS: 00010246
> [37752.584011] RAX: 000000001dff1dff RBX: ffff88020e380108 RCX:
> 00000000e8e08784
> [37752.584011] RDX: 00000000687249a8 RSI: 0000000000000002 RDI:
> ffff88020e380108
> [37752.584011] RBP: ffff88020def9dd0 R08: 00000000e8e08784 R09:
> 000000000000036b
> [37752.584011] R10: dead000000100100 R11: dead000000200200 R12:
> ffff88020e36b800
> [37752.584011] R13: ffff88020e380100 R14: ffff88020e380130 R15:
> ffff88020e380108
> [37752.584011] FS:=C2=A0=C2=A000007f8e0a353740(0000) GS:ffff88021fc00000(=
0000)
> knlGS:00000000f75586c0
> [37752.584011] CS:=C2=A0=C2=A00010 DS: 0000 ES: 0000 CR0: 000000008005003=
b
> [37752.584011] CR2: 000000001dff2107 CR3: 000000020f61e000 CR4:
> 00000000000006f0
> [37752.584011] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [37752.584011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [37752.584011] Process md0_raid1 (pid: 267, threadinfo
> ffff88020def8000, task ffff88020e2eae00)
> [37752.584011] Stack:
> [37752.584011]=C2=A0=C2=A0ffff88020def9e20 ffff88020e36b800 ffff88020def9=
e60
> ffffffffa001cbe5
> [37752.584011]=C2=A0=C2=A0ffff88020e380140 ffff880044dbd800 0000000091827=
364
> ffff88020def9df8
> [37752.584011]=C2=A0=C2=A0ffff88020def9df8 ffff88020def9e08 ffff88020def9=
e08
> ffff880200000000
> [37752.584011] Call Trace:
> [37752.584011]=C2=A0=C2=A0[<ffffffffa001cbe5>] raid1d+0x2a5/0x2b0 [raid1]
> [37752.584011]=C2=A0=C2=A0[<ffffffff814f0f9e>] md_thread+0x11e/0x170
> [37752.584011]=C2=A0=C2=A0[<ffffffff8108c650>] ? add_wait_queue+0x60/0x60
> [37752.584011]=C2=A0=C2=A0[<ffffffff814f0e80>] ? md_rdev_init+0x130/0x130
> [37752.584011]=C2=A0=C2=A0[<ffffffff8108bbac>] kthread+0x8c/0xa0
> [37752.584011]=C2=A0=C2=A0[<ffffffff816746b4>] kernel_thread_helper+0x4/0=
x10
> [37752.584011]=C2=A0=C2=A0[<ffffffff8108bb20>] ? flush_kthread_worker+0xa=
0/0xa0
> [37752.584011]=C2=A0=C2=A0[<ffffffff816746b0>] ? gs_change+0x13/0x13
> [37752.584011] Code: e4 48 8b 53 48 75 de 48 89 d7 e8 e2 cd 14 e1 48
> c7 43 48 00 00 00 00 4c 8b 43 18 48 8b 43 20 48 8b 4b 18 48 63 53 10
> 48 8b 73 08 <48> 8b b8 08 03 00 00 49 c1 e8 03 48 c1 e9 02 41 83 e0
> 01 83 e1=C2=A0
> [37752.584011] RIP=C2=A0=C2=A0[<ffffffffa001909a>] close_write+0x6a/0xa0
> [raid1]
> [37752.584011]=C2=A0=C2=A0RSP <ffff88020def9dc0>
> [37752.584011] CR2: 000000001dff2107
> [37752.889674] ---[ end trace 276f024e11aa62ac ]---
>=20
> Any ideas what is all of a sudden happening?
>=20
> Cheers,
> b.

--=-WiLQOaFkdN+GBDN6AVCr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAABAgAGBQJXC5MFAAoJENrB0DQWy8iga4QIAJgzbwgq4riz3ZL5t/b4dVee
3oOHT6SZjYN5zXhOmrlRNlfDS6GGtxofgSO8/TKvmXLcjMzUGs2/+lxyGyFDw5HY
mOtVbDNvtK15gAGm06Jxaxi8LlZztec2YN2nxBX3VYLDZXTZ924R2+DIQ/y/yG6m
KBfLDQ4JGZLnOfo3wJU0bRs10zQ8re4qAt/sWgomzk64alX9MlhIN68KMjENwQD2
W/+DaVsZHl2+2/nnCRYgT1Ma9VqIYQvzDG+y2Ap7a+1BxdlCrzffMlVHgZlB3qce
ppmZc/w7VGok/PyK2R8UzH6JTV+M5pq6KbDGxCc/8L3iyGMOHSAW1S2Q45FLG4o=
=S/Rc
-----END PGP SIGNATURE-----

--=-WiLQOaFkdN+GBDN6AVCr--


