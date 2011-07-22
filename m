From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 15/34] md/raid5: rearrange a test in fetch_block6.
Date: Fri, 22 Jul 2011 16:37:00 +0900
Message-ID: <87mxg6daw3.fsf@gmail.com>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023226.6728.14782.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721023226.6728.14782.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:32:26 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> Next patch will unite fetch_block5 and fetch_block6.
> First I want to make the differences a little more clear.
>
> For RAID6 if we are writing at all and there is a failed device, then
> we need to load or compute every block so we can do a
> reconstruct-write.
> This case isn't needed for RAID5 - we will do a read-modify-write in
> that case.
> So make that test a separate test in fetch_block6 rather than merged
> with two other tests.
>
> Make a similar change in fetch_block5 so the one bit that is not
> needed for RAID6 is clearly separate.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>
