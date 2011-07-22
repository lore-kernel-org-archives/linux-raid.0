From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 16/34] md/raid5: unite fetch_block5 and fetch_block6
Date: Fri, 22 Jul 2011 17:24:22 +0900
Message-ID: <87ipqud8p5.fsf@gmail.com>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023226.6728.42897.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721023226.6728.42897.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:32:26 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> Provided that ->failed_num[1] is not a valid device number (which is
> easily achieved) fetch_block6 provides all the functionality of
> fetch_block5.
>
> So remove the latter and rename the former to simply "fetch_block".
>
> Then handle_stripe_fill5 and handle_stripe_fill6 become the same and
> can similarly be united.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>
