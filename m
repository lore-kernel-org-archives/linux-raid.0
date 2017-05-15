From: MasterPrenium <masterprenium.lkml@gmail.com>
Subject: Fwd: Re: PROBLEM: Kernel BUG with raid5 soft + Xen + DRBD - invalid
 opcode
Date: Mon, 15 May 2017 02:59:39 +0200
Message-ID: <4e7c4d43-57b7-25c2-f740-bdfc1b3b7edb@gmail.com>
References: <70a42dcf-7d2d-39e6-689b-010d1cc3144b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70a42dcf-7d2d-39e6-689b-010d1cc3144b@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,

Finally the problem is still present, but harder to reproduce, I 
couldn't reproduce it with fio... But syncing DRBD stack finally made 
the kernel crash again :

May 13 05:33:49 Node_2 kernel: [ 7040.167706] ------------[ cut here 
]------------
May 13 05:33:49 Node_2 kernel: [ 7040.170426] kernel BUG at 
drivers/md/raid5.c:527!
May 13 05:33:49 Node_2 kernel: [ 7040.173136] invalid opcode: 0000 [#1] SMP
May 13 05:33:49 Node_2 kernel: [ 7040.175820] Modules linked in: drbd 
lru_cache xen_acpi_processor xen_pciback xen_gntalloc xen_gntdev joydev 
iTCO_wdt iTCO_vendor_support mxm_wmi sb_edac edac_core 
x86_pkg_temp_thermal coretemp ghash_clmulni_intel aesni_intel aes_x86_64 
glue_helper lrw igb ixgbe gf128mul ablk_helper cryptd pcspkr mpt3sas 
mdio i2c_i801 ptp i2c_smbus lpc_ich xhci_pci scsi_transport_sas pps_core 
ioatdma dca mfd_core xhci_hcd shpchp wmi tpm_tis tpm_tis_core tpm
May 13 05:33:49 Node_2 kernel: [ 7040.188405] CPU: 0 PID: 2944 Comm: 
drbd_r_drbd0 Not tainted 4.9.16-gentoo #8
May 13 05:33:49 Node_2 kernel: [ 7040.191672] Hardware name: Supermicro 
Super Server/X10SDV-4C-7TP4F, BIOS 1.0b 11/21/2016
May 13 05:33:49 Node_2 kernel: [ 7040.195033] task: ffff880268e40440 
task.stack: ffffc90005f64000
May 13 05:33:49 Node_2 kernel: [ 7040.198493] RIP: 
e030:[<ffffffff8176c4a6>]  [<ffffffff8176c4a6>] 
raid5_get_active_stripe+0x566/0x670
May 13 05:33:49 Node_2 kernel: [ 7040.202157] RSP: 
e02b:ffffc90005f67b70  EFLAGS: 00010086
May 13 05:33:49 Node_2 kernel: [ 7040.205861] RAX: 0000000000000000 RBX: 
ffff880269ad9c00 RCX: dead000000000200
May 13 05:33:49 Node_2 kernel: [ 7040.209646] RDX: 0000000000000000 RSI: 
0000000000000002 RDI: ffff8802581fca90
May 13 05:33:49 Node_2 kernel: [ 7040.213409] RBP: ffffc90005f67c10 R08: 
ffff8802581fcaa0 R09: 0000000034bfc400
May 13 05:33:49 Node_2 kernel: [ 7040.217207] R10: ffff8802581fca90 R11: 
0000000000000001 R12: ffff880269ad9c10
May 13 05:33:49 Node_2 kernel: [ 7040.221111] R13: ffff8802581fca90 R14: 
ffff880268ee6f00 R15: 0000000034bfc510
May 13 05:33:49 Node_2 kernel: [ 7040.225004] FS: 0000000000000000(0000) 
GS:ffff880270c00000(0000) knlGS:ffff880270c00000
May 13 05:33:49 Node_2 kernel: [ 7040.229000] CS:  e033 DS: 0000 ES: 
0000 CR0: 0000000080050033
May 13 05:33:49 Node_2 kernel: [ 7040.233005] CR2: 0000000000c7d2e0 CR3: 
0000000264d39000 CR4: 0000000000042660
May 13 05:33:49 Node_2 kernel: [ 7040.237056] Stack:
May 13 05:33:49 Node_2 kernel: [ 7040.241073] 0000000000003af8 
ffff880269ad9c00 0000000000000000 ffff880269ad9c08
May 13 05:33:49 Node_2 kernel: [ 7040.245172] ffff880269ad9de0 
ffff880200000002 0000000000000000 0000000034bfc510
May 13 05:33:49 Node_2 kernel: [ 7040.249344] ffff8802581fca90 
ffffffff81760000 ffffffff819a93b0 ffffc90005f67c10
May 13 05:33:49 Node_2 kernel: [ 7040.253395] Call Trace:
May 13 05:33:49 Node_2 kernel: [ 7040.257327] [<ffffffff81760000>] ? 
raid10d+0xa00/0x12e0
May 13 05:33:49 Node_2 kernel: [ 7040.261327] [<ffffffff819a93b0>] ? 
_raw_spin_lock_irq+0x10/0x30
May 13 05:33:49 Node_2 kernel: [ 7040.265336] [<ffffffff8176c75b>] 
raid5_make_request+0x1ab/0xda0
May 13 05:33:49 Node_2 kernel: [ 7040.269297] [<ffffffff811c0100>] ? 
kmem_cache_alloc+0x70/0x1a0
May 13 05:33:49 Node_2 kernel: [ 7040.273264] [<ffffffff81166df5>] ? 
mempool_alloc_slab+0x15/0x20
May 13 05:33:49 Node_2 kernel: [ 7040.277145] [<ffffffff810b5050>] ? 
wake_up_atomic_t+0x30/0x30
May 13 05:33:49 Node_2 kernel: [ 7040.281080] [<ffffffff81776b68>] 
md_make_request+0xe8/0x220
May 13 05:33:49 Node_2 kernel: [ 7040.285000] [<ffffffff813b82e0>] 
generic_make_request+0xd0/0x1b0
May 13 05:33:49 Node_2 kernel: [ 7040.289002] [<ffffffffa004e75b>] 
drbd_submit_peer_request+0x1fb/0x4b0 [drbd]
May 13 05:33:49 Node_2 kernel: [ 7040.293018] [<ffffffffa004ef0e>] 
receive_RSDataReply+0x1ce/0x3b0 [drbd]
May 13 05:33:49 Node_2 kernel: [ 7040.297102] [<ffffffffa004ed40>] ? 
receive_rs_deallocated+0x330/0x330 [drbd]
May 13 05:33:49 Node_2 kernel: [ 7040.301235] [<ffffffffa004ed40>] ? 
receive_rs_deallocated+0x330/0x330 [drbd]
May 13 05:33:49 Node_2 kernel: [ 7040.305331] [<ffffffffa0050cca>] 
drbd_receiver+0x18a/0x2f0 [drbd]
May 13 05:33:49 Node_2 kernel: [ 7040.309425] [<ffffffffa0058de0>] ? 
drbd_destroy_connection+0xe0/0xe0 [drbd]
May 13 05:33:49 Node_2 kernel: [ 7040.313600] [<ffffffffa0058e2b>] 
drbd_thread_setup+0x4b/0x120 [drbd]
May 13 05:33:49 Node_2 kernel: [ 7040.317820] [<ffffffffa0058de0>] ? 
drbd_destroy_connection+0xe0/0xe0 [drbd]
May 13 05:33:49 Node_2 kernel: [ 7040.322006] [<ffffffff81092a4a>] 
kthread+0xca/0xe0
May 13 05:33:49 Node_2 kernel: [ 7040.326100] [<ffffffff81092980>] ? 
kthread_park+0x60/0x60
May 13 05:33:49 Node_2 kernel: [ 7040.330157] [<ffffffff819a9945>] 
ret_from_fork+0x25/0x30
May 13 05:33:49 Node_2 kernel: [ 7040.334176] Code: 0f 85 b8 fc ff ff 0f 
0b 0f 0b f3 90 8b 43 70 a8 01 75 f7 89 45 a0 e9 80 fd ff ff f0 ff 83 40 
02 00 00 e9 d0 fc ff ff 0f 0b 0f 0b <0f> 0b 48 89 f2 48 c7 c7 88 a5 16 
82 31 c0 48 c7 c6 7b de d1 81
May 13 05:33:49 Node_2 kernel: [ 7040.342995] RIP [<ffffffff8176c4a6>] 
raid5_get_active_stripe+0x566/0x670
May 13 05:33:49 Node_2 kernel: [ 7040.347054]  RSP <ffffc90005f67b70>
May 13 05:33:49 Node_2 kernel: [ 7040.367142] ---[ end trace 
47ae5e57e18c95c6 ]---
May 13 05:33:49 Node_2 kernel: [ 7040.391125] BUG: unable to handle 
kernel NULL pointer dereference at           (null)
May 13 05:33:49 Node_2 kernel: [ 7040.395306] IP: [<ffffffff810b4b0b>] 
__wake_up_common+0x2b/0x90
May 13 05:33:49 Node_2 kernel: [ 7040.399513] PGD 25b915067
May 13 05:33:49 Node_2 kernel: [ 7040.399562] PUD 26474b067
May 13 05:33:49 Node_2 kernel: [ 7040.403751] PMD 0
May 13 05:33:49 Node_2 kernel: [ 7040.403785]
May 13 05:33:49 Node_2 kernel: [ 7040.408059] Oops: 0000 [#2] SMP

Really need some help to fix it...

Bests,


Le 13/05/2017 à 02:06, MasterPrenium a écrit :
> Hi guys,
>
> My issue is still remaining with new kernels, at least last revision 
> of 4.10.x branch.
>
> But I found something that can be interesting for investigations, here 
> I attached another .config file for kernel building, with this 
> configuration I'm not able to reproduce the kernel panic, I got no 
> crash at all with exactly the same procedure.
>
> Tested on 4.9.16 kernel and 4.10.13 :
> - config_Crash.txt : result in a crash running fio within less than 2 
> minutes
> - config_NoCrash.txt : even after hours of fio, rebuilding arrays, etc 
> ... no crash at all, neither no warning or anything in dmesg.
>
> Note : config_NoCrash is coming from another server on which I had 
> setup similar system and which was not crashing. Tested this kernel on 
> my crashing system, and no crash anymore...
>
> I can't believe how a different config can solve a kernel BUG...
>
> If someone has any idea...
>
> Bests,
>
>
> Le 09/01/2017 à 23:44, Shaohua Li a écrit :
>> On Sun, Jan 08, 2017 at 02:31:15PM +0100, MasterPrenium wrote:
>>> Hello,
>>>
>>> Replies below + :
>>> - I don't know if this can help but after the crash, when the system
>>> reboots, the Raid 5 stack is re-synchronizing
>>> [   37.028239] md10: Warning: Device sdc1 is misaligned
>>> [   37.028541] created bitmap (15 pages) for device md10
>>> [   37.030433] md10: bitmap initialized from disk: read 1 pages, set 
>>> 59 of
>>> 29807 bits
>>>
>>> - Sometimes the kernel completely crash (lost serial + network 
>>> connection),
>>> sometimes only got the "BUG" dump, but still have network access (but a
>>> reboot is impossible, need to reset the system).
>>>
>>> - You can find blktrace here (while running fio), I hope it's 
>>> complete since
>>> the end of the file is when the kernel crashed : https://goo.gl/X9jZ50
>> Looks most are normal full stripe writes.
>>>> I'm trying to reproduce, but no success. So
>>>> ext4->btrfs->raid5, crash
>>>> btrfs->raid5, no crash
>>>> right? does subvolume matter? When you create the raid5 array, does 
>>>> adding
>>>> '--assume-clean' option change the behavior? I'd like to narrow 
>>>> down the issue.
>>>> If you can capture the blktrace to the raid5 array, it would be 
>>>> great to hint
>>>> us what kind of IO it is.
>>> Yes Correct.
>>> The subvolume doesn't matter.
>>> -- assume-clean doesn't change the behaviour.
>> so it's not a resync issue.
>>
>>> Don't forget that the system needs to be running on xen to crash, 
>>> without
>>> (on native kernel) it doesn't crash (or at least, I was not able to 
>>> make it
>>> crash).
>>>>> Regarding your patch, I can't find it. Is it the one sent by 
>>>>> Konstantin
>>>>> Khlebnikov ?
>>>> Right.
>>> It doesn't help :(. Maybe the crash is happening a little bit later.
>> ok, the patch is unlikely helpful, since the IO size isn't very big.
>>
>> Don't have good idea yet. My best guess so far is virtual machine 
>> introduces
>> extra delay, which might trigger some race conditions which aren't 
>> seen in
>> native.  I'll check if I could find something locally.
>>
>> Thanks,
>> Shaohua
>

