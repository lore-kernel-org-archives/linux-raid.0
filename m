From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Multiplexed RAID-1 mode
Date: Mon, 1 Aug 2005 14:22:03 +1000
Message-ID: <17133.41835.683675.621675@cse.unsw.edu.au>
References: <Pine.LNX.4.56.0507310955400.3698@lion.drogon.net>
	<200507311907.WAA07886@raad.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Al Boldi on Sunday July 31
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: 'Gordon Henderson' <gordon@drogon.net>, linux-raid@vger.kernel.org, 'Jeff Breidenbach' <jeff@jab.org>
List-Id: linux-raid.ids

On Sunday July 31, a1426z@gawab.com wrote:
> Gordon Henderson wrote: {
> On Sat, 30 Jul 2005, Jeff Breidenbach wrote:
> >
> > I just ran a Linux software RAID-1 benchmark with some 500GB SATA 
> > drives in NCQ mode, along with a non-RAID control. Details are here 
> > for those interested.
> >
> >       http://www.jab.org/raid-bench/
> 
> The results you get are about what I get on various systems - essentially
> with RAID-1 you get about the same speed as a single drive will get. 
> 
> ns1:/var/tmp# hdparm -tT /dev/md1 /dev/sda1 /dev/sdb1
> 
> /dev/md1:
>  Timing cached reads:   4116 MB in  2.00 seconds = 2058.31 MB/sec
>  Timing buffered disk reads:  174 MB in  3.00 seconds =  57.99 MB/sec
> 
> /dev/sda1:
>  Timing cached reads:   4096 MB in  2.00 seconds = 2048.31 MB/sec
>  Timing buffered disk reads:  176 MB in  3.03 seconds =  58.11 MB/sec
> 
> /dev/sdb1:
>  Timing cached reads:   4116 MB in  2.00 seconds = 2057.28 MB/sec
>  Timing buffered disk reads:  176 MB in  3.02 seconds =  58.27 MB/sec
> }
> 
> Multiplexing read/write requests would certainly improve performance ala
> RAID-0 (-offset overhead).
> During reads the same RAID-0 code (+mirroring offset) could be used.
> During writes though, this would imply delayed mirroring.

In 2.6, md has a 'raid10' mode which combines features of raid1 and
raid0.
With a layout of 'f2'  you should get raid0-style read performance
like I think you are describing.

But what exactly do you mean by 'delayed mirroring'?
Are you suggesting that the write request completes after only writing
to one mirror?  If so, which one?  Wouldn't this substantially reduce
the value of mirroring?

NeilBrown
