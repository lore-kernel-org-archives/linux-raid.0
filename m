From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID1 On 3 Drives
Date: Sat, 13 Mar 2010 18:50:14 -0500
Message-ID: <4B9C24B6.7040507@tmr.com>
References: <4B9C11FB.7040604@gmx.net> <d80f793f1003131518u2bfe77e9k52ef77e3d2c68360@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1003131518u2bfe77e9k52ef77e3d2c68360@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Mennens <carloswill@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Carlos Mennens wrote:
> I am glad I asked! Thanks for all the info. Now my question next is if
> I am creating a 3 disk raid with a 1 disk spare, do I need to use any
> special 'mdadm' parameters besides what u see below for /boot (Grub)?
>
> # mdadm --create /dev/md0 --level=1 --raid-devices=3 /dev/sda1
> /dev/sdb1 /dev/sdc1 --spare-devices=1 /dev/sdd1
>
> Anything else I should add to the above command for my /boot partition?
>   

Having a spare on raid-1 is fairly pointless, it hurts performance and 
buys you nothing. Having one more copy of the data built and ready 
serves you better.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

