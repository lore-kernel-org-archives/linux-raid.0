From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: raid5:md3: read error corrected , followed by , Machine Check
Date: Mon, 23 Jul 2007 21:44:20 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0707231939520.24752@filesrv1.baby-dragons.com>
References: <200707171518.l6HFIUBU022021@cichlid.com>
 <Pine.LNX.4.64.0707211610120.29412@filesrv1.baby-dragons.com>
 <46A5347A.2080903@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46A5347A.2080903@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Andrew Burgess <aab@cichlid.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 	Hello Bill ,

On Mon, 23 Jul 2007, Bill Davidsen wrote:
> Mr. James W. Laferriere wrote:
>>     Hello Andrew ,
>> 
>> On Tue, 17 Jul 2007, Andrew Burgess wrote:
>>>>     The 'MCE's have been ongoing for sometime .  I have replaced every 
>>>> item
>>>> in the system except the chassis & scsi backplane & power 
>>>> supply(750Watts) .
>>>>     Everything .  MB,cpu,memory,scsi controllers, ...
>>>>     These MCE's only happen when I am trying to build or bonnie++ test 
>>>> the
>>>> md3 .  It consists of (now 7+1spare) 146GB drives in the SuperMicro
>>>> SYS-6035B-8B's backplane attached to a LSI22320 .
>>> 
>>> Probably every old timer has a story about chasing a hardware problem
>>> where changing the power supply finally fixed it. I keep spares now.
>>> 
>>> If an MCE (which means bad cpu) doesn't go away after changing the cpu
>>> it would either have to be temperature, power or a bug in the MCE code.
>>> What else could it be?
>>
>>     Thank you for the idea of 'changing out the PS' .  So I did it a bit 
>> differant .  I removed the system PS from the raid backplane & dropped in a 
>> known good ps of proper wattage & re-tested .  But left the systems ps 
>> attached to only the MB & fans .
>>     It doesn't appear to be power load related .  I tried rebuilding my 7 
>> disk raid6 array & I got the same thing ,  MCE .
>>     Now the raid backplane is still in the air stream in front of the cpu's 
>> and memory slots .  So it could be a marginal cpu or memory stick .
>>
>>     But here's the clincher ,  when I don't use the two drives in from of 
>> the PS & cpu & memory slots .  The array completes it's resync .  So I'm 
>> back to testing memory (again) ,  If that passes then I'll try the new 
>> cpu(s) route .
>> 
> It does sound like a cooling problem, which does not have to imply the 
> overheated parts are bad, although that may be true.
 	Fyi ,  memtest86+ @ 19 passes (~ 52hours) on 8GB of memory ,  no errors .

> Could be the total number of i/o in flight, etc.
 	Hmmm ,  I didn't think of this one .

> Have you tried dropping two other drives?
 	Well ,  no .  I dropped those two in front of the CPU as a test in 
working my way up the scsi backplane(BP) trying to find a point that worked & 
the last two drives in the BP just happened to be in front of the cpu/memory 
air path .  The minute I put those in the MD build tree within the usual time 
frame I get a MCE .  What I have'nt tried is what you are probably suggesting 
make sure it is the drives in the air path by putting them in the MD build and 
leaving another two out .  I'll try that as well .

> Can you put in a bit more fan?
 	Nope ,  It's maxed out .  sounds like a 747 on take off as it is .
 	It's a supermicro SYS-6035B-8B if you have the time to go look at the 
specs & pics .

> Read the system board and CPU temps with the "sensors" package?
 	Not yet ,  I am building the need items into the kernel now .
 	Will report back (hopefully) sometime this weekend .

 		Tia ,  JimL
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
