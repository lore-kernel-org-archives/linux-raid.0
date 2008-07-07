From: thomas62186218@aol.com
Subject: Re: md devices disappearing on system reboot
Date: Mon, 07 Jul 2008 08:52:03 -0400
Message-ID: <8CAAE4763AEB341-2F6C-570@webmailbeta-m07.sysops.aol.com>
References: <8CAA9B1F81B8E21-614-D2D@webmail-nc09.sysops.aol.com> <20080702162108.GF4981@skl-net.de> <8CAAD37CC87F1BD-FD8-4A21@webmail-stg-d08.sysops.aol.com> <20080707093004.GQ23944@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080707093004.GQ23944@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: maan@systemlinux.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Andre,

Thank you for the response. When running:  mdadm -A /dev/md0   I get:

mdadm: no devices found for /dev/md0

But fdisk -l  shows all the devices present on the system...

-Thomas

-----Original Message-----
From: Andre Noll <maan@systemlinux.org>
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
Sent: Mon, 7 Jul 2008 2:30 am
Subject: Re: md devices disappearing on system reboot










On 00:27, thomas62186218@aol.com wrote:

> Thank you for responding. I created md0 with 4 hard drives, RAID 0.
> Here is the /etc/mdadm.conf
> DEVICE  /dev/sd*
> ARRAY /dev/md0 level=raid0 num-devices=4
> UUID=d58a686f:20aa9ffe:e0d5f27e:e17216ec
>
> Here is the output of mdadm -E -scan
> ARRAY /dev/md0 level=raid0 num-devices=4
> UUID=d58a686f:20aa9ffe:e0d5f27e:e17216ec

Looks good.

> However, cat /proc/mdstat shows nothing:
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> unused devices: <none>

What happens if you try to assemble the array by executing

    mdadm -A /dev/md0

?

Andre
--
The only person who always got his work done by Friday was Robinson 
Crusoe





