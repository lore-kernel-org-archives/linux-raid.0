From: Tim Moore <tim.moore@nsr500.net>
Subject: Re: 3Ware on 64bit Linux.
Date: Sun, 19 Jun 2005 08:57:45 -0700
Message-ID: <42B595F9.9020207@nsr500.net>
References: <602f2f2b050608100938ddad81@mail.gmail.com> <200506081156.31051.hjm@tacgi.com> <42A94E91.80009@nsr500.net> <200506100836.20625.hjm@tacgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506100836.20625.hjm@tacgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Harry Mangalam wrote:
> 
> On Friday 10 June 2005 1:25 am, Tim Moore wrote:
> 
> 
>>The SD's are 100% duty cycle, 24x7, 1M hour MTBF commercial SATA II drives,
>>whereas the JD's are SATA I with a "desktop" rating and a 'designed for
>>Microsoft Windows' cert.  Why WD would trade a commercial drive for a
>>desktop drive?
> 
> 
> Dunno, but they did, altho the disks back were 'recertified', not new.  As to 

Interesting.  Maybe there were serious mfg problems with the JDs.

> the 1M MTBF rating, I also dunno.  I got 9 're-certified SD drives' back from 
> WD and 2 of them (oops, make that 3 of them) have failed in the past 24 
> hours, which points to some underlying problem in the system.  It's on a UPS 
> which should condition the voltage. The drives that went out were on 
> different ports and one of them was direct-connected, not via a hotswap cage 
> (due to previous suspicions about the hotswap cage).
> 
> Any insight into this failure rate would be appreciated.  About to open 
> another support call to 3ware...

I've also taken "failed" WD drives on production hardware which have passed 
WD's own check program and found that badblocks -n will force remapping the 
bad sectors.

> 
> 
>>Besides that I've used 3Ware controllers since the 6400 and have had zero
>>problems with anything.  
> 
> 
> I guess I'm the reason they say YMMV. :)

Fair enough.
