From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Re[2]: [PATCH 07/11] md: rewrite handle_stripe_dirtying6 in
	asynchronous way
Date: Fri, 16 Jan 2009 11:39:54 -0700
Message-ID: <e9c3a7c20901161039t1ad9d8dawaf7fb9823583db49@mail.gmail.com>
References: <200812090057.33890.yur@emcraft.com>
	 <e9c3a7c20901151351p5e1b4641h1b4c8ba1ae5dcc73@mail.gmail.com>
	 <e9c3a7c20901151421o69522f71rfe6d7d9621de47eb@mail.gmail.com>
	 <1141743016.20090116172403@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1141743016.20090116172403@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

On Fri, Jan 16, 2009 at 7:24 AM, Yuri Tikhonov <yur@emcraft.com> wrote:
>> Ok, I now see why this change was made.  Please make this changelog
>> more descriptive than "Rewrite handle_stripe_dirtying6 function to
>> work asynchronously."
>
>  Sure, how about the following:
>
> "
>
>  md: rewrite handle_stripe_dirtying6 in asynchronous way
>
>  Processing stripe dirtying in asynchronous way requires some changes
> to the handle_stripe_dirtying6() algorithm.
>
>  In the synchronous implementation of the stripe dirtying we processed
> dirtying of a degraded stripe (with partially changed strip(s) located
> on the failed drive(s)) inside one handle_stripe_dirtying6() call:
> - we computed the missed strips from the old parities, and thus got
> the fully up-to-date stripe, then
> - we did reconstruction using the new data to write.
>
>  In the asynchronous case of handle_stripe_dirtying6() we don't
> process anything right inside this function (since we under the lock),
> but only schedule the necessary operations with flags. Thus, if
> handle_stripe_dirtying6() is performed on the top of a degraded array
> we should schedule the reconstruction operation when the failed strips
> are marked (by previously called fetch_block6()) as to be computed
> (with the R5_Wantcompute flag), and all the other strips of the stripe
> are UPTODATE. The schedule_reconstruction() function will set the
> STRIPE_OP_POSTXOR flag [for new parity calculation], which is then
> handled in raid_run_ops() after the STRIPE_OP_COMPUTE_BLK one [which
> causes computing of the data missed].
>
> "

Excellent!

Thanks,
Dan
