From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid5:md3: read error corrected , followed by , Machine Check
Date: Mon, 23 Jul 2007 19:06:34 -0400
Message-ID: <46A5347A.2080903@tmr.com>
References: <200707171518.l6HFIUBU022021@cichlid.com> <Pine.LNX.4.64.0707211610120.29412@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707211610120.29412@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Andrew Burgess <aab@cichlid.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mr. James W. Laferriere wrote:
>     Hello Andrew ,
>
> On Tue, 17 Jul 2007, Andrew Burgess wrote:
>>>     The 'MCE's have been ongoing for sometime .  I have replaced 
>>> every item
>>> in the system except the chassis & scsi backplane & power 
>>> supply(750Watts) .
>>>     Everything .  MB,cpu,memory,scsi controllers, ...
>>>     These MCE's only happen when I am trying to build or bonnie++ 
>>> test the
>>> md3 .  It consists of (now 7+1spare) 146GB drives in the SuperMicro
>>> SYS-6035B-8B's backplane attached to a LSI22320 .
>>
>> Probably every old timer has a story about chasing a hardware problem
>> where changing the power supply finally fixed it. I keep spares now.
>>
>> If an MCE (which means bad cpu) doesn't go away after changing the cpu
>> it would either have to be temperature, power or a bug in the MCE code.
>> What else could it be?
>
>     Thank you for the idea of 'changing out the PS' .  So I did it a 
> bit differant .  I removed the system PS from the raid backplane & 
> dropped in a known good ps of proper wattage & re-tested .  But left 
> the systems ps attached to only the MB & fans .
>     It doesn't appear to be power load related .  I tried rebuilding 
> my 7 disk raid6 array & I got the same thing ,  MCE .
>     Now the raid backplane is still in the air stream in front of the 
> cpu's and memory slots .  So it could be a marginal cpu or memory stick .
>
>     But here's the clincher ,  when I don't use the two drives in from 
> of the PS & cpu & memory slots .  The array completes it's resync .  
> So I'm back to testing memory (again) ,  If that passes then I'll try 
> the new cpu(s) route .
>
It does sound like a cooling problem, which does not have to imply the 
overheated parts are bad, although that may be true. Could be the total 
number of i/o in flight, etc. Have you tried dropping two other drives? 
Can you put in a bit more fan? Read the system board and CPU temps with 
the "sensors" package?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

