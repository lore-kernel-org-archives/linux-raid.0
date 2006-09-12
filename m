From: "Ruth Ivimey-Cook" <Ruth.Ivimey-Cook@ivimey.org>
Subject: RE: Correct way to create multiple RAID volumes with hot-spare?
Date: Tue, 12 Sep 2006 23:25:12 +0100
Message-ID: <000001c6d6ba$50819ad0$0e00a8c0@sherlock>
References: <4507212E.3060703@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4507212E.3060703@maine.edu>
Sender: linux-raid-owner@vger.kernel.org
To: 'Steve Cousins' <steve.cousins@maine.edu>, 'Neil Brown' <neilb@suse.de>
Cc: 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Steve, 

> The recent "Messed up creating new array..." thread has 
> someone who started by using the whole drives but she now 
> wants to use partitions because the array is not starting 
> automatically on boot (I think that was the symptom).  I'm 
> guessing this is because there is no partigion ID of "fd" 
> since there isn't even a partition.

Yes, that's right.

> I'm on the verge of re-doing this array with 11 full drives 
> (/dev/sd? as opposed to /dev/sd?1 and /dev/sd?2).  Will I 
> have the same problems with booting?  I like the idea of not 
> having to partition the drives but not if it is going to 
> cause hassles.  I realize that there could be a potential 
> problem if I need to replace a drive with a slightly 
> different model that is slightly smaller.

That's the reason I ended up re-creating the array from backup, using
partitions.

You _can_ use raw disks, but it's not as easy. I worked out that I was
originally having problems because my mdadm.conf file had the right drives
(/dev/sdc ...) in the ARRAY line, but didn't have the same drives listed in the
DEVICES line.

I would suggest you do use partitions.

Ruth

