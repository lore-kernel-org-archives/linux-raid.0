From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [RFC PATCH] blk: reset 'bi_next' when bio is done inside request
Date: Tue, 4 Apr 2017 12:23:15 +0200
Message-ID: <2a6f8c30-616c-d6fe-1c3f-ab687c145cd7@profitbricks.com>
References: <9505ff12-7307-7dec-76b5-2a233a592634@profitbricks.com>
 <877f31kwti.fsf@notabene.neil.brown.name>
 <9be3ca00-d802-bf64-bcdc-1e76608147f0@profitbricks.com>
 <871st8jyya.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <871st8jyya.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids


On 04/04/2017 11:37 AM, NeilBrown wrote:
> On Tue, Apr 04 2017, Michael Wang wrote:
[snip]
>>>
>>> If sync_request_write() is using a bio that has already been used, it
>>> should call bio_reset() and fill in the details again.
>>> However I don't see how that would happen.
>>> Can you give specific details on the situation that triggers the bug?
>>
>> We have storage side mapping lv through scst to server, on server side
>> we assemble them into multipath device, and then assemble these dm into
>> two raid1.
>>
>> The test is firstly do mkfs.ext4 on raid1 then start fio on it, on storage
>> side we unmap all the lv (could during mkfs or fio), then on server side
>> we hit the BUG (reproducible).
> 
> So I assume the initial resync is still happening at this point?
> And you unmap *all* the lv's so you expect IO to fail?
> I can see that the code would behave strangely if you have a
> bad-block-list configured (which is the default).
> Do you have a bbl?  If you create the array without the bbl, does it
> still crash?

The resync is at least happen concurrently in this case, we try
to simulate the case that all the connections dropped, the IO do
failed, also bunch of kernel log like:

md: super_written gets error=-5
blk_update_request: I/O error, dev dm-3, sector 64184
md/raid1:md1: dm-2: unrecoverable I/O read error for block 46848

we expect that to happen, but server should not crash on BUG.

And we haven't done any thing special regarding bbl, the bad_blocks
in sysfs are all empty.

> 
>>
>> The path of bio was confirmed by add tracing, it is reused in sync_request_write()
>> with 'bi_next' once chained inside blk_attempt_plug_merge().
> 
> I still don't see why it is re-used.
> I assume you didn't explicitly ask for a check/repair (i.e. didn't write
> to .../md/sync_action at all?).  In that case MD_RECOVERY_REQUESTED is
> not set.

Just unmap lv on storage side, no operation on server side.

> So sync_request() sends only one bio to generic_make_request():
>    r1_bio->bios[r1_bio->read_disk];
> 
> then sync_request_write() *doesn't* send that bio again, but does send
> all the others.
> 
> So where does it reuse a bio?

If that's the design then it would be strange... the log do showing the path
of that bio go through sync_request(), will do more investigation.

> 
>>
>> We also tried to reset the bi_next inside sync_request_write() before
>> generic_make_request() which also works.
>>
>> The testing was done with 4.4, but we found upstream also left bi_next
>> chained after done in request, thus we post this RFC.
>>
>> Regarding raid1, we haven't found the place on path where the bio was
>> reset... where does it supposed to be?
> 
> I'm not sure what you mean.
> We only reset bios when they are being reused.
> One place is in process_checks() where bio_reset() is called before
> filling in all the details.
> 
> 
> Maybe, in sync_request_write(), before
> 
> 	wbio->bi_rw = WRITE;
> 
> add something like
>   if (wbio->bi_next)
>      printk("bi_next!= NULL i=%d read_disk=%d bi_end_io=%pf\n",
>           i, r1_bio->read_disk, wbio->bi_end_io);
> 
> that might help narrow down what is happening.

Just triggered again in 4.4, dmesg like:

