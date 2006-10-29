From: Matt Thrailkill <matt@modestolan.com>
Subject: Re: Raid 0 breakage (maybe)
Date: Sun, 29 Oct 2006 15:06:15 -0800
Message-ID: <1162163175.17928.14.camel@stoneburner.xwredwing.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Actually I kind of fixed it last night.  I found a posting by someone
on an older Ubuntu release with a similar problem, and he resolved it
by making loopback devices pointing at his constituent drives, and then
assembled the array using those.  That works for me also, so the array
is running now.. but off of loopback devices instead of the direct raw
disks.  Before I did that, proc/mdstat was empty.  I just now looked in
/sys/block/hde/holders, but I don't know how to read it.

> This is telling you that /dev/hde - or one of it's partitions - is
> "Busy".  This means more than just 'open'.  It means mounted or
> included in an md or dm array, or used for swap.
> You need to find out what is keeping it busy.
> Most likely dm or md.
> What does
>   cat /proc/mdstat
> show?
> I don't know much about dm - is there some 'pvlist' command or similar
> that will show all the phys volumes it is holding on to..
> 
> Or possibly just look in /sys/block/hde/holders
-- 
Matt Thrailkill <matt@modestolan.com>

