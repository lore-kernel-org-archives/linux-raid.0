From: "Chris Evans" <chris1@psyctc.org>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Wed, 03 Mar 2004 01:20:54 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <404532F6.8743.303008B@localhost>
References: <4045288B.27321.2DA4EF3@localhost>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <200403030211.35753.maarten@vbvb.nl>
To: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3 Mar 2004 at 2:11, Maarten J H van den Berg wrote:

> Hope it's not too obvious, but...
> Did you also actually _run_ lilo ?  
> Is fstab on /dev/md0 edited to reflect the new mountpoints ?
No it's not too obvious and maybe I need to work through all the 
options again and document what went wrong each time but I did try to 
run lilo on each: some ran without complaint but didn't solve the 
problem, and some resulted in lilo complaining something along the 
lines that it was using the current boot device and that device x (a 
numeric representatiion, sorry, didn't note it) wasn't a device in 
which it could write its stuff.

> Not that it helps you here, but I followed the procedure -albeit not
> from the same howto[1]- multiple times with many machines. It _should_
> work...
Well, it encourages me!
 
>   [1] I used a howto by the name of Boot+root+raid+llilo. Maybe see if
> there are any obvious differences between the two procedures /
> howtos...? 
Yes, found that.  Mostly the differences are that the one I worked 
from uses mdadm and that one uses raidtools2 but I thought they said 
the same things really and I couldn't get either approach: mdadm or 
raidtools/raidtab, to work for me.

One thing: I asssume that mdrecoveryd isn't holding an inode active?  
I _think_ I've failed just as totally after killing mdrecoveryd but 
can't vouch for having done that every time.

Thanks Maarten,

C

PSYCTC: Psychotherapy, Psychology, Psychiatry, Counselling
   and Therapeutic Communities; practice, research, 
   teaching and consultancy.
Chris Evans & Jo-anne Carlyle
http://psyctc.org/ Email: chris@psyctc.org

