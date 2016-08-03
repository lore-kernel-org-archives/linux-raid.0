From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 3/3] MD: hold mddev lock for md-cluster receive thread
Date: Wed, 3 Aug 2016 11:18:24 +0800
Message-ID: <57A16280.9050503@suse.com>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
 <7763e508fb97d44bd61e826912055617b8be2c2d.1469922791.git.shli@fb.com>
 <579F0AA3.5090806@suse.com> <20160801214522.GA129828@kernel.org>
 <57A06D69.2040703@suse.com> <20160802224456.GD98613@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160802224456.GD98613@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids



On 08/03/2016 06:44 AM, Shaohua Li wrote:
> On Tue, Aug 02, 2016 at 05:52:41PM +0800, Guoqing Jiang wrote:
>>
>> On 08/02/2016 05:45 AM, Shaohua Li wrote:
>>> On Mon, Aug 01, 2016 at 04:38:59PM +0800, Guoqing Jiang wrote:
>>>> Hi,
>>>>
>>>> On 07/31/2016 07:54 AM, shli@kernel.org wrote:
>>>>> From: Shaohua Li <shli@fb.com>
>>>>>
>>>>> md-cluster receive thread calls .quiesce too, let it hold mddev lock.
>>>> I'd suggest hold on for the patchset, I can find lock problem easily with
>>>> the patchset applied. Take a resyncing  clusteed raid1 as example.
>>>>
>>>> md127_raid1 thread held reconfig_mutex then update sb, so it needs dlm
>>>> token lock. Meanwhile md127_resync thread got token lock and wants
>>>> EX on ack lock but recv_daemon can't release ack lock since recv_daemon
>>>> doesn't get reconfig_mutex.
>>> Thansk, I'll drop this one. Other two patches are still safe for md-cluster,
>>> right?
>>  From the latest test, I can't find  lock issues with the first two patches,
>> but I doubt it would have side effect for the performance of resync.
> That's not need to be worried. The .quiesce() call is way heavier than
> hold/release the mutex.
>
>>> I really hope to have consistent locking for .quiesce. For the
>>> process_recvd_msg, I'm wondering what's protecting the datas? for example,
>>> md-cluster uses md_find_rdev_nr_rcu, which access the disks list without
>>> locking. Is there a race?
>> Yes, it should be protected by rcu lock, I will post a patch for it, thanks
>> for reminder.
>>
>>> Does it work if we move the mddev lock to
>>> process_recvd_msg?
>> I tried that, but It still have lock issue, eg, when node B and C have
>> status
>> as "resync=PENDING", then try to stop the resyncing array in node A.
> can you elaborate it?

I am not lucky enough to do the same test as yesterday, but I even
can't assemble clustered raid1 in other nodes.

1. node135: mdadm --create md0 --bitmap=clustered --raid-devices=2 
--level=mirror /dev/vdb /dev/vdc
2. Then node240 and node244 try to assemble it, but both of them would hang.

betalinux135:~ # cat /proc/mdstat
Personalities : [raid1]
md127 : active raid1 vdc[1] vdb[0]
       2095104 blocks super 1.2 [2/2] [UU]
       [=>...................]  resync =  6.2% (130816/2095104) 
finish=1.5min speed=21802K/sec
       bitmap: 1/1 pages [4KB], 65536KB chunk

