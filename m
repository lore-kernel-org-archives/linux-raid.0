From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Linear raid extend component
Date: Sat, 29 Dec 2012 14:24:08 -0600
Message-ID: <50DF5168.9050703@hardwarefreak.com>
References: <CE9AB803-93DD-4A9A-BA97-FD5F323833DE@websitemanagers.com.au> <E2F855BB-D735-4186-8A0A-92DB8024A5DE@colorremedies.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E2F855BB-D735-4186-8A0A-92DB8024A5DE@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/29/2012 12:14 PM, Chris Murphy wrote:
> 
> On Dec 29, 2012, at 4:44 AM, Adam Goryachev <adam@websitemanagers.com.au> wrote:
> 
>>
>> Then when complete:
>> mdadm --grow /dev/md3 --size=max
> 
> In a VM I'm unable to get a linear device to grow. I think you can only grow linear by adding devices. You could partition the 3TB such that the 1st partition matches the total sectors of the partition on the replaced 1TB drive; then add the 2TB partition of the 3TB drive onto the end of the linear array. It'd work, but it's a weird configuration. You're better off reverting to the original setup, and adding the 3TB drives at the end, then growing the file system.

Somebody posted the same scenario a few weeks ago.  The only 'proper'
way to do this is to swap out the drives in the last RAID1 pair in the
linear array.

The whole point of the linear array, or concatenation, is to constantly
add drives to expand.  Swapping drives in a concat with larger units was
never anticipated as a valid growth option.  As Chris states, you can do
this with partitions, but it is not elegant.

Since your total array size is ~3TB, if you're using XFS, you could
simply do a dump to one of the new 3TB drives.  Afterwards you can
simply blow away everything and start over, creating a RAID1 with the
remaining 3TB drive but with a missing drive.  Then create the RAID1
with the 2x 2TB drives.  Then create the linear array and format it.
Then do a restore of the XFS filesystem.  Then add the 3TB drive to the
missing RAID1.

You can do the same thing with any filesystem but you'll be using 'cp
-a' or rsync, etc, to move the files around, which is much slower.

-- 
Stan

