From: Arka Sharma <arka.sw1988@gmail.com>
Subject: Re: mdadm I/O error with Ddf RAID
Date: Thu, 17 Nov 2016 10:51:59 +0530
Message-ID: <CAPO=kN3psOzSYzbKZ5dAGK5uEk3JfTSf-Ec+S_UTL0iaD78Pdg@mail.gmail.com>
References: <CAPO=kN2QDLEMgo9p9pU3=MeLQ=J6R8eeDL1Pw9m2pHjbVsuFGg@mail.gmail.com>
 <874m3ak3ci.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <874m3ak3ci.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Neil for you response. The devices we are using have physical
sector size of 512 bytes. We are writing the anchor header at last LBA
of the devices. We also written the controller data, physical records,
virtual records, physical data, config data to both primary and
secondary. We have also dumped 32 MB of metadata for RAID created by
mdadm and our tool. The guid's, crc's, timestamps are different as
expected, and the other fields are mostly similar, except in between
some header mdadm is writing 'FF' and we are writing 0's. We have also
dumped the call trace in block layer and put following prints,

[   10.312362] generic_make_request: bio->bi_iter.bi_sector=18446744073709551615
[   10.312363] generic_make_request_checks:
bio->bi_iter.bi_sector=18446744073709551615
[   10.312364] bio_check_eod: nr_sector=8, max_sector=1000215216,
bio->bi_iter.bi_sector=18446744073709551615

And following is the call trace

[   10.312372]  [<ffffffff983d4b5c>] dump_stack+0x63/0x87
[   10.312374]  [<ffffffff983a06c1>] generic_make_request_checks+0x2a1/0x550
[   10.312375]  [<ffffffff980d54a9>] ? vprintk_default+0x29/0x40
[   10.312377]  [<ffffffff983a2cf2>] generic_make_request+0x52/0x210
[   10.312378]  [<ffffffff9839c0bf>] ? bio_clone_bioset+0x12f/0x320
[   10.312380]  [<ffffffffc031ed6a>] raid1_make_request+0xa2a/0xe00 [raid1]
[   10.312382]  [<ffffffff98192fcc>] ? get_page_from_freelist+0x36c/0xa50
[   10.312383]  [<ffffffff9822f8d5>] ? __d_alloc+0x25/0x1d0
[   10.312385]  [<ffffffff986739f2>] md_make_request+0xe2/0x230
[   10.312387]  [<ffffffff980be164>] ? __wake_up+0x44/0x50
[   10.312391]  [<ffffffff983a2dc6>] generic_make_request+0x126/0x210
[   10.312395]  [<ffffffff98325e3b>] ? d_lookup_done.part.24+0x26/0x2b
[   10.312398]  [<ffffffff983a2f3b>] submit_bio+0x8b/0x1a0
[   10.312401]  [<ffffffff9839ab48>] ? bio_alloc_bioset+0x168/0x2a0
[   10.312405]  [<ffffffff9824d9ac>] submit_bh_wbc+0x15c/0x1a0
[   10.312408]  [<ffffffff9824e26c>] block_read_full_page+0x1ec/0x370
[   10.312411]  [<ffffffff98250230>] ? I_BDEV+0x20/0x20
[   10.312414]  [<ffffffff9818ad60>] ? find_get_entry+0x20/0x140
[   10.312417]  [<ffffffff98250a18>] blkdev_readpage+0x18/0x20
[   10.312420]  [<ffffffff9818cc7b>] generic_file_read_iter+0x1ab/0x850
[   10.312423]  [<ffffffff98250c77>] blkdev_read_iter+0x37/0x40
[   10.312427]  [<ffffffff9821571e>] __vfs_read+0xbe/0x130
[   10.312430]  [<ffffffff9821674e>] vfs_read+0x8e/0x140
[   10.312433]  [<ffffffff98217b56>] SyS_read+0x46/0xa0
[   10.312437]  [<ffffffff98216437>] ? SyS_lseek+0x87/0xb0
[   10.312440]  [<ffffffff988106f6>] entry_SYSCALL_64_fastpath+0x1e/0xa8

Is it some header field our application is not writing correctly for
which mdadm is reading wrong data and invalid sector value is formed
in bio ?

Regards,
Arka

On Mon, Nov 14, 2016 at 11:30 AM, NeilBrown <neilb@suse.com> wrote:
> On Fri, Nov 11 2016, Arka Sharma wrote:
>
>> Hi All,
>>
>> We have developed a RAID creation application which create RAID with
>> Ddf RAID metadata. We are using PCIe ssd as physical disks. We are
>> writing the anchor, primary, secondary headers, virtual and physical
>> records, configuration record and physical disk data. The offsets of
>> the headers are updated in the primary, secondary and anchor headers
>> correctly. The problem is when we try to boot to Ubuntu server and we
>> observe that mdadm is throwing a disk failure error message and from
>> block layer we are getting rw=0, want=7, limit=1000215216. We also
>> confirmed using there is no I/O error is coming from the PCIe ssd,
>> using a logic analyzer. Also the limit value 1000215216 is the
>> capacity of the ssd in 512 byte blocks. Any insight will be highly
>> appreciated.
>>
>
> It looks like mdadm is attempting a 4K read starting at the last sector.
>
> Possibly the ssd's report a physical sector size of 4K.
>
> I don't know how DDF is supposed to work on a device like that.
> Should the anchor be at the start of the last 4K block,
> or in the last 512byte virtual block?
>
> DDF support in mdadm was written with the assumption of 512 byte blocks.
>
> I'm not at all certain this is the cause of the problem though.
>
> I would suggest starting by finding out which READ request in mdadm is
> causing the error.
>
> NeilBrown
