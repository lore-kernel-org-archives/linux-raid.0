From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 12/36] md/raid1: store behind-write pages in bi_vecs.
Date: Thu, 28 Jul 2011 00:16:56 +0900
Message-ID: <87mxfzn47r.fsf@gmail.com>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025848.8422.51169.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721025848.8422.51169.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:58:48 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> When performing write-behind we allocate pages to store the data
> during write.
> Previously we just keep a list of pages.  Now we keep a list of
> bi_vec which includes offset and size.
> This means that the r1bio has complete information to create a new
> bio which will be needed for retrying after write errors.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>
