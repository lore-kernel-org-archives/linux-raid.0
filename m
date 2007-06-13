From: "Mike Snitzer" <snitzer@gmail.com>
Subject: raid1 with nbd member hangs MD on SLES10 and RHEL5
Date: Tue, 12 Jun 2007 22:30:27 -0400
Message-ID: <170fa0d20706121930g3b89ddeex8b31c8923d2a0ff6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When using raid1 with one local member and one nbd member (marked as
write-mostly) MD hangs when trying to format /dev/md0 with ext3.  Both
'cat /proc/mdstat' and 'mdadm --detail /dev/md0' hang infinitely.
I've not tried to reproduce on 2.6.18 or 2.6.19ish kernel.org kernels
yet but this issue affects both SLES10 and RHEL5.

sysrq traces for RHEL5 follow; I don't have immediate access to a
SLES10 system at the moment but I've seen this same hang with SLES10
SP1 RC4:

cat /proc/mdstat

cat           S ffff8100048e7de8  6208 11428  11391                     (NOTLB)
 ffff8100048e7de8 00000000076eb000 ffffffff80098ea6 0000000000000008
 ffff81001ff170c0 ffff810037e17100 00045f8d13924085 000000000006b89f
 ffff81001ff17290 0000000000000001 0000000000000005 00000000ffffffff
Call Trace:
 [<ffffffff80098ea6>] seq_printf+0x67/0x8f
 [<ffffffff80233df5>] __mutex_lock_interruptible_slowpath+0x7f/0xbc
 [<ffffffff801be644>] md_seq_show+0x123/0x6aa
 [<ffffffff8009939f>] seq_read+0x1b8/0x28d
 [<ffffffff8007b7a8>] vfs_read+0xcb/0x171
 [<ffffffff8007bb87>] sys_read+0x45/0x6e
 [<ffffffff800097e1>] tracesys+0xd1/0xdc

/sbin/mdadm --detail /dev/md0

mdadm         S ffff810035a1dd78  6384  3829   3828                     (NOTLB)
 ffff810035a1dd78 ffff81003f4570c0 ffffffff80094e4d 0000000000000001
 ffff81000617c870 ffff810037e17100 00043e667c800afe 000000000005ae94
 ffff81000617ca40 0000000000000001 0000000000000021 00000000ffffffff
Call Trace:
 [<ffffffff80094e4d>] mntput_no_expire+0x19/0x89
 [<ffffffff80233df5>] __mutex_lock_interruptible_slowpath+0x7f/0xbc
 [<ffffffff801be4e7>] md_open+0x2e/0x68
 [<ffffffff80082560>] do_open+0x216/0x316
 [<ffffffff8008280b>] blkdev_open+0x0/0x4f
 [<ffffffff8008282e>] blkdev_open+0x23/0x4f
 [<ffffffff80079889>] __dentry_open+0xd9/0x1dc
 [<ffffffff80079a40>] do_filp_open+0x2d/0x3d
 [<ffffffff80079a94>] do_sys_open+0x44/0xbe
 [<ffffffff800097e1>] tracesys+0xd1/0xdc

I can provided more detailed information; please just ask.

thanks,
Mike
