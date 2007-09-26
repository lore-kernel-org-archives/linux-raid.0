From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Without tweaking ,  (was:Re: mkfs options for a 16x hw raid5 and
 xfs ...)
Date: Wed, 26 Sep 2007 10:44:52 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0709260953580.12074@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Justin & all ,

> ----------Justin Piszcz Wrote: ----------
> Date: Wed, 26 Sep 2007 12:24:20 -0400 (EDT)
> From: Justin Piszcz <jpiszcz@lucidpixels.com>
> Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
> 
> I have a question, when I use multiple writer threads (2 or 3) I see 550-600 
> MiB/s write speed (vmstat) but when using only 1 thread, ~420-430 MiB/s... Also 
> without tweaking, SW RAID is very slow (180-200 MiB/s) using the same disks.
> Justin.
 	Speaking of 'without tweaking' ,  Might you have or know of a relatively 
accurate list of points to begin tweaking & possible( even guesses at the) out 
come of making those changes ?

 	We(maybe even I) could put together a patch for tuning options in the 
Documentation directory (&/or other files if necessary) .
 	The kernel method would allow those with 'doxygen' (amongst other 
installed tools ) acquire a mediocum of information .
 	The info could be ,  ear marked .  Such as fs-tunable ,  disk-tunable ,
for ease of identification of the intended subject matter .
 	Tho without a list of the present known tunables I am probably going to 
find the challenge a bit confusing as well as time consuming .
 	At present I believe I (just might) be able to ,  with everyones help ,
  put together a list for the linux-raid tunables .  Note: 'with everyones help' 
.

 	Just thoughts .

... much good info snipped...
 		Tia ,  JimL
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
