From: Christian Hesse <list@eworm.de>
Subject: unable to handle kernel NULL pointer dereference in get_free_stripe
Date: Sun, 23 Aug 2015 23:03:41 +0200
Message-ID: <20150823230341.3dd46f66@leda.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/iu3m3vyiDNaKJMs4r_84CQf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

--Sig_/iu3m3vyiDNaKJMs4r_84CQf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello everybody,

with linux 4.1.x I am hit by this issue with RAID5:

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffffa05a4b91>] get_free_stripe+0x31/0xf0 [raid456]
PGD bbb4e067 PUD a371f067 PMD 0=20
Oops: 0000 [#1] PREEMPT SMP=20
Modules linked in: fuse raid456 nft_reject_inet nf_reject_ipv4 async_raid6_=
recov nf_reject_ipv6 async_memcpy nft_reject async_pq async_xor xor async_t=
x vmw_vsock_vmci_transport vsock nft_meta iosf_mbi nf_conntrack_ipv6 corete=
mp nf_defrag_ipv6 crct10dif_pclmul crc32_pclmul ghash_clmulni_intel raid6_p=
q mousedev aesni_intel nf_conntrack_ipv4 ppdev nf_defrag_ipv4 aes_x86_64 md=
_mod nft_ct nf_conntrack lrw gf128mul glue_helper vmw_balloon ablk_helper c=
ryptd psmouse nft_hash serio_raw pcspkr nft_rbtree nf_tables_inet nf_tables=
_ipv6 vmwgfx nf_tables_ipv4 nf_tables ttm drm_kms_helper battery drm nfnetl=
ink i2c_piix4 irda acpi_cpufreq vmw_vmci i2c_core shpchp evdev parport_pc c=
rc_ccitt parport processor mac_hid ac sch_fq_codel nfs lockd grace sunrpc f=
scache ip_tables x_tables ext4 crc16 mbcache
 jbd2 dm_snapshot dm_bufio squashfs loop dm_mirror dm_region_hash dm_log dm=
_mod sd_mod sr_mod cdrom ata_generic pata_acpi mptsas ata_piix scsi_transpo=
rt_sas mptscsih libata mptbase crc32c_intel vmxnet3 scsi_mod atkbd libps2 i=
ntel_agp intel_gtt floppy i8042 serio button
CPU: 0 PID: 430 Comm: rsync Tainted: G        W       4.1.6-2-ARCH #1
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference=
 Platform, BIOS 6.00 07/09/2012
task: ffff8800bb5628c0 ti: ffff880021ad8000 task.ti: ffff880021ad8000
RIP: 0010:[<ffffffffa05a4b91>]  [<ffffffffa05a4b91>] get_free_stripe+0x31/0=
xf0 [raid456]
RSP: 0018:ffff880021adb748  EFLAGS: 00010086
RAX: fffffffffffffff0 RBX: 0000000000000000 RCX: 00000000000000ff
RDX: 0000000100100001 RSI: 00000000ffffffff RDI: ffff8800bb756800
RBP: ffff880021adb778 R08: ffff880235eee380 R09: ffff880235eede00
R10: ffffea00000de600 R11: 0000000000019d48 R12: ffff8800bb756800
R13: ffff8800bb756806 R14: ffff8800bb756990 R15: 0000000000000080
FS:  00007f5bc71d6700(0000) GS:ffff88023fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000bb40f000 CR4: 00000000000406f0
Stack:
 ffff880021adb778 00000000ffffffff ffff8800bb756800 ffff8800bb756806
 ffff8800bb756938 0000000000000080 ffff880021adb7a8 ffffffffa05a9814
 ffff880021adb7a8 000000000000000b ffff8800bb756800 ffff880021adb870
Call Trace:
 [<ffffffffa05a9814>] drop_one_stripe+0x44/0xb0 [raid456]
 [<ffffffffa05a9a6a>] raid5_cache_scan+0x6a/0x90 [raid456]
 [<ffffffff81179299>] shrink_slab+0x229/0x440
 [<ffffffff8117cbca>] shrink_zone+0x2ca/0x2e0
 [<ffffffff8117cd53>] do_try_to_free_pages+0x173/0x410
 [<ffffffff8117d097>] try_to_free_pages+0xa7/0x1a0
 [<ffffffff8116fcbf>] __alloc_pages_nodemask+0x5ff/0x9e0
 [<ffffffff811b71f1>] alloc_pages_current+0x91/0x110
 [<ffffffff81166657>] __page_cache_alloc+0xa7/0xd0
 [<ffffffff811738e0>] __do_page_cache_readahead+0x120/0x290
 [<ffffffff81173b30>] ondemand_readahead+0xe0/0x2a0
 [<ffffffff811666ac>] ? pagecache_get_page+0x2c/0x1f0
 [<ffffffff81173e3e>] page_cache_sync_readahead+0x2e/0x50
 [<ffffffff81167b44>] generic_file_read_iter+0x4e4/0x600
 [<ffffffff811e062e>] __vfs_read+0xce/0x100
 [<ffffffff811e0f07>] vfs_read+0x87/0x140
 [<ffffffff811e1d19>] SyS_read+0x59/0xd0
 [<ffffffff8158bfee>] system_call_fastpath+0x12/0x71
Code: 48 63 c6 48 c1 e0 04 48 89 e5 41 57 41 56 4c 8d b4 07 a0 01 00 00 41 =
55 41 54 53 48 83 ec 08 49 8b 1e 49 39 de 0f 84 b7 00 00 00 <48> 8b 13 48 8=
b 43 08 41 89 f5 49 89 fc 4c 8d 7b f0 48 89 42 08=20
RIP  [<ffffffffa05a4b91>] get_free_stripe+0x31/0xf0 [raid456]
 RSP <ffff880021adb748>
CR2: 0000000000000000
---[ end trace c34528a6b22f7fec ]---

I applied a patch series by Yuanhan Liu for preparation [0][1][2] and a pat=
ch
by Neil Brown to avoid a race condition [3]. This still happens.

[0]
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/?id=
=3D9f3520c3
[1]
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/?id=
=3Db1b46486
[2]
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/?id=
=3De9e4c377
[3]
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/?id=
=3D2d5b569b

--=20
Best regards,
Chris

--Sig_/iu3m3vyiDNaKJMs4r_84CQf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJV2jUtAAoJEIlFIdfMgPR27ZQIAOuX7NUhdHtgiNDFneuqVz6o
SNw1HOv1tOpTHeNCYxjzl9c6z7NXEpfsslmUVipCkyhXa6e+/iVhy/mCQT09O0dy
OVUj3S6dIK+3suo/lLucem7JyXhBBlDQV/TrXQ7HdWxcKNzVP1kJkBtVq0kpf4OA
AuUL8sOR55BEA2mWOyNfZumE8S1iUK/rlguVR70bFeIU14iPm/u3zYPbd6NR2G1X
QQjRmbREg7VIJ/NRq8+4KSRgq92kBlK0h7Z1o/e0Ec/27pxtCetTTu6cl11wjsHV
J41IbeYLsWDJki5jN4Tqx6uhB746aVLf+u6byeYkYgyx/aUPxoQ/rvlr5arlxqg=
=hHiM
-----END PGP SIGNATURE-----

--Sig_/iu3m3vyiDNaKJMs4r_84CQf--
