From: "John Stilson" <john9601@gmail.com>
Subject: Re: RAID 10 resync leading to attempt to access beyond end of device
Date: Thu, 15 Feb 2007 13:02:25 -0500
Message-ID: <e1e9d81a0702151002t2b5b7e43v84ceedb7b6eed2b5@mail.gmail.com>
References: <e1e9d81a0702141408k4f42887by4d4c4c9aa9d536c0@mail.gmail.com>
	 <17875.40267.951634.476979@notabene.brown>
	 <e1e9d81a0702141606r7dea6288qea942cee2d978ee2@mail.gmail.com>
	 <17875.57273.543122.581106@notabene.brown>
	 <e1e9d81a0702142051v152c4c8dme2b20e1c53e1f4b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e1e9d81a0702142051v152c4c8dme2b20e1c53e1f4b2@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok tried the patch and got a kernel BUG this time (BUG_ON(k == conf->copies)?)

-John

Feb 15 12:52:35 testsvr kernel: md: recovery of RAID array md0
Feb 15 12:52:35 testsvr kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Feb 15 12:52:35 testsvr kernel: md: using maximum available idle IO
bandwidth (but not more than 40000 KB/sec) for recovery.
Feb 15 12:52:35 testsvr kernel: md: using 128k window, over a total of
8040320 blocks.
Feb 15 12:55:57 testsvr kernel: ------------[ cut here ]------------
Feb 15 12:55:57 testsvr kernel: kernel BUG at drivers/md/raid10.c:1804!
Feb 15 12:55:57 testsvr kernel: invalid opcode: 0000 [#1]
Feb 15 12:55:57 testsvr kernel: SMP
Feb 15 12:55:57 testsvr kernel: Modules linked in:
Feb 15 12:55:57 testsvr kernel: CPU:    0
Feb 15 12:55:57 testsvr kernel: EIP:    0060:[<c036bbe8>]    Not tainted VLI
Feb 15 12:55:57 testsvr kernel: EFLAGS: 00010246   (2.6.20test1 #3)
Feb 15 12:55:57 testsvr kernel: EIP is at sync_request+0x43d/0x928
Feb 15 12:55:57 testsvr kernel: eax: c2330e14   ebx: c2330dc0   ecx:
00000003   edx: 00000000
Feb 15 12:55:57 testsvr kernel: esi: f68b30c0   edi: f782d4c0   ebp:
00000002   esp: f7397e58
Feb 15 12:55:57 testsvr kernel: ds: 007b   es: 007b   ss: 0068
Feb 15 12:55:57 testsvr kernel: Process md0_resync (pid: 2589,
ti=f7396000 task=f7ade030 task.ti=f7396000)
Feb 15 12:55:57 testsvr kernel: Stack: f7397eac 00000000 00000024
00f55e00 00000000 f717fa00 00000000 00000000
Feb 15 12:55:57 testsvr kernel:        00000080 00000000 00000000
00000000 00000003 00000100 00000000 00000001
Feb 15 12:55:57 testsvr kernel:        c020307c 00443eb0 00000000
00f55f00 00000000 00000400 c036b7ab 00f55e00
Feb 15 12:55:57 testsvr kernel: Call Trace:
Feb 15 12:55:57 testsvr kernel:  [<c020307c>] __next_cpu+0x12/0x1f
Feb 15 12:55:57 testsvr kernel:  [<c036b7ab>] sync_request+0x0/0x928
Feb 15 12:55:57 testsvr kernel:  [<c037fade>] md_do_sync+0x581/0xa07
Feb 15 12:55:57 testsvr kernel:  [<c037a997>] md_thread+0x0/0xdc
Feb 15 12:55:57 testsvr kernel:  [<c037aa5d>] md_thread+0xc6/0xdc
Feb 15 12:55:57 testsvr kernel:  [<c0114004>] complete+0x38/0x47
Feb 15 12:55:57 testsvr kernel:  [<c0129eb2>] kthread+0xab/0xcf
Feb 15 12:55:57 testsvr kernel:  [<c0129e07>] kthread+0x0/0xcf
Feb 15 12:55:57 testsvr kernel:  [<c01041cb>] kernel_thread_helper+0x7/0x10
Feb 15 12:55:57 testsvr kernel:  =======================
Feb 15 12:55:57 testsvr kernel: Code: 4f 04 8b 01 f0 ff 80 9c 00 00 00
f0 ff 03 31 ed 8d 43 34 eb 0c 8b 4c 24 30 39 08 74 09 45 83 c0 10 3b
6f 1c 7c ef
3b 6f 1c 75 04 <0f> 0b eb fe 8b 4b 38 c1 e5 04 89 71 08 89 59 3c c7 41 34 ba b6
Feb 15 12:55:57 testsvr kernel: EIP: [<c036bbe8>]
sync_request+0x43d/0x928 SS:ESP 0068:f7397e58


On 2/14/07, John Stilson <john9601@gmail.com> wrote:
> Wow thanks for the quick response. I will try this tomorrow morning
> and let you know.
>
> -John
>
> On 2/14/07, Neil Brown <neilb@suse.de> wrote:
> >
> > Thanks for the extra detail.  I think I've nailed it.
> > Does this fix it for you?
> >
> > Thanks,
> > NeilBrown
> >
> > Signed-off-by: Neil Brown <neilb@suse.de>
> >
> > ### Diffstat output
> >  ./drivers/md/raid10.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
> > --- .prev/drivers/md/raid10.c   2007-02-15 13:57:34.000000000 +1100
> > +++ ./drivers/md/raid10.c       2007-02-15 15:20:04.000000000 +1100
> > @@ -420,7 +420,7 @@ static sector_t raid10_find_virt(conf_t
> >                 if (dev < 0)
> >                         dev += conf->raid_disks;
> >         } else {
> > -               while (sector > conf->stride) {
> > +               while (sector >= conf->stride) {
> >                         sector -= conf->stride;
> >                         if (dev < conf->near_copies)
> >                                 dev += conf->raid_disks - conf->near_copies;
> > @@ -1747,6 +1747,7 @@ static sector_t sync_request(mddev_t *md
> >                                                 for (k=0; k<conf->copies; k++)
> >                                                         if (r10_bio->devs[k].devnum == i)
> >                                                                 break;
> > +                                               BUG_ON(k == conf->copies);
> >                                                 bio = r10_bio->devs[1].bio;
> >                                                 bio->bi_next = biolist;
> >                                                 biolist = bio;
> > @@ -1973,6 +1974,7 @@ static int run(mddev_t *mddev)
> >         conf->far_offset = fo;
> >         conf->chunk_mask = (sector_t)(mddev->chunk_size>>9)-1;
> >         conf->chunk_shift = ffz(~mddev->chunk_size) - 9;
> > +       mddev->size &= ~(conf->chunk_mask >> 1);
> >         if (fo)
> >                 conf->stride = 1 << conf->chunk_shift;
> >         else {
> >
>
