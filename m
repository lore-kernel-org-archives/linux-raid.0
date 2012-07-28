From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID10 Performance
Date: Sat, 28 Jul 2012 16:36:03 +1000
Message-ID: <50138853.5030100@websitemanagers.com.au>
References: <50115123.1020900@websitemanagers.com.au> <50123E2C.8090108@hardwarefreak.com> <50129176.3050604@websitemanagers.com.au> <5012DE22.10108@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5012DE22.10108@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 28/07/12 04:29, Stan Hoeppner wrote:
> On 7/27/2012 8:02 AM, Adam Goryachev wrote:
>> On 27/07/12 17:07, Stan Hoeppner wrote:
> 
>>> 1.  Recreate the arrays with 6 or 8 drives each, use a 64KB 
>>> chunk
>> How do you get that many drives into a decent "server"? I'm
>> using a 4RU rackmount server case, but it only has capacity for 5
>> x hot swap 3.5" drives (plus one internal drive).
> 
> Given that's a 4U chassis, I'd bet you mean 5 x 5.25" bays with 
> 3.5" hot swap carriers.

I'm not exactly sure the number of external 5.25" bays at the moment,
but at least 3, possibly 4 or 5. Currently I have a extra "chassis"
that provides 5 x 3.5" hot swap bays using 3 x 5.25" bays. I can also
get a similar unit that will convert 2 x 5.25" to 3 x 3.5" hot swap
bays....

> In that case, get 8 of these: 
> http://www.newegg.com/Product/Product.aspx?Item=N82E16822148710

Are you suggesting these drives because:
a) They perform better than the WD drives?
b) They are cheaper than the WD drives
c) give more spindles per TB
d) The physical size
e) other?

Just trying to clarify the choices, as far as I can find, the avg seek
times are almost identical, but for reason b and c, I could see the
advantage.

> and replace two carriers with two of these: 
> http://www.newegg.com/Product/Product.aspx?Item=N82E16817994142

Thank you for your suggestions.

> Providing the make/model of the case would be helpful.

Don't have it handy right now, but I think with the above suggestions
I've got enough :)

>>> 2.  Replace the 7.2k WD drives with 10k SATA, or 15k SAS 
>>> drives
>> 
>> Which drives would you suggest? The drives I have are already 
>> over $350 each (AUD)...
> 
> See above.  Or you could get 6 of these: 
> http://www.newegg.com/Product/Product.aspx?Item=N82E16822236243

Would 6 of these perform better than 8 of the above seagates at 7200rpm?

>> Would adding another 2 identical drives and configuring in RAID10
>> really improve performance by double?
> 
> No because you'd have 5 drives and you have 3 now.

Sorry, I wasn't clear. I currently am using a 2 drive RAID10 (which is
the same as a RAID1) with a hot spare. The third drive is not active.

> With 6 drives total, yes, performance will be doubled.  And BTW, 
> there is no such thing as an odd number of drives RAID10.  That's 
> actually more akin to RAID1E.  It just happens that the md/RAID 
> driver that provides it is the RAID10 driver.  You want an even 
> number of drives. Use a standard RAID10 layout, not "near" or
> "far" layouts.

Certainly :)

>> Would it be more than double (because much less seeking should 
>> give better throughput, similar I expect to performance of two 
>> concurrent reads is less than half of a single read)?
> 
> It's not throughput you're after, but latency reduction.  More 
> spindles in the stripe, or faster spindles, is what you want for a 
> high concurrency workload, to reduce latency.  Reducing latency 
> will increase the responsiveness of the client machines, and, to 
> some degree throughput, because the array can now process more IO 
> transactions per unit time.

The specific workload that performance is being measured on is
actually large file read + concurrent large file write + concurrent
small random read/write. ie, in better english:
1) Normal operations (small random read/write, low load)
2) Performance testing - copying a large file with source and
destination on the same location.

In real world application, number 2 is replaced by a once weekly
"maintenance procedure" that essentially is a backup (copy large file
from/to same drive).

In actual fact, normal performance currently is fine, apart from this
weekly maintenance task (blackbox, I'm not allowed to know more).

The main concern is that once we add a SQL server, domain controller,
and 2 XP VM's, it will further increase the stress on the system.

>> If using SSD's, what would you suggest to get 1TB usable space? 
>> Would 4 x Intel 480GB SSD 520 Series (see link) in RAID10 be the 
>> best solution? Would it make more sense to use 4 in RAID6 so
>> that expansion is easier in future (ie, add a 5th drive to add
>> 480G usable storage)?
> 
> I actually wouldn't recommend SSDs for this server.  The
> technology is still young, hasn't been proven yet for long term
> server use, and the cost/GB is still very high, more than double
> that of rust.
> 
> I'd recommend the 10k RPM WD Raptor 1TB drives.  They're sold as 
> 3.5" drives but are actually 2.5" drives in a custom mounting 
> frame, so you can use them in a chassis with either size of hot 
> swap cage.  They're also very inexpensive given the performance 
> plus capacity.

Would you suggest that these drives are reliable enough to support
this type of usage? We are currently using enterprise grade drives...

> I'd also recommend using XFS if you aren't already.  And do NOT
> use the metadata 1.2 default 512KB chunk size.  It is horrible for 
> random write workloads.  Use a 32KB chunk with your md/RAID10 with 
> these fast drives, and align XFS during mkfs.xfs using -d options 
> su/sw.

Not using XFS at all, it's just plain raw disk space from MD, LVM2,
and exported via iSCSI, the client VM will format (NTFS) and use it.

>> PS, thanks for the reminder that RAID10 grow is not yet 
>> supported, I may need to do some creative raid management to 
>> "grow" the array, extended downtime is possible to get that done 
>> when needed...
> 
> You can grow a RAID10 based array:  join 2 or more 4 drive RAID10s 
> in a --linear array.  Add more 4 drive RAID10s in the future by 
> growing the linear array.  Then grow the filesystem over the new 
> space.

Does a 8 drive RAID10 look like:
A A B B C C D D
...
W W X X Y Y Z Z

OR

A A B B W W X X
...
C C D D Y Y Z Z

In other words, does RAID10 with 8 drives write 4 x as fast as a
single drive (large continuous write) by splitting it into 4 stripes
and writing each stripe to a pair of drives.

Just in case I'm being silly, could I create a 8 drive RAID10 array
using the drives you suggested above, giving 4TB usable space, move
the existing 3 drives to the "standby" server, giving it 6 x 2TB
drives in RAID10 maybe 2 x hot spare, and 4 usable for 4TB total
usable space?

Long term, the "standby" SAN could be replaced with the same 8 x 1TB
drives, and move the 6 x 2TB drives into the disk based backup server
(not san). This would avoid wasting the drives.

Thanks again for your comments and suggestions on parts.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
