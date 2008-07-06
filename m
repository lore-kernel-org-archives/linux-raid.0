From: thomas62186218@aol.com
Subject: Re: md devices disappearing on system reboot
Date: Sun, 06 Jul 2008 00:27:56 -0400
Message-ID: <8CAAD37CC87F1BD-FD8-4A21@webmail-stg-d08.sysops.aol.com>
References: <8CAA9B1F81B8E21-614-D2D@webmail-nc09.sysops.aol.com> <20080702162108.GF4981@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080702162108.GF4981@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: maan@systemlinux.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Andre,

Thank you for responding. I created md0 with 4 hard drives, RAID 0. 
Here is the /etc/mdadm.conf
DEVICE  /dev/sd*
ARRAY /dev/md0 level=raid0 num-devices=4 
UUID=d58a686f:20aa9ffe:e0d5f27e:e17216ec

Here is the output of mdadm -E -scan
ARRAY /dev/md0 level=raid0 num-devices=4 
UUID=d58a686f:20aa9ffe:e0d5f27e:e17216ec


However, cat /proc/mdstat shows nothing:
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
unused devices: <none>


Thank you for any guidance!
-Thomas

-----Original Message-----
From: Andre Noll <maan@systemlinux.org>
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
Sent: Wed, 2 Jul 2008 9:21 am
Subject: Re: md devices disappearing on system reboot










On 12:52, thomas62186218@aol.com wrote:

> I have what I am sure is a simple problem to solve but I cannot 
figure
> it out. I am running 64-bit Linux 2.6.20.11 (custom build) and my md
> devices are not appearing after system reboot. Any ideas?

Show us your /etc/mdadm.conf and the output of mdadm -E --scan.

Andre
--
The only person who always got his work done by Friday was Robinson 
Crusoe





