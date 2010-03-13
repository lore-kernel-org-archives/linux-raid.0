From: Kapetanakis Giannis <bilias@edu.physics.uoc.gr>
Subject: Re: large filesystem corruptions
Date: Sat, 13 Mar 2010 02:55:40 +0200
Message-ID: <4B9AE28C.8030905@edu.physics.uoc.gr>
References: <4B9A9D81.3000009@edu.physics.uoc.gr> <4B9AA5AC.9090005@redhat.com> <4B9ADC61.7080007@edu.physics.uoc.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9ADC61.7080007@edu.physics.uoc.gr>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/03/10 02:29, Kapetanakis Giannis wrote:
> I did a new test now and didn't use GFT partitions
> but the whole physical/logical drives
>
> sdb -
> | ---> md0 ---> LVM ---> ext4 filesystems
> sdc -
>
> all sdb, sdc, md0 are gpt labeled without gpt partitions
> inside. No crash so far but without any data written.
>
> Maybe the gpt partitions did the bad thing?
> Can md0 use large gpt drives with no partitions?
> can lvm2 use large raid device with no partition pv?

crashed and burned also:

Mar 13 02:40:28 server kernel: EXT4-fs error (device dm-4): 
ext4_mb_generate_buddy: EXT4-fs: group 48: 24544 blocks in bitmap, 2016 
in gd
Mar 13 02:40:28 server kernel: EXT4-fs error (device dm-4): 
mb_free_blocks: double-free of inode 12's block 1583104(bit 10240 in 
group 48)
Mar 13 02:40:28 server kernel: EXT4-fs error (device dm-4): 
mb_free_blocks: double-free of inode 12's block 1583105(bit 10241 in 
group 48)
--snip

so gpt partitions was not a problem.

Next in list: XFS

    682  2:47    mkfs.xfs -f /dev/vgshare/share
    684  2:47    mount /dev/vgshare/share /share/
    686  2:47    mkfs.xfs -f /dev/vgshare/test
    687  2:47    mount /dev/vgshare/test /test/
    689  2:47    cd /share/
    691  2:48    dd if=/dev/zero of=papaki bs=4096

Mar 13 02:47:23 server kernel: Filesystem "dm-4": Disabling barriers, 
not supported by the underlying device
Mar 13 02:47:23 server kernel: XFS mounting filesystem dm-4
Mar 13 02:47:48 server kernel: Filesystem "dm-5": Disabling barriers, 
not supported by the underlying device
Mar 13 02:47:48 server kernel: XFS mounting filesystem dm-5
Mar 13 02:48:05 server kernel: Filesystem "dm-4": XFS internal error 
xfs_trans_cancel at line 1138 of file 
/home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_PAE/xfs_trans.c. 
  Caller 0xf90e0bbc
Mar 13 02:48:05 server kernel:  [<f90d85fe>] xfs_trans_cancel+0x4d/0xd6 
[xfs]
Mar 13 02:48:05 server kernel:  [<f90e0bbc>] xfs_create+0x4ec/0x525 [xfs]
Mar 13 02:48:05 server kernel:  [<f90e0bbc>] xfs_create+0x4ec/0x525 [xfs]
Mar 13 02:48:05 server kernel:  [<f90e88f4>] xfs_vn_mknod+0x19c/0x380 [xfs]
Mar 13 02:48:05 server kernel:  [<c04760e9>] __getblk+0x30/0x27a
Mar 13 02:48:05 server kernel:  [<f8852ac7>] 
do_get_write_access+0x441/0x46e [jbd]
Mar 13 02:48:05 server kernel:  [<f8889502>] 
__ext3_get_inode_loc+0x109/0x2d5 [ext3]
Mar 13 02:48:05 server kernel:  [<c045a7aa>] 
get_page_from_freelist+0x96/0x370
Mar 13 02:48:05 server kernel:  [<f90b6827>] xfs_dir_lookup+0x91/0xff [xfs]
Mar 13 02:48:05 server kernel:  [<f90c3c51>] xfs_iunlock+0x51/0x6d [xfs]
Mar 13 02:48:05 server kernel:  [<c04824f0>] __link_path_walk+0xc62/0xd33
Mar 13 02:48:05 server kernel:  [<c0480b43>] vfs_create+0xc8/0x12f
Mar 13 02:48:05 server kernel:  [<c04834ef>] open_namei+0x16a/0x5fb
Mar 13 02:48:05 server kernel:  [<c0472a92>] __dentry_open+0xea/0x1ab
Mar 13 02:48:05 server kernel:  [<c0472be2>] do_filp_open+0x1c/0x31
Mar 13 02:48:05 server kernel:  [<c0472c35>] do_sys_open+0x3e/0xae
Mar 13 02:48:05 server kernel:  [<c0472cd2>] sys_open+0x16/0x18
Mar 13 02:48:05 server kernel:  [<c0404f17>] syscall_call+0x7/0xb
Mar 13 02:48:05 server kernel:  =======================
Mar 13 02:48:05 server kernel: xfs_force_shutdown(dm-4,0x8) called from 
line 1139 of file 
/home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_PAE/xfs_trans.c. 
  Return address = 0xf90eb6c4
Mar 13 02:48:05 server kernel: Filesystem "dm-4": Corruption of 
in-memory data detected.  Shutting down filesystem: dm-4
Mar 13 02:48:05 server kernel: Please umount the filesystem, and rectify 
the problem(s)
Mar 13 02:48:45 server kernel: xfs_force_shutdown(dm-4,0x1) called from 
line 424 of file 
/home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_PAE/xfs_rw.c. 
Return address = 0xf90eb6c4
Mar 13 02:48:45 server kernel: xfs_force_shutdown(dm-4,0x1) called from 
line 424 of file 
/home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_PAE/xfs_rw.c. 
Return address = 0xf90eb6c4

xfs_check /dev/vgshare/share
XFS: Log inconsistent (didn't find previous header)
XFS: failed to find log head
ERROR: cannot find log head/tail, run xfs_repair

xfs_repair /dev/vgshare/share
Phase 1 - find and verify superblock...
bad primary superblock - filesystem mkfs-in-progress bit set !!!

attempting to find secondary superblock...
...................................

I stopped it, can't wait to search 7TB to find the secondary 
superblock...probably won't find anything

/test works

So are we sure it's the fs?
Something else is fishy...

regards,

Giannis
