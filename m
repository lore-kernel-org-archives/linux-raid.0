From: Tejun Heo <tj@kernel.org>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Mon, 28 Mar 2011 17:59:28 +0200
Message-ID: <20110328155928.GB6736@htj.dyndns.org>
References: <201103251725.21180.thomas.jarosch@intra2net.com>
 <20110328075937.GB16530@htj.dyndns.org>
 <201103281302.20219.thomas.jarosch@intra2net.com>
 <201103281453.53382.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201103281453.53382.thomas.jarosch@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hello,

On Mon, Mar 28, 2011 at 02:53:53PM +0200, Thomas Jarosch wrote:
> Pid: 1143, comm: blkid Not tainted 2.6.38 #26 MSI MS-7349/MS-7349
> EIP: 0060:[<c12dc768>] EFLAGS: 00000246 CPU: 0
> EIP is at __mutex_unlock_slowpath+0xb8/0x150
> EAX: 00000246 EBX: c14252a0 ECX: 00000001 EDX: 00000001
> ESI: c14252c4 EDI: 00000246 EBP: f568fd8c ESP: f568fd80
>  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Process blkid (pid: 1143, ti=f568e000 task=f615c030 task.ti=f568e000)
> Stack:
>  00000000 f545a9c0 00900000 f568fd94 c12dc808 f568fdc0 c11c4451 c11323b0
>  f568fdf0 f55e2e00 00000009 f61ae800 00000000 00000000 f568fdf0 f5df7490
>  f568fdd0 c11331b8 f5df7480 f55e2e00 f568fe00 c10e85aa f615c030 00000000
> Call Trace:
>  [<c12dc808>] mutex_unlock+0x8/0x10
>  [<c11c4451>] kobj_lookup+0xe1/0x140
>  [<c11323b0>] ? exact_match+0x0/0x10
>  [<c11331b8>] get_gendisk+0x98/0xb0
>  [<c10e85aa>] __blkdev_get+0xca/0x320
>  [<c10e8843>] blkdev_get+0x43/0x2c0
>  [<c12de75d>] ? _raw_spin_unlock+0x1d/0x20
>  [<c10e8b12>] blkdev_open+0x52/0x70
>  [<c10bb12d>] __dentry_open+0x9d/0x240
>  [<c10bb3c6>] nameidata_to_filp+0x66/0x80
>  [<c10e8ac0>] ? blkdev_open+0x0/0x70
>  [<c10c781f>] finish_open+0xaf/0x190
>  [<c10c8a24>] ? do_path_lookup+0x44/0xe0
>  [<c10c9920>] do_filp_open+0x210/0x6d0
>  [<c10672e9>] ? lock_release_non_nested+0x59/0x2f0
>  [<c12de75d>] ? _raw_spin_unlock+0x1d/0x20
>  [<c10d47d8>] ? alloc_fd+0xb8/0xf0
>  [<c10baf45>] do_sys_open+0x55/0xf0
>  [<c10bb049>] sys_open+0x29/0x40
>  [<c1002e9f>] sysenter_do_call+0x12/0x38

Hmmm... Weird.

* blkid seems to be looping in blkdev_open() repeatedly calling
  md_open() which keeps returning -ERESTARTSYS.

* It triggered softlockup.  Even with -ERESTARTSYS looping, I can't
  see how that would be possible.

Is this custom boot script?  If so, do you use RT priority in the
script?

Thanks.

-- 
tejun
