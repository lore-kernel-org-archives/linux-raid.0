From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Replace drive in RAID5 without losing redundancy?
Date: Wed, 07 Mar 2007 10:14:56 -0500
Message-ID: <45EED6F0.6010107@tmr.com>
References: <37643E71-0FD9-4F8A-AE68-A8565FEB0247@bj-ig.de> <17900.39356.684798.56121@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17900.39356.684798.56121@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday March 5, ralf@bj-ig.de wrote:
>   
>> Is it possible to mark a disk as "to be replaced by an existing spare",
>> then migrate to the spare disk and kick the old disk _after_ migration
>> has been done? Or not even kick - but mark as new spare.
>>     
>
> No, this is not possible yet.

I was thinking about this, and looked at the code a bit. It would seem 
(as someone who doesn't have to write code) that the capabilities are 
all there. There is rebuild on spare, write-mostly, and therefore a 
"migrate" might be done by just using the pieces cleverly.

What I was thinking is to trigger the code to rebuild on spare, but to 
only rebuild the data from parity of the drive being replaced were 
unreadable. That should make the process run much faster. any write 
would present a different problem, I would say the data would go to the 
new drive, and if bitmap was enabled the bit would be set for the old 
drive but no write done. If the new drive failed during the migrate the 
old drive could then be resynced. Without a bitmap you DO want to write 
the old drive if it's good, DON'T if you think it's failing.

Thoughts on this?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

