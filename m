From: "Jeffrey B. Layton" <laytonjb@charter.net>
Subject: Re: mdadm array not found on reboot
Date: Mon, 07 May 2007 13:06:46 -0400
Message-ID: <463F5CA6.6090407@charter.net>
References: <463F5796.1060808@charter.net> <Pine.LNX.4.64.0705071258410.968@p34.internal.lan>
Reply-To: laytonjb@charter.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705071258410.968@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
>
>
> On Mon, 7 May 2007, Jeffrey B. Layton wrote:
>
>> Hello,
>>
>> I apologize if this is a FAQ question or a typical newbie question,
>> but by google efforts have yielded anything yet.
>>
>> I built a RAID-1 using mdadm (Centos 4.2 with 2.6.16.19 kernel
>> and mdadm 1.6.0-2). It's just two SATA drives that I created using:
>>
>> mdadm --create --verbose /dev/md1 --level=raid1 --raid-devices=2 
>> /dev/sda1 /dev/sdb1
>>
>> The md built correctly and I built an ext3 on it. I created 
>> /etc/mdadm.conf
>> and modified /etc/fstab to mount the device. But when I reboot, the 
>> kernel
>> drops into RAID repair mode because it can't seem to find /dev/md1 and
>> yells about not finding any valid superblock (I can get the exact 
>> message
>> if needed). However I can mount /dev/sda1 with no problems.
>>
>> The only way I can get md1 back is to issue the command:
>>
>> mdadm -A /dev/md1 /dev/sda1 /dev/sdb1
>>
>> and everything works. I want to have /dev/md1 mounted automatically
>> on boot. I'm missing something simple here - how do I do this?
>>
>> TIA!
>>
>> Jeff
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Sounds like a udev issue and/or you did not create the mdadm.conf 
> properly.  Show us your mdadm.conf.
>
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=e235ee6c:415f1494:23c28b59:afd20140
   devices=/dev/sda1,/dev/sdb1
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=7121b438:7d36f9f6:8aa9c8b3:b5b0d211
   devices=/dev/hdc1,/dev/hdd1

Thanks!

Jeff

