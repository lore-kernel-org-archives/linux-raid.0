From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: persistent removed MD referrence on reboot
Date: Tue, 31 Jul 2012 11:26:48 +1000
Message-ID: <50173458.40505@websitemanagers.com.au>
References: <CAO7BsSnu+CZMeQ=YNUKDOCQGF9FYjCTV37rhkBiW1JGAVexxuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO7BsSnu+CZMeQ=YNUKDOCQGF9FYjCTV37rhkBiW1JGAVexxuQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Skip Coombe <skipcoombe@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/31/2012 11:02 AM, Skip Coombe wrote:
> I have an md entry referring to a badly removed RAID1 device (by me) after
> the associated device crashed (can't afford a replacement drive at this
> time).
> Despite attempts to remove the reference, after a reboot I see:
>
> ================================
> $ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4]
> [raid10]
> md2 : inactive sdc[1](S)
>        488385560 blocks super 1.2
>
> unused devices: <none>
> ================================
>
> I am trying to repurpose the good drive as a not-RAID device. I have done
> sudo mdadm --zero-superblock /dev/sdc
> and
> sudo mdadm --zero-superblock --force /dev/sdc
> and even low level formatted /dev/sdc
What do you mean "low level formatted"? Have you done a
dd if=/dev/zero of=/dev/sdc
> ================================
> $ ls /etc/mdadm/mdadm.conf
> ls: cannot access /etc/mdadm/mdadm.conf: No such file or directory
> ================================
Did you update the initrd file? This file probably contains a copy of 
the mdadm.conf

Also, did you modify the partition type, from fd to 83
I would suggest running the above dd command, which will erase ALL 
traces of anything, including any data on the drive (so back it up 
elsewhere first).

Most likely, the md code looks at a couple of different places on the 
drive for the md information, so when you run the zero-superblock, it is 
only erasing one of the possible locations. See man mdadm, especially 
the --metadata section.

Regards,
Adam
