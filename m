From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Relabeling UUID
Date: Wed, 13 Dec 2006 00:42:49 -0500
Message-ID: <457F92D9.6020105@tmr.com>
References: <457F3BAD.6060206@tmr.com> <17791.18766.36228.208220@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17791.18766.36228.208220@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday December 12, davidsen@tmr.com wrote:
>   
>> I needed to move an array to other drives, and because of the way the 
>> array is used, want to keep the UUID on the new array. It doesn't appear 
>> that uuid= works with create (why?), or that stopping the array and then 
>> using assemble with uuid= will renumber the array in the superblock.
>>     
>
>  --update=uuid
>
>   
>> What's the correct way to do this, or is it broken? And why can't I 
>> specify uuid= in create?
>>     
>
> Added to my 'todo' list - but no promises.

Before I tell you that doesn't work, could you provide a complete 
command line you expect to work rather than just one argument? Showing 
the array designator and the location of the actual new UUID to use? We 
think we have tried every combination of array name or array components 
in every order, and other than a fine collection of error messages have 
not had any luck.

We would look at the example but found none.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

