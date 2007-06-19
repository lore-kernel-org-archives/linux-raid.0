From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH git-md-accel 1/2] raid5: refactor handle_stripe5 and handle_stripe6
Date: Mon, 18 Jun 2007 17:53:38 -0700
Message-ID: <e9c3a7c20706181753x506af4daue8b3f530da3a0817@mail.gmail.com>
References: <20070618210546.19865.7170.stgit@dwillia2-linux.ch.intel.com>
	 <20070618210724.19865.94357.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070618210724.19865.94357.stgit@dwillia2-linux.ch.intel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/18/07, Dan Williams <dan.j.williams@intel.com> wrote:
...
> +static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
> +                               struct r6_state *r6s)
> +{
> +       int i;
> +
> +       /* We have read all the blocks in this stripe and now we need to
> +        * copy some of them into a target stripe for expand.
> +        */
> +       clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
> +       for (i = 0; i < sh->disks; i++)
> +               if (i != sh->pd_idx && (r6s && i != r6s->qd_idx)) {
> +                       int dd_idx, pd_idx, j;
> +                       struct stripe_head *sh2;
> +
> +                       sector_t bn = compute_blocknr(sh, i);
> +                       sector_t s = raid5_compute_sector(bn, conf->raid_disks,
> +                                               conf->raid_disks-1, &dd_idx,
> +                                               &pd_idx, conf);
this bug made it through the regression test:

'conf->raid_disks-1' should be 'conf->raid_disks - conf->max_degraded'

--
Dan
