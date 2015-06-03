From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: 4.1-rc6 radi5 OOPS
Date: Wed, 03 Jun 2015 17:57:43 -0400
Message-ID: <wrfjzj4glajs.fsf@jes.lga.redhat.com>
References: <wrfjlhg0mtmi.fsf@jes.lga.redhat.com>
	<20150604064048.0cb2d7c9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150604064048.0cb2d7c9@notabene.brown> (NeilBrown's message of
	"Thu, 4 Jun 2015 06:40:48 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Wed, 03 Jun 2015 16:20:21 -0400 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
>
>> Neil,
>> 
>> I was running testing on the current 4.1-rc6 tree (Linus' top of trunk
>> 8cd9234c64c584432f6992fe944ca9e46ca8ea76) and I am seeing the following
>> OOPS which is reproducible.
>> 
>> It shows up when running the mdadm test suite, 07changelevelintr to be
>> specific.
>> 
>> Is this something you have seen?
>> 
>> Cheers,
>> Jes
>> 
>> ------------[ cut here ]------------
>> kernel BUG at drivers/md/raid5.c:5391!
>
> No, I haven't seen that.  And I've been running the test suite quite a bit
> lately.
>
> Can you get it to print out the relevant numbers?  Include
> readpos/writepos/safepos too.

This enough? Let me know if you need more.

I suspect this started happening with the changes that went in between
4.1-rc5 and 4.1-rc6. I will try to bisect it tomorrow.

Cheers,
Jes

mddev->dev_sectors: 0x9800, reshape_sectors: 0x0200 stripe_addr: fffffffffffffdff, sector_nr 0, readpos 511, writepos -513, safepos 512
------------[ cut here ]------------
kernel BUG at drivers/md/raid5.c:5394!
invalid opcode: 0000 [#1] SMP 
Modules linked in: raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 iptable_filter ip_tables tun bridge stp llc x86_pkg_temp_thermal coretemp kvm_intel kvm xfs crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw libcrc32c nfsd gf128mul ablk_helper auth_rpcgss oid_registry exportfs nfs_acl lockd cryptd iTCO_wdt grace sunrpc microcode raid0 ppdev iTCO_vendor_support shpchp i2c_i801 i2c_core pcspkr lpc_ich mfd_core parport_pc acpi_cpufreq parport video uinput autofs4 ext4 mbcache jbd2 sd_mod e1000e ptp pps_core ahci r8169 libahci mii dm_mirror dm_region_hash dm_log dm_mod ipv6
CPU: 1 PID: 14648 Comm: md0_resync Not tainted 4.1.0-rc2+ #5
Hardware name: Intel Corporation S1200BTL/S1200BTL, BIOS S1200BT.86B.02.00.0035.030220120927 03/02/2012
task: ffff880234b0f080 ti: ffff88022aadc000 task.ti: ffff88022aadc000
RIP: 0010:[<ffffffffa05db722>]  [<ffffffffa05db722>] reshape_request+0x8d2/0x8e0 [raid456]
RSP: 0018:ffff88022aadfb68  EFLAGS: 00010296
RAX: 0000000000000087 RBX: ffff88022a8d2400 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff88023ee2d368 RDI: ffff88023ee2d368
RBP: ffff88022aadfc28 R08: 0000000000000400 R09: ffffffff81d6c864
R10: 000000000000058f R11: 000000000000058e R12: ffff88022aadfd0c
R13: 0000000000000000 R14: ffff88022aadfd0c R15: ffff8800a778c800
FS:  0000000000000000(0000) GS:ffff88023ee20000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc8ddece000 CR3: 0000000001a0b000 CR4: 00000000001406e0
Stack:
 fffffffffffffdff 0000000000000200 0000000000000000 0000000000000200
 0000000000000001 0000000000000000 0000000000000001 fffffffffffffdff
 0000020000000001 ffffffff815b2d23 ffff880234b0f080 ffff880233748f00
Call Trace:
 [<ffffffff815b2d23>] ? __schedule+0x383/0x8e0
 [<ffffffffa05dba5e>] sync_request+0x32e/0x3a0 [raid456]
 [<ffffffff81092708>] ? __wake_up+0x48/0x60
 [<ffffffff8148b564>] md_do_sync+0x8f4/0xe90
 [<ffffffff81487888>] md_thread+0x128/0x140
 [<ffffffff81487760>] ? find_pers+0x80/0x80
 [<ffffffff81487760>] ? find_pers+0x80/0x80
 [<ffffffff81071b49>] kthread+0xc9/0xe0
 [<ffffffff810edd76>] ? __audit_syscall_exit+0x1e6/0x280
 [<ffffffff81071a80>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff815b6b92>] ret_from_fork+0x42/0x70
 [<ffffffff81071a80>] ? kthread_create_on_node+0x170/0x170
Code: 48 89 44 24 08 48 8b 85 78 ff ff ff 48 c7 c7 e0 3d 5e a0 4c 8b 85 68 ff ff ff 8b 55 84 48 89 04 24 48 89 c1 31 c0 e8 fe 10 fd e0 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 41 
RIP  [<ffffffffa05db722>] reshape_request+0x8d2/0x8e0 [raid456]
 RSP <ffff88022aadfb68>
---[ end trace 7eefd62cedfb2b13 ]---
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff81073c2f>] exit_creds+0x1f/0x70
PGD 2365b1067 PUD 235280067 PMD 0 
Oops: 0000 [#2] SMP 
Modules linked in: raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 iptable_filter ip_tables tun bridge stp llc x86_pkg_temp_thermal coretemp kvm_intel kvm xfs crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw libcrc32c nfsd gf128mul ablk_helper auth_rpcgss oid_registry exportfs nfs_acl lockd cryptd iTCO_wdt grace sunrpc microcode raid0 ppdev iTCO_vendor_support shpchp i2c_i801 i2c_core pcspkr lpc_ich mfd_core parport_pc acpi_cpufreq parport video uinput autofs4 ext4 mbcache jbd2 sd_mod e1000e ptp pps_core ahci r8169 libahci mii dm_mirror dm_region_hash dm_log dm_mod ipv6
CPU: 1 PID: 14535 Comm: mdadm Tainted: G      D         4.1.0-rc2+ #5
Hardware name: Intel Corporation S1200BTL/S1200BTL, BIOS S1200BT.86B.02.00.0035.030220120927 03/02/2012
task: ffff8800a6b67100 ti: ffff880232ae4000 task.ti: ffff880232ae4000
RIP: 0010:[<ffffffff81073c2f>]  [<ffffffff81073c2f>] exit_creds+0x1f/0x70
RSP: 0018:ffff880232ae7ca8  EFLAGS: 00010292
RAX: 0000000000000000 RBX: ffff880234b0f080 RCX: ffff880232ae7d00
RDX: 0000000000005a31 RSI: 0000000000000296 RDI: 0000000000000000
RBP: ffff880232ae7cb8 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000b R11: 0000000000000246 R12: ffff880234b0f080
R13: 000000000000000b R14: ffff8802338f0000 R15: 0000000000000004
FS:  00007f70bfc97740(0000) GS:ffff88023ee20000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000234966000 CR4: 00000000001406e0
Stack:
 ffff880232ae7cb8 ffff880234b0f080 ffff880232ae7cd8 ffffffff8105265a
 0000000000000000 ffff880234b0f080 ffff880232ae7d08 ffffffff81072058
 ffff880200000004 ffff8802361046c0 ffff8800a778c950 0000000000000004
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
 RSP <ffff880232ae7ca8>
CR2: 0000000000000000
---[ end trace 7eefd62cedfb2b14 ]---


>
> Thanks,
> NeilBrown
>
>
>> invalid opcode: 0000 [#1] SMP 
>> Modules linked in: raid456 async_raid6_recov async_memcpy async_pq
>> async_xor xor async_tx raid6_pq nf_conntrack_ipv4 nf_defrag_ipv4
>> xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 iptable_filter
>> ip_tables tun bridge stp llc xfs x86_pkg_temp_thermal coretemp
>> kvm_intel kvm crc32c_intel ghash_clmulni_intel libcrc32c aesni_intel
>> aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd ppdev raid0
>> microcode pcspkr iTCO_wdt iTCO_vendor_support parport_pc i2c_i801
>> i2c_core parport shpchp lpc_ich mfd_core video acpi_cpufreq nfsd
>> auth_rpcgss oid_registry exportfs nfs_acl lockd grace sunrpc uinput
>> autofs4 ext4 mbcache jbd2 sd_mod e1000e ptp pps_core ahci r8169 mii
>> libahci dm_mirror dm_region_hash dm_log dm_mod ipv6
>> CPU: 0 PID: 15142 Comm: md0_resync Tainted: G        W       4.1.0-rc6+ #2
>> Hardware name: Intel Corporation S1200BTL/S1200BTL, BIOS
>> S1200BT.86B.02.00.0035.030220120927 03/02/2012
>> task: ffff88022b2642d0 ti: ffff8802327e0000 task.ti: ffff8802327e0000
>> RIP: 0010:[<ffffffffa046d6f7>] [<ffffffffa046d6f7>]
>> reshape_request+0x8a7/0x8b0 [raid456]
>> RSP: 0018:ffff8802327e3b78  EFLAGS: 00010297
>> RAX: 0000000000000200 RBX: ffff88022b130400 RCX: 0000000000000200
>> RDX: 0000000000009801 RSI: 0000000000000200 RDI: 0000000000000001
>> RBP: ffff8802327e3c28 R08: 00000000000001ff R09: 0000000000000000
>> R10: fffffffffffffdff R11: 0000000000000001 R12: ffff8802327e3d0c
>> R13: 0000000000000000 R14: ffff8802327e3d0c R15: ffff880234577000
>> FS:  0000000000000000(0000) GS:ffff88023ee00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f985b677140 CR3: 0000000001a0b000 CR4: 00000000001406f0
>> Stack:
>>  0000000000000000 0000000000000200 0000000000000001 0000000000000000
>>  0000000000000000 fffffffffffffdff 0000020000000001 ffffffff815b34d3
>>  ffff88022b2642d0 ffff880235f2f080 ffff8802327e3c08 ffff8802327e4000
>> Call Trace:
>>  [<ffffffff815b34d3>] ? __schedule+0x383/0x8e0
>>  [<ffffffffa046da2e>] sync_request+0x32e/0x3a0 [raid456]
>>  [<ffffffff81092738>] ? __wake_up+0x48/0x60
>>  [<ffffffff8148b974>] md_do_sync+0x8f4/0xe90
>>  [<ffffffff810779bc>] ? update_rq_clock.part.89+0x1c/0x40
>>  [<ffffffff81487c98>] md_thread+0x128/0x140
>>  [<ffffffff81487b70>] ? find_pers+0x80/0x80
>>  [<ffffffff81487b70>] ? find_pers+0x80/0x80
>>  [<ffffffff81071b39>] kthread+0xc9/0xe0
>>  [<ffffffff810eddd6>] ? __audit_syscall_exit+0x1e6/0x280
>>  [<ffffffff81071a70>] ? kthread_create_on_node+0x170/0x170
>>  [<ffffffff815b7352>] ret_from_fork+0x42/0x70
>>  [<ffffffff81071a70>] ? kthread_create_on_node+0x170/0x170
>> Code: 00 00 be 03 00 00 00 e8 18 50 c2 e0 49 8d 7f 50 48 c7 c2 39 55
>> 47 a0 31 f6 e8 56 21 da e0 48 8b 45 88 e9 ae fb ff ff 0f 0b 0f 0b
>> <0f> 0b 0f 1f 80 00 00 00 00 55 48 89 e5 41 57 41 56 41 55 41 54
>> RIP  [<ffffffffa046d6f7>] reshape_request+0x8a7/0x8b0 [raid456]
>>  RSP <ffff8802327e3b78>
>> ---[ end trace 1d72a07e246912ea ]---
>> BUG: unable to handle kernel NULL pointer dereference at           (null)
>> IP: [<ffffffff81073c1f>] exit_creds+0x1f/0x70
>> PGD bdc0c067 PUD a6697067 PMD 0 
>> Oops: 0000 [#2] SMP 
>> Modules linked in: raid456 async_raid6_recov async_memcpy async_pq
>> async_xor xor async_tx raid6_pq nf_conntrack_ipv4 nf_defrag_ipv4
>> xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 iptable_filter
>> ip_tables tun bridge stp llc xfs x86_pkg_temp_thermal coretemp
>> kvm_intel kvm crc32c_intel ghash_clmulni_intel libcrc32c aesni_intel
>> aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd ppdev raid0
>> microcode pcspkr iTCO_wdt iTCO_vendor_support parport_pc i2c_i801
>> i2c_core parport shpchp lpc_ich mfd_core video acpi_cpufreq nfsd
>> auth_rpcgss oid_registry exportfs nfs_acl lockd grace sunrpc uinput
>> autofs4 ext4 mbcache jbd2 sd_mod e1000e ptp pps_core ahci r8169 mii
>> libahci dm_mirror dm_region_hash dm_log dm_mod ipv6
>> CPU: 1 PID: 15030 Comm: mdadm Tainted: G      D W       4.1.0-rc6+ #2
>> Hardware name: Intel Corporation S1200BTL/S1200BTL, BIOS
>> S1200BT.86B.02.00.0035.030220120927 03/02/2012
>> task: ffff880233550110 ti: ffff8800a6cbc000 task.ti: ffff8800a6cbc000
>> RIP: 0010:[<ffffffff81073c1f>]  [<ffffffff81073c1f>] exit_creds+0x1f/0x70
>> RSP: 0018:ffff8800a6cbfca8  EFLAGS: 00010292
>> RAX: 0000000000000000 RBX: ffff88022b2642d0 RCX: ffff8800a6cbfd00
>> RDX: 0000000000005110 RSI: 0000000000000296 RDI: 0000000000000000
>> RBP: ffff8800a6cbfcb8 R08: 0000000000000000 R09: 0000000000000000
>> R10: 000000000000000b R11: 0000000000000246 R12: ffff88022b2642d0
>> R13: 000000000000ff00 R14: 0000000000000004 R15: 0000000000000004
>> FS:  00007f70ff26f740(0000) GS:ffff88023ee20000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000000000000 CR3: 00000000a66cf000 CR4: 00000000001406e0
>> Stack:
>>  ffff8800a6cbfcb8 ffff88022b2642d0 ffff8800a6cbfcd8 ffffffff8105264a
>>  0000000000000000 ffff88022b2642d0 ffff8800a6cbfd08 ffffffff81072048
>>  ffff880000000001 ffff880233cb9140 ffff880234577150 ffffffffa0477320
>> Call Trace:
>>  [<ffffffff8105264a>] __put_task_struct+0x4a/0x130
>>  [<ffffffff81072048>] kthread_stop+0x88/0x100
>>  [<ffffffff81487cf5>] md_unregister_thread+0x45/0x80
>>  [<ffffffff8148e73d>] md_reap_sync_thread+0x1d/0x1a0
>>  [<ffffffff8148ea68>] action_store+0x1a8/0x2b0
>>  [<ffffffff8105cd4d>] ? ns_capable+0x2d/0x60
>>  [<ffffffff8148bf8b>] md_attr_store+0x7b/0xd0
>>  [<ffffffff8120f77d>] sysfs_kf_write+0x3d/0x50
>>  [<ffffffff8120eeda>] kernfs_fop_write+0x12a/0x180
>>  [<ffffffff81199ba8>] __vfs_write+0x28/0xf0
>>  [<ffffffff8119c7a9>] ? __sb_start_write+0x49/0xf0
>>  [<ffffffff81230b93>] ? security_file_permission+0x23/0xa0
>>  [<ffffffff8119a299>] vfs_write+0xa9/0x1b0
>>  [<ffffffff8119b066>] SyS_write+0x46/0xb0
>>  [<ffffffff810edb94>] ? __audit_syscall_entry+0xb4/0x110
>>  [<ffffffff815b6f97>] system_call_fastpath+0x12/0x6a
>> Code: 0f 84 37 fe ff ff e9 10 fe ff ff 90 0f 1f 44 00 00 55 48 89 e5
>> 53 48 89 fb 48 83 ec 08 48 8b 87 c8 09 00 00 48 8b bf c0 09 00 00
>> <8b> 00 48 c7 83 c0 09 00 00 00 00 00 00 f0 ff 0f 74 1f 48 8b bb
>> RIP  [<ffffffff81073c1f>] exit_creds+0x1f/0x70
>>  RSP <ffff8800a6cbfca8>
>> CR2: 0000000000000000
>> ---[ end trace 1d72a07e246912eb ]---
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
