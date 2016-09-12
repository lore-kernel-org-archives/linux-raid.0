From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v3] mdadm: fix a buffer overflow
Date: Mon, 12 Sep 2016 12:51:55 -0400
Message-ID: <wrfj8tuxgixg.fsf@redhat.com>
References: <1473358867-4114379-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1473358867-4114379-1-git-send-email-songliubraving@fb.com> (Song
        Liu's message of "Thu, 8 Sep 2016 11:21:07 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com
List-Id: linux-raid.ids

Song Liu <songliubraving@fb.com> writes:
> struct mdp_superblock_1.set_name is 32B long, but struct mdinfo.name
> is 33B long. So we need strncpy instead strcpy to avoid buffer
> overflow.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  super1.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied thanks!

Note there is at least one place with a str operation hardcoding the
length of set_name to 32. Would you mind fixing that too?

Cheers,
Jes
