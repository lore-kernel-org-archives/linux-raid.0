From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 02/36] md/bad-block-log: add sysfs interface for
 accessing bad-block-log.
Date: Wed, 27 Jul 2011 11:05:46 +1000
Message-ID: <20110727110546.204d5dcf@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025847.8422.8246.stgit@notabene.brown>
	<87livlxw9w.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87livlxw9w.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 26 Jul 2011 17:48:27 +0900 Namhyung Kim <namhyung@gmail.com> wrote:


> Empty line in comment.
> 
> And you might need this as well:

Thanks.  I've added the patch.

> (or maybe it should be located somewhere in Documentation/ABI/)

Yes... maybe...  I wonder who reads that ....

Thanks,
NeilBrown



> 
> >From 95c3f191bd0cbe6d339fced75656502b2d591fe4 Mon Sep 17 00:00:00 2001
> From: Namhyung Kim <namhyung@gmail.com>
> Date: Tue, 26 Jul 2011 17:39:52 +0900
> Subject: [PATCH] md: add documentation for bad block log
> 
> Previous patch in the bad block series added new sysfs interfaces
> ([unacknowledged_]bad_blocks) for each rdev without documentation.
> Add it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  Documentation/md.txt |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/md.txt b/Documentation/md.txt
> index f0eee83ff78a..be88a24b8584 100644
> --- a/Documentation/md.txt
> +++ b/Documentation/md.txt
> @@ -562,6 +562,20 @@ also have
>       that number to reach sync_max.  Then you can either increase
>       "sync_max", or can write 'idle' to "sync_action".
>  
> +   bad_blocks
> +     This gives the list of all known bad blocks in the form of
> +     start address and length (in sectors respectively). If output
> +     is too big to fit in a page, it will be truncated. Writing
> +     "sector length" to this file will add new acknowledged (i.e.
> +     saved to disk safely) bad blocks.
> +
> +   unacknowledged_bad_blocks
> +     This gives the list of known-but-not-yet-saved-to-disk bad
> +     blocks in the same form of 'bad_blocks'. If output is too big
> +     to fit in a page, it will be truncated. Writing to this file
> +     adds bad blocks without acknowledging them. This is largely
> +     for testing.
> +
>  
>  Each active md device may also have attributes specific to the
>  personality module that manages it.

