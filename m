From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 12/34] md/raid5: move stripe_head_state and more code into handle_stripe.
Date: Fri, 22 Jul 2011 14:41:40 +0900
Message-ID: <87zkk6dg8b.fsf@gmail.com>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023225.6728.26725.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721023225.6728.26725.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:32:26 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> By defining the 'stripe_head_state' in 'handle_stripe', we can move
> some common code out of handle_stripe[56]() and into handle_stripe.
>
> The means that all accesses for stripe_head_state in handle_stripe[56]
> need to be 's->' instead of 's.', but the compiler should inline
> those functions and just use a direct stack reference, and future
> patches while hoist most of this code up into handle_stripe()
> so we will revert to "s.".
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>
