From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: Better handling of readerrors with raid5.
Date: Fri, 23 Dec 2005 20:40:59 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0512232038260.32612@adsl.a2000.nu>
References: <200512222245.jBMMj1r0007687@cichlid.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200512222245.jBMMj1r0007687@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 22 Dec 2005, Andrew Burgess wrote:

>> i recovered my raid by using dd_rescue the last failed disk to a spare
>> disk (with 4 read errors)
>> (and doing a mdadm -A -force)
>
>> (so I should have a corrupted file somewhere?)
>
> Or a corrupted filesystem, which e2fsck will find & fix.
filesystem is xfs

and to make sure i runned xfs_check
(which runned for a while with no output)

afther this the dmesg output after mounting :

XFS mounting filesystem md0
Ending clean XFS mount for filesystem: md0


> Did you write down the bad sectors?  If so, you can use debugfs to find out
> where they are on the filesystem. Computing the filesystem block number from
> the device sector number will be an exercise...

dd_rescue made a logfile :

dd_rescue: (warning): /dev/sdb1 (39297916.0k): Input/output error!
dd_rescue: (warning): /dev/sdb1 (39297916.5k): Input/output error!
dd_rescue: (warning): /dev/sdb1 (39297917.0k): Input/output error!
dd_rescue: (warning): /dev/sdb1 (39297917.5k): Input/output error!


