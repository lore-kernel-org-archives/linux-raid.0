From: Sebastian Slota <nc_slotase@netcologne.de>
Subject: Re: linux/raid problem, linux not recognizing bios raidHi
Date: Sun, 17 Oct 2004 15:11:21 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410171511.21544.nc_slotase@netcologne.de>
References: <000401c4b3f4$47bc9570$6101a8c0@renoir>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000401c4b3f4$47bc9570$6101a8c0@renoir>
Content-Disposition: inline
To: "Robert E. Singer" <Robert.E.Singer@cox.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

THe best start for you would be to delete the BIOS RAID and create a Linux 
software raid. I've the Abit ic7g too and it works for me.
The bios Raid is kinda software raid anyway. and even slower compared to linux 
native software raid. (tested on 2.4 kernels with medley drivers, which 
support hte bios software raid stuff, vs. 2.4 kernel with linux software 
raid)
hope that helps.


Sebastian


On Sunday 17 October 2004 04:52, Robert E. Singer wrote:
> hi -
>
> i dont have tons of linux experience.  my in-depth unix experience was many
> years ago.
>
> im building a system containing:
> - abit ic7g motherboard
> - 2 wd 160gb sata hard drives
> - red hat linux workstation version 3
>
> the drives have been physically installed and the bios configured to run
> the disks as a raid (either raid0 or raid1). this is verified during the
> post.
>
> when i try to install linux, the disk partitioning program reports two
> disks /dev/sda & /dev/sdb individually with 160gb capacities available for
> partitioning, not one.  whether using bios raid0 or raid1, only 1 disk
> should be available (with 160 or 320 gb available, depending on the raid
> flavor).
>
> whats wrong?
>
> bob singer
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
