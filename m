From: David Miller <davem@davemloft.net>
Subject: Re: Any pros or cons of using full disk versus partitons?
Date: Wed, 13 Apr 2011 13:21:12 -0700 (PDT)
Message-ID: <20110413.132112.102552472.davem@davemloft.net>
References: <07a801cbfa12$64b8a950$2e29fbf0$@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <07a801cbfa12$64b8a950$2e29fbf0$@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mjtice@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: "Matthew Tice" <mjtice@gmail.com>
Date: Wed, 13 Apr 2011 13:38:39 -0600

> So of course it technically doesn't matter but are there certain
> (non-apparent) repercussions for choosing one over the other?  It seems to
> save a couple steps by using the whole disk (not having to partition) - but
> is that it?  One thing I'm thinking about the pros of using partitions is if
> all your disks (or some) are different sizes - then you can set the
> partition sizes the same.

First, you sent this to "linux-raid-owner" instead of just
"linux-raid".  The former goes to me, not to the mailing list.

I've corrected it in the CC:

Second, to answer your question, for some disk label variants you
risk over-writing the disk label if you use the whole device
as part of your RAID volume.  This definitely will happen, for
example, with Sun disk labels.
