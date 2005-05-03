From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Any way to Increase MD_SB_DISKS=27 ? I need 31 devices
Date: Tue, 3 May 2005 15:45:34 +0200
Message-ID: <usbkk2-1e9.ln1@news.it.uc3m.es>
References: <427583FA.7030704@dtbb.net> <4b0hk2-1gn.ln1@news.it.uc3m.es> <4275E782.6090509@dtbb.net> <mj6hk2-4lb.ln1@news.it.uc3m.es> <kt8hk2-lhp.ln1@news.it.uc3m.es> <4277641D.6060303@dtbb.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tyler <pml@dtbb.net> wrote:
> Thanks for all the great info, I had about half of it figured out :)  
> I'm starting to wonder though, isn't the version 1 superblock supposed 
> to be able to use many more drives than 27? .. If so, should this not 

I don't know (nor do I know anything about superblocks, i.e.  which
format you should be using).  All I can see is that the struct you
wanted to modify (the one with the "27" in its standard definition) is
read and written to disk in the first 4K of the 64K just after the
array contents.

Maybe you don't want to modify that struct but something else.  Maybe
something slightly different is written to disk.  That's impossible to
tell without documetation or experiment!

According to Paul, all should just work hunky-dory if you just suppress
the check in mdadm itself!

> already be patched in the kernel source, and in the mdadm source?  What 
> am I missing? .. it seems like I am trying to do something that's 
> already supposedly done.. am I not?

It most definitely is not the case that a particular one of the structs
in md_p.h can take more than 27 entries in the array that appears in it.
What significance that has requires some strategic inverse engineering
to discover. The most obvious interpretation is that it is a real
limit, but maybe not one that comes into play because we are using a
different ondis struct.

Peter

