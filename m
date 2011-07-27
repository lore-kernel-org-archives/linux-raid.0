From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 11/36] md/raid1: clear bad-block record when write succeeds.
Date: Wed, 27 Jul 2011 14:05:33 +0900
Message-ID: <87oc0ggvoi.fsf@gmail.com>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025848.8422.11955.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721025848.8422.11955.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:58:48 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> If we succeed in writing to a block that was recorded as
> being bad, we clear the bad-block record.
>
> This requires some delayed handling as the bad-block-list update has
> to happen in process-context.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>
