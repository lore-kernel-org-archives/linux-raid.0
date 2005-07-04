From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm -f ?
Date: Mon, 4 Jul 2005 17:06:54 +1000
Message-ID: <17096.57358.766527.898673@cse.unsw.edu.au>
References: <200506290823.09776.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mitchell Laks on Wednesday June 29
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 29, mlaks@verizon.net wrote:
> Hi,
> I described  on this list (a few days ago) how I physically removed one of 2 
> drives from a raid 1 array. I then took it to another computer to use it as a 
> second copy of the data.
> 
> 
> 
> That worked fine, although I described at that time that my linux box would  
> not boot normally until I ran mdadm -A --run /dev/md0 /dev/hdb1 
> with the --run option
> as the raid 1 would not start in the degraded state otherwise.

This is a safety feature of mdadm.  It makes it harder to accidentally
started an array without all devices being present.
mdadm will only start a degraded array if "--run" is explicitly given,
or if it is starting it under "--assemble --scan", and it has searched
for drives itself and not found them all.


> 
> I was wondering. 
> 
> imagine I have /dev/md0 composed of /dev/hdb1 and /dev/hdg1
> 
> What is the effect  of the command
> 
> 
> mdadm --manage /dev/md0 -f /dev/hdg1
> 
> Ie: If I "fail" the drive in this way:
> 1) will the remainder of the array (ie /dev/md0 composed of /dev/hdb1) now 
> boot without the --run being added in?

See above.  If you are using mdadm.conf and "mdadm -As" to start the
arrays, the fact that one is missing isn't a problem.


> 2) Will I still be able to take the drive /dev/hdg1 and use it on another 
> machine as a copy of the data from the array?

Yes, this should work.

> 3) If the  answer to 2 is no, should I do
> 	a) remove drive /dev/hdg1 physically (machine off)
> 	b) then after booting without /dev/hdg1 via the --run 
> 		run the command 	
> 		mdadm --manage /dev/md0 -f /dev/hdg1 (even though it is  not on the 
> machine...

This is meaningless in the context.  You cannot fail a drive that
isn't present.

> 		then will it boot without the --run added in.

See above for when --run is needed.


> 
> thanks,
> 
> I am simply not sure of what -f does...

It simulates an error on that drive and causes it to be excluded from
the array.  No further IO is performed to the drive by md.

NeilBrown
