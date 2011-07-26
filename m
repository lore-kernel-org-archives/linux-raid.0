From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 08/36] md: add 'write_error' flag to component devices.
Date: Wed, 27 Jul 2011 00:22:17 +0900
Message-ID: <87pqkxdq3a.fsf@gmail.com>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025848.8422.63231.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721025848.8422.63231.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:58:48 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> If a device has ever seen a write error, we will want to handle
> known-bad-blocks differently.
> So create an appropriate state flag and export it via sysfs.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>

but it looks like documentation update is needed too
(probably can be squashed to next patch 09/36).
