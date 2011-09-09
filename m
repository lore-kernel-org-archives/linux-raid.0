From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Bootable Raid-1
Date: Fri, 09 Sep 2011 15:09:52 -0400
Message-ID: <4E6A6480.1060407@tmr.com>
References: <8B.08.07087.360784D4@cdptpa-omtalb.mail.rr.com> <4D487CA4.2030502@faccat.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D487CA4.2030502@faccat.br>
Sender: linux-raid-owner@vger.kernel.org
To: naira@faccat.br
Cc: lrhorer@satx.rr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Naira Kaieski wrote:
> Hi,
>
> My metadata is 0.90...
>
> My Partitions:
> /dev/sda1               1         122      979933+  fd  Linux raid 
> autodetect
> /dev/sda2   *         123         134       96390   fd  Linux raid 
> autodetect
> /dev/sda3             135       19457   155211997+  fd  Linux raid 
> autodetect

When you use RAID1 you can do it one of two ways, as a while drive array 
or as a series of arrays based on partitions. Some versions of GRUB will 
only understand 0.90 metadata, so at least the boot partition should use 
that. In addition, if you don't have the whole drive raid, you really 
should be sure you have written a useful boot sector to each drive. 
Other than that I can't think of any particular issues you might have.

Depending on your distribution you may have to create a new boot image 
using mkinitrd or whatever your distribution has decided is better. If 
you change your setup after install this is often needed.

-- 
Bill Davidsen<davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010



