From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 15/36] md/raid1: improve handling of read failure during recovery.
Date: Thu, 28 Jul 2011 00:45:15 +0900
Message-ID: <87aabzn2wk.fsf@gmail.com>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025848.8422.18207.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721025848.8422.18207.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:58:49 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> If we cannot read a block from anywhere during recovery, there is
> now a better approach than just giving up.
> We can record a bad block on each device and keep going - being
> careful not to clear the bad block when a write succeeds as it might -
> it will be a write of incorrect data.
>
> We have now reached the state where - for raid1 - we only call
> md_error if md_set_badblocks has failed.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>
