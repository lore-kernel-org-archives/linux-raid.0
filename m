From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: Still Need Help on mdadm and udev
Date: Thu, 10 Nov 2005 13:20:36 -0800 (PST)
Message-ID: <Pine.LNX.4.63.0511101317070.13184@twinlark.arctic.org>
References: <Pine.LNX.4.44.0511101421260.19226-100000@firewall2.tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0511101421260.19226-100000@firewall2.tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: davidsen@tmr.com
Cc: Neil Brown <neilb@suse.de>, andyliebman@editshare.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 10 Nov 2005, Bill Davidsen wrote:

> I haven't had a good use for a partitionable device

i've used it to have root, swap, and some external xfs/ext3 logs on a 
single raid1... (the xfs/ext3 logs are for filesystems on another raid5) 
rather than managing 4 or 5 separate raid1s on the same 2 disks.

-dean
