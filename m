From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 14/36] md/raid1: record badblocks found during resync etc.
Date: Thu, 28 Jul 2011 00:39:36 +0900
Message-ID: <87ei1bn35z.fsf@gmail.com>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025848.8422.35737.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721025848.8422.35737.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:58:48 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> If we find a bad block while writing as part of resync/recovery we
> need to report that back to raid1d which must record the bad block,
> or fail the device.
>
> Similarly when fixing a read error, a further error should just
> record a bad block if possible rather than failing the device.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>
