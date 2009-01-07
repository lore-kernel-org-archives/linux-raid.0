From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: failed raid5 after ide cable malfunction.
Date: Wed, 7 Jan 2009 13:18:32 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901071316170.29147@p34.internal.lan>
References: <003301c970e8$1c6d2b90$554782b0$@de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <003301c970e8$1c6d2b90$554782b0$@de>
Sender: linux-raid-owner@vger.kernel.org
To: stephan sperber <quinte17@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 7 Jan 2009, stephan sperber wrote:

> Hello everybody!
> I have a little trouble in getting the raid5 up and running again.
> What has happened so far:
> 1. Booting the System
> 2. Ide cable had some troubles so 2 disks went "mad" during boot and raid
> couldn't get assembled.
> (/dev/sda4 /dev/sdb2)
> 3. I forced poweroff because system wasn't responsible due to ATA connection
> problems.
> 4. after reboot the raid5 got up again, were clean, but attempted a resync.
> 5. during the resync the cable had troubles again, so those 2 devices were
> marked as spare.
> 6. i forced a poweroff again and reseated the cable.
> 7. I booted again but now all devices of the raid were marked as spare.
>
> Is there a possibility to get the raid active without dataloss?
>
> Here some infos:
> cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4]
> [raid10]
> md1 : inactive sdc2[2](S) sdb2[1](S) sda4[0](S)
>      709140864 blocks
>
> unused devices: <none>
>
> mdadm --detail /dev/md1
> mdadm: md device /dev/md1 does not appear to be active.
>
> Thx in advance
> Stephan
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Example (use your disks obviously):

# mdadm --assemble --force /dev/md3 /dev/sd[c-l]1

If that does not work, you can use Neil's advice from another thread:

> Your only option at this stage is to re-create the array with the best
> devices.  Create it will one device missing so that it won't try a
> resync.
> e.g.

>  mdadm -C /dev/md0 -l5 -n5 /dev/hde1 /dev/hdg1 /dev/hdi1 missing /dev/sda1

You would want -C /dev/md1 -l5 -n3 and then specify only two of the disks
with one "missing"

See if this does it for you?

Justin.




