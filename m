From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid5 slow
Date: Tue, 30 Nov 2004 11:30:41 +1100
Message-ID: <16811.48945.141392.294625@cse.unsw.edu.au>
References: <200411290449.iAT4nsN02715@www.watkins-home.com>
	<Pine.LNX.4.61.0411290928430.13437@adsl.a2000.nu>
	<Pine.LNX.4.61.0411290948230.13437@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephan van Hienen on Monday November 29
Sender: linux-raid-owner@vger.kernel.org
To: Stephan van Hienen <raid@a2000.nu>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 29, raid@a2000.nu wrote:
> 
> now i get 275MB/sec with raid0 (14 disks)
> 171MB/sec with raid5 (14 disks)
> 
> while the old raid5 situation was 257MB/sec with raid5 (13 disks)

I presume you are only looking at 'read' speed here.

There is a read optimisation that I haven't implemented in 2.6 yet
that could  account for about a 10% difference, but a 30% difference
definitely surprises me.

Normally raid5 will read into the stripe cache, and then copy data out
of the stripe cache and into the request buffer for reads.
The optimisation is to read directly into the request buffer in
situations where no degraded stripes or pending write requests.  This
optimisation is implemented in 2.4 and gave me about a 10% speedup on
sequential reads.  Its substantially more complicated in 2.6...

I might do a bit of testing myself, but more results from others would
be helpful...

NeilBrown
