From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Linear raid extend component
Date: Sun, 30 Dec 2012 22:23:22 -0600
Message-ID: <50E1133A.9060000@hardwarefreak.com>
References: <CE9AB803-93DD-4A9A-BA97-FD5F323833DE@websitemanagers.com.au> <E2F855BB-D735-4186-8A0A-92DB8024A5DE@colorremedies.com> <50DF5168.9050703@hardwarefreak.com> <8C403E78-26FA-4FF7-AE77-A2E2A81AF56A@colorremedies.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8C403E78-26FA-4FF7-AE77-A2E2A81AF56A@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/29/2012 3:52 PM, Chris Murphy wrote:
> 
> On Dec 29, 2012, at 1:24 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>> On 12/29/2012 12:14 PM, Chris Murphy wrote:
>>>
>>> On Dec 29, 2012, at 4:44 AM, Adam Goryachev <adam@websitemanagers.com.au> wrote:
>>>
>>>>
>>>> Then when complete:
>>>> mdadm --grow /dev/md3 --size=max
>>>
>>> In a VM I'm unable to get a linear device to grow. I think you can only grow linear by adding devices. You could partition the 3TB such that the 1st partition matches the total sectors of the partition on the replaced 1TB drive; then add the 2TB partition of the 3TB drive onto the end of the linear array. It'd work, but it's a weird configuration. You're better off reverting to the original setup, and adding the 3TB drives at the end, then growing the file system.
>>
>> Somebody posted the same scenario a few weeks ago.  The only 'proper'
>> way to do this is to swap out the drives in the last RAID1 pair in the
>> linear array.
> 
> I haven't tried this, but man mdadm says about linear:
> 
> "If the target array is a Linear array, then --add can be used to add one or more devices to the array. They are simply catenated on to the end of the array. Once added, the devices cannot be removed."
> 
> So in any case it seems he'd have to partition that 3TB disk. But at least by adding it at the end of the linear array, the 3TB disk's 2nd partition at 2TB is linearly arranged within the linear array. So the same LBAs are used in any case, whether two partitions or one. And even if an XFS AG were bisected by the partitioning, since it's linearly arranged, offhand I see no performance downside to this.
> 
> Making the linear array effectively non-linear by adding some earlier disk's 2nd partition to the end of the linear array would cause disk contention if XFS is being used; maybe it's negligible depending on the usage. And likely negligible if a non-parallel fs is being used. *shrug* But it's a confusing arrangement for any sysadmin, current or the one who inherits the beginnings of such a rat's nest.

Yeah, it's ugly no matter what, for everyone.  Which is why I recommend
against doing such a thing, no matter which FS is used atop.

> So when growing an XFS volume, does it add more AG's automatically when it sees additional underlying devices?

XFS allocation group size is fixed, static.  When growing an XFS new AGs
are created in the new free space.  And to be clear, XFS doesn't see
additional underlying devices.  It simply sees more unallocated sectors
at the end of the current device, that being a concat or striped array.

-- 
Stan

