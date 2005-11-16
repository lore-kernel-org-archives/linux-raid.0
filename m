From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: udev and mdadm -- I'm lost
Date: Wed, 16 Nov 2005 12:38:20 -0500
Message-ID: <437B6E8C.9000100@tmr.com>
References: <1b9.203c2461.30a28d17@aol.com> <43713767.1060602@mvista.com> <20051109075732.GB7815@sam.triumf.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051109075732.GB7815@sam.triumf.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Konstantin Olchanski <olchansk@sam.triumf.ca>
Cc: Dave Jiang <djiang@mvista.com>, AndyLiebman@aol.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Konstantin Olchanski wrote:

>On Tue, Nov 08, 2005 at 04:40:23PM -0700, Dave Jiang wrote:
>  
>
>>>I see there is an mdadm  --auto option now...
>>>      
>>>
>>Just use --auto or --auto=yes and it should take care of the device node 
>> creations. I have a /etc/mdadm.conf so I just do:
>>mdadm -As --auto=yes and it brings everything up over udev.
>>    
>>
>
>I face a similar problem each time I use KNOPPIX to revive a non-booting
>server. It always takes me 10-20 minutes to figure out the right
>mdadm incantation to start the md devices. It does not help that mdadm
>wants an /etc/mdadm.conf which is on an md device itself, unaccessible.
>  
>
Hate to say it, that's a reward of a poor config choice and should be fixed.

>I wish there were a simple command to find and start all md devices, something
>along the lines of:
>
>mdadm --please-find-and-start-all-my-md-devices-please-please-please
>or
>mdadm --start-all, or whatever.
>
>  
>


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

