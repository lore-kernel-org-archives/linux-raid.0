From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Disk I/O error while rebuilding an md raid-5 array
Date: Tue, 09 Feb 2010 11:57:06 +0000
Message-ID: <4B714D92.2090802@anonymous.org.uk>
References: <adf93d751002081523y1b9de656kdbba276b3dbc6af4@mail.gmail.com> <87f94c371002081604g37984161h2ba65bd193714780@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c371002081604g37984161h2ba65bd193714780@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Dawning Sky <the.dawning.sky@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/02/2010 00:04, Greg Freemyer wrote:
>> PS, if in the end I have to build a new array, I'll probably go with a
>> raid 6 instead.
> 
> Agreed, someone recently posted that for a raid-5 composed of 1TB
> drives the odds of a rebuild failure are 1 in 67 even if the remaining
> drives are within spec.  (ie. the unrecoverable bit error rate is
> slowing succumbing to the ever increasing size of drives.)

Actually the odds were 1 in 67 of an unrecoverable read error while 
reading 2TB of data, if the odds were 1 in 10^15 per bit read[1], which 
was the worst-case spec offered by Western Digital. Others disagreed 
with my analysis, and I may be wrong.

This was nothing to do with RAID, but my suggestion followed on that 
RAID-5 was now only useful for defending against unrecoverable errors, 
and not dead drives, and if you wanted to defend against dead drives as 
well you need RAID-6.

> You have 500GB drives, but you have 3 left to rebuild from, so that's
> 1.5 TB your trying to read.  I'm not sure how the original calculation
> was done, so your odds of failed rebuild were either 1 in 134 or about
> 1 in 42.  Either not very good for something that is supposed to
> protect your data.

Actually there are 4 to read from - the original sde is still available. 
This would be a situation where I think having the hot-rebuild facility 
recently discussed on this list would be ideal, as if you can't read the 
data from the drive you're hot-replacing, you then get a second chance 
to read it from the rest of the drives using the parity information, and 
the odds of an unrecoverable read error at the same LBA on two drives is 
smaller - but I can't remember that bit of the probability course I did 
years ago to work out exactly what it is.

Cheers,

John.

[1] If the probability of an error while reading 1 bit is p, then the 
probability of an error while reading n bits is 1-(1-p)^n. In this case 
p=1E-15, n=1.6E13 and you need a scientific calculator to do the sum.
