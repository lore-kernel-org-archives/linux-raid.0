From: James Ralston <qralston+ml.linux-raid@andrew.cmu.edu>
Subject: raid5 software vs hardware: parity calculations?
Date: Thu, 11 Jan 2007 17:44:57 -0500
Message-ID: <2A887D754684B6703B52E126@emerald.sei.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm having a discussion with a coworker concerning the cost of md's
raid5 implementation versus hardware raid5 implementations.

Specifically, he states:

> The performance [of raid5 in hardware] is so much better with the
> write-back caching on the card and the offload of the parity, it
> seems to me that the minor increase in work of having to upgrade the
> firmware if there's a buggy one is a highly acceptable trade-off to
> the increased performance.  The md driver still commits you to
> longer run queues since IO calls to disk, parity calculator and the
> subsequent kflushd operations are non-interruptible in the CPU.  A
> RAID card with write-back cache releases the IO operation virtually
> instantaneously.

It would seem that his comments have merit, as there appears to be
work underway to move stripe operations outside of the spinlock:

    http://lwn.net/Articles/184102/

What I'm curious about is this: for real-world situations, how much
does this matter?  In other words, how hard do you have to push md
raid5 before doing dedicated hardware raid5 becomes a real win?

James

