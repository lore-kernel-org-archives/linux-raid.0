From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: RH 7.3 raid1 setup
Date: Mon, 3 Jun 2002 04:10:20 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1020603040836.18456A-100000@Maggie.Linux-Consulting.com>
References: <0617855078.20020603123922@vo.lu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0617855078.20020603123922@vo.lu>
To: Christian Schmit <cschmit@vo.lu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya christian..

did you use "fd" partition type when creating/partitioning the disk ??

what does lilo.conf ( or grub ) look like ??

thanx
alvin

On Mon, 3 Jun 2002, Christian Schmit wrote:

> 
> I installed RH 7.3 on raid1 using the standard
> RH 7.3 GUI setup.
> 
> Everything installs fine. According to mdstat
> raid1 seems to be running fine:
> 
> # cat /proc/mdstat 
> Personalities : [raid1] 
> read_ahead 1024 sectors
> md1 : active raid1 hda5[0] hdc5[1]
>       3494016 blocks [2/2] [UU]
>       
> md2 : active raid1 hda3[0] hdc3[1]
>       16892224 blocks [2/2] [UU]
>       
> md3 : active raid1 hda2[0] hdc2[1]
>       19454592 blocks [2/2] [UU]
>       
> md0 : active raid1 hda1[0] hdc1[1]
>       361344 blocks [2/2] [UU]
>       
> unused devices: <none>
> 
> However when shutting down the system and 
> disconnecting the 1st IDE drive I cannot 
> boot from the mirrored disk. I assume this 
> is because the MBR is not mirrored.
> 
> So to see if all the data is present on the 
> mirrored disk I launch the "linux rescue" mode
> from the RH7.3 CD but it cannot find any partitions
> to mount from on the 2nd mirrored disk.
> 
> Making the same with the primary ide disk works 
> fine, in thsi case "linux rescue" can mount all 
> partitions.
> 
> How can I check if all data is being mirrored
> on the 2nd ide disk?
> 
> How do I make the 2nd ide disk bootable? 
> (I use grub as bootloader)
> I already tried: 
> 
> root (hd1,0)
> setup (hd1)

