From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/2 v6] loop: Limit the number of requests in the bio list
Date: Fri, 30 Nov 2012 08:57:23 -0500
Message-ID: <x49txs7p518.fsf@segfault.boston.devel.redhat.com>
References: <1354272161-9173-1-git-send-email-lczerner@redhat.com>
	<1354272161-9173-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1354272161-9173-2-git-send-email-lczerner@redhat.com> (Lukas
	Czerner's message of "Fri, 30 Nov 2012 11:42:41 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk, akpm@linux-foundation.org
List-Id: linux-raid.ids

Lukas Czerner <lczerner@redhat.com> writes:

> Currently there is not limitation of number of requests in the loop bio
> list. This can lead into some nasty situations when the caller spawns
> tons of bio requests taking huge amount of memory. This is even more
> obvious with discard where blkdev_issue_discard() will submit all bios
> for the range and wait for them to finish afterwards. On really big loop
> devices and slow backing file system this can lead to OOM situation as
> reported by Dave Chinner.
>
> With this patch we will wait in loop_make_request() if the number of
> bios in the loop bio list would exceed 'nr_congestion_on'.
> We'll wake up the process as we process the bios form the list. Some
> threshold hysteresis is in place to avoid high frequency oscillation.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Dave Chinner <dchinner@redhat.com>

Lukas, please carry forward acked-by tags when there is no change so I
don't have to keep acking.

Thanks,
Jeff

Acked-by: Jeff Moyer <jmoyer@redhat.com>
