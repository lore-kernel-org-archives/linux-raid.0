From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 09/34] md/raid5: move common code into handle_stripe
Date: Fri, 22 Jul 2011 13:30:06 +0900
Message-ID: <87d3h3djjl.fsf@gmail.com>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023225.6728.48548.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721023225.6728.48548.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:32:25 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> There is common code at the start of handle_stripe5 and
> handle_stripe6.  Move it into handle_stripe.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>
