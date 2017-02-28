From: "Peter Sangas" <pete@wnsdev.com>
Subject: RE: GRUB warning after replacing disk drive in RAID1
Date: Tue, 28 Feb 2017 15:15:58 -0800
Message-ID: <009601d29218$9fd3e460$df7bad20$@wnsdev.com>
References: <002f01d29152$737b4550$5a71cff0$@wnsdev.com> <ab6d048b-b944-6661-11a5-503012dfad50@thelounge.net> <008001d29205$e4f503c0$aedf0b40$@wnsdev.com> <59c85e04-2f6a-1c81-ccba-fa8aac1c50ee@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59c85e04-2f6a-1c81-ccba-fa8aac1c50ee@thelounge.net>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Reindl Harald' <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your help.  See below for output

-----Original Message-----
From: Reindl Harald [mailto:h.reindl@thelounge.net] 
Sent: Tuesday, February 28, 2017 2:34 PM
To: linux-raid@vger.kernel.org
Subject: Re: GRUB warning after replacing disk drive in RAID1



Am 28.02.2017 um 22:01 schrieb Peter Sangas:
> But I issue the grub command AFTER the re-sync is completed

>>>output of "cat /proc/mdstat" and your environment missing!

>>>* cat /proc/mdstat
>>>* df -hT
>>>* lsscsi
>>>* lsblk

>>>no pictures and interpretations, just copy&paste from the terminal (input
as well as output)

>>>please help others to help you


cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4]
[raid10] 
md3 : active raid1 sdc5[3] sdb5[1] sda5[0]
      97589248 blocks super 1.2 [3/3] [UUU]
      
