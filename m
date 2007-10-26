From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID1 resync and read errors (loop)
Date: Fri, 26 Oct 2007 06:09:54 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710260609470.711@p34.internal.lan>
References: <dc4d04cc0710260303y2ffa13fatdd428b8df6be8a6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dc4d04cc0710260303y2ffa13fatdd428b8df6be8a6e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Filippo Carletti <filippo.carletti@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 26 Oct 2007, Filippo Carletti wrote:

> Is there a way to control an array resync process?
> In particular, is it possible to skip read errors?
>
> My setup:
> LVM2 Phisical Volume over a two disks MD RAID1 array
> Logical Volumes didn't span whole PV, some PE free at the end of disks
>
> What happened:
> disk1 broke
> I installed new disk1
> and started sync from disk2 to disk1
> but at 99.9% disk2 gave some read errors and the sync process started
> again, over and over
>
> I didn't notice errors on disk2 because they were in unallocated PEs
> at the end of the disk.
> The MD device spans the whole disk, while the LVs don't.
>
> I'd like to complete sync ignoring read errors, then replace disk2.
>
> I think this is a not-so-uncommon situation, leaving some PEs free for
> future expansion is a good idea and errors go undetected until you
> "use" those free areas.
>
> Thanks.
>
> -- 
> Ciao,
> Filippo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

This is why you should scrub your RAID.

Justin.
