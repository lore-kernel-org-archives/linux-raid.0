From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 3 Jan 2005 09:37:00 +0100
Message-ID: <cqcna2-78j.ln1@news.it.uc3m.es>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es> <41D45C1F.5030307@tls.msk.ru> <u59ea2-4qr.ln1@news.it.uc3m.es> <20050102194240.GE99565@caffreys.strugglers.net> <5h1ma2-asq.ln1@news.it.uc3m.es> <20050103003005.GG99565@caffreys.strugglers.net> <16856.59660.57838.440787@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
> Well, how about I wade in.....

Sure! :-)

> A RAID controller, whether software, firmware, or hardware, will also
> re-order requests to make best use of the devices.

Possibly.  I have written block device drivers that maintain write
order, however (or at least do so if you ask them to, with the right
switch), because ...

> Any filesystem that assumes that requests will not be re-ordered is
> broken, as the assumption is wrong.
> I would be *very* surprised if Reiserfs makes this assumption.

.. because that is EXACTLY what Hans Reiser has said to me. I don't
think I've kept the mail, but I remember it.  a quick google for
reiserfs + write ordering shows up some suggestive quotes:

  > We cannot use the buffer.c dirty list anyway because bdflush can write
  > those buffers to disk at any time.  Transactions have to control the
  > write ordering  ...

(hey, that was Hans quoting Stephen). From the Linux High Availability
website (http://linuxha.trick.ca/DataRedundancyByDrbd):

   Since later WRITE requests might depend on successful finished
   previous ones, this is needed to assure strict write ordering on
   both nodes. ...

Well, I'm not going to search now. Onecan simply ask HR and find out
what the current status is vis a vis reiserfs.

To be certain what I am talking about, I'll define write ordering as:

Writes are not reordered and reads may not be reordered beyond the
writes that bound them either side.

> Until relatively recently, the only assumption that could be made is
> that a write request will be handled sometime between when it is made,
> and when the request completes (i.e. the end_io callback is called).

This _appears_ to be what Stephen is saying he needs, from which I
deduce that he probably has a single-threaded implementation in ext3,
because:

> If several requests are concurrent they could commit in any order.

Yes.

> With only this guarantee, the simplest approach for a journalling
> filesystem is to write the content of a journal entry, wait for the
> writes to complete, and then write a single block "header" which
> describes and hence commits that journal entry.  The journal entry is
> not "safe" until this second write completes.
> 
> This is equally applicable for IDE drives, SCSI drives, software
> RAID1, software RAID5, hardware RAID etc.

I would agree. No matter what the hardware people say, or what claims
are made for equipment, I don't see how there can be any way of knowing
the order in which writes are committed internally.  I only hope that
reads are not reordered beyond writes :-).

(this would cause you to read the wrong data: you go W1 R1 W2 and yet
read in R1 what you wrote in W2!)

> More recently (2.6 only) Linux has had support for "write barriers".
> The idea here is that you submit a number of write requests, then a

Well, I seem to recall that at some point "request specials" were to
act as request barriers, but I don't know if that is still the case.
When a driver received one it had to flush all outstanding requests
before acking the special.

Perhaps Linus gave up on people implementing that and put the support
in the kernel core, so as to enforce it? It would be possible. Or maybe
he dropped it.

> "barrier", then some more write requests. (The "barrier" might be a
> flag on the last request of a list, I'm not sure of that detail).  The
> meaning is that no write request submitted after the barrier will be
> attempted until all requests submitted before the barrier are
> complete.  Some drives support this concept natively so Linux simply
> does not re-order requests across a barrier, and sends the barrier at
> the appropriate time.  Drives can do their own re-ordering but will
> not reorder across a barrier (if they support the barrier concept).

Yes.

> If Linux needs to write a barrier to a device that doesn't support
> barriers (as the md/raid currently doesn't) it will (should) submit
> all requests before the barrier, flush them out, wait for them to
> complete, then allow other requests to be forwarded.

But I at least don't know if "Linux" does that :-).

By "Linux" you either mean some part of the block subsystem, or fs's
acting on their own.

> In short, md/raid provides the same guarantees as normal drives, and
> any filesystem that expects more is broken.

Normal drives do not reorder writes. Their drivers also probably make
no attempt to do so, nor not to do so, but in the nature of things
(single input, single output) it is unlikely that they do.  Software
RAID on the other hand is fundamentally parallel so the intrinsic
liklihood that something somewhere gets reordered is much higher, and I
believe you agree with me that no attempt is made to either check on or
prevent it.


> Definitely put your journal on RAID  with at least as much redundancy
> as your main filesystem (I put my filesystem on raid5 and my journal
> on raid1).

:-) But I don't think you ought to put the journal on raid - what good
does it do you to do so?  (apart from testing out raid :).  After all,
the journal integrity is not itself guaranteed by a journal, and it is a
point of failure for the whole system, and it is a point where you have
doubled i/o density over and above the normal journal rate, which is
already extremely high if you do data journalling, since ALL the data on
the system flows through that point first. So you will stress the disk
there as well as making all your data vulnerable to anything that
happens there.  What extra benefit do you get from putting it there that
is not balanced by greater risks? I'm curious! Surely raid is about
"spreading your eggs out through several baskets"?

Peter

