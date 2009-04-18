From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: Proposal: make RAID6 code optional
Date: Sat, 18 Apr 2009 17:58:50 +0300
Message-ID: <20090418145850.GD28512@mea-ext.zmailer.org>
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de> <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: Prakash Punnoor <prakash@punnoor.de>, Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Sat, Apr 18, 2009 at 03:56:17PM +0200, Jesper Juhl wrote:
> On Sat, 18 Apr 2009, Prakash Punnoor wrote:
> > On Samstag 18 April 2009 10:09:54 Michael Tokarev wrote:
> > > Prakash Punnoor wrote:
.....
> > > What's your goal?  What's the problem you're trying to solve?
> > 
> > Having duplicate code is not good, of course. But unused code is also not 
> > good. As I said, I only use RAID5, so I don't need RAID6 support. The RAID6 
> > support enlarges kernel (the built-in.o in drivers/md grows from 325kb to 
> > 414kb in my case), making boot time and compile time longer 
> 
> By a few ms perhaps - nothing that you'd ever notice in real life... A 
> small price to pay for the shared code. If you were to split them all 
> again, the combined total size would be greater still.


I did quick "sum of symbol sizes" lookup of the   raid.ko, and got
it like this:

nm -t d -n -S /lib/modules/2.6.27.21-170.2.56.fc10.x86_64/kernel/drivers/md/raid456.ko | grep raid4|awk '{print $2}'|sed -e 's/^0*//g'|awk '{sum+=$1}END{print sum}'
  ...

raid4:   152
raid5:  7165
raid6: 75558

Entire 64kB of that raid6 is single pre-initialized r/o datablock:  raid6_gfmul

So yes, having RAID6 personality as separate module would be appropriate for
systems that are only interested in RAID4 or RAID5.  Separating the RAID4
personality wastes space, separating RAID5 ...  barely 2 of 4k memory pages.

There are perhaps a few kB more of codes for RAID5 and RAID6 classes - not all
local functions at each are named with relevant prefix,  but overall I would
consider extracting RAID6 as a reasonable goal with common codes on RAID4/5.

> > - admittedly not 
> > by a big margin. But then again I could argue: Why not put RAID0,1,10,4,5,6 
> > into one big module? Makes no sense, huh? 
> 
> Makes perfect sense to me. Just modprobe raid.o and you have all 
> raid levels available. That would make a lot of sense. 

Also, systems with so many disks that they run RAID4/5/6 to begin with are
likely to have enough memory so that "wasted" 75-80 kB does not matter.

> > For me putting 5 and 6 into one 
> > monolithic module makes no sense. A proper architecture would be to have some 
> > common shared code (in a separate module?), not a monolithic big one.
> 
> That's also a way, and certainly better than just splitting out raid6.
> -- 
> Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
> Plain text mails only, please      http://www.expita.com/nomime.html

/Matti Aarnio
