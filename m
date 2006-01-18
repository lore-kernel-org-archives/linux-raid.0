From: John Hendrikx <hjohn@xs4all.nl>
Subject: Re: RAID 1 vs RAID 0
Date: Wed, 18 Jan 2006 14:02:13 +0100
Message-ID: <43CE3C55.4050204@xs4all.nl>
References: <dqkie5$mf2$3@sea.gmane.org> <Pine.LNX.4.44.0601180228370.2456-100000@coffee.psychology.mcmaster.ca> <dqksi3$mf2$5@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dqksi3$mf2$5@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Max Waterman wrote:
> Mark Hahn wrote:
>>> They seem to suggest RAID 0 is faster for reading than RAID 1, and I 
>>> can't figure out why.
>>
>> with R0, streaming from two disks involves no seeks;
>> with R1, a single stream will have to read, say 0-64K from the first 
>> disk,
>> and 64-128K from the second.  these could happen at the same time, 
>> and would indeed match R0 bandwidth.  but with R1, each disk has to 
>> seek past
>> the blocks being read from the other disk.  seeking tends to be slow...
>
> Ah, a good way of putting it...I think I was pretty much there with my 
> followup message.
>
> Still, it seems like it should be a solvable problem...if you order 
> the data differently on each disk; for example, in the two disk case, 
> putting odd and even numbered 'stripes' on different platters [or 
> sides of platters].
I don't think the example above is really that much of an issue.  AFAIK, 
most hard disks will read the current track (all platters) at once as 
soon as the heads are positioned.  It doesn't even wait for the start of 
the track, it just starts reading as soon as possible and stores all of 
it in the internal buffer (it will determine the real start of the track 
by looking for markers in the buffer).  It will then return the data 
from the buffer.

Anyway, the track buffer is quite large because it needs to be able to 
hold the data from an entire track, which is usually quite a bit larger 
than the stripe size (I'd say around 1 to 2 MB).  It's highly unlikely 
that your hard disk will need to seek to read 0-64k, then 128-192k, then 
256-320k, and so on.  There's a good chance that all of that data is 
stored on the same track and can be returned directly from the buffer.  
Even if a seek is required, it would only be a seek of 1 track which are 
relatively fast compared to a random seek.

The only reason I could think of why a mirror would be slower than a 
stripe is the fact that about twice as many single track seeks are 
needed when reading huge files.  That can be avoided if you increase the 
size of the reads significantly though (for example, reading the 1st 
half of the file from one disk, and the 2nd half of the file from the 
other).

--John

