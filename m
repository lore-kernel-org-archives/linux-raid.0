From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Help a Newbie on Linux-Raid 1
Date: Sat, 13 Dec 2008 19:55:08 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812131952450.20605@p34.internal.lan>
References: <20995732.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20995732.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: dturner <dan@voiceweather.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 13 Dec 2008, dturner wrote:

>
> I am rather new to linux and decided to set up a system using linux raid on
> centos 5.2  Being new I find some howtos easy to follow and I used one in
> setting up the raid. All looked fine when I finished and everything was was
> in order showing working raid and then I did a stupid thing and stopped the
> machine to make sure each drive could boot. Stopping the machine between
> drive swaps. THis all worked well then I configured the machine and a few
> days latter I noticed that the raid was showing degraded on both drives.
>
> Now being a newbie I am in a bind. The machine is still running and after
> spending many hours configuring it, I do not want to screw it up so I look
> to someone with lots more knowledge than I for help.
>
> Please help with full command lines to solve this issue and get the raid
> rebuilt as I do not want to screw anything up. I have included the
> information on the system below. If anything else is needed please let me
> know.
>
> Many thanks in advance guys.....
>
> Dan
Assuming nothing is bad with the other drive, you just need to add it back 
into the RAID-1 array (after you are done testing)

mdadm /dev/md0 -a /dev/sda1
mdadm /dev/md1 -a /dev/sda2

This will re-add the other drive partitions back into the raid1 array.

It will not re-add automatically if you disconnected one drive to test
the RAID-1 functionality.

>
> SCSI device sda: drive cache: write back
> sda: sda1 sda2
        ^^^^^^^^^
> SCSI device sdb: drive cache: write back
> sdb: sdb1 sdb2
        ^^^^^^^^^

Justin.

