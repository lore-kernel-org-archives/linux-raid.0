From: Stephen C Woods <scw@seas.ucla.edu>
Subject: Re: Good news / bad news - The joys of RAID
Date: Thu, 2 Dec 2004 09:29:20 -0800
Message-ID: <20041202172920.GB10818@seas.ucla.edu>
References: <Pine.LNX.4.44.0411201657570.19120-100000@coffee.psychology.mcmaster.ca> <200412021147.12410.systemloc@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200412021147.12410.systemloc@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: TJ <systemloc@earthlink.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


  Perhaps servo/timing data?  Also I recall some Kennedy Winchester
drives back in the early 80s that if you had a power outage would get
header CRC errors at pairs of blocks that were arranged in a spiral as the head
headed for the landing zone.    I recall writing a standalone program
that would read the entire drive and then 'correct' the CRC errors as it
found them.   Since much of the drive was unused I finally figurered out
that the data was fine it was the header CRC that got clobbered, apparently
there was a bug in the powerdown hardware so it would enable the write head
when it was in the the interblock zone as it was flying to land....

    Ahh for the days of poking into device registers  (in Memory) to get I/O to
happen (from the console).
<scw>


On Thu, Dec 02, 2004 at 11:47:12AM -0500, TJ wrote:
> > afaikt, the deathstar incident was actually bad firmware
> > (didn't correctly flush data when hard powered off, resulting in
> > blocks on disk with bogus ECC, which had to be considered bad from
> > then on, even if the media was perfect.)
> 
> I do not think the deathstar incident was due to a firmware problem as you 
> describe at all. I had a lot of these drives fail, and I read as much as I 
> could find on the subject. The problem was most likely caused by the fact 
> that these drives used IBM's new glass substrate technology. This substrate 
> had heat expansion issues which caused the heads to misalign on tracks and 
> eventually cross write over tracks, corrupting data. The classic "click of 
> death" was the sound of the drive searching for a track repetitively. In some 
> cases a format would allow the drive to be used again, in many cases it would 
> not. It is my belief that formatting was inneffective at fixing the drive 
> because the cross writing probably hit some of the low level data, which the 
> drive cannot repair on a format.

-- 
-----
Stephen C. Woods; UCLA SEASnet; 2567 Boelter hall; LA CA 90095; (310)-825-8614
Unless otherwise noted these statements are my own, Not those of the 
University of California.                      Internet mail:scw@seas.ucla.edu
