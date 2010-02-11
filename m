From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.32.3 x86_64 - XFS hangs, all I/O to D-state bug (again)
Date: Thu, 11 Feb 2010 09:35:02 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1002110933440.29019@p34.internal.lan>
References: <alpine.DEB.2.00.1002110903080.25392@p34.internal.lan> <alpine.DEB.2.00.1002110912120.25392@p34.internal.lan> <alpine.DEB.2.00.1002110921550.25392@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1002110921550.25392@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

On Thu, 11 Feb 2010, Justin Piszcz wrote:

Hm..


# cd /raid5_mdadm
# touch a
.. hang ..

From echo t to sysrq-trigger:

[ 6906.296062] touch         D ffff880222402680     0   705    599 0x00000000
[ 6906.296062]  ffff880034de3360 0000000000000086 0000000000014000 ffffffff811c985b
[ 6906.296062]  000000000000c928 ffff88019c26bfd8 ffff880222402680 ffff8802224028f8
[ 6906.296062]  0000000300014000 ffffffff811f5277 ffff88023e52f000 ffff8802224028f8
[ 6906.296062] Call Trace:
[ 6906.296062]  [<ffffffff811c985b>] ? xfs_buf_item_init+0xab/0x110
[ 6906.296062]  [<ffffffff811f5277>] ? xfs_trans_read_buf+0x247/0x350
[ 6906.296062]  [<ffffffff811feb3b>] ? xfs_buf_rele+0x3b/0x100
[ 6906.296122]  [<ffffffff810b56e6>] ? cache_alloc_refill+0x96/0x590
[ 6906.296125]  [<ffffffff8145dbc5>] ? schedule_timeout+0x195/0x1f0
[ 6906.296127]  [<ffffffff8145ea81>] ? __down+0x61/0xa0
[ 6906.296131]  [<ffffffff81072046>] ? down+0x46/0x50
[ 6906.296134]  [<ffffffff811ef1b5>] ? xfs_getsb+0x15/0x40
[ 6906.296134]  [<ffffffff811f53da>] ? xfs_trans_getsb+0x5a/0xc0
[ 6906.296134]  [<ffffffff811f325f>] ? xfs_trans_apply_sb_deltas+0xf/0x300
[ 6906.296144]  [<ffffffff811f39fb>] ? _xfs_trans_commit+0xeb/0x3a0
[ 6906.296144]  [<ffffffff811dffd3>] ? xfs_ialloc+0x513/0x6d0
[ 6906.296144]  [<ffffffff811ce72a>] ? xfs_dir_createname+0x17a/0x1d0
[ 6906.296144]  [<ffffffff8105d60e>] ? current_fs_time+0x1e/0x30
[ 6906.296144]  [<ffffffff811f86b1>] ? xfs_create+0x491/0x520
[ 6906.296165]  [<ffffffff81202752>] ? xfs_vn_mknod+0x82/0x130
[ 6906.296167]  [<ffffffff810c46c6>] ? vfs_create+0xa6/0xf0
[ 6906.296170]  [<ffffffff810c806e>] ? do_filp_open+0x9fe/0xad0
[ 6906.296174]  [<ffffffff810a2679>] ? handle_mm_fault+0x1b9/0x7d0
[ 6906.296177]  [<ffffffff8145d2fc>] ? thread_return+0x3e/0x622
[ 6906.296177]  [<ffffffff810b8ae7>] ? do_sys_open+0x97/0x150
[ 6906.296177]  [<ffffffff8102eeeb>] ? system_call_fastpath+0x16/0x1b
