From: Scott Mcdermott <smcdermott@questra.com>
Subject: RAID 1+0 makes BUG in raid1.c, but 0+1 works?
Date: Wed, 25 Dec 2002 17:20:09 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021225172009.Z1089@questra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have 10 disks.  Made 5 RAID1s.  Made a RAID0 over top.  Using the
following Neil Brown patches on top of 2.4.20-ac2 (only some relevant
here, but including in case there is some side effect)

        001NfsdRelease
        004ReadlinkResponseLen
        005MDSyncIo
        006SvcsockWarningGone
        008NfsdLocksExplock
        009NfsdLocksCachelock
        010NfsdLocksNfssvc
        011NfsdLocksRename
        012NfsdFhLock
        013NfsdLocksRacache
        014NfsdBKLgone
        015NfsdMaxBlkSize
        022NfsfhErrFix
        023MdSbNoFree

also using Trond's NFS_ALL, and Justin Gibbs' latest AIC7xxx driver.

When I went to make the RAID0 over the RAID1s (after waiting for the
RAID1s to sync, because I thought that might be the problem), I got
this:

        Dec 25 14:22:06 lujuria kernel: kernel BUG at raid1.c:586!
        Dec 25 14:22:06 lujuria kernel: invalid operand: 0000
        Dec 25 14:22:06 lujuria kernel: CPU:    1
        Dec 25 14:22:06 lujuria kernel: EIP:    0010:[<c02068c0>]    Not tainted
        Using defaults from ksymoops -t elf32-i386 -a i386
        Dec 25 14:22:06 lujuria kernel: EFLAGS: 00010246
        Dec 25 14:22:06 lujuria kernel: eax: 00000001   ebx: ce77dda4   ecx: 00000908   edx: c02beac0
        Dec 25 14:22:06 lujuria kernel: esi: cec40800   edi: ce77dda4   ebp: c138a8a0   esp: ce77dd08
        Dec 25 14:22:06 lujuria kernel: ds: 0018   es: 0018   ss: 0018
        Dec 25 14:22:06 lujuria kernel: Process mkraid (pid: 645, stackpage=ce77d000)
        Dec 25 14:22:06 lujuria kernel: Stack: 4a494847 4e4d4c4b 5251504f 56555453 00000000 00000000 33323130 37363534 
        Dec 25 14:22:06 lujuria kernel:        33323130 37363534 62613938 ce77dda4 00000008 0445c780 00000001 c0209032 
        Dec 25 14:22:06 lujuria kernel:        c138a8a0 00000001 ce77dda4 ce77dda4 c01abdc1 c0372098 00000001 ce77dda4 
        Dec 25 14:22:06 lujuria kernel: Call Trace:    [<c0209032>] [<c01abdc1>] [<c0209862>] [<c0250908>] [<c011c835>]
        Dec 25 14:22:06 lujuria kernel:   [<c0209780>] [<c011caa0>] [<c020a714>] [<c020aa79>] [<c020bc52>] [<c011caa0>]
        Dec 25 14:22:06 lujuria kernel:   [<c02099b5>] [<c020a8b7>] [<c020c9b6>] [<c020d6cc>] [<c015b619>] [<c014a898>]
        Dec 25 14:22:06 lujuria kernel:   [<c014aec3>] [<c014b038>] [<c0142383>] [<c014b1de>] [<c0153d0f>] [<c01426d2>]
        Dec 25 14:22:06 lujuria kernel:   [<c010760f>]
        Dec 25 14:22:06 lujuria kernel: Code: 0f 0b 4a 02 b5 55 29 c0 83 7c 24 44 02 89 34 24 8b 44 24 10 

