From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL REQUEST] md fixes for late 4.0-rc
Date: Mon, 13 Apr 2015 10:13:43 -0700
Message-ID: <CA+55aFxBQ25kQnaXvRcWcuqtMoBut-iG-6At6pU+wt5aYoU2+A@mail.gmail.com>
References: <20150413092018.0e153eea@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150413092018.0e153eea@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>, linux RAID <linux-raid@vger.kernel.org>, Joe Landman <joe.landman@gmail.com>, Dave Chinner <david@fromorbit.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>, Simon Kirby <sim@hostway.ca>, Dave Jones <davej@codemonkey.org.uk>
List-Id: linux-raid.ids

On Sun, Apr 12, 2015 at 4:20 PM, NeilBrown <neilb@suse.de> wrote:
>
>  two regression fixes for md, one fairly recent and minor (diskstats has
>  confusing data) and one older and more serious - RAID0 with non-power-of-2
>  chunksize corrupts data.  I guess (almost) no-one uses non-power-of-2 chunks.

So the pull request obviously came in after I had already tagged and
pushed out 4.0. I've pulled it now.

Both of them were marked for stable, so they'll make 4.0.x eventually
without any further action.

                         Linus