unused devices: <none>
betalinux135:~ # ssh betalinux240
Last login: Wed Aug  3 11:11:47 2016 from 192.168.100.1
betalinux240:~ # ps aux|grep md|grep D
root      1901  0.0  0.2  20896  2592 pts/0    D+   11:12   0:00 mdadm 
--assemble md0 /dev/vdb /dev/vdc
root      1914  0.0  0.2  19852  2032 ?        S    11:12   0:00 
/sbin/mdadm --incremental --export /dev/vdb --offroot ${DEVLINKS}
root      1915  0.0  0.1  19852  1940 ?        S    11:12   0:00 
/sbin/mdadm --incremental --export /dev/vdc --offroot ${DEVLINKS}
betalinux240:~ # cat /proc/1901/stack
[<ffffffffa069d4cb>] dlm_lock_sync+0x6b/0x80 [md_cluster]
[<ffffffffa069e7e6>] join+0x286/0x430 [md_cluster]
[<ffffffffa068a9f4>] bitmap_create+0x5f4/0x980 [md_mod]
[<ffffffffa0682f35>] md_run+0x595/0xa60 [md_mod]
[<ffffffffa06834cf>] do_md_run+0xf/0xb0 [md_mod]
[<ffffffffa0686781>] md_ioctl+0x11b1/0x1680 [md_mod]
[<ffffffff812ed158>] blkdev_ioctl+0x258/0x920
[<ffffffff8122f81d>] block_ioctl+0x3d/0x40
[<ffffffff8120ac0d>] do_vfs_ioctl+0x2cd/0x4a0
[<ffffffff8120ae54>] SyS_ioctl+0x74/0x80
[<ffffffff815e936e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[<ffffffffffffffff>] 0xffffffffffffffff
betalinux240:~ # exit
logout
Connection to betalinux240 closed.
betalinux135:~ # ssh betalinux244
Last login: Wed Aug  3 11:11:49 2016 from 192.168.100.1
betalinux244:~ # ps aux|grep md|grep D
root      1903  0.0  0.2  20896  2660 pts/0    D+   11:12   0:00 mdadm 
--assemble md0 /dev/vdb /dev/vdc
root      1923  0.0  0.2  19852  2112 ?        S    11:12   0:00 
/sbin/mdadm --incremental --export /dev/vdc --offroot ${DEVLINKS}
root      1928  0.0  0.2  19852  2092 ?        S    11:12   0:00 
/sbin/mdadm --incremental --export /dev/vdb --offroot ${DEVLINKS}
root      1938  0.0  0.0      0     0 ?        D    11:12   0:00 
[md0_cluster_rec]
betalinux244:~ # cat /proc/1903/stack
[<ffffffffa06904cb>] dlm_lock_sync+0x6b/0x80 [md_cluster]
[<ffffffffa06904fb>] lock_token+0x1b/0x50 [md_cluster]
[<ffffffffa06905fd>] metadata_update_start+0x3d/0xb0 [md_cluster]
[<ffffffffa06751ee>] md_update_sb.part.50+0x8e/0x810 [md_mod]
[<ffffffffa067646e>] md_allow_write+0x6e/0xc0 [md_mod]
[<ffffffffa0676505>] do_md_run+0x45/0xb0 [md_mod]
[<ffffffffa0679781>] md_ioctl+0x11b1/0x1680 [md_mod]
[<ffffffff812ed158>] blkdev_ioctl+0x258/0x920
[<ffffffff8122f81d>] block_ioctl+0x3d/0x40
[<ffffffff8120ac0d>] do_vfs_ioctl+0x2cd/0x4a0
[<ffffffff8120ae54>] SyS_ioctl+0x74/0x80
[<ffffffff815e936e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[<ffffffffffffffff>] 0xffffffffffffffff
betalinux244:~ # cat /proc/1938/stack
[<ffffffffa0691d90>] recv_daemon+0xc0/0x4a0 [md_cluster]
[<ffffffffa0670d30>] md_thread+0x130/0x150 [md_mod]
[<ffffffff810995ed>] kthread+0xbd/0xe0
[<ffffffff815e96bf>] ret_from_fork+0x3f/0x70
[<ffffffff81099530>] kthread+0x0/0xe0
[<ffffffffffffffff>] 0xffffffffffffffff

> For the raid5-cache issue, ignoring the md-cluster .quiesce() call is fine
> currently as we don't support raid5 cluster. We probably should add another
> parameter for .quiesce to indicate if the mddev lock is hold in the future.

Pls update me with the change in future, since it may have huge influence
for md-cluster.

Thanks,
GUoqing

