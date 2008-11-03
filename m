From: "George Spelvin" <linux@horizon.com>
Subject: Re: mdraid10 regression in 2.6.27.4 (possibly earlier)
Date: Mon, 03 Nov 2008 03:30:09 -0500
Message-ID: <20081103083009.11625.qmail@science.horizon.com>
References: <20081102173346.1685.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081102173346.1685.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: tmb@mandriva.org, linux@horizon.com
List-Id: linux-raid.ids

> And an extra datapoint.
>
> Booting into 2.6.26.5 triggers an instant resync of the spare disks, so 
> it means we have a regression between 2.6.26.5 and 2.6.27.4

Likewise, 2.6.26.6 fixed the problem for me.  And I can confirm that it's
broken in plain 2.6.27.

There are 8 commits to drivers/md/raid10.c in that interval.
commit 0310fa216decc3ecfab41f327638fa48a81f3735
    Allow raid10 resync to happening in larger chunks.
commit 1e24b15b267293567a8d752721c7ae63f281325a
    Merge branch 'for-linus' of git://neil.brown.name/md
commit 388667bed591b2359713bb17d5de0cf56e961447
    md: raid10: wake up frozen array
commit 8a392625b665c676a77c62f8608d10ff430bcb83
    Merge branch 'for-linus' of git://neil.brown.name/md
commit f233ea5c9e0d8b95e4283bf6a3436b88f6fd3586
    md: Make mddev->array_size sector-based.
commit cc371e66e340f35eed8dc4651c7c18e754c7fb26
    Add bvec_merge_data to handle stacked devices and ->merge_bvec()
commit 199050ea1ff2270174ee525b73bc4c3323098897
    rationalise return value for ->hot_add_disk method.
commit 6c2fce2ef6b4821c21b5c42c7207cb9cf8c87eda
    Support adding a spare to a live md array with external metadata.

It's not obvious which of these is the problem; they mostly look pretty simple
and safe, at least as far as raid10 ic concerned.
