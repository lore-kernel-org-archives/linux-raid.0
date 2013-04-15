From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: raid 1 errors then I failed and removed the drive. now cant tell
 which one it was?
Date: Mon, 15 Apr 2013 19:20:47 +0200
Message-ID: <516C36EF.2040909@schinagl.nl>
References: <20130416042742.GA12964@earthlink.net> <20130416074601.GA25795@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130416074601.GA25795@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@post.harvard.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16-04-13 09:46, Robin Hill wrote:
> On Tue Apr 16, 2013 at 12:27:42AM -0400, Mitchell Laks wrote:
>
>> Hi,
>>
>> I store lots of data on a raid1 created with mdadm on debian sid  using kernel
>> Linux  3.2.0-2-amd64 #1 SMP Fri Apr 6 05:01:55 UTC 2012 x86_64 GNU/Linux.
>>
>> Now I was backing up the data from the raid to another external drive
>> and the errors began
>>
>> [730636.445918] ata1.00: error: { UNC }
>> [730636.464576] ata1.00: configured for UDMA/33
>> [730636.464584] ata1: EH complete
>> [730638.110558] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [730638.115052] ata1.00: port_status 0x20200000
>> [730638.119441] ata1.00: failed command: READ DMA
>> [730638.123848] ata1.00: cmd c8/00:08:ef:9f:90/00:00:00:00:00/e1 tag 0 dma 4096 in
>> [730638.123850]          res 51/40:00:f4:9f:90/40:00:01:00:00/e1 Emask 0x9 (media error)
>> [730638.132821] ata1.00: status: { DRDY ERR }
>> [730638.137305] ata1.00: error: { UNC }
>> [730638.157256] ata1.00: configured for UDMA/33
>> [730638.157262] ata1: EH complete
>> [730639.802239] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [730639.806730] ata1.00: port_status 0x20200000
>> [730639.811111] ata1.00: failed command: READ DMA
>> [730639.815511] ata1.00: cmd c8/00:08:ef:9f:90/00:00:00:00:00/e1 tag 0 dma 4096 in
>> [730639.815513]          res 51/40:00:f4:9f:90/40:00:01:00:00/e1 Emask 0x9 (media error)
>> [730639.824457] ata1.00: status: { DRDY ERR }
>> [730639.828930] ata1.00: error: { UNC }
>> [730639.848936] ata1.00: configured for UDMA/33
>>
>> they seemed to be coming from drive /dev/sda1 of the raid while
>> /dev/sdb1 was ok
>> so i did
>> mdadm /dev/md0 -f /dev/sda1
>> mdadm /dev/md0 -r /dev/sda1
>>
>> then I rsynced from the remaining drive to /dev/sdd1 an external
>> drive. No more errors.
>>
>> However I forgot to label the usable drive by creating a file on it or
>> editing a file on it.
>>
>> But now I shut down and unplug one of the two drives, then run
>> mdadm -E /dev/sda1
>> it seems to be the good (unfailed) drive
>>
>> But similarly when  I unplug the other drive and put this one back
>> i still get it listed as an unfailed drive
>>
>> how can i figure out which is the failed drive and which is the
>> remaining one????
>>
> Normally, the event count and update time will indicate which was
> failed, but if you've restarted with each drive in separately then this
> may have updated both. The obvious way to check in this case would be to
> do a read test of the drive (dd if=/dev/sda1 of=/dev/null bs=1M) or a
> SMART test - if you get errors then it's the failed one.
smartctl -a /dev/disk should tell you any failures from its log all 
ready. Think pending errors or offline unrecoverable are key points to 
look at. If that also doesn't tell you which one is which, ata1 is the 
first sata port, but if you allready unplugged, that won't help you either.

If smartctl -t long /dev/disk doesn't result in any errors being found 
on both disks, chances are, the disks 'spare block recovery' mechanism 
kicked in and your disk is 'as good as new'. Personally, I would order a 
new disk and have it ready since once these errors start, the end is 
near. Chances are however, it'll work for years :)

Since you know the external drive is functioning properly and is up to 
date, wipe the superblock on both internal disks, add 1 to the externa 
driver, 'grow' the array to 3 disks', add the 2nd internal disks, run a 
'check' to be very sure, grow to 2 disks removing the external from the 
chain again.
>
> Cheers,
>      Robin

