From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Raid over 48 disks
Date: Tue, 18 Dec 2007 16:21:29 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712181619290.10513@p34.internal.lan>
References: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com>
 <Pine.LNX.4.64.0712181325480.13538@p34.internal.lan> <476820B0.9010200@ph.tum.de>
 <Pine.LNX.4.64.0712181523250.7823@p34.internal.lan> <476837F6.7050404@ph.tum.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <476837F6.7050404@ph.tum.de>
Sender: linux-raid-owner@vger.kernel.org
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Cc: Norman Elton <normelton@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 18 Dec 2007, Thiemo Nagel wrote:

>>> Performance of the raw device is fair:
>>> # dd if=/dev/md2 of=/dev/zero bs=128k count=64k
>>> 8589934592 bytes (8.6 GB) copied, 15.6071 seconds, 550 MB/s
>>> 
>>> Somewhat less through ext3 (created with -E stride=64):
>>> # dd if=largetestfile of=/dev/zero bs=128k count=64k
>>> 8589934592 bytes (8.6 GB) copied, 26.4103 seconds, 325 MB/s
>> 
>> Quite slow?
>> 
>> 10 disks (raptors) raid 5 on regular sata controllers:
>> 
>> # dd if=/dev/md3 of=/dev/zero bs=128k count=64k
>> 8589934592 bytes (8.6 GB) copied, 10.718 seconds, 801 MB/s
>> 
>> # dd if=bigfile of=/dev/zero bs=128k count=64k
>> 3640379392 bytes (3.6 GB) copied, 6.58454 seconds, 553 MB/s
>
> Interesting.  Any ideas what could be the reason?  How much do you get from a 
> single drive?  -- The Samsung HD501LJ that I'm using gives ~84MB/s when 
> reading from the beginning of the disk.
>
> With RAID 5 I'm getting slightly better results (though I really wonder why, 
> since naively I would expect identical read performance) but that does only 
> account for a small part of the difference:
>
> 	16k read	64k write
> chunk
> size	RAID 5	RAID 6	RAID 5	RAID 6
> 128k	492	497	268	270
> 256k	615	530	288	270
> 512k	625	607	230	174
> 1024k	650	620	170	75
>
> Kind regards,
>
> Thiemo
>

# dd if=/dev/sdc of=/dev/null bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 13.8108 seconds, 77.7 MB/s

With more than 2x the drives I'd think you'd have faster speed, perhaps 
the contoller is the problem?

I am using ICH8R (but the raid within linux) and 2 port SATA cards, each 
has their own dedicated bandwidth via PCI-e bus.

I have also tried (on 3ware controllers exporting as JBOD etc, sw RAID5) 
with 10 disks, I saw similar performance with read but not write.

Justin.
