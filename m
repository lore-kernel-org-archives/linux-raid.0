From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: raid5 parity algorithm
Date: Thu, 27 Feb 2003 16:56:18 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E5E8982.53D437CB@SteelEye.com>
References: <Pine.LNX.4.53.0302272238300.20334@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stephan van Hienen wrote:
> 
> Options are: left-asymmetric, left-symmetric, right-asymmetric,
> right-symmetric, la,  ra,  ls,  rs.
> The default is left-symmetric.
> 
> What is the difference between this ?
> and why do i want to use anything else than the default ?


Hi Stephan,

I'm forwarding a message that I posted to linux-kernel a little while
back...someone else had asked some very similar questions...I hope this
helps...

--
Paul


---------- Forwarded message ----------
Date: Thu, 16 Jan 2003 14:47:16 -0500 (EST)
From: Paul Clements <kernel@steeleye.com>
Reply-To: Paul.Clements@steeleye.com
To: Ezra Nugroho <ezran@goshen.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: raid 5 algorithm docs

On 16 Jan 2003, Ezra Nugroho wrote:

> I don't know if linux-raid mailing list is still active, the archive
> sites look very old...

Yes, linux-raid is still alive and kicking...
it's at: linux-raid@vger.kernel.org
 
> Raidtab's man page tells about left/right (a)synchronous algorithm, but
> doesn't tell how they differ.

I haven't seen much documentation either, but here's what I got from 
looking at the code (BTW, the relevant section of code is 
raid5.c:raid5_compute_sector(), if you're curious):

Basically, the left/right refers to how the parity information is laid 
out and the symmetric/asymmetric refers to how the data is laid out. 

The "left" algorithms start with parity on the last disk, moving the 
parity one disk closer to the first disk for each stripe (wrapping 
as necessary). The "right" algorithms do just the opposite, starting 
with parity on the first disk, moving it one disk closer to the last 
disk for each stripe (wrapping as necessary).

The "asymmetric" algorithms place the data blocks for a given stripe in 
simple sequential order, skipping over the parity block as necessary
and always starting with the first data block of a stripe on the 
first disk. The "symmetric" algorithms differ from this in that they
do not always place the first block of a stripe on the first disk,
but continue to lay out the data blocks in sequential disk order,
simply wrapping back to the first disk when it's necessary.
So the symmetric algorithms tend to give better performance on large
sequential reads, for example, since the actual disk reads are 
evenly spread across all disks.

There's a pretty good diagram of the left-symmetric disk layout here: 
www.pdl.cmu.edu/PDL-FTP/Declustering/ASPLOS.ps (see figure 2-1)

-- 
Paul Clements
Paul.Clements@SteelEye.com
