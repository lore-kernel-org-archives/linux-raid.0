From: Thomas Steudten <alpha@steudten.com>
Subject: Re: RAID1-Device won't survive reboot
Date: Thu, 09 Oct 2003 14:00:28 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F854DDC.6060200@steudten.com>
References: <OFBE4F4C3A.AD55E9B4-ONC1256DB9.0052F11A@pta.de> <3F8483CE.2070309@fantinibakery.com>
Reply-To: alpha@steudten.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F8483CE.2070309@fantinibakery.com>
To: rob <rob@fantinibakery.com>
Cc: alexander.weber@pta.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I think the partition is not marked with type fd: like
mime: It must be type "fd"

[1021] (1) #  fdisk -l /dev/sda

Disk /dev/sda: 64 heads, 32 sectors, 35003 cylinders
Units = cylinders of 2048 * 512 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/sda1             1      8676   8884208   fd  Linux raid autodetect
/dev/sda2          8677     35003  26958848   83  Linux



rob wrote:

> I'm not familiar with SuSE 8.2,   but here are some hints:
> 
> -is it possible that  either the mount of md0 is getting done before  
> md0 is assembled, or hdb1  is getting mounted directly?  check  df -v  
> right after boot.
> 

>>


