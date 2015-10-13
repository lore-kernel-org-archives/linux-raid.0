From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Block integrity registration update
Date: Tue, 13 Oct 2015 10:38:13 -0700
Message-ID: <CAPcyv4jS718028xnW2wLMUH8xRgaJ6jRbTB0UHdz4heqDr5NVQ@mail.gmail.com>
References: <B58D82457FDA0744A320A2FC5AC253B93CBE5758@fmsmsx104.amr.corp.intel.com>
	<1444683912-7140-1-git-send-email-martin.petersen@oracle.com>
	<1444696266.9780.13.camel@intel.com>
	<1444701214.9780.23.camel@intel.com>
	<20151013122608.GA18816@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151013122608.GA18816@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "Busch, Keith" <keith.busch@intel.com>, "willy@linux.intel.com" <willy@linux.intel.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "axboe@fb.com" <axboe@fb.com>, "snitzer@redhat.com" <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ adding Neil, linux-raid ]

On Tue, Oct 13, 2015 at 5:26 AM, hch@infradead.org <hch@infradead.org> wrote:
> On Tue, Oct 13, 2015 at 01:53:34AM +0000, Williams, Dan J wrote:
>> ...i.e. that we're destroying the integrity profile while i/o is still
>> in flight.  As far as I can see any driver that calls
>> blk_integrity_unregister() before blk_cleanup_queue() can hit this.
>>
>> However, with the change to static allocation I'm not sure why a driver
>> would ever need to call blk_integrity_unregister() in its shutdown path.
>
> It shouldn't.
>
>> It seems this would only be necessary for disabling integrity at run
>> time, but it can only do it safely when the queue is known to be idle.
>
> Yes.  And even for that case we should a) only clear ->flags not the
> whole integrity profile (and fix blk_integrity_revalidate to check the
> right thing) and b) clear flags before calling blk_integrity_revalidate.
>
>> Is there a way to solve this without the generic blk_freeze_queue()
>> implementation? [1].  The immediate fix for libnvdimm is to just stop
>> calling blk_integrity_unregister().
>
> Seems like only nvme ever updates the profile, and nvme is blk-mq
> only.

Looks like both dm and md are calling blk_integrity_unregister() at
run-time as well when adding new disks to the configuration.  Even if
we fix blk_integrity_unregister() to not trigger a crash it seems we
still need to stop all I/O during the unregistration so we don't throw
spurious integrity miscompares for in-flight i/o.

For dm I'm wondering what's the difference between a mapped_device
being suspended vs having completed a stop_queue()?  Mike?

For md looks like a simple mddev_suspend()/resume() in
md_integrity_add_rdev() is sufficient.

...and then blk_mq_freeze_queue() for nvme in nvme_revalidate_disk().

I'll throw together a patch...
