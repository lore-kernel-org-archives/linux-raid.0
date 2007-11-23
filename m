From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Re: HELP! New disks being dropped from RAID 6 array on every reboot
Date: Fri, 23 Nov 2007 20:40:07 +0100
Message-ID: <47472C97.60809@systella.fr>
References: <e59c37290711231019v3c20ea71od906bca6e5cab724@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e59c37290711231019v3c20ea71od906bca6e5cab724@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Joshua Johnson wrote:
> Greetings, long time listener, first time caller.
> 
> I recently replaced a disk in my existing 8 disk RAID 6 array.
> Previously, all disks were PATA drives connected to the motherboard
> IDE and 3 promise Ultra 100/133 controllers.  I replaced one of the
> Promise controllers with a Via 64xx based controller, which has 2 SATA
> ports and one PATA port.  I connected a new SATA drive to the new
> card, partitioned the drive and added it to the array.  After 5 or 6
> hours the resyncing process finished and the array showed up complete.
>  Upon rebooting I discovered that the new drive had not been added to
> the array when it was assembled on boot.   I resynced it and tried
> again -- still would not persist after a reboot.  I moved one of the
> existing PATA drives to the new controller (so I could have the slot
> for network), rebooted and rebuilt the array.  Now when I reboot BOTH
> disks are missing from the array (sda and sdb).  Upon examining the
> disks it appears they think they are part of the array, but for some
> reason they are not being added when the array is being assembled.
> For example, this is a disk on the new controller which was not added
> to the array after rebooting:

	What is your partition system ? When I have tried to created a raid6 
array over a SunOS partition type, I have seen this bug. Never on PC system.

	Regards,

	JKB
