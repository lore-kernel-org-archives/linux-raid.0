From: matt brennan <raid@classforge.com>
Subject: Resizing raid-1 on replacing failed disk
Date: Sat, 23 Oct 2004 13:41:07 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4179D9DB.2070709@classforge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would like replace a failed disk in a raid-1 with a larger disk - and 
ultimately increase the size of the array (and ext3 partition) by 
subsequently adding a second larger disk in lieu of the currently active 
one.

I am hoping someone will scan the following and briefly reply: "this 
looks ok" or "you forgot step(s) X" before I commence.

<disclaimer>
I have read the software-raid-howto, list faq, mdadm man pages and 
trawled this mailing list to try to ensure I am not posting a question 
that has been answered before. If you believe that this topic is well 
covered elsewhere, please smack me up and post a link.
</disclaimer>

Currently:

kernel: 2.4.18
mdadm: 0.7.2-2 (version reported by dpkg)

> # mdadm --detail /dev/md0
> /dev/md0:
>         Version : 00.90.00
>   Creation Time : Sun Dec 23 05:46:51 2001
>      Raid Level : raid1
>      Array Size : 39078016 (37.26 GiB 40.01 GB)
>     Device Size : 39078016 (37.26 GiB 40.01 GB)
>      Raid Disks : 2
>     Total Disks : 2
> Preferred Minor : 0
>     Persistance : Superblock is persistant
<snip>
>     Number   Major   Minor   RaidDisk   State
>        0       3        1        0      active sync   /dev/hda1
>        1      22        1        1      faulty   /dev/hdc1
>            UUID : 3e9f6b0c:e3c4d3cc:761130b2:d4f74686

Plan:

- backup
- physcially remove the failed disk
- physcially replace the failed disk with a larger disk
- add the new disk to the array and allow to resync
- fail and remove the active smaller disk
- physcially replace the active smaller disk with a larger disk
- resize the ext3 partition

Help:

Could you indicate whether this is possible with the listed kernel and 
mdadm version before I kick off?

Thanks and regards,

   matt
