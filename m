From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: feature re-quest for "re-write"
Date: Mon, 24 Feb 2014 10:24:36 +0800
Message-ID: <530AAD64.4030701@fnarfbargle.com>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/02/14 02:09, Mikael Abrahamsson wrote:
>
> Hi,
>
> we have "check", "repair", "replacement" and other operations on raid
> volumes.
>
> I am not a programmer, but I was wondering how much work it would
> require to take current code and implement "rewrite", basically
> re-writing every block in the md raid level. Since "repair" and "check"
> doesn't seem to properly detect a few errors, wouldn't it make sense to
> try least existance / easiest implementation route to just re-write all
> data on the entire array? If reads fail, re-calculate from parity, if
> reads work, just write again.

Now, this is after 3 minutes of looking at raid5.c, so if I've missed 
something obvious please feel free to yell at me. I'm not much of a 
programmer. Having said that -

Can someone check my understanding of this bit of code?

static void handle_parity_checks6(struct r5conf *conf, struct 
stripe_head *sh,
                                   struct stripe_head_state *s,
                                   int disks)
<....>

         switch (sh->check_state) {
         case check_state_idle:
                 /* start a new check operation if there are < 2 failures */
                 if (s->failed == s->q_failed) {
                         /* The only possible failed device holds Q, so it
                          * makes sense to check P (If anything else 
were failed,
                          * we would have used P to recreate it).
                          */
                         sh->check_state = check_state_run;
                 }
                 if (!s->q_failed && s->failed < 2) {
                         /* Q is not failed, and we didn't use it to 
generate
                          * anything, so it makes sense to check it
                          */
                         if (sh->check_state == check_state_run)
                                 sh->check_state = check_state_run_pq;
                         else
                                 sh->check_state = check_state_run_q;
                 }


So we get passed a stripe. If it's not being checked we :

- If Q has failed we initiate check_state_run (which checks only P)

- If we have less than 2 failed drives (lets say we have none), if we 
are already checking P (check_state_run) we upgrade that to 
check_state_run_pq (and therefore check both).

However

- If we were check_state_idle, beacuse we had 0 failed drives, then we 
only mark check_state_run_q and therefore skip checking P ??

Regards,
Brad
