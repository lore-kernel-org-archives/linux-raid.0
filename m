From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 1/2] md/raid5: Add change_consistency_policy to raid4
 and raid6
Date: Fri, 24 Mar 2017 10:08:59 -0700
Message-ID: <20170324170859.fkbyn5ruqy7xyf5q@kernel.org>
References: <20170316221409.3283344-1-songliubraving@fb.com>
 <20170324144535.chk4jgktism4mvlu@kernel.org>
 <8acaaf1e-7e67-2c9b-fc1f-7c9237131260@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8acaaf1e-7e67-2c9b-fc1f-7c9237131260@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On Fri, Mar 24, 2017 at 04:17:16PM +0100, Artur Paszkiewicz wrote:
> On 03/24/2017 03:45 PM, Shaohua Li wrote:
> > On Thu, Mar 16, 2017 at 03:14:08PM -0700, Song Liu wrote:
> >> Add change_consistency_policy to raid6_personality and
> >> raid4_personality.
> >>
> >> Signed-off-by: Song Liu <songliubraving@fb.com>
> >> ---
> >>  drivers/md/raid5.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index 88cc898..7a6e7ea 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -8408,6 +8408,7 @@ static struct md_personality raid6_personality =
> >>  	.quiesce	= raid5_quiesce,
> >>  	.takeover	= raid6_takeover,
> >>  	.congested	= raid5_congested,
> >> +	.change_consistency_policy = raid5_change_consistency_policy,
> >>  };
> >>  static struct md_personality raid5_personality =
> >>  {
> >> @@ -8456,6 +8457,7 @@ static struct md_personality raid4_personality =
> >>  	.quiesce	= raid5_quiesce,
> >>  	.takeover	= raid4_takeover,
> >>  	.congested	= raid5_congested,
> >> +	.change_consistency_policy = raid5_change_consistency_policy,
> >>  };
> > sorry for the late reply.
> > 
> > the change_consistency_policy is only for raid5 for a reason, ppl is only for
> > raid5. I think you need to filter out raid 4/6 in
> > raid5_change_consistency_policy for ppl.
> 
> Not necessarily. There is a check in ppl_init_log() that won't allow
> starting ppl if it's not raid5. But it certainly wouldn't hurt.

It will still set the PPL flag for raid4/6. Checking raid 5 in
change_consistency_policy is clearer anyway.

Thanks,
Shaohua
