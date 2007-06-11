From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: below 10MB/s write on raid5
Date: Mon, 11 Jun 2007 09:53:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706110950120.31708@p34.internal.lan>
References: <200706111446.55813.Dexter.Filmore@gmx.de>
 <Pine.LNX.4.64.0706110847380.31708@p34.internal.lan> <200706111528.11828.Dexter.Filmore@gmx.de>
 <Pine.LNX.4.64.0706110928420.31708@p34.internal.lan>
 <Pine.LNX.4.64.0706110844280.5806@gheavc.wnzcbav.cig>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706110844280.5806@gheavc.wnzcbav.cig>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 11 Jun 2007, Jon Nelson wrote:

> On Mon, 11 Jun 2007, Justin Piszcz wrote:
>
>>
>>
>> On Mon, 11 Jun 2007, Dexter Filmore wrote:
>>
>>> On Monday 11 June 2007 14:47:50 Justin Piszcz wrote:
>>>> On Mon, 11 Jun 2007, Dexter Filmore wrote:
>>>>> I recently upgraded my file server, yet I'm still unsatisfied with the
>>>>> write speed.
>>>>> Machine now is a Athlon64 3400+ (Socket 754) equipped with 1GB of RAM.
>>>>> The four RAID disks are attached to the board's onbaord sATA controller
>>>>> (Sil3114 attached via PCI)
>>>>> Kernel is 2.6.21.1, custom on Slackware 11.0.
>>>>> RAID is on four Samsung SpinPoint disks, has LVM, 3 volumes atop of each
>>>>> XFS.
>>>>>
>>>>> The machine does some other work, too, but still I would have suspected
>>>>> to get into the 20-30MB/s area. Too much asked for?
>>>>>
>>>>> Dex
>>>>
>>>> What do you get without LVM?
>>>
>>> Hard to tell: the PV hogs all of the disk space, can't really do non-LVM
>>> tests.
>>
>> You can do a read test.
>>
>> 10gb read test:
>>
>> dd if=/dev/md0 bs=1M count=10240 of=/dev/null
>
> eek! Make sure to use iflag=direct
> with that otherwise you'll get cached reads and that will throw
> the numbers off considerably.

Wow, makes a difference for faster devices.  Does bonnie++ use 
iflag=direct when benchmarking?

p34:~# dd if=/dev/md0 bs=1M count=1024 of=/dev/null iflag=direct
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 15.0454 seconds, 71.4 MB/s
p34:~# dd if=/dev/md0 bs=1M count=1024 of=/dev/null
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 14.991 seconds, 71.6 MB/s
p34:~# dd if=/dev/md3 bs=1M count=1024 of=/dev/null iflag=direct
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 3.08707 seconds, 348 MB/s
p34:~# dd if=/dev/md3 bs=1M count=1024 of=/dev/null
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 2.02948 seconds, 529 MB/s
p34:~#

p34:~# dd if=/dev/md3 bs=1M count=10024 of=/dev/null
10024+0 records in
10024+0 records out
10510925824 bytes (11 GB) copied, 17.7321 seconds, 593 MB/s
p34:~# sync
p34:~# dd if=/dev/md3 bs=1M count=10024 of=/dev/null iflag=direct
10024+0 records in
10024+0 records out
10510925824 bytes (11 GB) copied, 29.022 seconds, 362 MB/s
p34:~#


