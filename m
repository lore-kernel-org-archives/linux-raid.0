From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Removing devices from RAID-5
Date: Thu, 14 Jun 2007 15:15:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706141515060.23451@p34.internal.lan>
References: <m3ejkel7yy.fsf@shadow.org.uk> <Pine.LNX.4.64.0706141422580.3306@p34.internal.lan>
 <m3abv2jrfy.fsf@shadow.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m3abv2jrfy.fsf@shadow.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Rich Walker <rw@shadowrobot.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 14 Jun 2007, Rich Walker wrote:

> Justin Piszcz <jpiszcz@lucidpixels.com> writes:
>
>> On Thu, 14 Jun 2007, Rich Walker wrote:
>
> [snip]
>>>
>>> The array is used as a single PV/VG for LVM.
>>>
>>> What I want to do is to
>>> (a) reduce the PV/VG so it would fit in 160*3 rather than 160*4
>>> (b) remove the last 160GB drive, (hdi), taking the array from 4+1 to 4+0
>>> (c) rearrange the array from 4+0 to 3+1
>>> (d) grow the array to 250*3
>>> (e) enlarge the PV/VG again.
>>>
>>> I would think that
>>> mdadm --grow --raid-devices=4 -z max /dev/md1 /dev/hdg2 /dev/hde2 /dev/sda2 /dev/hdk2
>>> would do steps (b),(c),(d) in one go - is this correct?
>>>
>>> The linux kernel version running is 2.6.21.3 SMP.
>>
>> As far as I know you cannot shrink any md raid in Linux.
>>
>> Justin.
>
> Step (c) shrinks the array, which would be a problem.
>
> But the mdadm command given *should* actually grow the array (from 640GB
> to 750GB) whilst reducing the number of disks...
>
> Is this likely to work?
>
> mdadm says:
>
> thoth:/--# mdadm --grow --help
> Usage: mdadm --grow device options
>
> This usage causes mdadm to attempt to reconfigure a running array.
> This is only possibly if the kernel being used supports a particular
> reconfiguration.  This version only supports changing the number of
> devices in a RAID1, and changing the active size of all devices in
> a RAID1/4/5/6.
>
> Options that are valid with the grow (-G --grow) mode are:
>  --size=        -z   : Change the active size of devices in an array.
>                      : This is useful if all devices have been replaced
>                      : with larger devices.
>  --raid-disks=  -n   : Change the number of active devices in a RAID1
>                      : array.
> thoth:/--# mdadm -V
> mdadm - v2.5.6 - 9 November 2006
> thoth:/--#
>
> which makes me think it wouldn't...
>
> cheers, Rich.
>
> -- 
> rich walker         |  Shadow Robot Company | rw@shadow.org.uk
> technical director     251 Liverpool Road   |
> need a Hand?           London  N1 1LX       | +UK 20 7700 2487
> www.shadowrobot.com/hand/overview.shtml
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

You can try it, otherwise grab the latest version of mdadm and go ahead 
and grow it.  I have grown a 1.8TB array to 3.3TB and it was a pretty old 
version of mdadm.

Justin.
