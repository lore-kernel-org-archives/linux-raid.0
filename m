From: David Greaves <david@dgreaves.com>
Subject: Re: Strange behaviour on "toy array"
Date: Tue, 17 May 2005 09:41:36 +0100
Message-ID: <4289AE40.4090201@dgreaves.com>
References: <200505170228.j4H2Sim20649@www.watkins-home.com> <42898989.8060201@ucolick.org> <42899947.6080107@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42899947.6080107@ucolick.org>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik Jonsson <patrik@ucolick.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

IIRC, Neil submitted a fix for this looping very recently.

yup - 13/May/05 03:55

>Thanks for the ping, things sometimes get lost in the noise....
>
>This sounds a bit like the problem that is addressed by 
>  md-make-raid5-and-raid6-robust-against-failure-during-recovery.patch 
>in the current -mm patches (look in the brokenout directory).
>
>This would only happen if you have multiple failed devices.  So maybe
>while the rebuild was happening, another device failed (which seems to
>happen more and more as device sizes are increasing and reliability is
>going the other way).
>
>Could this (another drive failure) be the case?
>
>NeilBrown
>  
>

I would say that there's been a fair amount of bug fixing activity since
2.6.9 and mdadm 1.6
I'd be happy with them for 'simple' ext3 over md but I'm pretty damned
sure that you'll have problems with xfs and/or lvm2

I _strongly_ suggest 2.6.11.xx and mdadm 1.9 if you'll be playing with
xfs and or lvm2 (which I suggest you do for the system you described)



David



Patrik Jonsson wrote:

> Just as a further comment on what happened when my system hung: The
> process [md0_sync] was rapidly respawning and the syslog filled with
> thousands of messages like these:
>
> May 16 23:16:44 localhost kernel: md: syncing RAID array md0
> May 16 23:16:44 localhost kernel: md: minimum _guaranteed_
> reconstruction speed\
> : 1000 KB/sec/disc.
> May 16 23:16:44 localhost kernel: md: using maximum available idle IO
> bandwith \
> (but not more than 200000 KB/sec) for reconstruction.
> May 16 23:16:44 localhost kernel: md: using 128k window, over a total
> of 960 bl\
> ocks.
> May 16 23:16:44 localhost kernel: md: md0: sync done.
> May 16 23:16:44 localhost kernel: md: syncing RAID array md0
> May 16 23:16:44 localhost kernel: md: minimum _guaranteed_
> reconstruction speed\
> : 1000 KB/sec/disc.
> May 16 23:16:44 localhost kernel: md: using maximum available idle IO
> bandwith \
> (but not more than 200000 KB/sec) for reconstruction.
> May 16 23:16:44 localhost kernel: md: using 128k window, over a total
> of 960 bl\
> ocks.
> May 16 23:16:45 localhost kernel: md: md0: sync done.
> ... etc etc...
>
> I had to halt the system to make it stop. I tried to stop the array
> with mdadm -S /dev/md0 but got "device or resource busy". Did i do
> something illegal here?
>
> Thanks,
>
> /Patrik


