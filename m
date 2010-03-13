From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: large filesystem corruptions
Date: Fri, 12 Mar 2010 17:58:03 -0800
Message-ID: <4877c76c1003121758w49cdeccas6865e65c9e985770@mail.gmail.com>
References: <4B9A9D81.3000009@edu.physics.uoc.gr> <4B9AA5AC.9090005@redhat.com>
	 <4B9ADC61.7080007@edu.physics.uoc.gr>
	 <4B9AE28C.8030905@edu.physics.uoc.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9AE28C.8030905@edu.physics.uoc.gr>
Sender: linux-raid-owner@vger.kernel.org
To: Kapetanakis Giannis <bilias@edu.physics.uoc.gr>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 12, 2010 at 4:55 PM, Kapetanakis Giannis
<bilias@edu.physics.uoc.gr> wrote:
> On 13/03/10 02:29, Kapetanakis Giannis wrote:
>>
>> I did a new test now and didn't use GFT partitions
>> but the whole physical/logical drives
>>
>> sdb -
>> | ---> md0 ---> LVM ---> ext4 filesystems
>> sdc -
>>
>> all sdb, sdc, md0 are gpt labeled without gpt partitions
>> inside. No crash so far but without any data written.
>>
>> Maybe the gpt partitions did the bad thing?
>> Can md0 use large gpt drives with no partitions?
>> can lvm2 use large raid device with no partition pv?
>
> crashed and burned also:
>
> Mar 13 02:40:28 server kernel: EXT4-fs error (device dm-4):
> ext4_mb_generate_buddy: EXT4-fs: group 48: 24544 blocks in bitmap, 20=
16 in
> gd
> Mar 13 02:40:28 server kernel: EXT4-fs error (device dm-4): mb_free_b=
locks:
> double-free of inode 12's block 1583104(bit 10240 in group 48)
> Mar 13 02:40:28 server kernel: EXT4-fs error (device dm-4): mb_free_b=
locks:
> double-free of inode 12's block 1583105(bit 10241 in group 48)
> --snip
>
> so gpt partitions was not a problem.
>
> Next in list: XFS
>
> =A0 682 =A02:47 =A0 =A0mkfs.xfs -f /dev/vgshare/share
> =A0 684 =A02:47 =A0 =A0mount /dev/vgshare/share /share/
> =A0 686 =A02:47 =A0 =A0mkfs.xfs -f /dev/vgshare/test
> =A0 687 =A02:47 =A0 =A0mount /dev/vgshare/test /test/
> =A0 689 =A02:47 =A0 =A0cd /share/
> =A0 691 =A02:48 =A0 =A0dd if=3D/dev/zero of=3Dpapaki bs=3D4096
>
> Mar 13 02:47:23 server kernel: Filesystem "dm-4": Disabling barriers,=
 not
> supported by the underlying device
> Mar 13 02:47:23 server kernel: XFS mounting filesystem dm-4
> Mar 13 02:47:48 server kernel: Filesystem "dm-5": Disabling barriers,=
 not
> supported by the underlying device
> Mar 13 02:47:48 server kernel: XFS mounting filesystem dm-5
> Mar 13 02:48:05 server kernel: Filesystem "dm-4": XFS internal error
> xfs_trans_cancel at line 1138 of file
> /home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_PAE/xfs_trans.=
c.
> =A0Caller 0xf90e0bbc
> Mar 13 02:48:05 server kernel: =A0[<f90d85fe>] xfs_trans_cancel+0x4d/=
0xd6
> [xfs]
> Mar 13 02:48:05 server kernel: =A0[<f90e0bbc>] xfs_create+0x4ec/0x525=
 [xfs]
> Mar 13 02:48:05 server kernel: =A0[<f90e0bbc>] xfs_create+0x4ec/0x525=
 [xfs]
