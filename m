From: Justin Bronder <jsbronder@gentoo.org>
Subject: Raid10 device hangs during resync and heavy I/O.
Date: Fri, 16 Jul 2010 14:46:18 -0400
Message-ID: <20100716184618.GA25890@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I've been able to reproduce this across a number of machines with the same
hardware configuration.  During a raid10 resync, it's possible to hang the
device so that any further I/O operations will also block.  This can be
fairly simply done using dd. =20

Interestingly, this is not reproducible when using a non-partitioned device.
That is, creating the device with --auto=3Dyes and then directly using it
functions as expected.  However, using --auto=3Dyes or --auto=3Dmdp and then
creating a partition across the device will cause the hang.

=46rom all appearances, this is not just slow I/O, days later the same tasks
are still blocked.  The rest of the system continues to function normally,
including other raid devices.

Below I'm going to include the script I'm using to reproduce, the relevant
kernel tracebacks, and /proc/mdstat.  Thanks in advance for any help
resolving this.


=3D=3D=3D md10-hang.sh =3D=3D=3D
#!/bin/bash

MDP=3Dfalse
# Pick two unused drives here.
MD_DRIVES=3D"sdc sdd"

if ${MDP}; then
    MD_DEV=3D"md_d99"
else
    MD_DEV=3D"md99"
fi

M=3D"/mnt/mdmount"
SIZE=3D8192

die () {
    echo
    echo "ERROR:  $*"
    echo
    exit 1
}

mkraid() {
    local d
    local drives
    local mdargs=3D"--auto=3Dyes"

    ${MDP} && mdargs=3D"--auto=3Dmdp"

    mkdir -p ${M}
    umount -f ${M} &>/dev/null
    mdadm --stop /dev/md_d99 &>/dev/null
    mdadm --stop /dev/md99 &>/dev/null

    for d in ${MD_DRIVES}; do
        sfdisk -uM /dev/${d} <<-EOF
,${SIZE},83
,,83
EOF
        mdadm --zero-superblock /dev/${d}1 &>/dev/null
        drives=3D"${drives} /dev/${d}1"
    done
    mdadm --create /dev/${MD_DEV} \
        --run \
        --force \
        --level=3D10 \
        --layout=3Df2 \
        --raid-devices=3D2 \
        ${mdargs} ${drives} || die "mdadm --create failed"

    if ${MDP}; then
        printf ",,83\n" | sfdisk -uM /dev/${MD_DEV}
        mkfs.ext2 -q /dev/${MD_DEV}p1
        mount /dev/${MD_DEV}p1 ${M} || die "Mount failed"
    else
        printf ",,83\n" | sfdisk -uM /dev/${MD_DEV}
        mkfs.ext2 -q /dev/${MD_DEV}p1
        mount /dev/${MD_DEV}p1 ${M} || die "Mount failed"
    fi

    echo "Creating tmp file"
    dd if=3D/dev/zero of=3D${M}/tmpfile bs=3D1M count=3D4000
}

mkraid
i=3D1
while [ "$(</sys/block/${MD_DEV}/md/sync_action)"  !=3D "idle" ]; do
    echo "Attempt ${i} to cause crash"
    cat /proc/mdstat
    dd if=3D${M}/tmpfile of=3D${M}/cpfile bs=3D1M
    i=3D$((i++))
done


