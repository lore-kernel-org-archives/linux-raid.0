From: jes.sorensen@gmail.com
Subject: Re: [PATCHv2 1/2] super1: ignore failfast flag for setting device role
Date: Tue, 28 Mar 2017 14:01:58 -0400
Message-ID: <wrfjd1d1gu09.fsf@gmail.com>
References: <1490003517-4216-1-git-send-email-gi-oh.kim@profitbricks.com>
        <1490003517-4216-2-git-send-email-gi-oh.kim@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490003517-4216-2-git-send-email-gi-oh.kim@profitbricks.com>
        (Gioh Kim's message of "Mon, 20 Mar 2017 10:51:56 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids

Gioh Kim <gi-oh.kim@profitbricks.com> writes:
> There is corner case for setting device role,
> if new device has failfast flag.
> The failfast flag should be ignored.
>
> Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
> Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> ---
>  super1.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Applied!

Ideally I would like to get rid of the hardcoded values and use the bit
defines instead, but the original code did the same, so I am going to
take it.

I am leaving out the second patch for now, per Neil's comments. If you
feel strongly about it, please conveince Neil first :)

Thanks,
Jes
