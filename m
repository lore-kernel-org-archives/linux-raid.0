From: Troels Bang Jensen <marvin@fnuck.dk>
Subject: Re: RAID 5 array keeps dropping drive on boot
Date: Tue, 8 Nov 2005 00:39:00 +0100
Message-ID: <5DD8751D-7FE2-4179-9887-853A704DE0D6@fnuck.dk>
References: <2A807893-B5A6-4EF1-B862-1D6F22D71B60@fnuck.dk> <17263.57266.902113.362087@cse.unsw.edu.au>
Mime-Version: 1.0 (Apple Message framework v734)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17263.57266.902113.362087@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Nov 8, 2005, at 00:13 , Neil Brown wrote:

> On Monday November 7, marvin@fnuck.dk wrote:
>
>> I've got a simple setup with three IDE drives where two disks share a
>> 30mb RAID1 partition for /boot and all three share a 590GB RAID5
>> array for /
>>
>> My mdadm.conf looks like this:
>>
>> DEVICE partitions
>> ARRAY /dev/md1 level=raid5 num-devices=3 UUID=4b22b17d:
>> 06048bd3:ecec156c:31fabbaf
>>     devices=/dev/hda3,/dev/hdc3,/dev/hdg2
>> ARRAY /dev/md0 level=raid1 num-devices=2
>> UUID=7d5c8486:35fff755:f5d34fc2:a12f1f81
>>     devices=/dev/hda1,/dev/hdc1
>>
>
> You should remove the "devices=" sections.  They aren't causing a
> problem in this case, but they could if you happened to change the
> name of a device (plug it in somewhere different).
>
>
>>
>> The UUIDs check out with the devices, and indeed /dev/md0 works
>> fine. /dev/md1 used to work perfectly, but read on :-p
>>
>> All the raid partitions are type 0xfd RAID auto-detect.
>>
>
> Are you sure?  Really really sure?  Particularly hdc3.  What is it's
> type.  Could you
>   fdisk -l /dev/hdc
> just to convince me?  Because your problem REALLY looks like the
> partition type isn't 0xfd...
> You gave lots of detail, which is excellent, and from all that detail,
> I cannot see any other possible explanation.
>

Unfortunately I'm sure;

    Device Boot      Start         End      Blocks   Id  System
/dev/hdc1               1           6       48163+  fd  Linux raid  
autodetect
/dev/hdc2               7          30      192780   82  Linux swap /  
Solaris
/dev/hdc3              31       36481   292792657+  fd  Linux raid  
autodetect

The table is identical to the one hda uses.

Originally I created the RAID partitions with the Debian Sarge  
installer - and it's worked great up until I replaced hdc.

I just did a little more googling and found this:

http://groups.google.com/group/linux.debian.maint.boot/browse_thread/ 
thread/c8d20fc20603b120/46104bd9670312b6?lnk=st&q=raid+dropping 
+partition+boot&rnum=3#46104bd9670312b6

which describes a Debian installation on a drive structure similar to  
mine(except I don't use LVM on top of the RAID5).

It states that it could be a problem having more than one primary  
partition for software raid on a drive because mdadm would write a  
raid superblock to the disk device and cause chaos.

I checked the drives, and it looked like this:

mdadm: No super block found on /dev/hda (Expected magic a92b4efc, got  
00000000)
mdadm: No super block found on /dev/hdc (Expected magic a92b4efc, got  
00000000)
mdadm: No super block found on /dev/hdg (Expected magic a92b4efc, got  
70e7710e)

So I think I should be safe. Still, all partitions on the drives are  
primary partitions. Could that be the explanation?

Regards, Troels
