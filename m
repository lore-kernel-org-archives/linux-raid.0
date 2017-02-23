From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Thu, 23 Feb 2017 11:58:11 -0800
Message-ID: <20170223195811.sio23y5m4zxeqnmt@kernel.org>
References: <87k28lshg5.fsf@notabene.neil.brown.name>
 <20170220070430.4mca7clpaw7kpj4j@kernel.org>
 <7178ADEA-6263-4FB0-95A5-96E5F71A9740@suse.de>
 <878tp0s7w8.fsf@notabene.neil.brown.name>
 <f36e85b1-cca1-5be4-a171-d64057cc56a3@suse.de>
 <20170221174542.rer73ywil3oq26gj@kernel.org>
 <c04d68cd-96e8-dff9-c54e-54248394119f@suse.de>
 <488f88e0-8111-a320-3abb-c6e6611a957e@suse.de>
 <20170223173418.qrgjpj6utgceg5f4@kernel.org>
 <b6134a31-6cf6-3ea4-a3e5-0073c38c3a51@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b6134a31-6cf6-3ea4-a3e5-0073c38c3a51@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On Fri, Feb 24, 2017 at 03:31:16AM +0800, Coly Li wrote:
> On 2017/2/24 上午1:34, Shaohua Li wrote:
> > On Thu, Feb 23, 2017 at 01:54:47PM +0800, Coly Li wrote:
> [snip]
> >>>>>> As r1bio_pool preallocates 256 entries, this is unlikely  but not 
> >>>>>> impossible.  If 256 threads all attempt a write (or read) that
> >>>>>> crosses a boundary, then they will consume all 256 preallocated
> >>>>>> entries, and want more. If there is no free memory, they will block
> >>>>>> indefinitely.
> >>>>>>
> >>>>>
> >>>>> If raid1_make_request() is modified into this way,
> >>>>> +	if (bio_data_dir(split) == READ)
> >>>>> +		raid1_read_request(mddev, split);
> >>>>> +	else
> >>>>> +		raid1_write_request(mddev, split);
> >>>>> +	if (split != bio)
> >>>>> +		generic_make_request(bio);
> >>>>>
> >>>>> Then the original bio will be added into the bio_list_on_stack of top
> >>>>> level generic_make_request(), current->bio_list is initialized, when
> >>>>> generic_make_request() is called nested in raid1_make_request(), the
> >>>>> split bio will be added into current->bio_list and nothing else happens.
> >>>>>
> >>>>> After the nested generic_make_request() returns, the code back to next
> >>>>> code of generic_make_request(),
> >>>>> 2022                         ret = q->make_request_fn(q, bio);
> >>>>> 2023
> >>>>> 2024                         blk_queue_exit(q);
> >>>>> 2025
> >>>>> 2026                         bio = bio_list_pop(current->bio_list);
> >>>>>
> >>>>> bio_list_pop() will return the second half of the split bio, and it is
> >>>>
> >>>> So in above sequence, the curent->bio_list will has bios in below sequence:
> >>>> bios to underlaying disks, second half of original bio
> >>>>
> >>>> bio_list_pop will pop bios to underlaying disks first, handle them, then the
> >>>> second half of original bio.
> >>>>
> >>>> That said, this doesn't work for array stacked 3 layers. Because in 3-layer
> >>>> array, handling the middle layer bio will make the 3rd layer bio hold to
> >>>> bio_list again.
> >>>>
> >>>
> >>> Could you please give me more hint,
> >>> - What is the meaning of "hold" from " make the 3rd layer bio hold to
> >>> bio_list again" ?
> >>> - Why deadlock happens if the 3rd layer bio hold to bio_list again ?
> >>
> >> I tried to set up a 4 layer stacked md raid1, and reduce I/O barrier
> >> bucket size to 8MB, running for 10 hours, there is no deadlock observed,
> >>
> >> Here is how the 4 layer stacked raid1 setup,
> >> - There are 4 NVMe SSDs, on each SSD I create four 500GB partition,
> >>   /dev/nvme0n1:  nvme0n1p1, nvme0n1p2, nvme0n1p3, nvme0n1p4
> >>   /dev/nvme1n1:  nvme1n1p1, nvme1n1p2, nvme1n1p3, nvme1n1p4
> >>   /dev/nvme2n1:  nvme2n1p1, nvme2n1p2, nvme2n1p3, nvme2n1p4
> >>   /dev/nvme3n1:  nvme3n1p1, nvme3n1p2, nvme3n1p3, nvme3n1p4
> >> - Here is how the 4 layer stacked raid1 assembled, level 1 means the top
> >> level, level 4 means the bottom level in the stacked devices,
> >>   - level 1:
> >> 	/dev/md40: /dev/md30  /dev/md31
> >>   - level 2:
> >> 	/dev/md30: /dev/md20  /dev/md21
> >> 	/dev/md31: /dev/md22  /dev/md23
> >>   - level 3:
> >> 	/dev/md20: /dev/md10  /dev/md11
> >> 	/dev/md21: /dev/md12  /dev/md13
> >> 	/dev/md22: /dev/md14  /dev/md15
> >> 	/dev/md23: /dev/md16  /dev/md17
> >>   - level 4:
> >> 	/dev/md10: /dev/nvme0n1p1  /dev/nvme1n1p1
> >> 	/dev/md11: /dev/nvme2n1p1  /dev/nvme3n1p1
> >> 	/dev/md12: /dev/nvme0n1p2  /dev/nvme1n1p2
> >> 	/dev/md13: /dev/nvme2n1p2  /dev/nvme3n1p2
> >> 	/dev/md14: /dev/nvme0n1p3  /dev/nvme1n1p3
> >> 	/dev/md15: /dev/nvme2n1p3  /dev/nvme3n1p3
> >> 	/dev/md16: /dev/nvme0n1p4  /dev/nvme1n1p4
> >> 	/dev/md17: /dev/nvme2n1p4  /dev/nvme3n1p4
> >>
> >> Here is the fio job file,
> >> [global]
> >> direct=1
> >> thread=1
> >> ioengine=libaio
> >>
> >> [job]
> >> filename=/dev/md40
> >> readwrite=write
> >> numjobs=10
> >> blocksize=33M
> >> iodepth=128
> >> time_based=1
> >> runtime=10h
> >>
> >> I planed to learn how the deadlock comes by analyze a deadlock
> >> condition. Maybe it was because 8MB bucket unit size is small enough,
> >> now I try to run with 512K bucket unit size, and see whether I can
> >> encounter a deadlock.
> > 
> > Don't think raid1 could easily trigger the deadlock. Maybe you should try
> > raid10. The resync case is hard to trigger for raid1. The memory pressure case
> > is hard to trigger for both raid1/10. But it's possible to trigger.
> > 
> > The 3-layer case is something like this:
> 
> Hi Shaohua,
> 
> I try to catch up with you, let me try to follow your mind by the
> split-in-while-loop condition (this is my new I/O barrier patch). I
> assume the original BIO is a write bio, and original bio is split and
> handled in a while loop in raid1_make_request().
> 
> > 1. in level1, set current->bio_list, split bio to bio1 and bio2
> 
> This is done in level1 raid1_make_request().
> 
> > 2. remap bio1 to level2 disk, and queue bio1-level2 in current->bio_list
> 
> Remap is done by raid1_write_request(), and bio1_level may be added into
> one of the two list:
> - plug->pending:
>   bios in plug->pending may be handled in raid1_unplug(), or in
> flush_pending_writes() of raid1d().
>   If current task is about to be scheduled, raid1_unplug() will merge
> plug->pending's bios to conf->pending_bio_list. And
> conf->pending_bio_list will be handled in raid1d.
>   If raid1_unplug() is triggered by blk_finish_plug(), it is also
> handled in raid1d.
> 
> - conf->pending_bio_list:
>   bios in this list is handled in raid1d by calling flush_pending_writes().
> 
> 
> So generic_make_request() to handle bio1_level2 can only be called in
> context of raid1d thread, bio1_level2 is added into raid1d's
> bio_list_on_stack, not caller of level1 generic_make_request().
> 
> > 3. queue bio2 in current->bio_list
> 
> Same, bio2_level2 is in level1 raid1d's bio_list_on_stack.
> Then back to level1 generic_make_request()
> 
> > 4. generic_make_request then pops bio1-level2
> 
> At this moment, bio1_level2 and bio2_level2 are in either plug->pending
> or conf->pending_bio_list, bio_list_pop() returns NULL, and level1
> generic_make_request() returns to its caller.
> 
> If before bio_list_pop() called, kernel thread raid1d wakes up and
> iterates conf->pending_bio_list in flush_pending_writes() or iterate
> plug->pending in raid1_unplug() by blk_finish_plug(), that happens in
> level1 raid1d's stack, bios will not show up in level1
> generic_make_reques(), bio_list_pop() still returns NULL.
> 
> > 5. remap bio1-level2 to level3 disk, and queue bio1-level2-level3 in current->bio_list
> 
> bio2_level2 is at head of conf->pending_bio_list or plug->pending, so
> bio2_level2 is handled firstly.
> 
> level1 raid1 calls level2 generic_make_request(), then level2
> raid1_make_request() is called, then level raid1_write_request().
> bio2_level2 is remapped to bio2_level3, added into plug->pending (level1
> raid1d's context) or conf->pending_bio_list (level2 raid1's conf), it
> will be handled by level2 raid1d, when level2 raid1d wakes up.
> Then returns back to level1 raid1, bio1_level2
> is handled by level2 generic_make_request() and added into level2
> plug->pending or conf->pending_bio_list. In this case neither
> bio2_level2 nor bio1_level is added into any bio_list_on_stack.
> 
> Then level1 raid1d handles all bios in level1 conf->pending_bio_list,
> and sleeps.
> 
> Then level2 raid1d wakes up, and handle bio2_level3 and bio1_level3, by
> iterate level2 plug->pending or conf->pending_bio_list, and calling
> level3 generic_make_request().
> 
> In level3 generic_make_request(), because it is level2 raid1d context,
> not level1 raid1d context, bio2_level3 is send into
> q->make_request_fn(), and finally added into level3 plug->pending or
> conf->pending_bio_list, then back to level3 generic_make_reqeust().
> 
> Now level2 raid1d's current->bio_list is empty, so level3
> generic_make_request() returns to level2 raid1d and continue to iterate
> and send bio1_level3 into level3 generic_make_request().
> 
> After all bios are added into level3 plug->pending or
> conf->pending_bio_list, level2 raid1d sleeps.
> 
> Now level3 raid1d wakes up, continue to iterate level3 plug->pending or
> conf->pending_bio_list by calling generic_make_request() to underlying
> devices (which might be a read device).
> 
> On the above whole patch, each lower level generic_make_request() is
> called in context of the lower level raid1d. No recursive call happens
> in normal code path.
> 
> In raid1 code, recursive call of generic_make_request() only happens for
> READ bio, but if array is not frozen, no barrier is required, it doesn't
> hurt.
> 
> 
> > 6. generic_make_request then pops bio2, but bio1 hasn't finished yet, deadlock
> 
> As my understand to the code, it won't happen neither.
> 
> > 
> > The problem is because we add new bio to current->bio_list tail.
> 
> New bios are added into other context's current->bio_list, which are
> different lists. If what I understand is correct, a dead lock won't
> happen in this way.
> 
> If my understanding is correct, suddenly I come to realize why raid1
> bios are handled indirectly in another kernel thread.
> 
> (Just for your information, when I write to this location, another run
> of testing finished, no deadlock. This time I reduce I/O barrier bucket
> unit size to 512KB, and set blocksize to 33MB in fio job file. It is
> really slow (130MB/s), but no deadlock observed)
> 
> 
> The stacked raid1 devices are really really confused, if I am wrong, any
> hint is warmly welcome.

Aha, you are correct. I missed we never directly dispatch bio in a schedule based
blk-plug flush. I'll drop the patch. Thanks for the insistence, good discussion!

Thanks,
Shaohua
