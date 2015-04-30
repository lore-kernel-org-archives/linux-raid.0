From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [PATCH 1/2] md/raid5: fix typo
Date: Thu, 30 Apr 2015 15:22:40 +0800
Message-ID: <20150430072240.GA3858@yliu-dev.sh.intel.com>
References: <1430377277-6167-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20150430171426.46d03aa1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150430171426.46d03aa1@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 30, 2015 at 05:14:26PM +1000, NeilBrown wrote:
> On Thu, 30 Apr 2015 15:01:16 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
> wrote:
> 
> > bion -> bios
> > 
> > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > ---
> >  drivers/md/raid5.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 697d77a..2651bda 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -2919,7 +2919,7 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
> >  }
> >  
> >  /*
> > - * Each stripe/dev can have one or more bion attached.
> > + * Each stripe/dev can have one or more bios attached.
> >   * toread/towrite point to the first in a chain.
> >   * The bi_next chain must be in order.
> >   */
> 
> That was intentional.  "bios" as a plural looks too much like "BIOS" which is
> in the ROM of computers.
> 
> Children and oxen are plurals with an 'n' at the end.  So I used 'bion'.
> Private joke?

Interesting.

> 
> I'd rather leave it as it is.

Okay, and sorry for the noise.

	--yliu
