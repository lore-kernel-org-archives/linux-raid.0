From: David Wahler <dwahler@gmail.com>
Subject: Re: BUG?: RAID6 reshape hung in reshape_request
Date: Wed, 29 Apr 2015 19:33:27 -0500
Message-ID: <CAGivzjE=v06+R=-EDavp_4YTSeQAs9LATXKSym4xhLEAEUpGig@mail.gmail.com>
References: <CAGivzjGyifS3r0rypqM7n2P-fcA7NvPjJWa6kV_wfGx2biDrDg@mail.gmail.com>
 <20150427112056.7195d226@notabene.brown> <CAGivzjE4zVGpoUdGpgKR_e+EaiBE60R3Ta=o9mW+VFqO8McrrQ@mail.gmail.com>
 <CAGivzjHvk8pSUyWOMzNioNtgpQ7gRoL=hkTX0=m7Mi8KzgRWAg@mail.gmail.com>
 <20150427165926.6128d59b@notabene.brown> <CAGivzjF-5VWBzE0M9FB9BGpYeed=0rxNvKPzkZJdVbUAwbqyJA@mail.gmail.com>
 <20150429100339.5b0cf4f3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150429100339.5b0cf4f3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 28, 2015 at 7:03 PM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 27 Apr 2015 12:20:50 -0500 David Wahler <dwahler@gmail.com> wrote:
>>
>> I don't urgently need this array up and running, so I'm happy to leave
>> it in its current state for the next few days in case there's anything
>> else I can do to help track this down.
>
> Thanks for the various status data.
>
> I'm fairly easily able to reproduce the problem.  I clearly never thought
> about 'reshape' when I was writing the bad_block handling.
>
> You can allow the reshape to complete by the following hack:
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 77dfd720aaa0..e6c68a450d4c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4306,7 +4306,7 @@ static void handle_stripe(struct stripe_head *sh)
>          */
>         if (s.failed > conf->max_degraded) {
>                 sh->check_state = 0;
> -               sh->reconstruct_state = 0;
> +//             sh->reconstruct_state = 0;
>                 if (s.to_read+s.to_write+s.written)
>                         handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
>                 if (s.syncing + s.replacing)
>
> It may not necessarily do exactly the right thing, but it won't be too bad.

Yep, worked like a charm.

Running fsck afterwards found a dozen or so corrupted inodes. I'm not
sure whether that's because of the initial read failure that caused
the blocks to be marked as bad, or if it was aggravated by me
repeatedly interrupting the reshape.

Thanks again for the assistance.

-- David
