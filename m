From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: consistency detect
Date: Mon, 11 Oct 2004 14:42:58 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <416A63B2.7020004@tls.msk.ru>
References: <1097465522.3111.24.camel@localhost.localdomain> <416A4A29.9080906@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <416A4A29.9080906@wasp.net.au>
To: Brad Campbell <brad@wasp.net.au>
Cc: mingz@ele.uri.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell wrote:
> Ming Zhang wrote:
> 
>> I have a question on RAID error detect. hope somebody can help me to
>> find it out. thanks.
>>
>> take raid1 as an example, if one disk fail, raid 1 can detect the data
>> on disk is compromised and then reconstruct it using a spare disk. this
>> is straight forward.
>>
>> but if one request comes to raid1 and raid1 sends requests to both
>> disks, at this time, system reboots because power outage, system
>> crashes, or any other reason. then after system reboots, how raid 1
>> detects which disk has consistent data? since before reboot, anything
>> can happen, data may in disk1 but not in disk2, or in disk2 but not in
>> disk1, or not in both disks, or already on both disks.
>>
>> how raid1 or other raid code deal with this?
> 
> 
> In short, it does not deal with it at all. RAID will deal with a disk 
> failure, it has no guarantees about consistency on power failures, hard 
> lockups or other catastrophic events.

This is incorrect.  In-kernel raid code keeps track of arrays and
underlying disk state during write operations.  On clean shutdown,
when everything has been written, raid superblocks on all disks
gets updated to indicate this.  In case of unclean shutdown, raid
code will reconstruct older copies of data using most recent ones
(ie, from a disk which has most recent "events" value in superblock).
The same is done for all other raid levels (4, 5, 6), but onot for
raid0 for obvious reasons (as there's no R in raid0 per se).

> A UPS is cheap insurance against consistency issues in combination with 
> a journalling filesystem.

Well, it is another (albiet very good) layer of protection.

/mjt
