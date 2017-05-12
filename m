From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: Re: [PATCH v2] raid1: prefer disk without bad blocks
Date: Fri, 12 May 2017 14:23:58 +0200
Message-ID: <20170512122358.GA5359@proton.igk.intel.com>
References: <1494413599-8749-1-git-send-email-tomasz.majchrzak@intel.com>
 <1494422180-22772-1-git-send-email-tomasz.majchrzak@intel.com>
 <20170510195701.dvrp52cwdyvampev@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170510195701.dvrp52cwdyvampev@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 10, 2017 at 12:57:01PM -0700, Shaohua Li wrote:
> > ---
> >  drivers/md/raid1.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > v2:
> >   updated the title not to include internal defect number :)
> > 
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index a1f3fbe..e7ab3bb 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -628,8 +628,11 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
> >  					break;
> >  			}
> >  			continue;
> > -		} else
> > +		} else {
> > +			if ((sectors > best_good_sectors) && (best_disk >= 0))
> > +				best_disk = disk;
> 
> best_disk = -1 seems better here to me. If this is the only disk, we will
> choose in below 'if (best_disk == -1)' check. If there are more disks which
> cover the whole range, we will choose the best disk with minimum seek/pending.
>
Agreed, it's a neater way to fix it. I'll send the patch.

Tomek
