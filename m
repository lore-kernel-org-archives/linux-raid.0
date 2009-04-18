From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: Proposal: make RAID6 code optional
Date: Sat, 18 Apr 2009 15:56:17 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net>
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758009AbZDRN4a@vger.kernel.org>
In-Reply-To: <200904181117.03418.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Sat, 18 Apr 2009, Prakash Punnoor wrote:

> On Samstag 18 April 2009 10:09:54 Michael Tokarev wrote:
> > Prakash Punnoor wrote:
> > > Hi,
> > >
> > > as I am using only RAID5 I wonder why the RAID6 code also needs to be
> > > built. Here is a rough patch of making RAID6 optional (but depending on
> > > raid456) without reording of functions to minimize ifdef scattering.
> > > (I also haven't checked yet who needs ASYNC_MEMCPY and ASYNC_XOR...)
> > > It would probably be nicer to make RAID4/5 and RAID6 independently
> > > selectable of each other. But that requires more refactoring, as I can
> > > see.
> >
> > Hm.  In "old good days" there were 3 independent kernel modules,
> > named raid4, raid5 and raid6.  Later on, they got merged into one
> > since they share quite alot of the code, and has only a few specific
> > parts.  Now you're trying to separate them back somewhat....
> >
> > What's your goal?  What's the problem you're trying to solve?
> 
> Having duplicate code is not good, of course. But unused code is also not 
> good. As I said, I only use RAID5, so I don't need RAID6 support. The RAID6 
> support enlarges kernel (the built-in.o in drivers/md grows from 325kb to 
> 414kb in my case), making boot time and compile time longer 

By a few ms perhaps - nothing that you'd ever notice in real life... A 
small price to pay for the shared code. If you were to split them all 
again, the combined total size would be greater still.

> - admittedly not 
> by a big margin. But then again I could argue: Why not put RAID0,1,10,4,5,6 
> into one big module? Makes no sense, huh? 

Makes perfect sense to me. Just modprobe raid.o and you have all 
raid levels available. That would make a lot of sense. 

> For me putting 5 and 6 into one 
> monolithic module makes no sense. A proper architecture would be to have some 
> common shared code (in a separate module?), not a monolithic big one.
> 
That's also a way, and certainly better than just splitting out raid6.

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
