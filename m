From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Swap on RAID1?
Date: Tue, 14 Oct 2003 09:48:30 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0310140947390.29390@unicorn.drogon.net>
References: <200310140012.33121.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310140012.33121.dusty@strike.wu-wien.ac.at>
To: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 14 Oct 2003, Hermann Himmelbauer wrote:

> Hi,
> I am considering putting my Swap on a RAID1.
>
> I am aware that using 2 seperate Swap-Spaces without RAID would probably
> speed things up as Linux distributes the swap.
>
> But what happens if a disk fails and the swap is on this disk? I assume
> Linux would crash? Wouldn't a swap on a RAID prevent such a crash?

It works for me. I even have it on RAID5 on some servers I manage.

Swap is no substitute for memory though - if you are worried about swap
speed, then get more memory.

Gordon
