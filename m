From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: *terrible* direct-write performance with raid5
Date: Wed, 23 Feb 2005 18:55:39 +0100
Message-ID: <rlsue2-0sc.ln1@news.it.uc3m.es>
References: <421B6E5D.6030004@tls.msk.ru> <Pine.LNX.4.62.0502221507160.25248@twinlark.arctic.org> <421CBF7D.20801@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> (note raid5 performs faster than a single drive, it's expectable
> as it is possible to write to several drives in parallel).

Each raid5 write must include at least ONE write to a target.  I think
you're saying that the writes go to different targets from time to time
and that when the targets are the bottlenecks then you get faster than
normal response.

Hmmmm. That's actually quite difficult to calculate, because if say you
have three raid disks, then every time you write to the array you write
to two of those three (foget the read, which will come via readahead and
buffers).  Suppose that's no slower than one write to one disk, how
could you get any speed INCREASE?

Well, only by writing to a different two out of the three each time, or
near each time. If you first write to AB, then to BC, then to CA, and
repeat, then you have written 3 times but only kept each disk busy 2/3
of the time, so I suppose there is some opportunity for pipelining. Can
anyone see where?

   A B C  A B C  ...
   B C A  B C A  ...
   1 2 3  1 2 3

Maybe like this:


   A1 A3  A1 A3  ...
   B1 B2  B1 B2  ...
   C2 C3  C2 C3  ...

Yes. That seems to preserve local order and go 50% faster.

Peter

