From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md ] Fix BUG in raid5 resync code.
Date: Fri, 4 Jun 2004 22:04:53 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16576.25957.792182.211940@cse.unsw.edu.au>
References: <20040604165208.8646.patches@notabene>
	<E1BW8c2-0002Fs-EL@notabene.cse.unsw.edu.au>
	<40C02083.9050202@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Friday June 4
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 4, david@dgreaves.com wrote:
> Hi Neil
> 
> Given I'm about to resync about 400Gb of data I'd like to check this 
> before blindly storming ahead... :)
> 
> Would the following be the correct patch against 2.6.6?

Yes. Remove the "+failed".

NeilBrown

> 
> --- drivers/md/raid5.c~ 2004-05-30 18:38:49.000000000 +0100
> +++ drivers/md/raid5.c  2004-06-04 09:06:12.000000000 +0100
> @@ -1037,7 +1037,7 @@
>          * parity, or to satisfy requests
>          * or to load a block that is being partially written.
>          */
> -       if (to_read || non_overwrite || (syncing && (uptodate+failed < 
> disks))) {
> +       if (to_read || non_overwrite || (syncing && (uptodate < disks))) {
>                 for (i=disks; i--;) {
>                         dev = &sh->dev[i];
>                         if (!test_bit(R5_LOCKED, &dev->flags) && 
> !test_bit(R5_UPTODATE, &dev->flags) &&
> c
> 
