From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Tue, 14 Apr 2020 21:00:48 +0200
Message-ID: <f415cfb3-9612-d29d-17c1-d34405233519@peter-speer.de>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <875ze23pfm.fsf@vps.thesusis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <875ze23pfm.fsf@vps.thesusis.net>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <phill@thesusis.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 14.04.20 20:14, Phillip Susi wrote:
> 
> Stefanie Leisestreichler writes:
> 
>> To be safe on system updates I want to use LVM snapshots. I like to make
>> a LVM-based snapshot when the system comes up, do the system updates,
>> perform the test and dicide either to go with the updates made or revert
>> to the original state.
> 
> Tradditional LVM snapshots were not suitable for keeping multiple, long
> lived snapshots around.  They were really only for temporary use, such
> as taking a snapshot to do a dump of without having to shut down
> services.  I seem to remember they were developing a new multi snapshot
> dm backend that would address some of these shortcomings, but I can't
> find anything about that now in the google machine.
> 
I could imagine living with this limitation since I
- do not expect to have to revert to the original state at all
- will have a decision about deleting/merging the snapshot pretty soon 
after the tests.

>> I have read that - when using UEFI - the EFI-System-Partition (ESP) has
>> to reside in a own native partition, not in a RAID nor LVM block device.
> 
> Correct.
This is exactly the point which I do not understand. So it is implicitly 
saying that it makes no sense to raid the 2 EFI-System-Partitions (sda1 
+ sdb1), i.e. as /dev/md124, as GRUB can not write to a RAID device and 
instead uses /dev/sda1 and no automatic sync will happen?

If that is true, I wonder how to setup a system using RAID 1 where you 
can - frankly spoken - remove one or the other disk and boot it :-(

> 
>> I wonder, how I should build up this construct. I thought I could build
>> one partition with TOTAL_SIZE - 100M, Type FD00, on each device, take
>> these two (sda1 + sdb1) and build a RAID 1 array named md0. Next make
>> md0 the physical volume of my LVM (pvcreate /dev/md0) and after that add
>> a volume group in which I put my logical volumes:
>> - swap - type EF00
I was wrong with that, swap will be type 8200.


>> - /boot - with filesystem fat32 for uefi
> 
> Like you mentioned above, this needs to be a native partition, not a
> logical volume.  Actually you only need /boot/EFI in a native fat32
> partition, not all of /boot.
> 
> 
OK, got it and will do so.
