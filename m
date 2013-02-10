From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Sat, 9 Feb 2013 23:59:15 -0700
Message-ID: <201302092359.15280.thomas@fjellstrom.ca>
References: <201212212357.19292.thomas@fjellstrom.ca> <50F66BDB.3000203@anonymous.org.uk> <50F71BA4.40900@hardwarefreak.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F71BA4.40900@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: stan@hardwarefreak.com, Phil Turmel <philip@turmel.org>, Chris Murphy <lists@colorremedies.com>, Tommy Apel Hansen <tommyapeldk@gmail.com>
List-Id: linux-raid.ids

On January 16, 2013, Stan Hoeppner wrote:
[snip]
> This is the reason why RAID6 performs so horribly with mixed read/write
> workloads.  Using Thomas' example, while he was doing a streaming read
> of a media file and simultaneously doing non-aligned writes from a P2P
> or other application, md is performing a RMW operation during each
> write, adding substantially to the seek burden on the drives.  RAID5/6
> use rotating parity, so he also has an extra seek on each of two drives
> occurring, competing with the read seeks of his streaming app.  Consumer
> 7.2K drives aren't designed to handle this type of random seek load with
> good performance.

Re-reading through this thread (I have a bit of spare time this weekend), I 
finally understood what you wrote there. I'm not normally quite this dense, 
and I appologise. The RMW ops and double seek penalties are really quite 
harsh.

> If using RAID10 or RAID0 over RAID1, there is no RMW penalty for partial
> stripe width writes, and no extra seek burden for the parity writes, as
> described above for RAID5/6.  Thus it doesn't cause the playback stutter
> as the disks can service the read and write requests without running out
> of head seek bandwidth as parity arrays do due to RMW and parity block
> writes.
> 
> In summary, with Thomas' old disk system, he would have most likely
> avoided the playback stutter simply by using a non-parity RAID level.
> 
> I'm constantly amazed by the fact that so many people here using parity
> RAID don't understand the performance impact of these basic parity RAID
> IO behaviors, and how striping actually works, and the fact that most
> often they're not writing full stripes, and thus not benefiting from
> their spindle count.

I actually do/did have a decent understanding of how raid5 works, and why its 
slower than a lay-person would intuit. The extra seeking, the RMW, and for 
software raid, the parity calculations. What's happened is I didn't expand 
that up to how raid6 obviously works, with an extra parity set interleaved 
with the data. *sigh*

Complete face palm moment.

In the future, if I need more performance than what I'll get out of this 
setup, I'll move to smaller drives (with ERC, and low URE rates), in raid10. 
If I had a couple/few extra bays in this box, I'd be very tempted to go raid10 
right now.

As I haven't noticed any stuttering with my "old" 5.5TB (7x1TB) array, I 
somehwat doubt I'll notice any on my new 11TB array (7x2TB, switched to raid5, 
as with the backup array, I probably don't need/want the extra parity, if two 
drives do die at the same time, I still have a backup copy of most/all of the 
data, and can just restore it).

Thank you Stan, Chris, Phil, and Tommy for the help and insight. It was all 
very helpful.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
