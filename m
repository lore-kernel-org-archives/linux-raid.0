From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Cannot auto assemble a raid1 array on boot
Date: Wed, 24 Oct 2012 09:18:34 +1100
Message-ID: <508717BA.70906@websitemanagers.com.au>
References: <CAG9W8wBsh_i_jtqKFhEVywCk92hef41T0t+6J9saZD3CFT7V9A@mail.gmail.com> <507F7428.6030003@websitemanagers.com.au> <CAG9W8wCH9bfHou72_+t+JoCS3EA96opcpTOTzkc2E0oFkbX8zg@mail.gmail.com> <50808CB0.8020902@websitemanagers.com.au> <CAG9W8wBgqitp48C2O+8YUHWMp_HPf9TtokOt_wMM9qJcq2KL3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG9W8wBgqitp48C2O+8YUHWMp_HPf9TtokOt_wMM9qJcq2KL3Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jivko Sabev <jsabev@nicmus.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 24/10/12 02:43, Jivko Sabev wrote:
> Hi,
> 
> Thank you for the suggestions. I have tried explicitly listing the
> devices comprising the /dev/md1 array in mdadm.conf as follows:
> 
> [snip]
>  # definitions of existing MD arrays
> ARRAY /dev/md0 metadata=1.2 UUID=60ea870e:029dcf99:eaae356e:f1c12085
> name=mercury:0
> ARRAY /dev/md1 devices=/dev/md0,/dev/sde1
> [snip]
> 
> but that has yielded no new results. Same issue of the /dev/md1 array
> not being present at boot - dumped into initramfs shell. Below is the
> relevent info from "dmesg" in the initramfs shell.
> 
> [snip]

> Following the leads on the other suggestings, created a partion on md0
> of type FD (Linux Raid auto detect). Reassembled the array, updated
> the initrd image but the problem remains. That is the RAID array is
> not auto-assembled on boot. Here is the dmesg log
> 
> [snip]
> [    1.958921] md: bind<sdb1>
> [    2.470635] md: bind<sdc1>
> [    2.471928] md: linear personality registered for level -1
> [    2.875391] md0: detected capacity change from 0 to 1000213030400
> [    2.878472]  md0: p1
> [    2.945002] md: bind<sde1>
> [    4.397985] md: multipath personality registered for level -4
> [    4.399191] md: raid0 personality registered for level 0
> [    4.400490] md: raid1 personality registered for level 1
> [    4.896552] md: raid6 personality registered for level 6
> [    4.896580] md: raid5 personality registered for level 5
> [    4.896607] md: raid4 personality registered for level 4
> [    4.900306] md: raid10 personality registered for level 10
> [   57.097141] md: md1 stopped.
> [   57.097238] md: unbind<sde1>
> [   57.100051] md: export_rdev(sde1)
> [   75.147783] md: md1 stopped.
> [   75.148555] md: bind<sde1>
> [   75.148909] md: bind<md0>
> [   75.149880] md/raid1:md1: active with 2 out of 2 mirrors
> [   75.150003] md1: detected capacity change from 0 to 1000078639104
> [   75.170616]  md1: unknown partition table
> [snip]
> 
> Same problem. The system is in initramfs rescue shell. Array manually
> reassembled after which everything works.

Please show /etc/mdadm/mdadm.conf from within the initramfs (without the
comments).

I forget what I mentioned I had before, but I have:
md1 - 2 disk RAID1 sdc1 sde1
md2 - 2 disk RAID1 sdb1 sdd1
md3 - 2 md linear md1 md2

This is working for me...

BTW, my DEVICES line is
DEVICE partitions
If this matches your DEVICES line, please also send the content of
/proc/partitions within your initramfs before you manually make any
changes/do anything.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
