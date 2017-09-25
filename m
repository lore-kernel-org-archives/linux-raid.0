From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v3 1/6] md: Make md resync and reshape threads freezable
Date: Tue, 26 Sep 2017 06:45:28 +0800
Message-ID: <20170925224526.GA18137@ming.t460p>
References: <20170922221405.22091-1-bart.vanassche@wdc.com>
 <20170922221405.22091-2-bart.vanassche@wdc.com>
 <20170925023804.GD6434@ming.t460p>
 <1506356548.2641.13.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1506356548.2641.13.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "shli@kernel.org" <shli@kernel.org>
List-Id: linux-raid.ids

On Mon, Sep 25, 2017 at 04:22:29PM +0000, Bart Van Assche wrote:
> On Mon, 2017-09-25 at 10:38 +0800, Ming Lei wrote:
> > On Fri, Sep 22, 2017 at 03:14:00PM -0700, Bart Van Assche wrote:
> > > Some people use the md driver on laptops and use the suspend and
> > > resume functionality. Since it is essential that submitting of
> > > new I/O requests stops before device quiescing starts, make the
> > > md resync and reshape threads freezable.
> > 
> > Why is this patch part of this patchset? I don't think
> > MD is special enough wrt. the SCSI quiesce issue.
> 
> Because the scope of this patch series is not only to make SCSI quiesce safe
> but also to avoid that suspend and resume lock up with a storage stack that
> uses the md driver.

If SCSI quiesce is safe, there shouldn't be suspend/resume lockup on any
SCSI device wrt. quiesce, right?

Did you see Martin's report which is on BTRFS(RAID) instead of MD?

	https://marc.info/?l=linux-block&m=150634883816965&w=2

-- 
Ming
