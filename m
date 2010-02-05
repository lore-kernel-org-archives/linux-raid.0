From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: If your using large Sata drives in raid 5/6 ....
Date: Fri, 05 Feb 2010 12:12:53 -0500
Message-ID: <4B6C5195.6080903@tmr.com>
References: <87f94c371002021440o3b30414bk3a7ccf9d2fa9b8af@mail.gmail.com>	 <87f94c371002021446y38dce6fds6acca2b4919ad773@mail.gmail.com>	 <4B698365.1040007@anonymous.org.uk> <4B6C3B7D.2090502@tmr.com> <87f94c371002050814v6352826er4f079f436068852@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c371002050814v6352826er4f079f436068852@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Greg Freemyer wrote:
> On Fri, Feb 5, 2010 at 10:38 AM, Bill Davidsen <davidsen@tmr.com> wrote:
> <snip>
>   
>>>> The good news is that Western Digital is apparently introducing a new
>>>> series of drives with an error rate "2 orders of magnitude" better
>>>> than the current generation.
>>>>         
>>> It's not borne out in their figures; WD quote "less than 1 in 10^15 bits"
>>> which is the same as they quote for their older drives.
>>>
>>> What sums I've done, on the basis of a 1 in 10^15 bit unrecoverable error
>>> rate, suggest you've a 1 in 63 chance of getting an uncorrectable error
>>> while reading the whole surface of their 2TB disc. Read the whole disc 44
>>> times and you've a 50/50 chance of hitting an uncorrectable error.
>>>
>>>       
>> Rethink that, virtually all errors happen during write, reading is
>> non-destructive, in terms of what's on the drive. So it's valid after write
>> or it isn't, but having been written correctly, other than failures in the
>> media (including mechanical parts) or electronics, the chances of "going
>> bad" are probably vanishingly small. And since "write in the wrong place"
>> errors are proportional to actual writes, long term storage of unchanging
>> data is better than active drives with lots of change.
>>     
>
> Bill,
>
> I thought writes went to the media unverified.  Thus if you write data
> to a newly bad sector you won't know until some future point when you
> try to read it.
>
> During the read is when the bad CRC is detected and the sector marked
> for future relocation.  The relocation of course does not happen until
> another write comes along.  Thus the importance of doing a background
> scan routinely to detect bad sectors and when encountered to rebuild
> the info from other drives and then rewrite it thus triggering the
> remapping to a spare sector.
>
> If I've got that wrong, I'd appreciate a correction.
>   

No, modern drives are less robust than "read after write" tech used in 
the past, but what I was mentioning is that the "Read the whole disc 44 
times" idea, the chances or a good read being followed by a bad read are 
smaller than the chance of a fail during the first read after a write.

The whole idea of using larger sectors is hardly new, back in the days 
of eight inch floppy disks capacity was increased by going to large 
sectors, and eventually speed was boosted by using track buffers and 
reading an entire track into cache and delivering 256 byte "sectors" 
from that. And on writes, the data was modified in the buffer, then the 
modified 256 bytes pseudo sectors were tracked using a bitmap which 
flagged which 1k hardware sectors were dirty, or the whole track could 
be rewritten.

I wrote code to do that using 128k bank select memory from CCS in the 
late 70's, and sold enough hardware to buy a new car. So there is little 
new under the sun, the problem of handling small pseudo sectors has been 
studied for ages, and current hardware allows the solution to go into 
the drive itself, just like the variable number of sectors per track 
(although everyone uses LBA now).

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

