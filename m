From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Resizing raid-1 on replacing failed disk
Date: Sat, 23 Oct 2004 01:41:50 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410230541.i9N5fuN10579@www.watkins-home.com>
References: <4179D9DB.2070709@classforge.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4179D9DB.2070709@classforge.com>
To: 'matt brennan' <raid@classforge.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You will be replacing your boot disk (I think).  This will be a grub or lilo
issue.  Please wait for someone to help with this!  But not me!  I don't
trust my advice!  Other than my advice to wait for help. :)

I don't recall if the size will just grow when you replace with a larger
disk.  But if you know it will, then this should work (other than booting).
Oops, I recall some issue resizing a file system, don't recall the issue, or
how to deal with it.  Will search and send another message if I find it.

But I do have other notes:
- backup
* logically remove the failed disk - "mdadm /dev/md0 -r /dev/hdc1"
- physically remove the failed disk
- physically replace the failed disk with a larger disk
- add the new disk to the array and allow to resync
- fail and remove the active smaller disk
* fail the smaller disk - "mdadm /dev/md0 -f /dev/hda1"
* wait a few seconds (was some issue with failing and removing too quickly)
* remove the smaller disk - "mdadm /dev/md0 -r /dev/hda1"
- physically replace the active smaller disk with a larger disk
- resize the ext3 partition

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of matt brennan
Sent: Saturday, October 23, 2004 12:11 AM
To: linux-raid@vger.kernel.org
Subject: Resizing raid-1 on replacing failed disk

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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

