From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: xosview
Date: Mon, 1 Aug 2016 20:25:17 +0100
Message-ID: <579FA21D.5000307@youngman.org.uk>
References: <ffd06b83-0692-d5a4-1daa-126abf53edfa@youngman.org.uk>
 <579F9A00.6000906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <579F9A00.6000906@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks very much to all who replied :-)

The author is planning to rewrite based on /sys, however, so mdstat's
are likely no longer required ... the original raid code was donated,
and seems to have bit-rotted :-(

What I've said I'd like to see is the raid name and status - healthy,
rebuilding or degraded on the left; with the constituent
drives/partitions listed on the right, over colour bars indicating their
status (live, rebuilding, failed or spare). The author would also like
to add a status bar indicating the status of any rebuild.

So a healthy raid would be indicated by (default colours) green and
maybe blue for spare drives, while a degraded array would have red
around, and a rebuilding array would have yellow.

Anybody have any other ideas?

I know I'm bad at checking my raid status, and a lot of people probably
let the default install set up raid on a desktop without configuring
notification etc. It's just lovely to have a little utility like xosview
that can sit in the background on your desktop keeping an eye on things.
And that shows up instantly when things start going wrong. It keeps an
eye on my cpus, memory, swap space, and i/o. It could probably keep an
eye on more ...

Cheers,
Wol

On 01/08/16 19:50, Bill Hudacek wrote:
> Anthony Youngman wrote on 07/29/2016 12:52 PM:
>> So if people wouldn't mind, could you email your mdstat files?
>> Preferably on the list so people can see what has and has not been sent
>> - obviously I'd like standard setups like raid10, raid5, raid6, both
>> named and numbered. And if people have them, mdstats showing broken
>> arrays, rebuilds, complicated setups with lvm, etc.
>>
> 
> RAID 6 across 5 disks, of which 1 is a spare (in external cabinet), and
> two disks in RAID-1 (for OS, inside the tower):
> 
>> cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md0 : active raid6 sdc1[0] sdf1[3] sdd1[1] sdg1[4](S) sde1[2]
>       3071737856 blocks super 1.2 level 6, 1024k chunk, algorithm 2
> [4/4] [UUUU]
>       bitmap: 0/12 pages [0KB], 65536KB chunk
> 
> md126 : active raid1 sdb1[1] sda1[0]
>       2099136 blocks super 1.0 [2/2] [UU]
>       bitmap: 0/1 pages [0KB], 65536KB chunk
> 
> md127 : active raid1 sdb2[1] sda2[0]
>       234921984 blocks super 1.2 [2/2] [UU]
>       bitmap: 1/2 pages [4KB], 65536KB chunk
> 
> unused devices: <none>
> 
> I don't have any failure mdstat output saved, sorry...
> 

