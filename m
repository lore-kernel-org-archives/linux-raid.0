From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 13/36] md/raid1: Handle write errors by updating badblock log.
Date: Thu, 28 Jul 2011 00:28:57 +0900
Message-ID: <87ipqnn3nq.fsf@gmail.com>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025848.8422.78654.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721025848.8422.78654.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:58:48 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> When we get a write error (in the data area, not in metadata),
> update the badblock log rather than failing the whole device.
>
> As the write may well be many blocks, we trying writing each
> block individually and only log the ones which fail.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>
