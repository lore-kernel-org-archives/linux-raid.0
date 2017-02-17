From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: RAID10 and 'writemostly' support
Date: Fri, 17 Feb 2017 11:03:05 +0100
Message-ID: <f6ed7560-97b8-78ef-26be-789a8bc372b5@thelounge.net>
References: <07e8d394-2f95-caae-d971-a5fef009fefe@thelounge.net>
 <033aa14d-32a0-531d-7d7d-c01a0aeb13eb@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <033aa14d-32a0-531d-7d7d-c01a0aeb13eb@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 17.02.2017 um 02:24 schrieb Anthony Youngman:
> On 16/02/17 14:08, Reindl Harald wrote:
>> Hi
>>
>> i am new and was redirected to this list from the bugtracker
>> please have a look at https://bugzilla.kernel.org/show_bug.cgi?id=194551
>>
>> currently "writemostly" seems to be only supported on "real" RAID1 while
>> i was in hope that by the conecpt of RAID10 having more or less
>> RAID0+RAID1 it would also work on RAID10 (and on the virtual machine wre
>> i tested mdadm with the flag before buying the disks it did not complain)
>
> Be careful. Don't confuse Raid10 with Raid1+0. They are NOT the same
> thing (on linux at least), although they are very similar

yeah, i realized that but anyways thought the "writemostly" logic is 
there too and maybe the docs not up-to-date

sadly i can't write a patch on my own but only point how useful it would be

let's say you need a fast and really large storage on a mostly-read 
workload - take 10x4 TB disks - RAID5/RAID6 is horrible in case of drive 
error and rebuild, 10 x 4 TB SSD is horrible in case of pricing

5x4 TB SSD = 5 x 1400 = 7000
5x4 TB HDD = 5 x 100 = 500
total price 7500 versus 14000 for flash-only

surely, you can setup 5 RAID1 and on top RAID0 or LVM for such a large 
setup if your start from scratch - on the other hand my current RAID10 
is from 2011 where SSD was not such a topic and since the operating 
system is RAID10 too the inital setup is not that easy and after 
Fedora/RHEL "reworked" anaconda it's more painful to impossible (i even 
had enough of the manual partition tool in a virtual machine installing 
CentOS7 and created the data partitions after the OS install)
