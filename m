From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 17/34] md/raid5: unite handle_stripe_dirtying5 and handle_stripe_dirtying6
Date: Fri, 22 Jul 2011 18:10:33 +0900
Message-ID: <87tyaepto6.fsf@gmail.com>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023226.6728.28082.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721023226.6728.28082.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:32:26 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> RAID6 is only allowed to choose 'reconstruct-write' while RAID5 is
> also allow 'read-modify-write'
> Apart from this difference, handle_stripe_dirtying[56] are nearly
> identical.  So resolve these differences and create just one function.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>

BTW, here is a question:
  Why RAID6 doesn't allow the read-modify-write? I don't think it is
  not possible, so what prevents doing that? performance? complexity?
  or it's not possible? Why? :)
