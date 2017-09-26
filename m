From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v4 1/7] md: Make md resync and reshape threads freezable
Date: Tue, 26 Sep 2017 23:02:51 +0800
Message-ID: <20170926150250.GD31449@ming.t460p>
References: <20170925202924.16603-1-bart.vanassche@wdc.com>
 <20170925202924.16603-2-bart.vanassche@wdc.com>
 <20170925230421.GD18137@ming.t460p>
 <1506380954.2641.57.camel@wdc.com>
 <20170926040103.GA19111@ming.t460p>
 <20170926081309.GA518@ming.t460p>
 <1506436834.3787.22.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1506436834.3787.22.camel@wdc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "shli@kernel.org" <shli@kernel.org>
List-Id: linux-raid.ids

On Tue, Sep 26, 2017 at 02:40:36PM +0000, Bart Van Assche wrote:
> On Tue, 2017-09-26 at 16:13 +0800, Ming Lei wrote:
> > I am pretty sure that suspend/resume can survive when resync in progress
> > with my patchset applied on RAID1, without any MD change.
> 
> The above shows that you do not understand how suspend and resume works.
> In the documents in the directory Documentation/power it is explained clearly
> that I/O must be stopped before the hibernation image is generation to avoid

No, I don't use hibernation, and just use suspend/resume(s2r).

> hard to repair filesystem corruption. Although md is not a filesystem I think
> this also applies to md since md keeps some state information in RAM and some
> state information on disk. It is essential that all that state information is
> in consistent.
> 
> > If your patchset depends on this MD change, something should be wrong
> > in the following patches. Now I need to take a close look.
> 
> The later patches that make SCSI quiesce and resume safe do not depend on
> this change.

Are you sure?

If I remove the 1st patch, system suspend/resume will hang with all your
other 6 patchset.


-- 
Ming
