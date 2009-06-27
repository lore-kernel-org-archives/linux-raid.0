From: "NeilBrown" <neilb@suse.de>
Subject: Re: Request on RAID5
Date: Sat, 27 Jun 2009 16:37:49 +1000 (EST)
Message-ID: <4081d197ccf40434a8cc6c7ecb08f875.squirrel@neil.brown.name>
References: <loom.20090627T051604-240@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20090627T051604-240@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: satha <satha_koti@yahoo.co.in>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, June 27, 2009 3:16 pm, satha wrote:
> Hi All,
>
>  Iam using 2.6.27 kernel. Connected 8 disks using Silicon Image and
> Marvell
> Rocket RAID PCIe express cards.
>
>  Can any one help me in debugging the following problem:
>
> There is a kernel bug detected in __get_priority_stripe()
> BUG_ON(atomic_read(&sh->count) != 1) while testing RAID5,
> writing morethan 20GB data using dd, several times.
>
> Is Iam missing any configurations, can anyone briefly explain what exactly
> this function doing.

The function chooses the next stripe that needs to be 'handled'.
It either takes one from 'handle list' - which are completely ready
to be handed, or from 'hold list' which are reluctantly ready to be
handled... but they would be happy to wait a bit longer in case some
more blocks were added to it.

Stripes are only every added to handle_list or  delay_list when
their ->count is zero.  They only get on to hold_list straight
off delay_list, and they only ever have their ->count increment when
either:
  it is already non-zero or
  the stripe has just been removed from any list.

So that BUG cannot possibly happen :-)

Is it repeatable at all?   If there any chance of bad memory?

NeilBrown


