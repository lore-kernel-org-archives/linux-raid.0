From: Mirko Benz <mirko.benz@web.de>
Subject: Re: RAID 0 over HW RAID
Date: Thu, 11 May 2006 15:20:44 +0200
Message-ID: <44633A2C.8010503@web.de>
References: <Pine.LNX.4.44.0605101130080.11278-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0605101130080.11278-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

/sys/block/sdc/queue/max_sectors_kb is 256 for both HW RAID devices.

We have tested with larger block sizes (256K, 1MB) with actually 
provides a bit lower performance. Access is sequentiell.

We made some more tests with dd for measuring performance. With two 
strange issues where I have no explanation for.

1)
test:~# dd if=/dev/sdc of=/dev/null bs=128k count=30000
30000+0 records in
30000+0 records out
3932160000 bytes transferred in 11.311464 seconds (347626088 bytes/sec)

test:~# dd if=/dev/sdc1 of=/dev/null bs=128k count=30000
30000+0 records in
30000+0 records out
3932160000 bytes transferred in 21.004938 seconds (187201694 bytes/sec)

Read performance from the same HW RAID is different for entire device 
(sdc) compared with partition (sdc1).

2)
test:~# dd if=/dev/md0 of=/dev/null bs=128k count=30000
30000+0 records in
30000+0 records out
3932160000 bytes transferred in 9.950705 seconds (395163959 bytes/sec)

test:~# dd if=/dev/md0 of=/dev/null bs=128k count=30000 skip=1000
30000+0 records in
30000+0 records out
3932160000 bytes transferred in 6.398646 seconds (614530000 bytes/sec)

When skipping some MBytes performance improves significantly and is 
almost the sum of the two HW RAID controllers.

Regards,
Mirko

Mark Hahn schrieb:
>> - 2 RAID controllers: ARECA with 7 SATA disks each (RAID5)
>>     
>
> what are the /sys/block settings for the blockdevs these export?
> I'm thinking about max*sectors_kb.
>
>   
>> - stripe size is always 64k
>>
>> Measured with IOMETER (MB/s, 64 kb block size with sequential I/O).
>>     
>
> I don't see how that could be expected to work well.  you're doing 
> sequential 64K IO from user-space (that is, inherently one at a time),
> and those map onto a single chunk via md raid0.  (well, if the IOs
> are aligned - but in any case you won't be generating 128K IOs which
> would be the min expected to really make the raid0 shine.)
>
>   
>> one HW RAID controller:    
>> - R: 360 W: 240
>> two HW RAID controllers:    
>> - R: 619  W: 480 (one IOMETER worker per device)
>> MD0 over two  HW RAID controllers:
>> - R 367 W: 433 (one IOMETER worker over md device)
>>
>> Read throughput is similar to a single controller. Any hint how to 
>> improve that?
>> Using a larger block size does not help.
>>     
>
> which blocksize are you talking about?  larger blocksize at the app
> level should help.  _smaller_ block/chunk size at the md level.
> and of course those both interact with the block size prefered 
> by the areca.
>
>   
>> We are considering using MD to combine HW RAID controllers with battery 
>> backup support for better data protection.
>>     
>
> maybe.  all this does is permit the HW controller to reorder transactions,
> which is not going to matter much if your loads are, in fact, sequential.
>
>   
>> In this scenario md should do 
>> no write caching.
>>     
>
> in my humble understanding, MD doesn't do WC.
>
>   
>> Is it possible to use something like O_DIRECT  with md?
>>     
>
> certainly (exactly O_DIRECT).  this is mainly instruction to the 
> pagecache, not MD.  I presume O_DIRECT mainly just follows a write
> by a barrier, which MD can respect and pass to the areca driver
> (which presumably also respects it, though the point of battery-backed
> cache would be to let the barrier complete before the IO...)
>
>
>   

