From: Yuri Tikhonov <yur@emcraft.com>
Subject: Fwd: Re: md raid acceleration and the async_tx api
Date: Fri, 31 Aug 2007 14:15:23 +0400
Message-ID: <200708311415.23623.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 Hi Dan,

On Thursday 30 August 2007 23:34, you wrote:
...

> Looking at it again I see that what I added would not affect the
> failure you are seeing.  However I noticed that you are using a broken
> version of the stripe-queue and cache_arbiter patches.  In the current
> revisions the dev_q->flags field has been moved back to dev->flags
> which fixes a data corruption issue and could potentially address the
> hang you are seeing.

 Thank you for pointing this.

 Though I do not think that this addresses the hang-up I see since I did run
the similar tests using your even older "h/w accelerated RAID-5" patch-set
(with no queues) and observed the same hang-up too.

> The latest revisions are:
> raid5: add the stripe_queue object for tracking raid io requests (rev2)
> raid5: use stripe_queues to prioritize the "most deserving" requests (rev6)
>
> >  Note that before applying your patch I rolled my fix in the
> > ops_complete_biofill() function back. Do I understand it right that your
> > patch should be used *instead* of my one rather than *with* it ?
>
> You understood correctly.  The attached patch integrates your change
> to keep R5_Wantfill set while also protecting the 'more_to_read' case.
>  Please try it on top of the latest stripe-queue changes [1] (instead
> of the other proposed patches) .

 I've successfully run the patched RAID-5 driver on my h/w setup: no hang-ups
were observed.

 Note that I still used the broken version of the stripe-queue (so I'd
 adapted your patch a little). As soon as I upgrade my stripe-queue and
 cache_arbiter patches up to your latest version I'll retest the bonnie++
 hang-up and report about the results.

 One question, I cannot find the corresponding patches in your
git://lost.foo-projects.org/~dwillia2/git/iop tree, so, is it right that the
latest revision of the the stripe-queue and cache_arbiter patches you posted
here were on 22/07/07:
[GIT PATCH 0/2] stripe-queue for 2.6.23 consideration
[GIT PATCH 1/2] raid5: add the stripe_queue object for tracking raid io
requests (take2)
[GIT PATCH 2/2] raid5: use stripe_queues to prioritize the "most deserving"
requests (take4)
 ?

 Regards, Yuri

