From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: using the raid6check report
Date: Mon, 9 Jan 2017 13:13:39 +1100
Message-ID: <f364997c-af1a-d0d3-a6de-3eabe50e3428@eyal.emu.id.au>
References: <14e8ec23-de4a-e90b-4b67-155e5e3cc228@eyal.emu.id.au>
 <20170108174010.GA3699@lazy.lzy> <5872A698.7000009@youngman.org.uk>
 <20170108214111.GA7933@lazy.lzy> <87pojxjhwt.fsf@notabene.neil.brown.name>
 <62f5d174-0aef-5a70-68c3-26f7763b5e61@eyal.emu.id.au>
 <87h959j8ss.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h959j8ss.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/01/17 12:56, NeilBrown wrote:
> On Mon, Jan 09 2017, Eyal Lebedinsky wrote:
>
>>
>> I am aware of that discussion and agree with the sentiment (fix in user space).
>
> (I primarily provided for the information of others)
>
>> What I miss is a message from md when a 'check' mismatch is found. Not having
>> this means I have to run 'raid6check', then after looking at the situation
>> run 'raid6check autorepair' in the small sections reported as bad. This is time
>> consuming and risky.
>
> Something like this?
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 69b0a169e43d..f19c38baf2b2 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2738,6 +2738,8 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
>  			conf->mddev->resync_mismatches += STRIPE_SECTORS;
>  			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
>  				/* don't try to repair!! */
> +				pr_debug("%s: \"check\" found inconsistency near sector %llu\n",
> +					 md_name(conf->mddev), sh->sector);
>  				set_bit(STRIPE_INSYNC, &sh->state);
>  			else {
>  				sh->check_state = check_state_compute_run;
>
>
> I chose pr_debug() because I didn't want to flood the logs if there are
> lots of inconsistencies.
> You can selectively enable pr_debug() messages by writing to
> /sys/kernel/debug/dynamic_debug/control
> providing you have dynamic debugging compiled in.

I run fedora and can see the dynamic debugging control file.

> Maybe use pr_info_ratelimited() instead??

Yes, rate limiting is probably a good idea when we have a really bad day.

> NeilBrown

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