> Mar 13 02:48:05 server kernel: =A0[<f90e88f4>] xfs_vn_mknod+0x19c/0x3=
80 [xfs]
> Mar 13 02:48:05 server kernel: =A0[<c04760e9>] __getblk+0x30/0x27a
> Mar 13 02:48:05 server kernel: =A0[<f8852ac7>] do_get_write_access+0x=
441/0x46e
> [jbd]
> Mar 13 02:48:05 server kernel: =A0[<f8889502>]
> __ext3_get_inode_loc+0x109/0x2d5 [ext3]
> Mar 13 02:48:05 server kernel: =A0[<c045a7aa>]
> get_page_from_freelist+0x96/0x370
> Mar 13 02:48:05 server kernel: =A0[<f90b6827>] xfs_dir_lookup+0x91/0x=
ff [xfs]
> Mar 13 02:48:05 server kernel: =A0[<f90c3c51>] xfs_iunlock+0x51/0x6d =
[xfs]
> Mar 13 02:48:05 server kernel: =A0[<c04824f0>] __link_path_walk+0xc62=
/0xd33
> Mar 13 02:48:05 server kernel: =A0[<c0480b43>] vfs_create+0xc8/0x12f
> Mar 13 02:48:05 server kernel: =A0[<c04834ef>] open_namei+0x16a/0x5fb
> Mar 13 02:48:05 server kernel: =A0[<c0472a92>] __dentry_open+0xea/0x1=
ab
> Mar 13 02:48:05 server kernel: =A0[<c0472be2>] do_filp_open+0x1c/0x31
> Mar 13 02:48:05 server kernel: =A0[<c0472c35>] do_sys_open+0x3e/0xae
> Mar 13 02:48:05 server kernel: =A0[<c0472cd2>] sys_open+0x16/0x18
> Mar 13 02:48:05 server kernel: =A0[<c0404f17>] syscall_call+0x7/0xb
> Mar 13 02:48:05 server kernel: =A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Mar 13 02:48:05 server kernel: xfs_force_shutdown(dm-4,0x8) called fr=
om line
> 1139 of file
> /home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_PAE/xfs_trans.=
c.
> =A0Return address =3D 0xf90eb6c4
> Mar 13 02:48:05 server kernel: Filesystem "dm-4": Corruption of in-me=
mory
> data detected. =A0Shutting down filesystem: dm-4
> Mar 13 02:48:05 server kernel: Please umount the filesystem, and rect=
ify the
> problem(s)
> Mar 13 02:48:45 server kernel: xfs_force_shutdown(dm-4,0x1) called fr=
om line
> 424 of file
> /home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_PAE/xfs_rw.c. =
Return
> address =3D 0xf90eb6c4
> Mar 13 02:48:45 server kernel: xfs_force_shutdown(dm-4,0x1) called fr=
om line
> 424 of file
> /home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_PAE/xfs_rw.c. =
Return
> address =3D 0xf90eb6c4
>
> xfs_check /dev/vgshare/share
> XFS: Log inconsistent (didn't find previous header)
> XFS: failed to find log head
> ERROR: cannot find log head/tail, run xfs_repair
>
> xfs_repair /dev/vgshare/share
> Phase 1 - find and verify superblock...
> bad primary superblock - filesystem mkfs-in-progress bit set !!!
>
> attempting to find secondary superblock...
> ...................................
>
> I stopped it, can't wait to search 7TB to find the secondary
> superblock...probably won't find anything
>
> /test works
>
> So are we sure it's the fs?
> Something else is fishy...
>
> regards,
>
> Giannis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

This is a really basic thing, but do you have the x86 support for very
large block devices (I can't remember what the option is, since I've
been running 64 bits on any system that even remotely came close to
needing it anyway) enabled in the config as well?

Here's a hit from google, CONFIG_LBD http://cateee.net/lkddb/web-lkddb/=
LBD.html

Enable block devices of size 2TB and larger.

Since you're using a device >2TB in size, I will assume you are using
one of the three 'version 1' superblock types.  Either at the end 1.0,
beginning 1.1 or 4kb in from the beginning.

Please provide the full output of mdadm -Dvvs

You can use any block device as a member of an md array.  However if
you are going 'whole drive' then it would be a very good idea to erase
the existing partition table structure prior to putting a raid
superblock on the device.  This way there is no confusion about if the
device has partitions or is in fact a raid member.  Similarly when
transitioning back the other way ensuring that the old metadata for
the array is erased is also a good idea.

The kernel you're running seems to be ... exceptionally old and
heavily patched.  I have no way of knowing if the many, many, patches
that fixed numerous issues over the /years/ since it's release have
been included.  Please make sure you have the most recent release from
your vendor and ask them for support in parallel.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
