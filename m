From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast (intelligent) raid1
Date: Tue, 18 Feb 2003 16:04:46 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302181504.h1IF4kh12195@oboe.it.uc3m.es>
References: <15952.20989.131713.951636@notabene.cse.unsw.edu.au>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15952.20989.131713.951636@notabene.cse.unsw.edu.au> from Neil Brown
 at "Feb 17, 2003 02:07:41 pm"
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: ptb@it.uc3m.es, Ross Vandegrift <ross@willow.seitz.com>, Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"A month of sundays ago Neil Brown wrote:"
> The first time you set a bit, record the current 'event' number with
> the bitmap.

I'm having some trouble with this part. Now, there ARE things called
event_hi and event_lo in the current raid code, and you may be
referring to these.

Correct?

> On hot-add, read the old superblock.  If it looks valid and matches
> the current array, and has an event counter of X or more, then ignore

And this is the same event_hi and event_lo?

Now this all HAS to be done in md.c, vecause the read_disk_sb and
write_disk_sb functions are not exported from there.

Peter
