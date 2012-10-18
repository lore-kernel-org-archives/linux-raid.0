From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Cannot auto assemble a raid1 array on boot
Date: Thu, 18 Oct 2012 14:14:48 +1100
Message-ID: <507F7428.6030003@websitemanagers.com.au>
References: <CAG9W8wBsh_i_jtqKFhEVywCk92hef41T0t+6J9saZD3CFT7V9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG9W8wBsh_i_jtqKFhEVywCk92hef41T0t+6J9saZD3CFT7V9A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jivko Sabev <jsabev@nicmus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/10/12 13:35, Jivko Sabev wrote:
> Greetings,
>
> I have a RAID1 array setup of the following
>
> /dev/md0 [linear raid array consisting of two 500GB SATA drives]
> /dev/md1  [RAID1 array consisting of /dev/md0 and one 1TB SATA drive]
>
> here is my /proc/mdstat
>
> --------
>
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md1 : active raid1 md0[0] sde1[2]
>       976639296 blocks super 1.2 [2/2] [UU]
>
> md0 : active linear sdb1[0] sdc1[1]
>       976770537 blocks super 1.2 0k rounding
>
> unused devices: <none>
>
>
> --------
>
> However, on every reboot, the md1 array is in degraded mode and I get
> dumped to a intramfs shell. I can then assemble the said array - i.e.
> mdadm --assemble /dev/md1 /dev/md0 /dev/sde1 and everything is fine.
> Is it possible to have such an array auto assembled and how?
>

Maybe you need to update the mdadm.conf within the initrd image ?

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

