From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Sat, 8 Jan 2005 18:16:40 +0100
Message-ID: <200501081816.40144.maarten@ultratux.net>
References: <200501081632.j08GWM909993@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501081632.j08GWM909993@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 08 January 2005 17:32, Guy wrote:
> I don't recall having 2 disks with read errors at the same time.  But
> others on this list have.  Correctable read errors is my most common
> problem with my 14 disk array.  I think this partitioning approach will
> help.  But as you say, it is more complicated, which adds some risk, I
> believe.  But you can compute the level of reduced risk, but you can't
> compute the level of increased risk.

true.  Especially since LVM is completely new to me.

> Some added risk:
> 	More complicated setup, increases user errors.

I have confidence in myself (knock, knock).  I triplecheck every action I do 
with the output of 'cat /proc/mdadm' before hitting [enter] so as to not make 
thinking errors like using hdf5 instead of hde6, and similar mistakes.
I'm paranoid by nature, so that helps, too ;-)

> 	Example:  Maarten plans to have 2 spare partitions on an extra disk.
> Once he corrects the read error on the failed partition, he needs to remove
> the failed partition, fail the spare and add the original partition back to
> the correct array.  He has a 6 times increased risk of choosing the wrong

You must mean in the other order. If I fail the spare first, I'm toast! ;-)

> partition to fail or remove.  Is that 36 time increased risk of user error?
> Of course, the level of error may be negligible, depending on who the user
> is.  But it is still an increase of risk.

First of all you need to make everything as uniform as possible, meaning all 
disks belonging to array md3 are numbered hdX6, all of md4 are hdX7, etc.
I suppose this goes without saying for most people here, but it helps a LOT.

> than 6.  Is there a sweet spot?

Heh. Somewhere between 1 and 36 I'd bet. :)

> Also, Neil has an item on his wish list to handle bad blocks.  Once this is
> built into md, the 6 partition idea is useless.

I know but I'm not going to wait for that.  For now I have limited options.
Mine has not only the benefits outlined, but also the benefit of being able to 
use an older disk as a spare. I guess having this with a spare beats having 
one huge array without a spare.  Or else I'd need to buy yet another 250GB 
drive, and they're not really 'dirt cheap' if you know what I mean.  

> I test my disks every night with a tool from Seagate.  I don't think I have
> had a bad block since I started using this tool each night.  The tool is
> free, it is called "SeaTools Enterprise Edition".  I assume it only works
> with Seagate disks.

That's interesting.  Is that an _online_ test, or do you stop the array every 
night ?  The latter would seem quite error-prone by itself already, and the 
former... well I don't suppose Seagate supports linux, really.

Maarten


