From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] super1: make write_bitmap1 compatible with previous mdadm versions
Date: Wed, 19 Oct 2016 11:21:31 -0400
Message-ID: <wrfj7f94weis.fsf@redhat.com>
References: <1476253447-19865-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1476253447-19865-1-git-send-email-gqjiang@suse.com> (Guoqing
        Jiang's message of "Wed, 12 Oct 2016 02:24:07 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.com>
List-Id: linux-raid.ids

Guoqing Jiang <gqjiang@suse.com> writes:
> For older mdadm version, v1.x metadata has different bitmap_offset,
> we can't ensure all the bitmaps are on a 4K boundary since writing
> 4K for bitmap could corrupt the superblock, and Anthony reported
> the bug about it at below link.
>
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=837964
>
> So let's check about the alignment for bitmap_offset before set
> the boundary to 4096 unconditionally. Thanks for Neil's detailed
> explanation.
>
> Reported-by: Anthony DeRobertis <anthony@derobert.net>
> Fixes: 95a05b37e8eb ("Create n bitmaps for clustered mode")
> Cc: Neil Brown <neilb@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  super1.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

Applied!

Thanks,
Jes
