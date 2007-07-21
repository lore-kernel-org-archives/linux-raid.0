From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: raid5:md3: read error corrected , followed by , Machine Check
Date: Sat, 21 Jul 2007 16:25:31 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0707211610120.29412@filesrv1.baby-dragons.com>
References: <200707171518.l6HFIUBU022021@cichlid.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200707171518.l6HFIUBU022021@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 	Hello Andrew ,

On Tue, 17 Jul 2007, Andrew Burgess wrote:
>> 	The 'MCE's have been ongoing for sometime .  I have replaced every item
>> in the system except the chassis & scsi backplane & power supply(750Watts) .
>> 	Everything .  MB,cpu,memory,scsi controllers, ...
>> 	These MCE's only happen when I am trying to build or bonnie++ test the
>> md3 .  It consists of (now 7+1spare) 146GB drives in the SuperMicro
>> SYS-6035B-8B's backplane attached to a LSI22320 .
>
> Probably every old timer has a story about chasing a hardware problem
> where changing the power supply finally fixed it. I keep spares now.
>
> If an MCE (which means bad cpu) doesn't go away after changing the cpu
> it would either have to be temperature, power or a bug in the MCE code.
> What else could it be?

 	Thank you for the idea of 'changing out the PS' .  So I did it a bit 
differant .  I removed the system PS from the raid backplane & dropped in a 
known good ps of proper wattage & re-tested .  But left the systems ps attached 
to only the MB & fans .
 	It doesn't appear to be power load related .  I tried rebuilding my 7 
disk raid6 array & I got the same thing ,  MCE .
 	Now the raid backplane is still in the air stream in front of the cpu's 
and memory slots .  So it could be a marginal cpu or memory stick .

 	But here's the clincher ,  when I don't use the two drives in from of 
the PS & cpu & memory slots .  The array completes it's resync .  So I'm back to 
testing memory (again) ,  If that passes then I'll try the new cpu(s) route .

 		Tnx All ,  JimL
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
