From: Neil Brown <neilb@suse.de>
Subject: Re: stripe_cache_size ?
Date: Sat, 10 Dec 2005 07:43:50 +1100
Message-ID: <17305.60550.693294.479483@cse.unsw.edu.au>
References: <17305.21180.376781.954660@cse.unsw.edu.au>
	<Pine.LNX.4.44.0512090903370.5233-100000@firewall2.tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Friday December 9
Sender: linux-raid-owner@vger.kernel.org
To: davidsen@tmr.com
Cc: Kyle Wong <kylewong@southa.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 9, tmrbill@tmr.com wrote:
> On Fri, 9 Dec 2005, Neil Brown wrote:
> 
> > On Friday December 9, kylewong@southa.com wrote:
> > > Hi,
> > > 
> > > I found that there's a new sysfs "stripe_cache_size" variable. I want to
> > > know how does it affect RAID5 read / write performance (if any) ?
> > > Please cc to me if possible, thanks.
> > 
> > Would you like to try it out and see?
> > Any value from about 10 to a few thousand should be perfectly safe,
> > though very large values may cause the system to run short of memory.
> > 
> > The memory used is approximately
> >    stripe_cache_size * 4K * number-of-drives
> 
> What??? I hope that's a typo...
>  1 - there's no use of the sysfs variable?

'stripe_cache_size' is the sysfs variable.  Yes, it is used.

>  2 - that's going to be huge, 128k * 4k * 10 = 5.1GB !!!

That is why I warned to limit it to a few thousand (128k is more than
a few thousand!).

I just ran bonnie over a 5drive raid5 with stripe_cache_size varying
in from 256 to 4096 in a exponential sequence. (Numbers below 256
cause problems - I'll fix that).

Results:
 256   cage,8G,42594,93,151807,38,50660,18,38610,91,172056,38,912.8,2,16,4356,99,+++++,+++,+++++,+++,4389,99,+++++,+++,14091,100
 512   cage,8G,42145,92,186535,44,60659,21,42249,96,172057,37,971.9,2,16,4407,99,+++++,+++,+++++,+++,4452,99,+++++,+++,13909,99
1024   cage,8G,42250,92,210407,50,61254,21,42106,96,172575,37,903.1,2,16,4370,99,+++++,+++,+++++,+++,4395,99,+++++,+++,13809,100
2048   cage,8G,42458,92,229577,55,61762,21,41965,96,168950,36,837.9,2,16,4373,99,+++++,+++,+++++,+++,4460,99,+++++,+++,14084,100
4096   cage,8G,42305,92,250318,62,62192,21,42156,96,170692,38,981.8,3,16,4380,99,+++++,+++,+++++,+++,4426,99,+++++,+++,13723,99

Seq Write speed           ^
Increases substantially.
Seq Read                                             ^
Doesn't vary much.
Seq rewrite                         ^
improves a bit

So for that limited test, write speed is helped a lot, read speed
isn't.

Maybe I should try iozone...

NeilBrown
