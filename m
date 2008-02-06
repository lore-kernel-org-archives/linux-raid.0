From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: which raid level gives maximum overall speed? (raid-10,f2 vs.
 raid-0)
Date: Wed, 6 Feb 2008 23:15:14 +0100
Message-ID: <20080206231514.4b2e001c@szpak>
References: <20080130192133.17b254bf@szpak>
	<20080130220007.GG20173@rap.rap.dk>
	<20080130233639.5d46b044@szpak>
	<20080131015506.GB6617@rap.rap.dk>
	<20080205161036.GA30326@rap.rap.dk>
	<alpine.DEB.1.00.0802051152500.9790@p34.internal.lan>
	<20080205200423.GB17621@rap.rap.dk>
	<alpine.DEB.1.00.0802051726510.10352@p34.internal.lan>
	<20080205235215.750ea879@szpak>
	<47A9F96E.7050307@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A9F96E.7050307@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen said:     (by the date of Wed, 06 Feb 2008 13:16:14 -0500)

> Janek Kozicki wrote:
> > Justin Piszcz said:     (by the date of Tue, 5 Feb 2008 17:28:27 -0500 (EST))
> > writing on raid10 is supposed to be half the speed of reading. That's
> > because it must write to both mirrors.
> >

> ??? Are you assuming that write to mirrored copies are done sequentially 
> rather than in parallel? Unless you have enough writes to saturate 
> something the effective speed approaches the speed of a single drive. I 
> just checked raid1 and raid5, writing 100MB with an fsync at the end. 
> raid1 leveled off at 85% of a single drive after ~30MB.

Hi,

In above context I'm talking about raid10 (not about raid1, raid0,
raid0+1, raid1+0, raid5 or raid6).

Of course writes are done in parallel. When each chunk has two
copies raid10 reads twice as fast as it writes. 

If each chunk has three copies, then writes are 1/3 speed of reading.
If each chunk has number of copies equal to number of drives, then
write speed drops down to that of a single drive - a 1/Nth of read speed.

But it's all just a theory. I'd like to see more benchmarks :-)

-- 
Janek Kozicki                                                         |
