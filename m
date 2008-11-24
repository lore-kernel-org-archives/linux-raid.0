From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
 needed.
Date: Mon, 24 Nov 2008 13:18:51 +0900
Message-ID: <492A2B2B.7030606@kernel.org>
References: <20081124035516.3465.66413.stgit@notabene.brown> <20081124035530.3465.26724.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081124035530.3465.26724.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Doug Ledford <dledford@redhat.com>, Greg KH <greg@kroah.com>
List-Id: linux-raid.ids

(cc'ing Greg)

NeilBrown wrote:
> Currently md devices, once created, never disappear until the module
> is unloaded.  This is essentially because the gendisk holds a
> reference to the mddev, and the mddev holds a reference to the
> gendisk, this a circular reference.
> 
> If we drop the reference from mddev to gendisk, then we need to ensure
> that the mddev is destroyed when the gendisk is destroyed.  However it
> is not possible to hook into the gendisk destruction process to enable
> this.
> 
> So we drop the reference from the gendisk to the mddev and destroy the
> gendisk when the mddev gets destroyed.  However this has a
> complication.
> Between the call
>    __blkdev_get->get_gendisk->kobj_lookup->md_probe
> and the call
>    __blkdev_get->md_open
> 
> there is no obvious way to hold a reference on the mddev any more, so
> unless something is done, it will disappear and gendisk will be
> destroyed prematurely.
> 
> Also, once we decide to destroy the mddev, there will be an unlockable
> moment before the gendisk is unlinked (blk_unregister_region) during
> which a new reference to the gendisk can be created.  We need to
> ensure that this reference can not be used.  i.e. the ->open must
> fail.

Ah... I'm not really sure I'm following all of this correctly but would
it be possible to just add ->release to genhd and do regular reference
counting rather than this complex dancing?  ->release was recently added
to cdev so it'll be nicely parallel.

Thanks.

-- 
tejun
