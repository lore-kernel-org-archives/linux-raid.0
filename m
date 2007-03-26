From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Swap initialised as an md?
Date: Sun, 25 Mar 2007 23:45:53 -0400
Message-ID: <460741F1.5060407@tmr.com>
References: <20061110102955.ljws9mgxf4o4kgw8@my.pengus.net> <460436F1.2080003@tmr.com> <460439FE.8070605@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <460439FE.8070605@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: David <lists@edeca.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Bill Davidsen wrote:
> []
>   
>> If you use RAID0 on an array it will be faster (usually) than just
>> partitions, but any process with swapped pages will crash if you lose
>> either drive. With RAID1 operation will be more reliable but no faster.
>> If you use RAID10 the array will be faster and more reliable, but most
>> recovery CDs don't know about RAID10 swap. Any reliable swap will also
>> have the array size smaller than the sum of the partitions (you knew that).
>>     
>
> You seems to forgot to mention 2 more things:
>
>  o swap isn't usually needed for recovery CDs
>   
That's system dependent, but at least two report problems with swap if 
configured as RAID10. Confusing error messages are not a plus when you 
get to the stage of using a recovery CD. The need for swap depends on 
configuration.
>  o kernel vm subsystem already can do equivalent of raid0 for swap internally,
>    by means of allocating several block devices for swap space with the
>    same priority.
>
> If reliability (of swapped processes) is important, one can create several
> RAID1 arrays and "raid0 them" using regular vm techniques.  The result will
> be RAID10 for swap.

Sorry, no. It will be RAID0+1, not the same thing. See RAID10 description.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

