From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: make suspend range wait timed out
Date: Fri, 16 Jun 2017 08:52:04 -0700
Message-ID: <20170616155204.myffyxp5tuoctcoo@kernel.org>
References: <d95473d287e196a86a83390cb9c136913643bd61.1497037210.git.shli@fb.com>
 <877f0c7gvr.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877f0c7gvr.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: linux-raid.ids

On Fri, Jun 16, 2017 at 01:26:00PM +1000, Neil Brown wrote:
> On Fri, Jun 09 2017, Shaohua Li wrote:
> 
> > From: Shaohua Li <shli@fb.com>
> >
> > suspend range is controlled by userspace. If userspace doesn't clear suspend
> > range, it's possible a thread will wait for the range forever, we can't even
> > kill it. This is bad behavior. Add a timeout in the wait. If timeout happens,
> > we return IO error. The app controlling suspend range looks like part of disk
> > firmware, if disk isn't responded for a long time, timed out IO error is
> > returned.
> >
> > A simple search in SCSI code shows maximum IO timeout is 120s, so I use this
> > value here too.
> 
> I really don't like this.  It is an API change with no really
> justification.  Has the current behavior caused a problem?

This centainly causes problem. Set the suspend range will make application
stall for ever, don't you think this is a problem?

> Both md and dm export  APIs which allow IO to be suspended while
> changes are made.  Changing that to a timed-out period needs, I think,
> to be clearly justified.
> 
> If it is changed to a timed-out period, then that should be explicit,
> rather than having each request independently time out.
> i.e. when the suspend is initiated, the end-time should be computed, and
> any IO would block until that time, not block for some number of
> seconds.

Ok, this makes sense. We can add a timeout. If it's expired, we clear suspend
range. Userspace should know what they are doing.

> 
> If an md device is left suspended, then the current code will block IO
> indefinitely.  This patch will at a 20minute times to every single
> request, which will mean IO proceeds, but extremely slowly.  I don't see
> that as a useful improvement.

It returns error, so application will not dispatch more IO. But I agree a
timeout to clear the suspend looks a better policy.

Thanks,
Shaohua
