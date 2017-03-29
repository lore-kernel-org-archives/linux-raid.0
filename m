From: jes.sorensen@gmail.com
Subject: Re: [PATCH 1/2] super1: replace hard-coded values with bit definitions
Date: Wed, 29 Mar 2017 11:41:39 -0400
Message-ID: <wrfjtw6cdr9o.fsf@gmail.com>
References: <1490780434-8720-1-git-send-email-gi-oh.kim@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490780434-8720-1-git-send-email-gi-oh.kim@profitbricks.com>
        (Gioh Kim's message of "Wed, 29 Mar 2017 11:40:33 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Gioh Kim <gi-oh.kim@profitbricks.com> writes:
> Some hard-coded values for disk status are replaced
> with bit definitions.
>
> Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
> ---
>  super1.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Applied!

Please use --cover-letter when you send out multi-commit patch sets,
which includes a short description of what the set includes. That way I
can just respond to the cover letter if all the patches are applied.

Thanks,
Jes
