From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/5] misc cleanups for RAID5
Date: Thu, 23 Jun 2011 10:55:54 +1000
Message-ID: <20110623105554.19c5fe09@notabene.brown>
References: <1308718230-2536-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308718230-2536-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 22 Jun 2011 13:50:25 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> Hello,
> 
> These are assorted cleanup patches for RAID5 code.
> Please take a look. Any comments are welcomed.
> 
> Thanks.
> 
> 
> Namhyung Kim (5):
>   md/raid5: use kmem_cache_zalloc()
>   md/raid5: factor out dev_need_read()
>   md/raid5: factor out dev_need_for_write()
>   md/raid5: use r5_for_each_bio()
>   md/raid5: get rid of duplicated call to bio_data_dir()
> 
>  drivers/md/raid5.c |  146 ++++++++++++++++++++++++++--------------------------
>  1 files changed, 73 insertions(+), 73 deletions(-)
> 

Hi,
 thanks for these.

 I have applied the first and the last.

 The two "factor out" patches conflict with some much more substantial
 refactoring I have been doing in raid5.c.  I have just pushed all of that
 into my for-next branch:

      git://neil.brown.name/md for-next

 so you can use that as a basis for any further review.

 The r5_for_each_bio() patch I'm not 100% sure I'm happy with, and in any
 case it would have conflicted with my other changes too.
 I'm not fond of macros that hide details that could be important. A
 "for_each" macro that purely and simply walks through a list is fine.  A
 "for_each" macro that does anything more complicated I start to have doubts
 about...
 However if you really do like it and want to rebase it on the for-next
 branch I'll have another look and think harder about it.   Maybe I'll end up
 liking it after all, but no promises.

Thanks,
NeilBrown

