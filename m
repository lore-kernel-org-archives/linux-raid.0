From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: About seting up Raid5 on a four disk box.
Date: Tue, 13 Oct 2009 16:54:44 -0400
Message-ID: <4AD4E914.7080709@tmr.com>
References: <hb1udb$6t1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hb1udb$6t1$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: ap23563m@gmx.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Antonio Perez wrote:
> If I'm posting to the wrong group, sorry. just point to the RTFM link.
>
> This post is about setting up a Debian box with four disks (size should not 
> be important, me thinks), let's assume that a Raid 5 is the correct type for 
> the intended use.
>
>   
It's not, brief explanation follows.

You absolutely want your /boot to be raid-1 so it boots if the 1st drive 
fails. You want to grub install in the MBR of each drive, by hand. The 
boot will get the raid arrays going, so they can be raid-5, but read on.

If this will be a desktop, make / raid-10, it will be much faster. If 
you will be doing things which are big enough to trigger swap use, that 
should be raid-10 as well, allocated on the outer part of the drive. You 
other data can be in raid-5 partitions, if that's the balance of space 
and reliability for you. If you will use ext4 read the man pages on 
stripe= and stride= settings, they should match what you are doing. If 
these are large drives, ext4 has some options you should understand, DO 
NOT just let the installer create the filesystem, they are not yet 
clever enough, don't ask intended use questions, etc.

Read the comments on this stuff in the list archives, pick the ideas on 
tuning which you find helpful, virtually any tuning you pick based on 
projected use will beat the defaults.

Late thought: raid-10 swap is seriously faster than raid-5, I don't know 
if suspend works on it, I don't raid laptops or suspend servers. The 
wisdom of the list may appear here. ;-)

> Keeping aside LVM and/or layering of md (just for simplicity), and taking 
> into account that /boot, / and maybe other areas should go in a Raid 1 
> configuration, for booting reliability. I have three questions that perhaps 
> you could help to clarify:
>
> 1.- Should the "rest of the disk" be only one partition?
> I have read that making several partitions and setting several md disks:
> 	sd[a..d]2 --> md1
> 	sd[a..d]3 --> md2
> 	sd[a..d]4 --> md3
> would help with the rebuild time of each md, which sounds correct. It is 
> also proposed that the md on the outer area of the disk would be faster 
> allowing for better control of performance, assigning faster mds to the more 
> used filesystems.
>
> However, and this I don't know, those sda[2..4] are not really different 
> devices (spindles) and reads to one md would conflict (or not?) with reads 
> to the other mds.
>
> Setting the whole disk as one partition would prevent any conflict but would 
> take longer to rebuild and files would be spread over the whole area of the 
> disk.
>
> I really don't know the internals of md well enough to tell what advantages 
> and problems one setup has over the other.
>
> 2.- On the Raid 1: How many sectors to copy? 63?
> On an update of grub code, core.img could change, which means that the first 
> 63 sectors (to be on the safe side) of the disk which gets the update should 
> be copied to the other 3 disks.
> Or is it that the md code would mirror sectors 1-62 and only the MBR needs 
> to be manually mirroed?
>
> 2.- Is there a recomended way to trigger the said copy of question 2?
> Where should a call to copy the MBR should be placed? On update-grub?
>
> TIA
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

