From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: skip raid5 reconstruction
Date: Wed, 06 Jul 2005 19:45:10 +0400
Message-ID: <42CBFC86.4090009@tls.msk.ru>
References: <1120584167.5535.56.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120584167.5535.56.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ming Zhang wrote:
> Hi folks
> 
> I am testing some HW performance with raid5 with 2.4.x kenrel.
> 
> It is really troublesome every time I create a raid5, wait 4 hours for
> reconstruction, and then test some data and then recreate another one
> and wait again. I wonder if there is any hack or option available to
> create a raid5 without reconstruct the parity disk. I just have interest
> to test the performance so do not care about data correctness at this
> stage.

Maybe try smaller partitions?

/mjt
