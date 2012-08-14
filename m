From: NeilBrown <neilb@suse.de>
Subject: Re: md raid10 Oops on recent kernels
Date: Tue, 14 Aug 2012 10:50:43 +1000
Message-ID: <20120814105043.05c62805@notabene.brown>
References: <CANZ+j8dDLqe=30AFd7oJ9WjhTSTRfbkXPBfBdG3GH=7eHkUqeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sVXMcWhuXUkXbklD5d4=W/A"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANZ+j8dDLqe=30AFd7oJ9WjhTSTRfbkXPBfBdG3GH=7eHkUqeA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ivan Vasilyev <ivan.vasilyev@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/sVXMcWhuXUkXbklD5d4=W/A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Aug 2012 16:49:26 +0400 Ivan Vasilyev <ivan.vasilyev@gmail.com>
wrote:

> Hi all,
>=20
> I'm using md raid over LVM on some servers (since EVMS project has
> proven to be dead), but on kernel versions 3.4 and 3.5 there is a
> problem with raid10.
> It can be reproduced on current Debian Wheezy (set up from scratch with
> 7.0beta1 installer) with kernel package v3.5 taken
> from experimental repository.
>=20
> Array create, initial sync (after "dd ... of=3D/dev/md/rtest_a") and
> --assemble give no errors,
> but then any directIO on md device causes oops (dd without
> iflag=3Ddirect does not).
> Seems strange, but V4L capture by uvcvideo driver also freezes after firs=
t oops
> (and resumes only after mdadm --stop on problematic array)
>=20
> Recent LVM2 has built-in RAID (implemented with md driver), but
> unfortunately raid10 is not supported, so it can't replace current
> setup.
>=20
> Is this a bug in MD driver or in some other part of the kernel? Will it a=
ffect
> other raid setups in future? (like old one with raid0 layered over raid1)
>=20
>=20
> ------------------------------------------------------------
>=20
> Tested on a KVM guest, so hardware seems to be irrelevant.
> Config: 1.5Gb memory, 2 vCPUs, 5 virtio disks
>=20
>=20
> *** Short summary of commands:
> vgcreate gurion_vg_jnt /dev/vdb6 /dev/vdc6 /dev/vdd6 /dev/vde6
> lvcreate -n rtest_a_c1r -l 129 gurion_vg_jnt /dev/vdb6
> ...
> lvcreate -n rtest_a_c4r -l 129 guiron_vg_jnt /dev/vde6
> mdadm --create /dev/md/rtest_a --verbose --metadata=3D1.2 \
>   --level=3Draid10 --raid-devices=3D4 --name=3Drtest_a \
>   --chunk=3D1024 --bitmap=3Dinternal \
>   /dev/gurion_vg_jnt/rtest_a_c1r /dev/gurion_vg_jnt/rtest_a_c2r \
>   /dev/gurion_vg_jnt/rtest_a_c3r /dev/gurion_vg_jnt/rtest_a_c4r
>=20
>=20
> Linux version 3.5-trunk-amd64 (Debian 3.5-1~experimental.1)
> (debian-kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-1) )
> #1 SMP Thu Aug 2 17:16:27 UTC 2012
>=20
> ii  linux-image-3.5-trunk-amd64                  3.5-1~experimental.1
> ii  mdadm                                        3.2.5-1
>=20
> (oops is captured after "mdadm --assemble /dev/md/rtest_a" and then "lvs")
> ----------
>  BUG: unable to handle kernel paging request at ffffffff00000001
>  IP: [<ffffffff00000001>] 0xffffffff00000000
>  PGD 160d067 PUD 0
>  Oops: 0010 [#1] SMP
>  CPU 0
>  Modules linked in: appletalk ipx p8023 p8022 psnap llc rose netrom
> ax25 iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4
> nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables x_tables nfsd nfs
> nfs_acl auth_rpcgss fscache lockd sunrpc loop crc32c_intel
> ghash_clmulni_intel processor aesni_intel aes_x86_64 i2c_piix4
> aes_generic cryptd thermal_sys button snd_pcm i2c_core snd_page_alloc
> snd_timer snd soundcore psmouse pcspkr serio_raw evdev microcode
> virtio_balloon ext4 crc16 jbd2 mbcache dm_mod raid10 raid456
> async_raid6_recov async_memcpy async_pq async_xor xor async_tx
> raid6_pq raid1 raid0 multipath linear md_mod sr_mod cdrom ata_generic
> virtio_net floppy virtio_blk ata_piix uhci_hcd ehci_hcd libata
> scsi_mod virtio_pci virtio_ring virtio usbcore usb_common [last
> unloaded: scsi_wait_scan]
>=20
>  Pid: 11591, comm: lvs Not tainted 3.5-trunk-amd64 #1 Bochs Bochs
>  RIP: 0010:[<ffffffff00000001>]  [<ffffffff00000001>] 0xffffffff00000000
>  RSP: 0018:ffff88005a601a58  EFLAGS: 00010292
>  RAX: 0000000000100000 RBX: ffff88005cc34c80 RCX: ffff88005d334440
>  RDX: 0000000000000000 RSI: ffff88005a601a68 RDI: ffff88005b3d1c00
>  RBP: 0000000000000000 R08: ffffffffa017e99c R09: 0000000000000001
>  R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
>  R13: ffff88005cc34d00 R14: ffffea00010d7d60 R15: 0000000000000000
>  FS:  00007fd8fcef77a0(0000) GS:ffff88005f200000(0000) knlGS:000000000000=
0000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: ffffffff00000001 CR3: 000000005f836000 CR4: 00000000000407f0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Process lvs (pid: 11591, threadinfo ffff88005a600000, task ffff88005f8ae=
040)
>  Stack:
>   ffff880054ad0c80 ffffffff81126dec ffff880057065900 0000000000000400
>   ffffea0000000000 0000000000000000 ffff88005a601b80 ffff8800575ded40
>   ffff88005a601c20 0000000000000000 0000000000000000 ffffffff811299b5
>  Call Trace:
>   [<ffffffff81126dec>] ? bio_alloc+0xe/0x1e
>   [<ffffffff811299b5>] ? dio_bio_add_page+0x16/0x4c
>   [<ffffffff81129a51>] ? dio_send_cur_page+0x66/0xa4
>   [<ffffffff8112a4dc>] ? do_blockdev_direct_IO+0x8cb/0xa81
>   [<ffffffff8125ed7e>] ? kobj_lookup+0xf6/0x12e
>   [<ffffffff811a13c7>] ? disk_map_sector_rcu+0x5d/0x5d
>   [<ffffffff811a2d9f>] ? disk_clear_events+0x3f/0xe4
>   [<ffffffff8112873a>] ? blkdev_max_block+0x2b/0x2b
>   [<ffffffff81128000>] ? blkdev_direct_IO+0x4e/0x53
>   [<ffffffff8112873a>] ? blkdev_max_block+0x2b/0x2b
>   [<ffffffff810bbf07>] ? generic_file_aio_read+0xeb/0x5b5
>   [<ffffffff811103fd>] ? dput+0x26/0xf4
>   [<ffffffff81115b87>] ? mntput_no_expire+0x2a/0x134
>   [<ffffffff8110b3fc>] ? do_last+0x67d/0x717
>   [<ffffffff810ffe44>] ? do_sync_read+0xb4/0xec
>   [<ffffffff8110051e>] ? vfs_read+0x9f/0xe6
>   [<ffffffff811005aa>] ? sys_read+0x45/0x6b
>   [<ffffffff81364779>] ? system_call_fastpath+0x16/0x1b
>  Code:  Bad RIP value.
>  RIP  [<ffffffff00000001>] 0xffffffff00000000
>   RSP <ffff88005a601a58>
>  CR2: ffffffff00000001
>  ---[ end trace b86c49ca25a6cdb2 ]---
> ----------

It looks like the ->merge_bvec_fn is bad - the code is jumping to
0xffffffff00000001, which strongly suggests some function pointer is bad, a=
nd
merge_bvec_fn is the only one in that area of code.
However I cannot see how it could possibly get a bad value like that.

There were changes to merge_bvec_fn handling in RAID10 in 3.4 which is when
you say the problem appeared.  However I cannot see how direct IO would be
affected any differently to normal IO.

If I were to try to debug this I'd build a kernel and put a printk in
__bio_add_page in fs/bio.c just before calling q->merge_bvec_fn to print a
message if that value has the low bit set. (i.e. if (q->merge_bvec_fn & 1) =
...).
I don't know if you are up for that sort of thing...

NeilBrown


--Sig_/sVXMcWhuXUkXbklD5d4=W/A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCmg4znsnt1WYoG5AQKuQw//WoVOFt0I4aAyBnDivkI/JsbKiACqNlZz
GfMe39FHMC/Nh/cLx6a908z3gi5Pa411U3cjWkkHpMoa7/RIPb1jr/HMHIiTZQku
rCh4FAcWR1LA6xi50WjSKWFiIl4ygRKx2Rska/bXV6vjBLRL8NHfIImKz2WHhW7s
geA5BwxES4lZJ97WUQrIjMPasKlE8Yb7NsfOtXiQw7GkmLa6hboVnfPPMW5UZyFJ
Wu4Qpg5nqd9yxBw8buGZ9C7srmdTUtH4FhZ9iQAL4y/oylasH3rX2Vh8C/2CRWB1
t65p8Iw1FswTBZ4S+pLwsf29Z9ZtrAFvEXYWNaFsCbxsP5+GBjan+FEOKLilVEz7
1EuByhdxWGEFBPa7c4GHit20EIfT+n3cIHaQMzm/IctW8UWjFT2BqKoSNUE/DhPP
WJrhBD9ZCptd6YCR5XcaCdX2VWhTkn6VeHE7V+egkN8XNP2o0g8OCcx5fCsKeRAs
sxxcTSCTU0OL+VKfo5Rus8Q3ddFgQzD71OMd69U6jPBOR4/dImH2C/7hrU2lZ4D2
zVre3UwccT5OQQA1ixE2pOs/GjVtWjrnJm3HT4StmyM6Fbs80PaWzFW41pIktNBW
vNqBT7n2nX/2X4mTX0O5bx8H5QFf0EKTRW/pFvjYavJnrplOGzpvt/NjY06znTnt
ddGABCaW4vw=
=+d6e
-----END PGP SIGNATURE-----

--Sig_/sVXMcWhuXUkXbklD5d4=W/A--
