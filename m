From: Tom Walsh <tom@openhardware.net>
Subject: Re: array always resyncs on boot
Date: Mon, 01 Dec 2008 13:03:41 -0500
Message-ID: <493426FD.4060201@openhardware.net>
References: <4931B2C5.5060403@openhardware.net> <alpine.DEB.1.10.0811291633140.1796@p34.internal.lan> <4931E75D.5080905@openhardware.net> <493422E1.8080207@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <493422E1.8080207@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Tom Walsh wrote:
>> Justin Piszcz wrote:
>>>
>>
>>>> I just cannot keep the system from resyncing on every boot.  I've
>>>> gotten to the point that I'm thinking that I may have been root'ed and
>>>> the boot flash of the drives has been reflashed...  Ok, that is
>>>> reaching for an answer, I know.  This is time to ask for help.  help!
>>>
>>> If you boot knoppix and manually assemble the array does it assemble 
>>> cleanly
>>> or does it need a resync as well?
>>>
>>
>> Well, I used my last CD-R on the WD Data Lifeguard.  But, I think I 
>> know what you are driving at.  Booting Mandriva 2009 into Rescue mode, 
>> then choosing "Mount your partitions under mnt" does cleanly start the 
>> array.
>>
>> Following that further, I booted off /dev/sda1 (where my small 
>> Mandriva system is currently installed), then I disabled the mdadm 
>> service in /etc/init.d/.  I then waited for the system to do the 
>> resync and rebooted the system. Then logged into the system.
>>
> Just for grins, could you post the partition table for each disk? Maybe 
> just the output of "fdisk -l" to show everything? I always worry when 
> using drives of "almost" the same size.
> 

Sure, identical tables for all six drives:
Disk /dev/sda: 320.0 GB, 320071851520 bytes
255 heads, 63 sectors/track, 38913 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x733f1de9

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1        2433    19543041   fd  Linux raid 
autodetect
/dev/sda2            2434        2677     1959930   82  Linux swap / Solaris
/dev/sda3            2678       38900   290961247+   5  Extended
/dev/sda5            2678       38900   290961216   fd  Linux raid 
autodetect


Configuration is three RAID1 for '/', '/tmp' and '/var'.   RAID10 for 
/home as the larger array.

[root@speedy /]# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid1 sdd1[1] sdc1[0]
       19542976 blocks [2/2] [UU]
       bitmap: 0/150 pages [0KB], 64KB chunk

md3 : active raid10 sdd5[3] sdb5[1] sda5[0] sdc5[2] sde5[4] sdf5[5]
       872883456 blocks 64K chunks 2 near-copies [6/6] [UUUUUU]
       bitmap: 0/209 pages [0KB], 2048KB chunk

md2 : active raid1 sde1[0] sdf1[1]
       19542976 blocks [2/2] [UU]
       bitmap: 0/150 pages [0KB], 64KB chunk

md0 : active raid1 sda1[0] sdb1[1]
       19542976 blocks [2/2] [UU]
       bitmap: 0/150 pages [0KB], 64KB chunk

unused devices: <none>




-- 
Tom Walsh - WN3L - Embedded Systems Consultant
http://openhardware.net http://cyberiansoftware.com http://openzipit.org
"Windows? No thanks, I have work to do..."
----------------------------------------------------

