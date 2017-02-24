From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Fri, 24 Feb 2017 11:02:15 -0800
Message-ID: <20170224190215.uzv2cl65ry7siip5@kernel.org>
References: <7178ADEA-6263-4FB0-95A5-96E5F71A9740@suse.de>
 <878tp0s7w8.fsf@notabene.neil.brown.name>
 <f36e85b1-cca1-5be4-a171-d64057cc56a3@suse.de>
 <20170221174542.rer73ywil3oq26gj@kernel.org>
 <c04d68cd-96e8-dff9-c54e-54248394119f@suse.de>
 <488f88e0-8111-a320-3abb-c6e6611a957e@suse.de>
 <87lgswqz3w.fsf@notabene.neil.brown.name>
 <ef194546-a825-7eab-f8cb-e5ee147d065b@suse.de>
 <20170224171724.4go2ahruap2nqhlq@kernel.org>
 <77888b1a-9b5c-6171-f830-ff2d62193067@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <77888b1a-9b5c-6171-f830-ff2d62193067@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On Sat, Feb 25, 2017 at 02:57:26AM +0800, Coly Li wrote:
> On 2017/2/25 上午1:17, Shaohua Li wrote:
> > On Sat, Feb 25, 2017 at 01:06:22AM +0800, Coly Li wrote:
> >> On 2017/2/24 上午7:14, NeilBrown wrote:
> >>> On Thu, Feb 23 2017, Coly Li wrote:
> >>>
> >>>>
> >>>> I tried to set up a 4 layer stacked md raid1, and reduce I/O
> >>>> barrier bucket size to 8MB, running for 10 hours, there is no
> >>>> deadlock observed,
> >>>
> >>> Try setting BARRIER_BUCKETS_NR to '1' and BARRIER_UNIT_SECTOR_BITS
> >>> to 3 and make sure the write requests are larger than 1 page (and
> >>> have resync happen at the same time as writes).
> >>
> >> Hi Neil,
> >>
> >> Yes, the above method triggers deadlock easily. After come to
> >> understand how bios are handled in stacked raid1 and the relationship
> >> between current->bio_list, plug->pending and conf->pending_bio_list, I
> >> think I come to understand what you worried and the meaning of your fix.
> >>
> >> I totally agree and understand there will be hash conflict sooner or
> >> later now. Yes we need this fix.
> >>
> >> Thanks to you and Shaohua, explaining the details to me, and help me
> >> to catch up your mind :-)
> > 
> > I'm confused. So the deadlock is real? How is it triggered?
> 
> Let me explain,
> 
> There is no deadlock now, because,
> 1) If there is hash conflict existing, a deadlock is possible.
> 2) In current Linux kernel, hash conflict won't happen in real life
>    2.1) regular bio maximum size is 2MB, it can only be split into 2
> bios in raid1_make_request() of my new I/O barrier patch
>    2.2) DISCARD bio maximum size is 4GB, it can be split into 65 bios in
> raid1_make_request() of my new I/O barrier patch.
>    2.3) I verified that, for any consecutive  512 integers in [0,
> 1<<63], there is no hash conflict by calling sector_to_idx().
>    2.4) Currently there is almost no device provides LBA range exceeds
> (1<<63) bytes. So in current Linux kernel with my new I/O barrier patch,
> no dead lock will happen. The patch in current Linux kernel is deadlock
> clean from all conditions we discussed before.
> 
> The reason why I suggest to still have your patch is,
> 1) If one day bi_iter.bi_size is extended from 32bit (unsigned int) to
> 64bit (unsigned long), a DISCARD bio will be split to more than 1024
> smaller bios.
> 2) If a DISCARD bio is split into more then 1024 smaller bios, that
> means sector_to_idx() is called by 1024+ consecutive integers. It is
> 100% possible to have hash conflict.
> 3) If hash conflict exists, the deadlock described by Neil will be passible.
> 
> 
> What I mean is, currently there is no deadlock, because bi_iter.bi_size
> is 32 bit; if in future bi_iter.bi_size extended to 64 bit, we will have
> deadlock. Your fix almost does not hurt performance, improves code
> readability and will avoid a potential deadlock in future (when
> bi_iter.bi_size extended to 64 bit), why not have it ?

Let's assume there is hash conflict. We have raid10 anyway, which doesn't have
the fancy barrier. When can the deadlock be triggered? My understanding is
there isn't because we are handling bios in raid1/10d. Any thing I missed?

Thanks,
Shaohua