=3D=3D=3D kernel trace =3D=3D=3D
[ 9002.405247] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 9002.433361]  ffff88025436fc30 0000000000000046 ffff88025436fc10 ffff8802=
54616800
[ 9002.460415]  ffff88025d40dd70 ffff88025d40a3f0 0000000354616800 00000000=
000de600
[ 9002.487497]  ffff88025436fc10 ffff8801570343c0 ffff880157034420 ffff8801=
57034448
[ 9002.514575] Call Trace:
[ 9002.526609]  [<ffffffff81320efb>] raise_barrier+0x167/0x1a3
[ 9002.548139]  [<ffffffff810383b6>] ? default_wake_function+0x0/0xf
[ 9002.571218]  [<ffffffff813238e1>] sync_request+0x57d/0x8a8
[ 9002.592430]  [<ffffffff81320ca5>] ? raid10_unplug+0x24/0x28
[ 9002.613833]  [<ffffffff8132ad63>] ? md_thread+0x0/0xe8
[ 9002.633938]  [<ffffffff8132dab2>] md_do_sync+0x685/0xa9d
[ 9002.654556]  [<ffffffff8132ad63>] ? md_thread+0x0/0xe8
[ 9002.674650]  [<ffffffff8132ae31>] md_thread+0xce/0xe8
[ 9002.694435]  [<ffffffff81034aa6>] ? spin_unlock_irqrestore+0x9/0xb
[ 9002.717583]  [<ffffffff81056cc0>] kthread+0x69/0x71
[ 9002.736753]  [<ffffffff810037e4>] kernel_thread_helper+0x4/0x10
[ 9002.759062]  [<ffffffff81056c57>] ? kthread+0x0/0x71
[ 9002.778478]  [<ffffffff810037e0>] ? kernel_thread_helper+0x0/0x10
[ 9002.801286] INFO: task flush-9:99:5896 blocked for more than 120 seconds.
[ 9002.826287] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 9002.854475]  ffff88012fa8b870 0000000000000046 ffff88012fa8b850 ffff8802=
54616800
[ 9002.881589]  ffff88025d40ebd0 ffff88025d40a3f0 000000036fb73300 00000000=
00000001
[ 9002.908691]  ffff88012fa8b850 ffff8801570343c0 ffff880157034420 ffff8801=
57034448
[ 9002.935778] Call Trace:
[ 9002.947781]  [<ffffffff81320d5b>] wait_barrier+0xa7/0xe0
[ 9002.968438]  [<ffffffff810383b6>] ? default_wake_function+0x0/0xf
[ 9002.991452]  [<ffffffff8132163e>] make_request+0x121/0x507
[ 9003.012697]  [<ffffffff8132d2aa>] md_make_request+0xc7/0x101
[ 9003.034515]  [<ffffffff811dc817>] generic_make_request+0x1af/0x276
[ 9003.057953]  [<ffffffff811dda3b>] submit_bio+0x9e/0xa7
[ 9003.078197]  [<ffffffff810e950d>] submit_bh+0x11b/0x13f
[ 9003.098648]  [<ffffffff810ebba9>] __block_write_full_page+0x20b/0x310
[ 9003.122755]  [<ffffffff810ec383>] ? end_buffer_async_write+0x0/0x13a
[ 9003.146576]  [<ffffffff810ef5b2>] ? blkdev_get_block+0x0/0x50
[ 9003.168612]  [<ffffffff810ec383>] ? end_buffer_async_write+0x0/0x13a
[ 9003.192521]  [<ffffffff810ef5b2>] ? blkdev_get_block+0x0/0x50
[ 9003.214684]  [<ffffffff810ebd30>] block_write_full_page_endio+0x82/0x8e
[ 9003.239426]  [<ffffffff810ebd4c>] block_write_full_page+0x10/0x12
[ 9003.262539]  [<ffffffff810eea92>] blkdev_writepage+0x13/0x15
[ 9003.284297]  [<ffffffff8109e005>] __writepage+0x12/0x2b
[ 9003.304718]  [<ffffffff8109e46c>] write_cache_pages+0x1fa/0x306
[ 9003.327254]  [<ffffffff8109dff3>] ? __writepage+0x0/0x2b
[ 9003.347976]  [<ffffffff810e9f65>] ? mark_buffer_dirty+0x85/0x89
[ 9003.370488]  [<ffffffff8109e597>] generic_writepages+0x1f/0x25
[ 9003.392661]  [<ffffffff8109e5b9>] do_writepages+0x1c/0x25
[ 9003.413477]  [<ffffffff810e43e0>] writeback_single_inode+0xb0/0x1c7
[ 9003.436962]  [<ffffffff810e4b5a>] writeback_inodes_wb+0x2bf/0x35a
[ 9003.459949]  [<ffffffff810e4d1a>] wb_writeback+0x125/0x1a1
[ 9003.481145]  [<ffffffff810e4f66>] wb_do_writeback+0x138/0x14f
[ 9003.503124]  [<ffffffff810ab3e7>] ? bdi_start_fn+0x0/0xca
[ 9003.524024]  [<ffffffff810e4fa4>] bdi_writeback_task+0x27/0x92
[ 9003.546241]  [<ffffffff810ab44c>] bdi_start_fn+0x65/0xca
[ 9003.566875]  [<ffffffff81056cc0>] kthread+0x69/0x71
[ 9003.586179]  [<ffffffff810037e4>] kernel_thread_helper+0x4/0x10
[ 9003.608532]  [<ffffffff81056c57>] ? kthread+0x0/0x71
[ 9003.627949]  [<ffffffff810037e0>] ? kernel_thread_helper+0x0/0x10
[ 9003.650791] INFO: task dd:5912 blocked for more than 120 seconds.
[ 9003.673621] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 9003.701721]  ffff88024c84d7b8 0000000000000082 ffff88024c84d798 ffff8802=
54616800
[ 9003.728793]  ffff88025d6840b0 ffff88025f065640 0000000296364968 00000000=
00000000
[ 9003.755893]  000000014c84d798 ffff8801570343c0 ffff880157034420 ffff8801=
57034448
[ 9003.773323] Call Trace:
[ 9003.773326]  [<ffffffff81320d5b>] wait_barrier+0xa7/0xe0
[ 9003.773328]  [<ffffffff810383b6>] ? default_wake_function+0x0/0xf
[ 9003.773330]  [<ffffffff8132163e>] make_request+0x121/0x507
[ 9003.773332]  [<ffffffff810edbd7>] ? bio_split+0xca/0x183
[ 9003.773334]  [<ffffffff813215d5>] make_request+0xb8/0x507
[ 9003.773337]  [<ffffffff811d780d>] ? __elv_add_request+0xa1/0xaa
[ 9003.773339]  [<ffffffff8132d2aa>] md_make_request+0xc7/0x101
[ 9003.773341]  [<ffffffff811dc817>] generic_make_request+0x1af/0x276
[ 9003.773343]  [<ffffffff810ed885>] ? bio_alloc_bioset+0x70/0xc0
[ 9003.773345]  [<ffffffff811dda3b>] submit_bio+0x9e/0xa7
[ 9003.773347]  [<ffffffff810f0d0b>] mpage_bio_submit+0x22/0x26
[ 9003.773349]  [<ffffffff810f17df>] do_mpage_readpage+0x462/0x54e
[ 9003.773352]  [<ffffffff8109fb21>] ? get_page+0x9/0xf
[ 9003.773354]  [<ffffffff810a004d>] ? __lru_cache_add+0x40/0x58
[ 9003.773357]  [<ffffffff8112c194>] ? ext2_get_block+0x0/0x78a
[ 9003.773359]  [<ffffffff810f1a66>] mpage_readpages+0xc9/0x10f
[ 9003.773361]  [<ffffffff8112c194>] ? ext2_get_block+0x0/0x78a
[ 9003.773363]  [<ffffffff81001d89>] ? __switch_to+0x10e/0x1e1
[ 9003.773366]  [<ffffffff8112b40c>] ext2_readpages+0x1a/0x1c
[ 9003.773368]  [<ffffffff8109f4d0>] __do_page_cache_readahead+0xf6/0x191
[ 9003.773370]  [<ffffffff8109f587>] ra_submit+0x1c/0x20
[ 9003.773372]  [<ffffffff8109f7e3>] ondemand_readahead+0x17b/0x18e
[ 9003.773374]  [<ffffffff8109f870>] page_cache_async_readahead+0x7a/0xa2
[ 9003.773379]  [<ffffffff81098a59>] generic_file_aio_read+0x26e/0x55d
[ 9003.773382]  [<ffffffff810cb32e>] do_sync_read+0xc2/0x106
[ 9003.773384]  [<ffffffff810a009d>] ? lru_cache_add_lru+0x38/0x3d
[ 9003.773387]  [<ffffffff8100338e>] ? apic_timer_interrupt+0xe/0x20
[ 9003.773389]  [<ffffffff810cb980>] vfs_read+0xa4/0xde
[ 9003.773391]  [<ffffffff810cbc02>] sys_read+0x47/0x6d
[ 9003.773393]  [<ffffffff81002a42>] system_call_fastpath+0x16/0x1b


=3D=3D=3D /proc/mdstat =3D=3D=3D
Personalities : [raid1] [raid10]=20
md99 : active raid10 sdd1[1] sdc1[0]
      8393856 blocks 64K chunks 2 far-copies [2/2] [UU]
      [=3D>...................]  resync =3D  5.4% (455360/8393856) finish=
=3D3938.0min speed=3D33K/sec
     =20
md1 : active raid10 sda2[0] sdb2[1]
      976703488 blocks 512K chunks 2 far-copies [2/2] [UU]
     =20
md0 : active raid1 sda1[0] sdb1[1]
      56128 blocks [2/2] [UU]
     =20
unused devices: <none>


--=20
Justin Bronder

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEARECAAYFAkxAqPoACgkQ4MrvBE1wQ8mOCACeNVfdTn3jRPIwRgYDNS1KuXd1
6eQAn06Z9mW0qAmHSEmwZNhxBgEa366J
=jQfw
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