BUG at raid1.c:586 looks like this:

        static int raid1_make_request (mddev_t *mddev, int rw,
                                       struct buffer_head * bh)
        {
                        raid1_conf_t *conf = mddev_to_conf(mddev);
                        struct buffer_head *bh_req, *bhl;
                        struct raid1_bh * r1_bh;
                        int disks = MD_SB_DISKS;
                        int i, sum_bhs = 0;
                        struct mirror_info *mirror;

                        if (!buffer_locked(bh))
--->                             BUG();

here is the decode:

        >>EIP; c02068c0 <raid1_make_request+20/320>   <=====

        >>ebx; ce77dda4 <_end+e3e486c/1046eb28>
        >>ecx; 00000908 Before first symbol
        >>edx; c02beac0 <raid1_personality+0/40>
        >>esi; cec40800 <_end+e8a72c8/1046eb28>
        >>edi; ce77dda4 <_end+e3e486c/1046eb28>
        >>ebp; c138a8a0 <_end+ff1368/1046eb28>
        >>esp; ce77dd08 <_end+e3e47d0/1046eb28>

        Trace; c0209032 <md_make_request+82/90>
        Trace; c01abdc1 <generic_make_request+e1/140>
        Trace; c0209862 <sync_page_io+c2/100>
        Trace; c0250908 <igmp_group_dropped+18/80>
        Trace; c011c835 <call_console_drivers+65/120>
        Trace; c0209780 <bh_complete+0/20>
        Trace; c011caa0 <printk+140/180>
        Trace; c020a714 <write_disk_sb+134/1a0>
        Trace; c020aa79 <md_update_sb+199/220>
        Trace; c020bc52 <do_md_run+212/3f0>
        Trace; c011caa0 <printk+140/180>
        Trace; c02099b5 <calc_sb_csum+35/50>
        Trace; c020a8b7 <sync_sbs+77/a0>
        Trace; c020c9b6 <add_new_disk+146/2d0>
        Trace; c020d6cc <md_ioctl+36c/820>
        Trace; c015b619 <get_empty_inode+99/b0>
        Trace; c014a898 <bdget+128/190>
        Trace; c014aec3 <do_open+103/1a0>
        Trace; c014b038 <blkdev_open+38/50>
        Trace; c0142383 <dentry_open+d3/1e0>
        Trace; c014b1de <blkdev_ioctl+3e/40>
        Trace; c0153d0f <sys_ioctl+ef/2a0>
        Trace; c01426d2 <sys_open+a2/c0>
        Trace; c010760f <system_call+33/38>

        Code;  c02068c0 <raid1_make_request+20/320>
        00000000 <_EIP>:
        Code;  c02068c0 <raid1_make_request+20/320>   <=====
           0:   0f 0b                     ud2a      <=====
        Code;  c02068c2 <raid1_make_request+22/320>
           2:   4a                        dec    %edx
        Code;  c02068c3 <raid1_make_request+23/320>
           3:   02 b5 55 29 c0 83         add    0x83c02955(%ebp),%dh
        Code;  c02068c9 <raid1_make_request+29/320>
           9:   7c 24                     jl     2f <_EIP+0x2f>
        Code;  c02068cb <raid1_make_request+2b/320>
           b:   44                        inc    %esp
        Code;  c02068cc <raid1_make_request+2c/320>
           c:   02 89 34 24 8b 44         add    0x448b2434(%ecx),%cl
        Code;  c02068d2 <raid1_make_request+32/320>
          12:   24 10                     and    $0x10,%al

Using persistent superblock on all RAID1s and RAID0.  Using 128k chunks.
Using mkraid, not mdadm.  After this happens it *appears* that the RAID0
exists and functions, however upon reboot I get a similar BUG in the
reboot process, and then when booting again it BUGs in the swapper
process, and it refuses to boot if I allow it to autodetect.

is there something I'm doing wrong or is this a bug? Should I not be
using RAID1+0 ? I just tried it with RAID0+1 instead and it seems to
work fine (although it's somewhat slower than I expected, and initial
sync goes 250K/s for some reason until I turn up the minimum).  This
makes no sense to me as I thought that RAID devices were a block-level
abstraction...so why would 0+1 work but not 1+0 ?? I really dislike the
additional probability of second-disk failure in RAID0+1 over RAID1+0,
and the ridiculous resync times, and I don't like the slow write speed
of RAID5.

Thanks for any help.
