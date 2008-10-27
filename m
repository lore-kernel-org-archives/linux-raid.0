From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: question on how to (correctly) build an initrd for a root disk
 on a RAID1
Date: Sun, 26 Oct 2008 23:22:40 -0400
Message-ID: <49053400.5080704@maine.edu>
References: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Joe Landman wrote:
> Hi folks:
>
>   We have been trying to build an operational initrd for a root drive
> on  software RAID1.
>
>   Basic specs:   2.6.23.14 kernel (though same issues with 2.6.27.2
> kernel), on Centos 5.2, pair of SATA drives using libata and other
> drivers, x86_64 architecture.
>
>   Using mkinitrd --with=raid1 --with=libata --with=sd_mod ...
>
>   I am getting a kernel panic on switchroot, it can't find the root
> file system.  

Hi Joe,

What does the "root=" kernel parameter look like in your grub.conf (are 
you using grub?)? Mine looks like root=/dev/md2. My md0 is the boot 
partition and md1 is swap. I know this is simplistic but I didn't find 
it in your message.

Steve

> I did some googling, but could not find a similar
> example.  Do I need to create a specialized init script?  Is there an
> example of this somewhere?  I did look at the Documentation/md.txt and
> tried the
>
>      md=0,sda1,sdb1 md=1,sda2,sdb2  md=2,sda3,sdb3
>
>   kernel boot time option, to no avail.  Persistent superblocks are
> on, and the devices have the right partition types.
>
>   Any suggestions?  More things to read?
>
>   Thanks in advance.
>
> Joe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   


