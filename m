From: Christian Schmit <cschmit@vo.lu>
Subject: Re[2]: RH 7.3 raid1 setup
Date: Mon, 3 Jun 2002 14:18:54 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <162623827266.20020603141854@vo.lu>
References: <Pine.LNX.3.96.1020603040836.18456A-100000@Maggie.Linux-Consulting.com>
Reply-To: Christian Schmit <cschmit@vo.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1020603040836.18456A-100000@Maggie.Linux-Consulting.com>
To: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alvin,

Here is my config:

grub.conf:
-----------
default=0
timeout=10
splashimage=(hd0,0)/grub/splash.xpm.gz
title Red Hat Linux (2.4.18-3)
        root (hd0,0)
        kernel /vmlinuz-2.4.18-3 ro root=/dev/md2
        initrd /initrd-2.4.18-3.img


Partitions:
------------

Disk /dev/hda: 255 heads, 63 sectors, 5005 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hda1   *         1        45    361431   fd  Linux raid autodetect
/dev/hda2            46       810   6144862+  fd  Linux raid autodetect
/dev/hda3           811      1065   2048287+  fd  Linux raid autodetect

Disk /dev/hdc: 255 heads, 63 sectors, 5005 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdc1   *         1        45    361431   fd  Linux raid autodetect
/dev/hdc2            46       810   6144862+  fd  Linux raid autodetect
/dev/hdc3           811      1065   2048287+  fd  Linux raid autodetect


mdstat:
---------

# cat /proc/mdstat
Personalities : [raid1] 
read_ahead 1024 sectors
md0 : active raid1 hda3[0] hdc3[1]
      2048192 blocks [2/2] [UU]
      
md2 : active raid1 hda2[0] hdc2[1]
      6144768 blocks [2/2] [UU]
      
md1 : active raid1 hda1[0] hdc1[1]
      361344 blocks [2/2] [UU]


Christian



AO> hi ya christian..

AO> did you use "fd" partition type when creating/partitioning the disk ??

AO> what does lilo.conf ( or grub ) look like ??

AO> thanx
AO> alvin

AO> On Mon, 3 Jun 2002, Christian Schmit wrote:

>> 
>> I installed RH 7.3 on raid1 using the standard
>> RH 7.3 GUI setup.
>> 
>> Everything installs fine. According to mdstat
>> raid1 seems to be running fine:
>> 
>> # cat /proc/mdstat 
>> Personalities : [raid1] 
>> read_ahead 1024 sectors
>> md1 : active raid1 hda5[0] hdc5[1]
>>       3494016 blocks [2/2] [UU]
>>       
>> md2 : active raid1 hda3[0] hdc3[1]
>>       16892224 blocks [2/2] [UU]
>>       
>> md3 : active raid1 hda2[0] hdc2[1]
>>       19454592 blocks [2/2] [UU]
>>       
>> md0 : active raid1 hda1[0] hdc1[1]
>>       361344 blocks [2/2] [UU]
>>       
>> unused devices: <none>
>> 
>> However when shutting down the system and 
>> disconnecting the 1st IDE drive I cannot 
>> boot from the mirrored disk. I assume this 
>> is because the MBR is not mirrored.
>> 
>> So to see if all the data is present on the 
>> mirrored disk I launch the "linux rescue" mode
>> from the RH7.3 CD but it cannot find any partitions
>> to mount from on the 2nd mirrored disk.
>> 
>> Making the same with the primary ide disk works 
>> fine, in thsi case "linux rescue" can mount all 
>> partitions.
>> 
>> How can I check if all data is being mirrored
>> on the 2nd ide disk?
>> 
>> How do I make the 2nd ide disk bootable? 
>> (I use grub as bootloader)
>> I already tried: 
>> 
>> root (hd1,0)
>> setup (hd1)

AO> -
AO> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
AO> the body of a message to majordomo@vger.kernel.org
AO> More majordomo info at  http://vger.kernel.org/majordomo-info.html

