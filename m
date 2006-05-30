From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: problems with raid=noautodetect
Date: Tue, 30 May 2006 13:10:24 -0400
Message-ID: <447C7C80.3080002@tmr.com>
References: <4471B188.3060400@umit.at>	<17522.15774.526526.244768@cse.unsw.edu.au>	<20060526075308.GC8203@percy.comedia.it> <17530.30389.862288.268450@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17530.30389.862288.268450@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Friday May 26, bluca@comedia.it wrote:
>  
>
>>On Tue, May 23, 2006 at 08:39:26AM +1000, Neil Brown wrote:
>>    
>>
>>>Presumably you have a 'DEVICE' line in mdadm.conf too?  What is it.
>>>My first guess is that it isn't listing /dev/sdd? somehow.
>>>      
>>>
>>Neil,
>>i am seeing a lot of people that fall in this same error, and i would
>>propose a way of avoiding this problem
>>
>>1) make "DEVICE partitions" the default if no device line is specified.
>>    
>>
>
>As you note, we think alike on this :-)
>
>  
>
>>2) deprecate the "DEVICE" keyword issuing a warning when it is found in
>>the configuration file
>>    
>>
>
>Not sure I'm so keen on that, at least not in the near term.
>
Let's not start warning and depreciating powerful features because they 
can be misused... If I wanted someone to make decisions for me I would 
be using this software at all.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

