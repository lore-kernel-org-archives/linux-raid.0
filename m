From: matt brennan <raid@classforge.com>
Subject: partition sizing and raid1
Date: Thu, 04 Nov 2004 15:14:36 +1030
Message-ID: <4189B3B4.2060203@classforge.com>
References: <4179D9DB.2070709@classforge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4179D9DB.2070709@classforge.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I created a new raid1 array on two 300GB disks but it came in 
underweight in size...

Filesystem           1M-blocks      Used Available Use% Mounted on
/dev/md0                129013     27322     95137  23% /home

I guess I stuffed up with the partitioning (from fdisk):

> Disk /dev/hda: 255 heads, 63 sectors, 16709 cylinders
> Units = cylinders of 16065 * 512 bytes
> 
>    Device Boot    Start       End    Blocks   Id  System
> /dev/hda1             1     16709 134215011   fd  Linux raid autodetect

This was accepting fdisk's default max size.

I realise this is not an fdisk mailing list but I guess you've probably 
hit this problem when creating large disk arrays. Could anyone please 
provide a quick hint on what I've stuffed up?

kernel: 2.4.18

dpkg (debian woody) says fdisk is:
ii  util-linux     2.11n-7        Miscellaneous system utilities.

the fdisk man page suggests using cfdisk... is this likely to help? it 
looks like a will have to recreate the raid1 array anyway. :-(

   matt

