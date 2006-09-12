From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: Correct way to create multiple RAID volumes with hot-spare?
Date: Tue, 12 Sep 2006 17:05:50 -0400
Message-ID: <4507212E.3060703@maine.edu>
References: <44EB5579.4020200@maine.edu> <17644.55759.763091.379642@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17644.55759.763091.379642@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Neil Brown wrote:
> On Tuesday August 22, steve.cousins@maine.edu wrote:
 >>
>>Maybe I shouldn't be splitting the drives up into partitions.  I did 
>>this due to issues with volumes greater than 2TB.  Maybe this isn't an 
>>issue anymore and I should just rebuild the array from scratch with 
>>single partitions.  Or should there even be partitions? Should I just 
>>use /dev/sd[abcdefghijk] ?
>>
> 
> 
> I tend to just use whole drives, but your set up should work fine.
> md/raid isn't limited to 2TB, but some filesystems might have size
> issues (though i think even ext2 gots to at least 8 TB these days).

The recent "Messed up creating new array..." thread has someone who 
started by using the whole drives but she now wants to use partitions 
because the array is not starting automatically on boot (I think that 
was the symptom).  I'm guessing this is because there is no partigion ID 
of "fd" since there isn't even a partition.

I'm on the verge of re-doing this array with 11 full drives (/dev/sd? as 
opposed to /dev/sd?1 and /dev/sd?2).  Will I have the same problems with 
booting?  I like the idea of not having to partition the drives but not 
if it is going to cause hassles.  I realize that there could be a 
potential problem if I need to replace a drive with a slightly different 
model that is slightly smaller.

Thanks,

Steve
-- 
______________________________________________________________________
  Steve Cousins, Ocean Modeling Group    Email: cousins@umit.maine.edu
  Marine Sciences, 452 Aubert Hall       http://rocky.umeoce.maine.edu
  Univ. of Maine, Orono, ME 04469        Phone: (207) 581-4302


