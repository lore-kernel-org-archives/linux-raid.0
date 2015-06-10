From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: 4.1-rc6 radi5 OOPS
Date: Wed, 10 Jun 2015 17:02:13 -0400
Message-ID: <wrfjzj47gtuy.fsf@redhat.com>
References: <wrfjlhg0mtmi.fsf@jes.lga.redhat.com>
	<20150604064048.0cb2d7c9@notabene.brown>
	<wrfjzj4glajs.fsf@jes.lga.redhat.com>
	<20150610101942.0bc26a25@home.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150610101942.0bc26a25@home.neil.brown.name> (Neil Brown's
	message of "Wed, 10 Jun 2015 10:19:42 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:
> On Wed, 03 Jun 2015 17:57:43 -0400
> Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
>
>> NeilBrown <neilb@suse.de> writes:
>> > On Wed, 03 Jun 2015 16:20:21 -0400 Jes Sorensen
>> > <Jes.Sorensen@redhat.com> wrote:
>> >
>> >> Neil,
>> >> 
>> >> I was running testing on the current 4.1-rc6 tree (Linus' top of
>> >> trunk 8cd9234c64c584432f6992fe944ca9e46ca8ea76) and I am seeing
>> >> the following OOPS which is reproducible.
>> >> 
>> >> It shows up when running the mdadm test suite, 07changelevelintr
>> >> to be specific.
>> >> 
>> >> Is this something you have seen?
>> >> 
>> >> Cheers,
>> >> Jes
>> >> 
>> >> ------------[ cut here ]------------
>> >> kernel BUG at drivers/md/raid5.c:5391!
>> >
>> > No, I haven't seen that.  And I've been running the test suite
>> > quite a bit lately.
>> >
>> > Can you get it to print out the relevant numbers?  Include
>> > readpos/writepos/safepos too.
>> 
>> This enough? Let me know if you need more.
>> 
>> I suspect this started happening with the changes that went in between
>> 4.1-rc5 and 4.1-rc6. I will try to bisect it tomorrow.
>> 
>> Cheers,
>> Jes
>> 
>> mddev->dev_sectors: 0x9800, reshape_sectors: 0x0200 stripe_addr:
>> fffffffffffffdff, sector_nr 0, readpos 511, writepos -513, safepos
>> 512  
>
> These numbers suggest that conf->reshape_progress divided by
> "data_disks" or "new_data_disks" is -1 - or really the unsigned
> equivalent, which is MaxSectors.
> But unless data_disks is 1, ->reshape_progress must really be -2 or -3
> or something.
> So maybe if you could confirm the values of ->reshape_progress,
> data_disks, and new_data_disks, that might help.
>
>
> I don't think ->reshape_progress could get a negative value in any way
> except by being assigned MaxSectors.  And that only happens when the
> reshape has really completely finished.
>
> So it looks like some sort of race.  I have other evidence of a race
> with the resync/reshape thread starting/stopping.  If I track that
> down it'll probably fix this issue too.

Hi Neil,

I added the debug output you asked for - this is what I got. Looks like
reshape_progress did get set to -1.

Cheers,
Jes

mddev->dev_sectors: 0x9800, reshape_sectors: 0x0200 reshape_progress 0xffffffffffffffff, stripe_addr: fffffffffffffdff, sector_nr 0, readpos 511, writepos -513, safepos 512, data_disks 1, new_data_disks 1
------------[ cut here ]------------
kernel BUG at drivers/md/raid5.c:5363!
invalid opcode: 0000 [#1] SMP 
Modules linked in: raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 iptable_filter ip_tables tun bridge stp llc xfs x86_pkg_temp_thermal coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 libcrc32c glue_helper lrw gf128mul ablk_helper cryptd iTCO_wdt microcode iTCO_vendor_support raid0 ppdev pcspkr parport_pc nfsd parport shpchp i2c_i801 video i2c_core acpi_cpufreq lpc_ich mfd_core auth_rpcgss oid_registry exportfs nfs_acl lockd grace uinput sunrpc ext4 mbcache jbd2 sd_mod ahci libahci e1000e ptp pps_core r8169 mii dm_mirror dm_region_hash dm_log dm_mod ipv6 autofs4
CPU: 3 PID: 15216 Comm: md0_resync Not tainted 4.1.0-rc2+ #6
Hardware name: Intel Corporation S1200BTL/S1200BTL, BIOS S1200BT.86B.02.00.0035.030220120927 03/02/2012
task: ffff8800a582f040 ti: ffff8800bd410000 task.ti: ffff8800bd410000
RIP: 0010:[<ffffffffa04003a3>]  [<ffffffffa04003a3>] reshape_request+0x8e3/0x8f0 [raid456]
RSP: 0018:ffff8800bd413b48  EFLAGS: 00010296
RAX: 00000000000000cc RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff88023ee6d368 RDI: ffff88023ee6d368
RBP: ffff8800bd413c28 R08: 0000000000000400 R09: ffffffff81d6c864
R10: 000000000000058b R11: 000000000000058a R12: ffff8800bd413d0c
R13: 0000000000000000 R14: ffff8800bd413d0c R15: ffff8800bd6d6000
FS:  0000000000000000(0000) GS:ffff88023ee60000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f32b2cc7000 CR3: 0000000001a0b000 CR4: 00000000001406e0
Stack:
 00000000000001ff fffffffffffffdff 0000000000000200 ffff880200000001
 0000000000000001 0000000000010fb0 0000000000000000 0000000000000200
 0000000000000001 0000000000000000 0000000000000003 fffffffffffffdff
Call Trace:
 [<ffffffff815b2d33>] ? __schedule+0x383/0x8e0
 [<ffffffffa04006de>] sync_request+0x32e/0x3a0 [raid456]
 [<ffffffff81092708>] ? __wake_up+0x48/0x60
 [<ffffffff8148b564>] md_do_sync+0x8f4/0xe90
 [<ffffffff810779cc>] ? update_rq_clock.part.89+0x1c/0x40
 [<ffffffff81487888>] md_thread+0x128/0x140
 [<ffffffff81487760>] ? find_pers+0x80/0x80
 [<ffffffff81487760>] ? find_pers+0x80/0x80
 [<ffffffff81071b49>] kthread+0xc9/0xe0
 [<ffffffff810edd76>] ? __audit_syscall_exit+0x1e6/0x280
 [<ffffffff81071a80>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff815b6b92>] ret_from_fork+0x42/0x70
 [<ffffffff81071a80>] ? kthread_create_on_node+0x170/0x170
Code: 85 78 ff ff ff 4c 8b 8d 68 ff ff ff 8b 55 84 4c 89 04 24 89 5c 24 20 44 89 5c 24 18 48 89 44 24 08 49 89 c0 31 c0 e8 8d c4 1a e1 <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 41 56 
RIP  [<ffffffffa04003a3>] reshape_request+0x8e3/0x8f0 [raid456]
 RSP <ffff8800bd413b48>
---[ end trace f745eac38e148690 ]---
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff81073c2f>] exit_creds+0x1f/0x70
PGD a58ee067 PUD bd4f7067 PMD 0 
Oops: 0000 [#2] SMP 
Modules linked in: raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 iptable_filter ip_tables tun bridge stp llc xfs x86_pkg_temp_thermal coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 libcrc32c glue_helper lrw gf128mul ablk_helper cryptd iTCO_wdt microcode iTCO_vendor_support raid0 ppdev pcspkr parport_pc nfsd parport shpchp i2c_i801 video i2c_core acpi_cpufreq lpc_ich mfd_core auth_rpcgss oid_registry exportfs nfs_acl lockd grace uinput sunrpc ext4 mbcache jbd2 sd_mod ahci libahci e1000e ptp pps_core r8169 mii dm_mirror dm_region_hash dm_log dm_mod ipv6 autofs4
CPU: 1 PID: 15096 Comm: mdadm Tainted: G      D         4.1.0-rc2+ #6
Hardware name: Intel Corporation S1200BTL/S1200BTL, BIOS S1200BT.86B.02.00.0035.030220120927 03/02/2012
task: ffff880233e17000 ti: ffff8800365a4000 task.ti: ffff8800365a4000
RIP: 0010:[<ffffffff81073c2f>]  [<ffffffff81073c2f>] exit_creds+0x1f/0x70
RSP: 0018:ffff8800365a7ca8  EFLAGS: 00010292
RAX: 0000000000000000 RBX: ffff8800a582f040 RCX: ffff8800365a7d00
RDX: 0000000000006a70 RSI: 0000000000000296 RDI: 0000000000000000
RBP: ffff8800365a7cb8 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000b R11: 0000000000000246 R12: ffff8800a582f040
R13: 0000000000000000 R14: ffff8800a5d16000 R15: 0000000000000004
FS:  00007f3e1e2dc740(0000) GS:ffff88023ee20000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000bd1b6000 CR4: 00000000001406e0
Stack:
 ffff8800365a7cb8 ffff8800a582f040 ffff8800365a7cd8 ffffffff8105265a
 0000000000000000 ffff8800a582f040 ffff8800365a7d08 ffffffff81072058
 ffff880200000006 ffff880234cb5cc0 ffff8800bd6d6150 0000000000000004
Call Trace:
 [<ffffffff8105265a>] __put_task_struct+0x4a/0x130
 [<ffffffff81072058>] kthread_stop+0x88/0x100
 [<ffffffff814878e5>] md_unregister_thread+0x45/0x80
 [<ffffffff8148e32d>] md_reap_sync_thread+0x1d/0x1a0
 [<ffffffff8148e650>] action_store+0x1a0/0x290
 [<ffffffff8105cd5d>] ? ns_capable+0x2d/0x60
 [<ffffffff8148bb7b>] md_attr_store+0x7b/0xd0
 [<ffffffff8120f45d>] sysfs_kf_write+0x3d/0x50
 [<ffffffff8120ebba>] kernfs_fop_write+0x12a/0x180
 [<ffffffff81199878>] __vfs_write+0x28/0xf0
 [<ffffffff8119c479>] ? __sb_start_write+0x49/0xf0
 [<ffffffff81230873>] ? security_file_permission+0x23/0xa0
 [<ffffffff81199f69>] vfs_write+0xa9/0x1b0
 [<ffffffff8119ad36>] SyS_write+0x46/0xb0
 [<ffffffff810edb34>] ? __audit_syscall_entry+0xb4/0x110
 [<ffffffff815b67d7>] system_call_fastpath+0x12/0x6a
Code: 0f 84 37 fe ff ff e9 10 fe ff ff 90 0f 1f 44 00 00 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 8b 87 c8 09 00 00 48 8b bf c0 09 00 00 <8b> 00 48 c7 83 c0 09 00 00 00 00 00 00 f0 ff 0f 74 1f 48 8b bb 
RIP  [<ffffffff81073c2f>] exit_creds+0x1f/0x70
 RSP <ffff8800365a7ca8>
CR2: 0000000000000000
---[ end trace f745eac38e148691 ]---
