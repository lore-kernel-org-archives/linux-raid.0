From: Neil Brown <neilb@suse.de>
Subject: Re: 4 disks in raid 5: 33MB/s read performance?
Date: Thu, 25 May 2006 14:56:38 +1000
Message-ID: <17525.14598.970592.611106@cse.unsw.edu.au>
References: <Pine.LNX.4.44.0605221231560.20391-100000@coffee.psychology.mcmaster.ca>
	<4474BDE3.7030905@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Wednesday May 24
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Mark Hahn <hahn@physics.mcmaster.ca>, Dexter Filmore <Dexter.Filmore@gmx.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday May 24, davidsen@tmr.com wrote:
> Mark Hahn wrote:
> 
> >>I just dd'ed a 700MB iso to /dev/null, dd returned 33MB/s.
> >>Isn't that a little slow?
> >>    
> >>
> >
> >what bs parameter did you give to dd?  it should be at least 3*chunk
> >(probably 3*64k if you used defaults.)
> >
> 
> I would expect readahead to make this unproductive. Mind you, I didn't 
> say it is, but I can't see why not. There was a problem with data going 
> through stripe cache when it didn't need to, but I thought that was fixed.
> 
> Neil? Am I an optimist?

Probably....

You are write about readahead - it should make the difference in block
size irrelevant.

You are wrong about the problem of reading through the cache being
fixed.  It hasn't yet.  We still read through the cache.
However that shouldn't cause more than a 10% speed reduction, and
33MB/s sounds like more than 10% down.

NeilBrown
