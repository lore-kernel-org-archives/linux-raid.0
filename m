From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 0/2] Fix RCW bug and allow degraded raid6 do rmw
Date: Sun, 2 Aug 2020 23:55:08 -0700
Message-ID: <CAPhsuW72=Mh8v2oYwcftyjescPi06tOt4XZJXebPvnKF+Ok1-Q@mail.gmail.com>
References: <1596188998-2994-1-git-send-email-allenpeng@synology.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1596188998-2994-1-git-send-email-allenpeng@synology.com>
Sender: linux-raid-owner@vger.kernel.org
To: allenpeng <allenpeng@synology.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jul 31, 2020 at 2:56 AM allenpeng <allenpeng@synology.com> wrote:
>
> From: ChangSyun Peng <allenpeng@synology.com>
>
> This patch fix io stuck in force reconstruct-write degraded raid5
> problem and allow degraded raid6 do rmw.
>
> ChangSyun Peng (2):
>   md/raid5: Fix Force reconstruct-write io stuck in degraded raid5
>   md/raid5: Allow degraded raid6 to do rmw

Thanks for the patches. Applied to md-next.

>
>  drivers/md/raid5.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
>
> --
> 2.7.4
>
