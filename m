From: =?ISO-8859-1?Q?Martin_K=F6hling?= <mk423@lw1.cc-computer.de>
Subject: Kernel 2.4.x / RAID1 / RAID5 and swap partition?
Date: Fri, 21 May 2004 15:23:08 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0405211416350.5629-100000@lw2.cc-computer.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I've been using a small RAID5 array for the data partition on a file
server for some time now, with no obvious problems.

Now I want to convert the rest of the system to RAID1, which should be no
problem either, except perhaps swap space?

I found several RAID docs/HowTos that warn of possible problems, in
particular this German page:

http://www.resultings.de/linux/de-software-raid-howto/de-software-raid-howto.html

which claims that resync/hotadd on an active swap device can cause
an internally inconsistent array (because the resync process uses the
buffer cache, and the swap code doesn't).
Bad news if, e.g., an automatic resync happens after a power failure.

However, that HowTo is over two years old.

Perhaps this problem has long been fixed?

A Google search didn't yield any really conclusive results - perhaps
somebody on this list knows for sure? :-)

The system in question is a SuSE 8.2 box with SuSE kernel
k_deflt-2.4.20-111 (I could try installing a vanilla 2.4.26 kernel if
really necessary...).

Regards,
Martin

