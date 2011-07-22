From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 18/34] md/raid5: move more common code into handle_stripe
Date: Fri, 22 Jul 2011 18:20:02 +0900
Message-ID: <87pql2pt8d.fsf@gmail.com>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023226.6728.76228.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721023226.6728.76228.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:32:26 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> Apart from 'prexor' which can only be set for RAID5, and
> 'qd_idx' which can only be meaningful for RAID6, these two
> chunks of code are nearly the same.
>
> So combine them into one adding a test to call either
> handle_parity_checks5 or handle_parity_checks6 as appropriate.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>
