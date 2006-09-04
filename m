From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux: Why software RAID?
Date: Mon, 04 Sep 2006 13:29:22 -0400
Message-ID: <44FC6272.9000403@tmr.com>
References: <20060824090741.J30362@mail.kroptech.com> <1156425650.3007.140.camel@localhost.localdomain> <20060824093616.K30362@mail.kroptech.com> <Pine.LNX.4.56.0608241438360.6721@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0608241438360.6721@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: Adam Kropelin <akropel1@rochester.rr.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Gordon Henderson wrote:

>On Thu, 24 Aug 2006, Adam Kropelin wrote:
>
>  
>
>>>Generally speaking the channels on onboard ATA are independant with any
>>>vaguely modern card.
>>>      
>>>
>>Ahh, I did not know that. Does this apply to master/slave connections on
>>the same PATA cable as well? I know zero about PATA, but I assumed from
>>the terminology that master and slave needed to cooperate rather closely.
>>    
>>
>
>I don't know much about co-operation between master & slave, but I do know
>that a failing PATA IDE drive can take out the other one on the same bus -
>or in my case, render it unusable until I removed the dead drive,
>whereupon (to my relief) it sprang back into life.
>
>This was many many moons ago before I started to use s/w RAID, but it's
>one thing that would kill a multi-disk array, so I've never done it since.
>
>I guess the same could happen on SCSI, but I suspect the interface is a
>little better designed...
>
Until recently I was working with 38 systems using SCSI RAID controllers 
(IBM ServeRAID Ultra320). With several types of SCSI drives I saw 
failures where one drive failed, hung the bus, and caused the next 
command to another drive to fail. At that point I have to force the 
controller to think the 2nd drive failed was okay, and then it would 
recover. I'm told this happens with other hardware, I just haven't 
personally seen it.

 From that standpoint, the SATA on the MB look pretty good!

-- 

bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

