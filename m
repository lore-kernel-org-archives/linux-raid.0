From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 07/34] md/raid5: Protect some more code with ->device_lock.
Date: Fri, 22 Jul 2011 12:54:01 +0900
Message-ID: <87livrdl7q.fsf@gmail.com>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023225.6728.43609.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721023225.6728.43609.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:32:25 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> Other places that change or follow dev->towrite and dev->written take
> the device_lock as well as the sh->lock.
> So it should really be held in these places too.
> Also, doing so will allow sh->lock to be discarded.
>
> with merged fixes by: Namhyung Kim <namhyung@gmail.com>
>
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>