md1 : active raid1 sdc2[3] sdb2[1] sda2[0]
      126887936 blocks super 1.2 [3/3] [UUU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md5 : active raid1 sdc7[3] sdb7[1] sda7[0]
      244169728 blocks super 1.2 [3/3] [UUU]
      bitmap: 0/2 pages [0KB], 65536KB chunk

md2 : active raid1 sdc3[3] sdb3[1] sda3[0]
      195181568 blocks super 1.2 [3/3] [UUU]
      bitmap: 1/2 pages [4KB], 65536KB chunk

md4 : active raid1 sdc6[3] sdb6[1] sda6[0]
      97589248 blocks super 1.2 [3/3] [UUU]
      
md0 : active raid1 sdc1[3] sdb1[1] sda1[0]
      19514368 blocks super 1.2 [3/3] [UUU]
      
unused devices: <none>

uname -a 
Linux green 4.4.0-47-generic #68-Ubuntu SMP Wed Oct 26 19:39:52 UTC 2016
x86_64 x86_64 x86_64 GNU/Linux

df -hT
Filesystem     Type      Size  Used Avail Use% Mounted on
udev           devtmpfs   63G     0   63G   0% /dev
tmpfs          tmpfs      13G  746M   12G   6% /run
/dev/md2       ext4      184G   31G  144G  18% /
tmpfs          tmpfs      63G     0   63G   0% /dev/shm
tmpfs          tmpfs     5.0M     0  5.0M   0% /run/lock
tmpfs          tmpfs      63G     0   63G   0% /sys/fs/cgroup
/dev/md0       ext4       19G  289M   17G   2% /boot
/dev/md3       ext4       92G   40G   48G  46% /cl
/dev/md5       ext4      230G   31G  187G  15% /sd
/dev/md4       ext4       92G   20G   68G  22% /pc
tan:/clbck     nfs4      596G  169G  398G  30% /clbck
tan:/sdbck     nfs4      596G  169G  398G  30% /sdbck
tmpfs          tmpfs      13G  4.0K   13G   1% /run/user/275
/dev/sde1      ext3      2.7T  676G  1.9T  26% /archive
tmpfs          tmpfs      13G  4.0K   13G   1% /run/user/286
/dev/sdd1      ext3      1.8T  1.6T  182G  90% /backupdisk
tmpfs          tmpfs      13G   12K   13G   1% /run/user/277
tmpfs          tmpfs      13G     0   13G   0% /run/user/283
tmpfs          tmpfs      13G  4.0K   13G   1% /run/user/280
tmpfs          tmpfs      13G  4.0K   13G   1% /run/user/285
tmpfs          tmpfs      13G     0   13G   0% /run/user/299
tmpfs          tmpfs      13G     0   13G   0% /run/user/1100
tmpfs          tmpfs      13G     0   13G   0% /run/user/1685


lsscsi
[2:0:0:0]    disk    ATA      WDC WD30EZRS-00J 0A80  /dev/sde 
[3:0:0:0]    disk    ATA      WDC WD2000FYYZ-0 1K03  /dev/sdd 
[4:0:0:0]    disk    ATA      INTEL SSDSC2BX80 0140  /dev/sda 
[5:0:0:0]    disk    ATA      INTEL SSDSC2BX80 0140  /dev/sdb 
[6:0:0:0]    disk    ATA      INTEL SSDSC2BX80 0140  /dev/sdc

lsblk
NAME    MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda       8:0    0 745.2G  0 disk  
+-sda1    8:1    0  18.6G  0 part  
 L-md0   9:0    0  18.6G  0 raid1 /boot
+-sda2    8:2    0 121.1G  0 part  
 L-md1   9:1    0   121G  0 raid1 [SWAP]
+-sda3    8:3    0 186.3G  0 part  
 L-md2   9:2    0 186.1G  0 raid1 /
+-sda4    8:4    0     1K  0 part  
+-sda5    8:5    0  93.1G  0 part  
 L-md3   9:3    0  93.1G  0 raid1 /cl
+-sda6    8:6    0  93.1G  0 part  
 L-md4   9:4    0  93.1G  0 raid1 /pc
L-sda7    8:7    0   233G  0 part  
  L-md5   9:5    0 232.9G  0 raid1 /sd
sdb       8:16   0 745.2G  0 disk  
+-sdb1    8:17   0  18.6G  0 part  
 L-md0   9:0    0  18.6G  0 raid1 /boot
+-sdb2    8:18   0 121.1G  0 part  
 L-md1   9:1    0   121G  0 raid1 [SWAP]
+-sdb3    8:19   0 186.3G  0 part  
 L-md2   9:2    0 186.1G  0 raid1 /
+-sdb4    8:20   0     1K  0 part  
+-sdb5    8:21   0  93.1G  0 part  
 L-md3   9:3    0  93.1G  0 raid1 /cl
+-sdb6    8:22   0  93.1G  0 part  
 L-md4   9:4    0  93.1G  0 raid1 /pc
L-sdb7    8:23   0   233G  0 part  
  L-md5   9:5    0 232.9G  0 raid1 /sd
sdc       8:32   0 745.2G  0 disk  
+-sdc1    8:33   0  18.6G  0 part  
 L-md0   9:0    0  18.6G  0 raid1 /boot
+-sdc2    8:34   0 121.1G  0 part  
 L-md1   9:1    0   121G  0 raid1 [SWAP]
+-sdc3    8:35   0 186.3G  0 part  
 L-md2   9:2    0 186.1G  0 raid1 /
+-sdc4    8:36   0     1K  0 part  
+-sdc5    8:37   0  93.1G  0 part  
 L-md3   9:3    0  93.1G  0 raid1 /cl
+-sdc6    8:38   0  93.1G  0 part  
 L-md4   9:4    0  93.1G  0 raid1 /pc
L-sdc7    8:39   0   233G  0 part  
  L-md5   9:5    0 232.9G  0 raid1 /sd
sdd       8:48   0   1.8T  0 disk  
L-sdd1    8:49   0   1.8T  0 part  /backupdisk
sde       8:64   0   2.7T  0 disk  
L-sde1    8:65   0   2.7T  0 part  /archive

> -----Original Message-----
> From: Reindl Harald [mailto:h.reindl@thelounge.net]
> Sent: Tuesday, February 28, 2017 1:23 AM
> To: linux-raid@vger.kernel.org
> Subject: Re: GRUB warning after replacing disk drive in RAID1
>
> Am 28.02.2017 um 00:37 schrieb Peter Sangas:
>> I have a RAID1 with 3 disks sda,sdb,sdc.  After replacing sdc and 
>> re-syncing it to the array I issued the following command to load 
>> grub but I get this
>> warning:
>>
>> grub-install /dev/sdc
>>
>> Installing for i386-pc platform.
>> grub-install: warning: Couldn't find physical volume `(null)'. Some 
>> modules may be missing from core image..
>> grub-install: warning: Couldn't find physical volume `(null)'. Some 
>> modules may be missing from core image..
>> Installation finished. No error reported.
>>
>> Does anyone know why I get this warning and how to avoid it
>
> it's harmless and disappears after the resync finished
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

