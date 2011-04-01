From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: strange problem with my raid5
Date: Fri, 01 Apr 2011 08:22:30 +0100
Message-ID: <4D957D36.2060409@gmail.com>
References: <AANLkTinEcLaQAdoFgbV6+UGkPYKTgBass8J8pUBQ3h_X@mail.gmail.com>	<4D94AAB4.2050900@gmail.com> <AANLkTineJSt77ZNhUR61BTp65WMvDUDo4QGZdwpYgjBp@mail.gmail.com>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTineJSt77ZNhUR61BTp65WMvDUDo4QGZdwpYgjBp@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hank peng <pengxihan@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

My guess is that you've exported the physical disks you were using in MD 
as your iscsi luns, rather than creating a files on your formatted md 
device and exporting that file as a lun.  The partitions on these 
probably were created by Windows.

Can you post your iscsi config, the mdadm -E's that I asked for in the 
first place and the dmesg info ?

the partitions you've 'found' are all ntfs partitions, but I can't 
understand how they can get in to the mdadm.conf.  As far as I am aware 
mdadm.conf is always hand crafted (apart from the original which 
probably gets put there by apt).  Can anyone else on the list 
confirm/deny this ?

I'm guessing that this was clean and a proof of concept and that there 
is no dataloss.  can you confirm ?

cheers
Simon

On 01/04/2011 01:19, hank peng wrote:
> thanks for reply, I have other information to  add.
> I created 3 raid5 array, then I created 6 iscsi LUN on them, each
> raid5 had two LUNs. And then I exported them to Windows side. On
> Windows side, I format them using NTFS filesystem.
> On Linux side, there are some information as follows:
>
> #fdisk -l
> Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1      243199  1953495903+   7  HPFS/NTFS
>
> Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1      243199  1953495903+   7  HPFS/NTFS
>
> Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
> Disk /dev/sdc doesn't contain a valid partition table
>
> Disk /dev/sdd: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
> Disk /dev/sdd doesn't contain a valid partition table
>
> Disk /dev/sdf: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdf1               1      243199  1953495903+   7  HPFS/NTFS
>
> Disk /dev/sdg: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdg1               1      243199  1953495903+   7  HPFS/NTFS
>
> Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
> Disk /dev/sde doesn't contain a valid partition table
>
> Disk /dev/sdj: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
> Disk /dev/sdj doesn't contain a valid partition table
>
> Disk /dev/sdi: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
> Disk /dev/sdi doesn't contain a valid partition table
>
> Disk /dev/sdk: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
> Disk /dev/sdk doesn't contain a valid partition table
>
> Disk /dev/sdh: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
> Disk /dev/sdh doesn't contain a valid partition table
>
> Disk /dev/sdl: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdl1               1      243199  1953495903+   7  HPFS/NTFS
>
> Disk /dev/sdm: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sdm1               1      243199  1953495903+   7  HPFS/NTFS
>
> Disk /dev/sdn: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
> Disk /dev/sdn doesn't contain a valid partition table
>
> Disk /dev/sdo: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
> Disk /dev/sdo doesn't contain a valid partition table
>
> Disk /dev/sdp: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
> # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
> unused devices:<none>
> root@Dahua_Storage:~# cat /etc/mdadm.conf
> DEVICE /dev/sd*
> ARRAY /dev/md3 level=raid5 num-devices=5
> UUID=2d3ac8ef:2dbe2469:b31e3c87:77c5769c
>     devices=/dev/sdg1,/dev/sdg,/dev/sdf1,/dev/sdf,/dev/sde,/dev/sdd,/dev/sdc
> ARRAY /dev/md1 level=raid5 num-devices=5
> UUID=9462a7df:31fca040:023819d9:dbf71832
>     devices=/dev/sdm1,/dev/sdm,/dev/sdl1,/dev/sdl,/dev/sdk,/dev/sdj,/dev/sdi
> ARRAY /dev/md2 level=raid5 num-devices=5
> UUID=5dbc2bdc:9173d426:21a1b5c2:f8b2768a
>     devices=/dev/sdp,/dev/sdo,/dev/sdn,/dev/sdb1,/dev/sdb,/dev/sda1,/dev/sda
>
>
>
> There are two strange points:
> 1. As you see, there are "sdg1" "sdf1" "sdm1" "sdl1" "sdb1" "sda1".
> These partitions should not exist.
> 2. The content of /etc/mdadm.conf is abnormal, "sdg1" "sdf1" "sdm1"
> "sdl1" "sdb1" "sda1" should not be scanned and included.
>
>
>
>
>
>
>
> 2011/4/1 Simon McNair<simonmcnair@gmail.com>:
>> I think the normal thing to try in this situation is:
>>
>>   mdadm --assemble --scan
>>
>> and if that doesn't work, people normally ask for:
>>   mdadm -E /dev/sd?? for each appropriate drive which should be in the array
>>
>> have a look at dmesg too ?
>>
>> I don't know much about md, I just lurk so apologies if you already know
>> this.
>>
>> cheers
>> Simon
>>
>> On 30/03/2011 13:34, hank peng wrote:
>>> Hi,all:
>>> I created a raid5 array which consists of 15 disks, before recovering
>>> is done, a power failure event occured. After power is recovered, the
>>> machine box started successfully but "cat /proc/mdstat" gave no
>>> message, previously created raid5 was gone. I check kernel messages,
>>> it is as follows:
>>>
>>> <snip>
>>> bonding: bond0: enslaving eth1 as a backup interface with a down link.
>>> svc: failed to register lockdv1 RPC service (errno 97).
>>> rpc.nfsd used greatest stack depth: 5440 bytes left
>>> md: md1 stopped.
>>> iSCSI Enterprise Target Software - version 1.4.1
>>> </snip>
>>>
>>> In normal case, md1 should bind its disks after printing "md: md1
>>> stopped", then what happened in this cituation?
>>> BTW, my kernel version is 2.6.31.6.
>>>
>>>
>
>
