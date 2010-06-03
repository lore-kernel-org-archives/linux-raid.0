From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: devices get kicked from RAID about once a month
Date: Thu, 03 Jun 2010 12:37:34 -0400
Message-ID: <4C07DA4E.70501@tmr.com>
References: <87k4qho723.fsf@uwo.ca>	<628039470-1275491015-cardhu_decombobulator_blackberry.rim.net-326486810-@bda837.bisx.prod.on.blackberry>	<876321o3lm.fsf@uwo.ca> <4C067AD6.7040700@anonymous.org.uk>	<871vcpo0n6.fsf@uwo.ca> <4C069813.3010308@tmr.com> <87sk55mijx.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87sk55mijx.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Christensen wrote:
> Bill Davidsen <davidsen@tmr.com> writes:
>
>   
>> Presumably something shows in the logs, that's the next place to look.
>>     
>
> I believe my drives simply don't support adjusting the time it takes to
> try to recover a read (CCTL).  Or did you mean the logs at the time of
> failure?  If so, I posted those in the original message.
>
>   
Those logs don't show any information useful to me which tells me how 
long md waited, and I'm not able to parse any of the res: information to 
gain clarity. It would be nice if someone can parse that, but I can't. 
On timeout an elapsed time output would be nice to indicate what the 
time limit is.

But I do have desktop drives in raid arrays, and they do spin down when 
not in use, and when I access the array after it's been unused I get a 
multi-second delay before my ls info comes back, so clearly there are 
some paths in the SATA handling which don't easily time out.

> Have there been any kernel changes since 2.6.28 that might improve
> reliability of my set-up?  It would be nice if md could be told to try
> again before giving up on the drives.
>
>   
Don't know, Neil might. I sure would like to see a timeout in ms in the 
/sys for the device and a flag for the array to not kick a drive for 
timeout until some number of consecutive timeouts have occurred. Note 
that I'm not suggesting some particular implementation, just some 
tunables. And if only one sector times out, a delayed reconstruct and 
rewrite might fix it. Again, a topic for discussion, not a "do thus" 
suggestion.

I would hope that a drive with multiple partitions would get the 
partitions kicked, not the whole drive at once. So one slow sector 
wouldn't take out multiple arrays.
> Thanks for all of the help so far!
>
> Dan
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

