From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Wed, 14 Dec 2016 11:22:04 +0100
Message-ID: <CAMGffEnCesgUp4gBsPN2L9qg3WSxNXsCcYEPWH-BaeEEktaqcw@mail.gmail.com>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
 <87a8c20xpg.fsf@notabene.neil.brown.name> <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com>
 <87oa0gzuej.fsf@notabene.neil.brown.name> <CAMGffEm4BDhKJSiDt=2WmxrpRutg862at7JP221gMi6_SpPomQ@mail.gmail.com>
 <877f73zd5d.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877f73zd5d.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

Thanks Neil,

On Tue, Dec 13, 2016 at 11:18 PM, NeilBrown <neilb@suse.com> wrote:
> On Wed, Dec 14 2016, Jinpu Wang wrote:
>
>>
>> As you suggested, I re-run same test with 4.4.36 with no our own patch o=
n MD.
>> I can still reproduce the same bug, nr_pending on heathy leg(loop1) is t=
ill 1.
>>
>
> Thanks.
>
> I have an hypothesis.
>
> md_make_request() calls blk_queue_split().
> If that does split the request it will call generic_make_request()
> on the first half. That will call back into md_make_request() and
> raid1_make_request() which will submit requests to the underlying
> devices.  These will get caught on the bio_list_on_stack queue in
> generic_make_request().
> This is a queue which is not accounted in nr_queued.
>
> When blk_queue_split() completes, 'bio' will be the second half of the
> bio.
> This enters raid1_make_request() and by this time the array have been
> frozen.
> So wait_barrier() has to wait for pending requests to complete, and that
> includes the one that it stuck in bio_list_on_stack, which will never
> complete now.
>
> To see if this might be happening, please change the
>
>         blk_queue_split(q, &bio, q->bio_split);
>
> call in md_make_request() to
>
>         struct bio *tmp =3D bio;
>         blk_queue_split(q, &bio, q->bio_split);
>         WARN_ON_ONCE(bio !=3D tmp);
>
> If that ever triggers, then the above is a real possibility.

I triggered the warning as you expected, we can confirm the bug was
caused by your above hypothesis.
[  429.282235] ------------[ cut here ]------------
[  429.282407] WARNING: CPU: 2 PID: 4139 at drivers/md/md.c:262
md_set_array_sectors+0xac0/0xc30 [md_mod]()
[  429.285288] Modules linked in: raid1 ibnbd_client(O)
ibtrs_client(O) dm_service_time dm_multipath rdma_ucm ib_ucm rdma_cm
iw_cm ib_ipoib ib_cm ib_uverbs ib_umad mlx5_ib mlx5_c
ore vxlan ip6_udp_tunnel udp_tunnel mlx4_ib ib_sa ib_mad ib_core
ib_addr ib_netlink mlx4_core mlx_compat loop md_mod kvm_amd
edac_mce_amd kvm edac_core irqbypass acpi_cpufreq tpm
_infineon tpm_tis i2c_piix4 tpm serio_raw evdev k10temp processor
button fam15h_power crct10dif_pclmul crc32_pclmul sg sd_mod ahci
libahci libata scsi_mod crc32c_intel r8169 psmo
use xhci_pci xhci_hcd [last unloaded: mlx_compat]
[  429.288543] CPU: 2 PID: 4139 Comm: fio Tainted: G           O    4.4.36-=
1-pse
rver #1
[  429.288825] Hardware name: To be filled by O.E.M. To be filled by
O.E.M./M5A97 R2.0, BIOS 2501 04/07/2014
[  429.289113]  0000000000000000 ffff8801f64ff8f0 ffffffff81424486
0000000000000000
[  429.289538]  ffffffffa0561938 ffff8801f64ff928 ffffffff81058a60
ffff8800b8f3e000
[  429.290157]  0000000000000000 ffff8800b51f4100 ffff880234f9a700
ffff880234f9a700
[  429.290594] Call Trace:
[  429.290743]  [<ffffffff81424486>] dump_stack+0x4d/0x67
[  429.290893]  [<ffffffff81058a60>] warn_slowpath_common+0x90/0xd0
[  429.291046]  [<ffffffff81058b55>] warn_slowpath_null+0x15/0x20
[  429.291202]  [<ffffffffa0550740>] md_set_array_sectors+0xac0/0xc30 [md_m=
od]
[  429.291358]  [<ffffffff813fd3de>] generic_make_request+0xfe/0x1e0
[  429.291540]  [<ffffffff813fd522>] submit_bio+0x62/0x150
[  429.291693]  [<ffffffff813f53d9>] ? bio_set_pages_dirty+0x49/0x60
[  429.291847]  [<ffffffff811d32a7>] do_blockdev_direct_IO+0x2317/0x2ba0
[  429.292011]  [<ffffffffa0834f64>] ?
ib_post_rdma_write_imm+0x24/0x30 [ibtrs_client]
[  429.292271]  [<ffffffff811cdc40>] ? I_BDEV+0x10/0x10
[  429.292417]  [<ffffffff811d3b6e>] __blockdev_direct_IO+0x3e/0x40
[  429.292566]  [<ffffffff811ce2d7>] blkdev_direct_IO+0x47/0x50
[  429.292746]  [<ffffffff81132abf>] generic_file_read_iter+0x45f/0x580
[  429.292894]  [<ffffffff811ce620>] ? blkdev_write_iter+0x110/0x110
[  429.293073]  [<ffffffff811ce652>] blkdev_read_iter+0x32/0x40
[  429.293284]  [<ffffffff811deb86>] aio_run_iocb+0x116/0x2a0
[  429.293492]  [<ffffffff813fed52>] ? blk_flush_plug_list+0xc2/0x200
[  429.293703]  [<ffffffff81183ac6>] ? kmem_cache_alloc+0xb6/0x180
[  429.293901]  [<ffffffff811dfaf4>] ? do_io_submit+0x184/0x4d0
[  429.294047]  [<ffffffff811dfbaa>] do_io_submit+0x23a/0x4d0
[  429.294194]  [<ffffffff811dfe4b>] SyS_io_submit+0xb/0x10
[  429.294375]  [<ffffffff81815497>] entry_SYSCALL_64_fastpath+0x12/0x6a
[  429.294610] ---[ end trace 25d1cece0e01494b ]---

I double checked the nr_pending on heathy leg is still 1 as before.

>
> Fixing the problem isn't very easy...
>
> You could try:
> 1/ write a function in raid1.c which calls punt_bios_to_rescuer()
>   (which you will need to export from block/bio.c),
>   passing mddev->queue->bio_split as the bio_set.
>
> 1/ change the wait_event_lock_irq() call in wait_barrier() to
>    wait_event_lock_irq_cmd(), and pass the new function as the command.
>
> That way, if wait_barrier() ever blocks, all the requests in
> bio_list_on_stack will be handled by a separate thread.
>
> NeilBrown

I will try your sugested way to see if it fix the bug, will report back soo=
n.

--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
