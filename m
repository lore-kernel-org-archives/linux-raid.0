From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: very degraded RAID5, or increasing capacity by adding discs
Date: Mon, 8 Oct 2007 15:17:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710081517120.29139@p34.internal.lan>
References: <20071008211313.6cd8bbb5@absurd>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071008211313.6cd8bbb5@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 8 Oct 2007, Janek Kozicki wrote:

> Hello,
>
> Recently I started to use mdadm and I'm very impressed by its
> capabilities.
>
> I have raid0 (250+250 GB) on my workstation. And I want to have
> raid5 (4*500 = 1500 GB) on my backup machine.
>
> The backup machine currently doesn't have raid, just a single 500 GB
> drive. I plan to buy more HDDs to have a bigger space for my
> backups but since I cannot afford all HDDs at once I face a problem
> of "expanding" an array. I'm able to add one 500 GB drive every few
> months until I have all 4 drives.
>
> But I cannot make a backup of a backup... so reformatting/copying all
> data each time when I add new disc to the array is not possible for me.
>
> Is it possible anyhow to create a "very degraded" raid array - a one
> that consists of 4 drives, but has only TWO ?
>
> This would involve some very tricky *hole* management on the block
> device... A one that places holes in stripes on the block device,
> until more discs are added to fill the holes. When the holes are
> filled, the block device grows bigger, and with lvm I just increase
> the filesystem size. This is perhaps coupled with some "unstripping"
> that moves/reorganizes blocks around to fill/defragment the holes.
>
> is it just a pipe dream?
>
> best regards
>
>
> PS: yes it's simple to make a degraded array of 3 drives, but I
> cannot afford two discs at once...
>
> -- 
> Janek Kozicki                                                         |
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

With raid1 you can create a degraded array with 1 disk- I have done this, 
I have always wondered if mdadm will let you make a degraded raid 5 array 
with 2 disks (you'd specify 3 and only give 2) - you can always expand 
later.

Justin.
