From: Tim Southerwood <ts@dionic.net>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Wed, 23 Jan 2008 13:37:18 +0000
Message-ID: <4797430E.2020603@dionic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry if this breaks threaded mail readers, I only just subscribed to 
the list so don;t have the original post to reply to.

I believe I'm having the same problem.

Regarding XFS on a raid5 md array:

Kernels 2.6.22-14 (Ubuntu Gutsy generic and server builds) *and* 
2.6.24-rc8 (pure build from virgin sources) compiled for amd64 arch.

Raid 5 configured across 4 x 500GB SATA disks (Nforce nv_sata driver, 
Asus M2N-E mobo, Athlon X64, 4GB RAM

MD Chunk size is 1024k. This is allocated to an LVM2 PV, then sliced up.
Taking one sample logical volume of 150GB I ran

mkfs.xfs -d su=1024k,sw=3 -L vol_linux /dev/vg00/vol_linux

I then found that putting high write load on that filesystem cause a 
hang. High load could be a little as a single rsync of a mirror of 
Ubunty Gutsy (many 10's of GB) from my old server to here. Hang would 
happen in a few hours typically.

I could generate relatively quick hangs by running xfs_fsr (defragger) 
in parallel.

Trying the workaround up upping /sys/block/md1/md/stripe_cache_size to 
4096 seems (fingers crossed) to have helped. Been running the rsync 
again, plus xfs_fst + a few dd's of 11 GB to the same filesystem.

I did notice also that the write speed increased dramatically with a 
bigger stripe_cache_size.

A more detailed analysis of the problem indicated that, after the hang:

I could log in;

One CPU core was stuck in 100% IO wait.
The other core was useable, with care. So I managed to get a SysRQ T and 
  one place the system appeared blocked was via this path:

[ 2039.466258] xfs_fsr       D 0000000000000000     0  7324   7308
[ 2039.466260]  ffff810119399858 0000000000000082 0000000000000000 
0000000000000046
[ 2039.466263]  ffff810110d6c680 ffff8101102ba998 ffff8101102ba770 
ffffffff8054e5e0
[ 2039.466265]  ffff8101102ba998 000000010014a1e6 ffffffffffffffff 
ffff810110ddcb30
[ 2039.466268] Call Trace:
[ 2039.466277]  [<ffffffff8808a26b>] :raid456:get_active_stripe+0x1cb/0x610
[ 2039.466282]  [<ffffffff80234000>] default_wake_function+0x0/0x10
[ 2039.466289]  [<ffffffff88090ff8>] :raid456:make_request+0x1f8/0x610
[ 2039.466293]  [<ffffffff80251c20>] autoremove_wake_function+0x0/0x30
[ 2039.466295]  [<ffffffff80331121>] __up_read+0x21/0xb0
[ 2039.466300]  [<ffffffff8031f336>] generic_make_request+0x1d6/0x3d0
[ 2039.466303]  [<ffffffff80280bad>] vm_normal_page+0x3d/0xc0
[ 2039.466307]  [<ffffffff8031f59f>] submit_bio+0x6f/0xf0
[ 2039.466311]  [<ffffffff802c98cc>] dio_bio_submit+0x5c/0x90
[ 2039.466313]  [<ffffffff802c9943>] dio_send_cur_page+0x43/0xa0
[ 2039.466316]  [<ffffffff802c99ee>] submit_page_section+0x4e/0x150
[ 2039.466319]  [<ffffffff802ca2e2>] __blockdev_direct_IO+0x742/0xb50
[ 2039.466342]  [<ffffffff8832e9a2>] :xfs:xfs_vm_direct_IO+0x182/0x190
[ 2039.466357]  [<ffffffff8832edb0>] :xfs:xfs_get_blocks_direct+0x0/0x20
[ 2039.466370]  [<ffffffff8832e350>] :xfs:xfs_end_io_direct+0x0/0x80
[ 2039.466375]  [<ffffffff80444fb5>] __wait_on_bit_lock+0x65/0x80
[ 2039.466380]  [<ffffffff80272883>] generic_file_direct_IO+0xe3/0x190
[ 2039.466385]  [<ffffffff802729a4>] generic_file_direct_write+0x74/0x150
[ 2039.466402]  [<ffffffff88336db2>] :xfs:xfs_write+0x492/0x8f0
[ 2039.466421]  [<ffffffff883099bc>] :xfs:xfs_iunlock+0x2c/0xb0
[ 2039.466437]  [<ffffffff88336866>] :xfs:xfs_read+0x186/0x240
[ 2039.466443]  [<ffffffff8029e5b9>] do_sync_write+0xd9/0x120
[ 2039.466448]  [<ffffffff80251c20>] autoremove_wake_function+0x0/0x30
[ 2039.466457]  [<ffffffff8029eead>] vfs_write+0xdd/0x190
[ 2039.466461]  [<ffffffff8029f5b3>] sys_write+0x53/0x90
[ 2039.466465]  [<ffffffff8020c29e>] system_call+0x7e/0x83


However, I'm of the opinion that the system should not deadlock, even if 
tunable parameters are unfavourable. I'm happy with the workaround 
(indeed the system performs better).

However, it will take me a week's worth of testing before I'm willing to 
commission this as my new fileserver.

So, if there is anything anyone would like me to try, I'm happy to 
volunteer as a guinea pig :)

Yes, I can build and patch kernels. But I'm not hot at debugging kernels 
so if kernel core dumps or whatever are needed, please point me at the 
right document or hint as to which commands I need to read about.

Cheers

Tim
