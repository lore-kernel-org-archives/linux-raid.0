From: Asdo <asdo@shiftmail.org>
Subject: Re: Help on first dangerous scrub / suggestions
Date: Fri, 27 Nov 2009 19:11:31 +0100
Message-ID: <4B101653.8040904@shiftmail.org>
References: <4B0E7111.20202@shiftmail.org>
 <alpine.DEB.2.00.0911260720220.23317@p34.internal.lan>
 <4B0E8B75.2030006@shiftmail.org>
 <alpine.DEB.2.00.0911260915520.17452@p34.internal.lan>
 <4B0ED0DF.10502@shiftmail.org>
 <alpine.DEB.2.00.0911261554170.14297@p34.internal.lan>
 <4B0FD689.9030904@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4B0FD689.9030904@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Asdo wrote:
> ....
> Without knowing this I will probably opt for your way: rsync data out, 
> starting from the smallest and most important stuff...
> ...

I had another thought:

If I take the computer offline, boot with a livecd (one of the worst 
messes here is that the root filesystem is also in that array), run the 
raid6 array in READONLY MODE and maybe without spares, then I start a 
check (scrub) ...

If drives are kicked I can probably reasseble --force the array and it's 
like nothing happened, right?
Since it was mounted readonly I think it would be clean...

Only problem would be if 1 or more drives definitively die during the 
procedure, but I hope this is unlikely...
If less than 3 drives die I can still reassemble --force, and take the 
data out (at least SOME data, then if it degrades, reassemble again and 
try to get out data from another location...)

Do you agree?

I am starting to think that during the procedure for taking the data out 
and/or attempt first scrubbing the main problem are write accesses to 
the array, because if rebuild starts on a spare and then fails again and 
then there were writes in the middle... I think I end up doomed. 
Probably even reassemble --force would refuse to work on me. What do you 
think?

Thank you
