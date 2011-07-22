From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 06/34] md/raid5: Remove use of sh->lock in sync_request
Date: Fri, 22 Jul 2011 12:39:54 +0900
Message-ID: <87pql3dlv9.fsf@gmail.com>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023225.6728.58904.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721023225.6728.58904.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:32:25 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> This is the start of a series of patches to remove sh->lock.
>
> sync_request takes sh->lock before setting STRIPE_SYNCING to ensure
> there is no race with testing it in handle_stripe[56].
>
> Instead, use a new flag STRIPE_SYNC_REQUESTED and test it early
> in handle_stripe[56] (after getting the same lock) and perform the
> same set/clear operations if it was set.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>
