From: Thomas Horsten <thomas@horsten.com>
Subject: Re: Swap on RAID1?
Date: Mon, 13 Oct 2003 23:20:11 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310132320.11883.thomas@horsten.com>
References: <200310140012.33121.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310140012.33121.dusty@strike.wu-wien.ac.at>
Content-Disposition: inline
To: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday 13 October 2003 23:12, Hermann Himmelbauer wrote:

> I am considering putting my Swap on a RAID1.
>
> I am aware that using 2 seperate Swap-Spaces without RAID would probably
> speed things up as Linux distributes the swap.
>
> But what happens if a disk fails and the swap is on this disk? I assume
> Linux would crash? Wouldn't a swap on a RAID prevent such a crash?

It would, and if the hardware RAID is well implemented it'll probably spread the swap better than Linux could.

Kind regards,

Thomas

