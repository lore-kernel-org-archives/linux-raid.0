From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 03/36] md: don't allow arrays to contain devices with bad blocks.
Date: Sat, 23 Jul 2011 00:47:38 +0900
Message-ID: <87zkk648rp.fsf@gmail.com>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025847.8422.81361.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721025847.8422.81361.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:58:47 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> As no personality understand bad block lists yet, we must
> reject any device that is known to contain bad blocks.
> As the personalities get taught, these tests can be removed.
>
> This only applies to raid1/raid5/raid10.
> For linear/raid0/multipath/faulty the whole concept of bad blocks
> doesn't mean anything so there is no point adding the checks.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>
