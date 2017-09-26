From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v4 1/7] md: Make md resync and reshape threads freezable
Date: Tue, 26 Sep 2017 12:01:10 +0800
Message-ID: <20170926040103.GA19111@ming.t460p>
References: <20170925202924.16603-1-bart.vanassche@wdc.com>
 <20170925202924.16603-2-bart.vanassche@wdc.com>
 <20170925230421.GD18137@ming.t460p>
 <1506380954.2641.57.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1506380954.2641.57.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "shli@kernel.org" <shli@kernel.org>
List-Id: linux-raid.ids

On Mon, Sep 25, 2017 at 11:09:15PM +0000, Bart Van Assche wrote:
> On Tue, 2017-09-26 at 07:04 +0800, Ming Lei wrote:
> > On Mon, Sep 25, 2017 at 01:29:18PM -0700, Bart Van Assche wrote:
> > > Some people use the md driver on laptops and use the suspend and
> > > resume functionality. Since it is essential that submitting of
> > > new I/O requests stops before device quiescing starts, make the
> > > md resync and reshape threads freezable.
> > 
> > As I explained, if SCSI quiesce is safe, this patch shouldn't
> > be needed.
> > 
> > The issue isn't MD specific, and in theory can be triggered
> > on all devices. And you can see the I/O hang report on BTRFS(RAID)
> > without MD involved:
> > 
> > 	https://marc.info/?l=linux-block&m=150634883816965&w=2
> 
> What makes you think that this patch is not necessary once SCSI quiesce
> has been made safe? Does this mean that you have not tested suspend and

If we want to make SCSI quiesce safe, we have to drain up all submitted
I/O and prevent new I/O from being submitted, that is enough to deal
with MD's resync too.

> resume while md RAID 1 resync was in progress? This patch is necessary
> to avoid that suspend locks up while md RAID 1 resync is in progress.

I tested my patchset on RAID10 when resync in progress, not see any
issue during suspend/resume, without any MD's change. I will test
RAID1's later, but I don't think there is difference compared with
RAID10 because my patchset can make the queue being quiesced totally.

The upstream report did not mention that the resync is in progress:

	https://marc.info/?l=linux-block&m=150402198315951&w=2

I want to make the patchset(make SCSI quiesce safe) focusing on this
SCSI quiesce issue.

Maybe with this MD patch, the original report becomes quite difficult
to reproduce, that doesn't mean this MD patch fixes this kind of
issue. What I really cares is that your changes on BLOCK/SCSI can
fix this issue.


-- 
Ming
