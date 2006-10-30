From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: new features time-line
Date: Mon, 30 Oct 2006 18:19:52 -0500
Message-ID: <45468898.5030506@tmr.com>
References: <000a01c6ef12$0030b640$eb00000a@mine3ad5e808fe>	<17712.10578.16619.929884@cse.unsw.edu.au>	<453592FB.4090105@tmr.com> <17718.59159.519516.656790@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17718.59159.519516.656790@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan <dan@korstad.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Tuesday October 17, davidsen@tmr.com wrote:
>  
>
>>We talked about RAID5E a while ago, is there any thought that this would 
>>actually happen, or is it one of the "would be nice" features? With 
>>larger drives I suspect the number of drives in arrays is going down, 
>>and anything which offers performance benefits for smaller arrays would 
>>be useful.
>>    
>>
>
>So ... RAID5E is RAID5 using (N-1)/N of each drive (or close to that)
>and not having a hot spare.
>On a drive failure, the data is restriped across N-1 drives so that it
>becomes plain RAID5.  This means that instead of having an idle spare,
>you have spare space at the end of each drive.
>
>To implement this you would need kernel code to restripe and array to
>reduce the number of devices (currently we only increase the number of
>devices).
>
>Probably not too hard - just needs code and motivation.  
>

Code is not coming from me right now, but the motivation is (a) all 
drives in use so better response, particularly with small arrays, and 
(b) spare is being used, if it's going to have a problem it won't be 
just when you need it the most.

I suppose someone will want RAID6E as well, I would probably find a use 
for it, but RAID5E would suit many systems which could use a 
speed+reliability boost.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

