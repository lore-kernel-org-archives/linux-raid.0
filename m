From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?Re=3A_RAID0_size_over_2_TB?=
Date: Mon, 08 Sep 2014 09:33:51 +0200
Message-ID: <20140908093351.382B7496@pobox.sk>
References: <20140906230928.BB645CEE@pobox.sk>, <20140908170037.451e2376@notabene.brown>, <20140908091811.1DD1140C@pobox.sk> <20140908172832.7543b241@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140908172832.7543b241@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> CC: linux-raid@vger.kernel.org
>On Mon, 08 Sep 2014 09:18:11 +0200 "azurIt" <azurit@pobox.sk> wrote:
>
>> >
>> > CC: linux-raid@vger.kernel.org
>> >On Sat, 06 Sep 2014 23:09:28 +0200 "azurIt" <azurit@pobox.sk> wrote:
>> >
>> >> Hi,
>> >> 
>> >> i'm having problems with growing my RAID0 array over 2 TB. I installed two 4 TB drives, created 4 TB partitions but array cannot be resized over 2 TB. Superblock versoin is 0.90 and kernel version is 3.2.53 - according to linux RAID wiki, it should support 4 TB component/array size:
>> >> https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#The_version-0.90_Superblock_Format
>> >> 
>> >> Some more info:
>> >> 
>> >> # mdadm --detail /dev/md2
>> >> /dev/md2:
>> >>         Version : 0.90
>> >>   Creation Time : Tue Sep 28 16:54:04 2010
>> >>      Raid Level : raid1
>> >>      Array Size : 2147483520 (2048.00 GiB 2199.02 GB)
>> >>   Used Dev Size : 2147483520 (2048.00 GiB 2199.02 GB)
>> >>    Raid Devices : 2
>> >>   Total Devices : 2
>> >> Preferred Minor : 2
>> >>     Persistence : Superblock is persistent
>> >> 
>> >>     Update Time : Sat Sep  6 23:04:44 2014
>> >>           State : clean 
>> >>  Active Devices : 2
>> >> Working Devices : 2
>> >>  Failed Devices : 0
>> >>   Spare Devices : 0
>> >> 
>> >>            UUID : 9a363004:ad04abfe:2e31e1c3:caf66df4
>> >>          Events : 0.77066
>> >> 
>> >>     Number   Major   Minor   RaidDevice State
>> >>        0       8       33        0      active sync   /dev/sdc1
>> >>        1       8       49        1      active sync   /dev/sdd1
>> >> 
>> >> 
>> >> 
>> >> 
>> >> 
>> >> 
>> >> 
>> >> # fdisk /dev/sdd
>> >> 
>> >> WARNING: GPT (GUID Partition Table) detected on '/dev/sdd'! The util fdisk doesn't support GPT. Use GNU Parted.
>> >
>> >Why are you using "fdisk" even though "fdisk" is telling you not to use it?
>> >
>> >What does
>> >  cat /proc/partitions
>> >
>> >say about the sizes of the partitions?
>> >
>> >NeilBrown
>> >
>> 
>> 
>> 
>> I, of course, didn't use fdisk to create partitions - they were created using cgdisk, but it's graphical tool so i wasn't able to send output from it, so i get output from fdisk to prove, that partitions are large enough.
>
>Yet fdisk *didn't* prove that the partitions are large enough - it said the
>partitions were:
>
>/dev/sdd1               1  4294967295  2147483647+  ee  GPT
>                                       ^^^^^^^^^^^
>
>2 Gig.
>
>And /proc/partitions tells me:
>
>> 
>> 
>> # cat /proc/partitions
>> major minor  #blocks  name
>> 
>>    9        2 2147483520 md2
>>    8       32 3907018584 sdc
>>    8       33 2147483647 sdc1
>>    8       48 3907018584 sdd
>>    8       49 2147483647 sdd1
>
>that the partitions are 2Gig.  You need to sort the partition size out.  I
>cannot help you.  I have no experience with GPT.  Maybe a reboot?
>
>NeilBrown
>




This is really strange, here is what cgdisk is reporting:
http://imgur.com/U8VnAdM
