From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Write Order Restrictions
Date: Tue, 8 Mar 2005 13:39:33 +0100
Message-ID: <51j0g2-c27.ln1@news.it.uc3m.es>
References: <67694f3ccfa401a4523d7b2ed7a18e38@stanford.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can Sar <csar@stanford.edu> wrote:
> the driver just cycles through all devices that make up a soft raid 
> device and just calls generic_make_request on them. Is this correct, or 
> does some other function involved in the write process (starting from 
> the soft raid level down) actually wait on buffers to enforce 
> restrictions that e.g. cause blocks for one disk to be written before 
> those of another?

None that I know of.  Neil may have more to say.

In particular, I don't know of any *explicit* mechanism that guarantees
that write order is preserved on any ONE mirror (in the case of raid1).

On the other hand, md interposes its own make_request (as I recall),
so the generic kernel request elevator aggregation algorithm does not
apply.  And I think I remember that it does not allow queues greater
than length 1. If so, that would be helpful.

Peter

