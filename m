From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 07/36] md/raid1: avoid reading known bad blocks during resync
Date: Tue, 26 Jul 2011 23:25:10 +0900
Message-ID: <87tya9dsqh.fsf@gmail.com>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025848.8422.55863.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721025848.8422.55863.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:58:48 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> When performing resync/etc, keep the size of the request
> small enough that it doesn't overlap any known bad blocks.
> Devices with badblocks at the start of the request are completely
> excluded.
> If there is nowhere to read from due to bad blocks, record
> a bad block on each target device.
>
> Now that we never read from known-bad-blocks we can allow devices with
> known-bad-blocks into a RAID1.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>
