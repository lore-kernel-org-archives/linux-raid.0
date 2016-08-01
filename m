From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 3/3] MD: hold mddev lock for md-cluster receive thread
Date: Mon, 1 Aug 2016 16:38:59 +0800
Message-ID: <579F0AA3.5090806@suse.com>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
 <7763e508fb97d44bd61e826912055617b8be2c2d.1469922791.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7763e508fb97d44bd61e826912055617b8be2c2d.1469922791.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

Hi,

On 07/31/2016 07:54 AM, shli@kernel.org wrote:
> From: Shaohua Li <shli@fb.com>
>
> md-cluster receive thread calls .quiesce too, let it hold mddev lock.

I'd suggest hold on for the patchset, I can find lock problem easily with
the patchset applied. Take a resyncing  clusteed raid1 as example.

md127_raid1 thread held reconfig_mutex then update sb, so it needs dlm
token lock. Meanwhile md127_resync thread got token lock and wants
EX on ack lock but recv_daemon can't release ack lock since recv_daemon
doesn't get reconfig_mutex.

etalinux135:~ # ps aux|grep md|grep D
root      2028  0.0  0.0      0     0 ?        D    16:24   0:00 
[md127_raid1]
root      2041  0.0  0.0      0     0 ?        D    16:24   0:00 
[md127_resync]
betalinux135:~ # cat /proc/2028/stack
[<ffffffffa05f2660>] metadata_update_start+0xa0/0xb0 [md_cluster]
[<ffffffffa06cb1ce>] md_update_sb.part.50+0x8e/0x810 [md_mod]
[<ffffffffa06ccb8c>] md_check_recovery+0x23c/0x4f0 [md_mod]
[<ffffffffa06f6312>] raid1d+0x42/0x7d0 [raid1]
[<ffffffffa06c6d10>] md_thread+0x130/0x150 [md_mod]
[<ffffffff810995ed>] kthread+0xbd/0xe0
[<ffffffff815e96bf>] ret_from_fork+0x3f/0x70
[<ffffffff81099530>] kthread+0x0/0xe0
[<ffffffffffffffff>] 0xffffffffffffffff
betalinux135:~ # cat /proc/2041/stack
[<ffffffffa05f24cb>] dlm_lock_sync+0x6b/0x80 [md_cluster]
[<ffffffffa05f2708>] __sendmsg+0x98/0x130 [md_cluster]
[<ffffffffa05f282d>] sendmsg+0x1d/0x30 [md_cluster]
[<ffffffffa05f2b31>] resync_info_update+0x81/0xb0 [md_cluster]
[<ffffffffa06f3ad7>] sync_request+0xa57/0xaf0 [raid1]
[<ffffffffa06ca2dd>] md_do_sync+0x90d/0xe80 [md_mod]
[<ffffffffa06c6d10>] md_thread+0x130/0x150 [md_mod]
[<ffffffff810995ed>] kthread+0xbd/0xe0
[<ffffffff815e96bf>] ret_from_fork+0x3f/0x70
[<ffffffff81099530>] kthread+0x0/0xe0
[<ffffffffffffffff>] 0xffffffffffffffff


Thanks,
Guoqing

