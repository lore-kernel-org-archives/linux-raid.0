From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md 006 of 6] Add write-behind support for md/raid1
Date: Mon, 15 Aug 2005 08:16:39 +1000
Message-ID: <17151.49863.851690.714360@cse.unsw.edu.au>
References: <20050811171720.10115.patches@notabene>
	<E1E37OV-0002jU-9q@notabene.cse.unsw.edu.au>
	<200508120922.52689.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Al Boldi on Friday August 12
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 12, a1426z@gawab.com wrote:
> 
> Also, it would be nice to have something like:
> echo 1 > /proc/md../../WriteBehindEnabled
> echo 10 > /proc/md../../WriteBehindMaxDelayBeforeSync

Something like
   echo 1 > /sys/block/md0/md/d4/write_behind
or
   echo 10 > /sys/block/md0/md/max_write_behind

are real possibilities.
However "WriteBehindMaxDelayBeforeSync" doesn't make sense I don't
think.  When doing write behind, we don't delay the write at all.  We
just assume that it will take longer because it is on a slow device.
The only limit is the number of outstanding write requests.  Once this
crosses a maximum, all further requests a fully synchronous until the
number of outstanding writes drops below the maximum.

NeilBrown
