From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Question: how to identify failing disk in a RAID1
Date: Sun, 13 Apr 2008 21:14:19 -0400
Message-ID: <4802AFEB.9020006@tmr.com>
References: <48025B8D.2030803@harddata.com> <alpine.DEB.1.10.0804131529300.11311@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0804131529300.11311@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Maurice Hilarius <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
>
>
> On Sun, 13 Apr 2008, Maurice Hilarius wrote:
>
>> Hi there.
>>
>> Recently I have been frequently seeing a damaged filesystem on a 
>> RAID1 on boot.
>> a lengthy fsck does get it working, but I am seeing files 
>> disappearing as a result.
>>
>> I am pretty sure that one of the drives has developed some issues and 
>> needs to be replaced.
>>
>> How does one identify which of the 2 disks is the one that is failing?
>>
>> The system has 2 identical disks, and  / is on md0
>>
>> fstab:
>> /dev/md0                /                       ext3    
>> defaults        1 1
>> LABEL=/boot1            /boot                   ext2    
>> defaults        1 2
>> tmpfs                   /dev/shm                tmpfs   
>> defaults        0 0
>> devpts                  /dev/pts                devpts  
>> gid=5,mode=620  0 0
>> sysfs                   /sys                    sysfs   
>> defaults        0 0
>> proc                    /proc                   proc    
>> defaults        0 0
>> LABEL=/boot11           /boot1                  ext2    
>> defaults        1 2
>> LABEL=SWAP-sdb3         swap                    swap    
>> defaults        0 0
>> LABEL=SWAP-sda2         swap                    swap    
>> defaults        0 0
>>
>> fdisk -l shows me:
>> Disk /dev/sda: 400.0 GB, 400088457216 bytes
>> 255 heads, 63 sectors/track, 48641 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>>
>>  Device Boot      Start         End      Blocks   Id  System
>> /dev/sda1   *           1          13      104391   83  Linux
>> /dev/sda2              14         535     4192965   82  Linux swap / 
>> Solaris
>> /dev/sda3             536       48641   386411445   fd  Linux raid 
>> autodetect
>>
>> Disk /dev/sdb: 400.0 GB, 400088457216 bytes
>> 255 heads, 63 sectors/track, 48641 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>>
>>  Device Boot      Start         End      Blocks   Id  System
>> /dev/sdb1   *           1          13      104391   83  Linux
>> /dev/sdb2              14       48118   386403412+  fd  Linux raid 
>> autodetect
>> /dev/sdb3           48119       48640     4192965   82  Linux swap / 
>> Solaris
>>
>> Disk /dev/md0: 395.6 GB, 395677007872 bytes
>> 2 heads, 4 sectors/track, 96600832 cylinders
>> Units = cylinders of 8 * 512 = 4096 bytes
>>
>> Anyone have a suggestion, please?
>> Responses off list are probably most appropriate.
>>
>> Thanks for any help.
>>
>> -- 
>> Regards, Maurice
>> mhilarius@gmail.com
>>
>
> smartctl -a /dev/sda
> smartctl -a /dev/sdb
>
> also, how come swap was not on the raid1?

Very unexpected that the data would be bad without any hardware errors. 
Did you look at your logs to see if one of your drives, or perhasps 
both, are getting hardware errors? I would run a 'check' and and see 
what mdadm finds on the array, you may have other problems.

Actually, I think I would run memtest86 for at least a few hours, 
starting from a really cold system (not just a cold boot, off for a few 
hours). Your comment "on boot" may come from memory or other component 
which needs to physically get up to temperature before working reliably. 
Particularly if you don't get additional errors after you have been up 
for a while.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


