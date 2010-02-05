From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: If your using large Sata drives in raid 5/6 ....
Date: Fri, 5 Feb 2010 11:14:17 -0500
Message-ID: <87f94c371002050814v6352826er4f079f436068852@mail.gmail.com>
References: <87f94c371002021440o3b30414bk3a7ccf9d2fa9b8af@mail.gmail.com>
	 <87f94c371002021446y38dce6fds6acca2b4919ad773@mail.gmail.com>
	 <4B698365.1040007@anonymous.org.uk> <4B6C3B7D.2090502@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B6C3B7D.2090502@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Feb 5, 2010 at 10:38 AM, Bill Davidsen <davidsen@tmr.com> wrote:
<snip>
>>> The good news is that Western Digital is apparently introducing a new
>>> series of drives with an error rate "2 orders of magnitude" better
>>> than the current generation.
>>
>> It's not borne out in their figures; WD quote "less than 1 in 10^15 bits"
>> which is the same as they quote for their older drives.
>>
>> What sums I've done, on the basis of a 1 in 10^15 bit unrecoverable error
>> rate, suggest you've a 1 in 63 chance of getting an uncorrectable error
>> while reading the whole surface of their 2TB disc. Read the whole disc 44
>> times and you've a 50/50 chance of hitting an uncorrectable error.
>>
> Rethink that, virtually all errors happen during write, reading is
> non-destructive, in terms of what's on the drive. So it's valid after write
> or it isn't, but having been written correctly, other than failures in the
> media (including mechanical parts) or electronics, the chances of "going
> bad" are probably vanishingly small. And since "write in the wrong place"
> errors are proportional to actual writes, long term storage of unchanging
> data is better than active drives with lots of change.

Bill,

I thought writes went to the media unverified.  Thus if you write data
to a newly bad sector you won't know until some future point when you
try to read it.

During the read is when the bad CRC is detected and the sector marked
for future relocation.  The relocation of course does not happen until
another write comes along.  Thus the importance of doing a background
scan routinely to detect bad sectors and when encountered to rebuild
the info from other drives and then rewrite it thus triggering the
remapping to a spare sector.

If I've got that wrong, I'd appreciate a correction.

Greg
