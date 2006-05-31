From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: problems with raid=noautodetect
Date: Wed, 31 May 2006 09:23:59 -0400
Message-ID: <447D98EF.1030803@tmr.com>
References: <4471B188.3060400@umit.at> <17522.15774.526526.244768@cse.unsw.edu.au> <20060526075308.GC8203@percy.comedia.it> <17530.30389.862288.268450@cse.unsw.edu.au> <447C7C80.3080002@tmr.com> <20060530173020.GD4022@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060530173020.GD4022@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra wrote:

> On Tue, May 30, 2006 at 01:10:24PM -0400, Bill Davidsen wrote:
>
>>>> 2) deprecate the "DEVICE" keyword issuing a warning when it is 
>>>> found in
>>>> the configuration file
>>>
>>>
>>> Not sure I'm so keen on that, at least not in the near term.
>>>
>> Let's not start warning and depreciating powerful features because 
>> they can be misused... If I wanted someone to make decisions for me I 
>> would be using this software at all.
>
>
> you cut the rest of the mail.

Trimming the part about which I make no comment is usually a good thing.

> i did not propose to deprecate the feature,
> just the keyword.

"A rose by any other name would still smell as sweet." In other words, 
the capability is still able to be misused, and changing the name or 
generating error messages will only cause work and concern for people 
using the feature.

>
> but, ok,
> just go on writing DEVICE /dev/sda1
> DEVICE /dev/sdb1
> ARRAY /dev/md0 devices=/dev/sda1,/dev/sdb1
>
> then come on the list and complain when it stops working. 


What I suggest is that the feature keep working, and no one will 
complain. If there is a missing partition the error messages are clear. 
The feature is mainly used when there are partitions or drives which 
should not be examined, and "stops working" only when a hardware config 
has changed.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

