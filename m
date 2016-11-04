From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 2/2] mdadm: raid10.c Remove near atomic break
Date: Fri, 4 Nov 2016 16:08:33 -0700
Message-ID: <20161104230833.ai6o5hfq7y4qmoyp@kernel.org>
References: <20161103234508.12641-1-robert@leblancnet.us>
 <20161103234508.12641-3-robert@leblancnet.us>
 <87k2cjq4eh.fsf@notabene.neil.brown.name>
 <CAANLjFrXjS3HX-qv_FAXBapD6PE-n+y=d=6kzCwO3pSjajafWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAANLjFrXjS3HX-qv_FAXBapD6PE-n+y=d=6kzCwO3pSjajafWQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 03, 2016 at 11:37:48PM -0600, Robert LeBlanc wrote:
> On Thu, Nov 3, 2016 at 10:01 PM, NeilBrown <neilb@suse.com> wrote:
> > On Fri, Nov 04 2016, Robert LeBlanc wrote:
> >
> >> This is always triggered for small reads preventing spreading the reads
> >> across all available drives. The comments are also confusing as it is
> >> supposed to apply only to 'far' layouts, but really only applies to 'near'
> >> layouts. Since there isn't problems with 'far' layouts, there shouldn't
> >> be a problem for 'near' layouts either. This change fairly distributes
> >> reads across all drives where before only came from the first drive.
> >
> > Why is "fairness" an issue?
> > The current code will use a device if it finds that it is completely
> > idle. i.e. if nr_pending is 0.
> > Why is that ever the wrong thing to do?
> 
> The code also looks for a drive that is closest to the requested
> sector which doesn't get a chance to happen without this patch. The
> way this part of code is written, as soon as it finds a good disk, it
> cuts out of the loop searching for a better disk. So it doesn't even
> look for another disk. In a healthy array with array-disks X and -p
> nX, this means that the first disk gets all the reads for small I/O.
> Where nY is less than X, it may be covered up because the data is
> naturally striped, but it still may be picking a disk that is farther
> away from the selected sector causing extra head seeks.
> 
> > Does your testing show that overall performance is improved?  If so,
> > that would certainly be useful.
> > But it isn't clear (to me) that simply spreading the load more "fairly"
> > is a worthy goal.
> 
> I'll see if I have some mechanical drives somewhere to test (I've been
> testing four loopback devices on a single NVME drive so you don't see
> an improvement). You can see from the fio I posted [1] that before the
> patch, one drive had all the I/O and after the patch the I/O was
> distributed between all the drives (it doesn't have to be exactly
> even, just not as skewed as it was before is good enough). I would
> expect similar results to the 'far' tests done here [0]. Based on the
> previous tests I did, when I saw this code, it just made complete
> sense to me why we had great performance with 'far' and subpar
> performance with 'near'. I'll come back with some results tomorrow.

But in your test, iodepth is 1. So nr_pending is always 0 when we try to choose
a disk. In this case, always dispatching it to one disk doesn't matter. If your
test has high iodepth, the io will be distributed to all disks as the first
disk's nr_pending will not be 0.

That said the distribution algorithm does have problem. We should have
different algorithms for SSD and hardisk because seek isn't a problem for SSD.
I fixed it for raid1, but not raid10. I think we should do something similar
for raid10.

Thanks,
Shaohua
