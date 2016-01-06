From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 3/4] raid5-cache: handle flush request for journal hotadd
Date: Tue, 5 Jan 2016 17:47:05 -0800
Message-ID: <20160106014704.GA4056779@devbig084.prn1.facebook.com>
References: <cover.1452028077.git.shli@fb.com>
 <7b8a15be93941a393a5a08232659fef9ead4610b.1452028077.git.shli@fb.com>
 <87d1tfy0ii.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87d1tfy0ii.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com
List-Id: linux-raid.ids

On Wed, Jan 06, 2016 at 12:12:05PM +1100, NeilBrown wrote:
> On Wed, Jan 06 2016, Shaohua Li wrote:
> 
> > When we hotadd journal for array which isn't created with journal, the
> > array might be running write requests. Such writes aren't protected by
> > journal yet, so we can't skip disk flush. There is no easy way to know
> > when all such writes are finished, but the time should be enough after
> > reclaim runs once.
> 
> There is an easy way to know when such writes are finished.
> Call mddev_suspend(mddev).  This is used for the more intrusive
> reconfiguration such as initiating a reshape.
> I think it would be perfectly appropriate to
>   call mddev_suspend()
>   attach the journal
>   call mddev_resume()

hot add/remove disk is called in raid5d, we can't wait IO there.
mddev_suspend() will wait IO. So we can't call mddev_suspend()

Thanks,
Shaohua
