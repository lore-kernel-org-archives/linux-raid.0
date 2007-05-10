From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Questions about the speed when MD-RAID array is being initialized.
Date: Thu, 10 May 2007 17:33:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705101732540.11720@p34.internal.lan>
References: <20070508170441.GB4333@scavenger.homeip.net>  <f1sc2p$33q$1@sea.gmane.org>
 <BAY125-DAV2F4ABCF54BCB7458BA3D7933A0@phx.gbl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY125-DAV2F4ABCF54BCB7458BA3D7933A0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Liang Yang <multisyncfe991@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 10 May 2007, Liang Yang wrote:

> Hi,
>
> I created a MD-RAID5 array using 8 Maxtor SAS Disk Drives (chunk size is 
> 256k). I have measured the data transfer speed for single SAS disk drive 
> (physical drive, not filesystem on it), it is roughly about 80~90MB/s.
>
> However, I notice MD also reports the speed for the RAID5 array when it is 
> being initialized (cat /proc/mdstat). The speed reported by MD is not 
> constant which is roughly from 70MB/s to 90MB/s (average is 85MB/s which is 
> very close to the single disk data transfer speed).
>
> I just have three questions:
> 1. What is the exact meaning of the array speed reported by MD? Is that 
> mesured for the whole array (I used 8 disks) or for just single underlying 
> disk? If it is for the whole array, then 70~90B/s seems too low considering 8 
> disks are used for this array.
>
> 2. How is this speed measured and what is the I/O packet size being used when 
> the speed is measured?
>
> 3. From the beginning when MD-RAID 5 array is initialized to the end when the 
> intialization is done, the speed reports by MD gradually decrease from 90MB/s 
> down to 70MB/s. Why does the speed change? Why does the speed gradually 
> decrease?
>
> Could anyone give me some explanation?
>
> I'm using RHEL 4U4 with 2.6.18 kernel. MDADM version is 1.6.
>
> Thanks a lot,
>
> Liang
>
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

For no 3. because it starts from the fast end of the disk and works its 
way to the slower part (slower speeds).