[  399.240230] md: super_written gets error=-5
[  399.240286] md: super_written gets error=-5
[  399.240286] md/raid1:md0: dm-0: unrecoverable I/O read error for block 204160
[  399.240300] md/raid1:md0: dm-0: unrecoverable I/O read error for block 204160
[  399.240312] md/raid1:md0: dm-0: unrecoverable I/O read error for block 204160
[  399.240323] md/raid1:md0: dm-0: unrecoverable I/O read error for block 204160
[  399.240334] md/raid1:md0: dm-0: unrecoverable I/O read error for block 204160
[  399.240341] md/raid1:md0: dm-0: unrecoverable I/O read error for block 204160
[  399.240349] md/raid1:md0: dm-0: unrecoverable I/O read error for block 204160
[  399.240352] bi_next!= NULL i=0 read_disk=0 bi_end_io=end_sync_write [raid1]
[  399.240363] ------------[ cut here ]------------
[  399.240364] kernel BUG at block/blk-core.c:2147!
[  399.240365] invalid opcode: 0000 [#1] SMP 
[  399.240378] Modules linked in: ib_srp scsi_transport_srp raid1 md_mod ib_ipoib ib_cm ib_uverbs ib_umad mlx5_ib mlx5_core vxlan ip6_udp_tunnel udp_tunnel mlx4_ib ib_sa ib_mad ib_core ib_addr ib_netlink iTCO_wdt iTCO_vendor_support dcdbas dell_smm_hwmon acpi_cpufreq x86_pkg_temp_thermal tpm_tis coretemp evdev tpm i2c_i801 crct10dif_pclmul serio_raw crc32_pclmul battery processor acpi_pad button kvm_intel kvm dm_round_robin irqbypass dm_multipath autofs4 sg sd_mod crc32c_intel ahci libahci psmouse libata mlx4_core scsi_mod xhci_pci xhci_hcd mlx_compat fan thermal [last unloaded: scsi_transport_srp]
[  399.240380] CPU: 1 PID: 2052 Comm: md0_raid1 Not tainted 4.4.50-1-pserver+ #26
[  399.240381] Hardware name: Dell Inc. Precision Tower 3620/09WH54, BIOS 1.3.6 05/26/2016
[  399.240381] task: ffff8804031b6200 ti: ffff8800d72b4000 task.ti: ffff8800d72b4000
[  399.240385] RIP: 0010:[<ffffffff813fcd9e>]  [<ffffffff813fcd9e>] generic_make_request+0x29e/0x2a0
[  399.240385] RSP: 0018:ffff8800d72b7d10  EFLAGS: 00010286
[  399.240386] RAX: ffff8804031b6200 RBX: ffff8800d2577e00 RCX: 000000003fffffff
[  399.240387] RDX: ffffffffc0000001 RSI: 0000000000000001 RDI: ffff8800d5e8c1e0
[  399.240387] RBP: ffff8800d72b7d50 R08: 0000000000000000 R09: 000000000000003f
[  399.240388] R10: 0000000000000004 R11: 00000000001db9ac R12: 00000000ffffffff
[  399.240388] R13: ffff8800d2748e00 R14: ffff88040a016400 R15: ffff8800d2748e40
[  399.240389] FS:  0000000000000000(0000) GS:ffff88041dc40000(0000) knlGS:0000000000000000
[  399.240390] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  399.240390] CR2: 00007fb49246a000 CR3: 000000040215c000 CR4: 00000000003406e0
[  399.240391] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  399.240391] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  399.240392] Stack:
[  399.240393]  ffff8800d72b7d18 ffff8800d72b7d30 0000000000000000 0000000000000000
[  399.240394]  ffffffffa079c290 ffff8800d2577e00 0000000000000000 ffff8800d2748e00
[  399.240395]  ffff8800d72b7e58 ffffffffa079e74c ffff88040b661c00 ffff8800d2577e00
[  399.240396] Call Trace:
[  399.240398]  [<ffffffffa079c290>] ? sync_request+0xb20/0xb20 [raid1]
[  399.240400]  [<ffffffffa079e74c>] raid1d+0x65c/0x1060 [raid1]
[  399.240403]  [<ffffffff810b6800>] ? trace_raw_output_itimer_expire+0x80/0x80
[  399.240407]  [<ffffffffa0772040>] md_thread+0x130/0x140 [md_mod]
[  399.240409]  [<ffffffff81094790>] ? wait_woken+0x80/0x80
[  399.240412]  [<ffffffffa0771f10>] ? find_pers+0x70/0x70 [md_mod]
[  399.240414]  [<ffffffff81075066>] kthread+0xd6/0xf0
[  399.240415]  [<ffffffff81074f90>] ? kthread_park+0x50/0x50
[  399.240417]  [<ffffffff8180411f>] ret_from_fork+0x3f/0x70
[  399.240418]  [<ffffffff81074f90>] ? kthread_park+0x50/0x50
[  399.240433] Code: 89 04 24 e9 2d ff ff ff 49 8d bd d8 07 00 00 f0 49 83 ad d8 07 00 00 01 74 05 e9 8b fe ff ff 41 ff 95 e8 07 00 00 e9 7f fe ff ff <0f> 0b 55 48 63 c7 48 89 e5 41 54 53 48 89 f3 48 83 ec 28 48 0b 
[  399.240434] RIP  [<ffffffff813fcd9e>] generic_make_request+0x29e/0x2a0
[  399.240435]  RSP <ffff8800d72b7d10>


Regards,
Michael Wang

> 
> NeilBrown
> 
