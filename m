From: Alexander Stockinger <stockina@fmi.uni-passau.de>
Subject: Re: RAID 5 disks not spinning down
Date: Sat, 12 Mar 2005 15:19:21 +0100
Message-ID: <d0utn3$7vo$1@sea.gmane.org>
References: <d0uamj$s15$1@sea.gmane.org> <4232F80E.1030202@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4232F80E.1030202@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell wrote:
> Alexander Stockinger wrote:
> 
>> Hi all,
>>
>> I have a linux software RAID 5 running on a Debian Sarge with 
>> 2.6.7-smp. Since I installed the system (several kernel updates ago) 
>> the disks of the RAID 5 won't stay spinned down. Having them sent to 
>> standy manually using hdparm ends up in having the disks spin up 
>> within the next minute or so.
>> To further investigate the problem I watched the /proc/diskstats file 
>> for /dev/md0 and realized that prior to the spinup a single read 
>> access to the RAID is issued - consequently the disks attached to the 
>> read spin up again...
> 
> 
> Does it occur if you have the filesystem on the md device unmounted?

No, drives stay down when the mount point of /dev/md0 is unmounted. So 
it's probably an application accessing something on the disks? But how 
do I determine what is accessed? dnotify reports _nothing_...

> 
> Regards,
> Brad

Thanks,
Alex

