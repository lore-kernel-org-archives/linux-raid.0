From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: double read in raid1
Date: Tue, 24 Aug 2004 22:51:40 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408242051.i7OKpeq10271@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

In raid1 one could read from both (or more drives) and discard all read
returns except the first.  This should be fractionally faster than
reading from one drive alone in most circumstances.

However, one can also split the reads so that if say 128 requests are
queued, then the lowest 64 are read from one drive and the highest 64
from another.  With luck, that would amount to doubling the read rate,
as there would be little overlap on what is read from the two drives,
and requests are issued asyncronously.

Curiously, that is about what the current code does (by accident, and
slightly wrongly), but it stops doing it in exactly the circumstances
when it would do good - during a linear set of contiguous reads.  In
that case one should issue 50% of each batch of requests given to the
request function to one drive, and the other 50% as far away as possible
to the other drive. The current code does no switch half way through
each batch of requests (where it would do good), but instead after
counting through exactly 128 requests, which is a pretty random point 
in a batch.

If the reads come from all over the shop, then one still gains from
doing half on one drive and half on the other, so long as one does
both halves at the same time and one arranges that the readaheads
do not overlap the reads from the other drives (it's easier to say
that they don't when reads are a contiguous linear sequence, which is
why I said that that's the case when one should be sharing reads
between two drives).

Peter
