From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: PATCH - change to blkdev->queue calling triggers BUG in md.c
Date: Mon, 2 Sep 2002 21:06:04 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209022100250.1047-100000@home.transmeta.com>
References: <Pine.LNX.4.44.0209022051540.1332-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0209022051540.1332-100000@home.transmeta.com>
To: Andries.Brouwer@cwi.nl
Cc: aebr@win.tue.nl, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids


On Mon, 2 Sep 2002, Linus Torvalds wrote:
> 
> However, that has nothing to do with whether it is in user space or kernel 
> space. In many ways it is _easier_ to do on demand in kernel space: when 
> somebody opens /dev/sda1 and it isn't partitioned yet, you know it needs 
> to be. 

Note that this actually allows you to do your own user-space partitioning 
if you want to - simply by making sure that you do your partitioning 
_before_ somebody tries to open a partition on the device.

And if you look at how fs/block_dev.c looks right now, you'll notice that
we already handle the "main device" vs "sub-partition" cases differently,
so it should be fairly straightforward to eventually do the partitioning
on demand.

We're not there yet, no.  But doing it in the open() path of
fs/block_dev.c sure looks like it's the easiest way to maintain sanity wrt 
partitioning, _and_ maintain 100% backwards compatibility.

[ Well, the "100% backwards compatibility" is not strictly true. Doing
  partition handling on demand will mean that things like /proc/partitions
  will obviously also end up being populated on demand, which may break
  various sysadmin tools. But at least then it's fairly well localized, 
  and it's reasonably easy to grep for /proc/partitions in tools to see if 
  they may care ]

		Linus

