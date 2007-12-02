From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Spontaneous rebuild
Date: Sun, 2 Dec 2007 18:28:26 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712021827100.13428@p34.internal.lan>
References: <475230AF.3010100@student.tuwien.ac.at> <18259.15453.811495.461016@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18259.15453.811495.461016@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Oliver Martin <oliver.martin@student.tuwien.ac.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 3 Dec 2007, Neil Brown wrote:

> On Sunday December 2, oliver.martin@student.tuwien.ac.at wrote:
>>
>> Anyway, the problems are back: To test my theory that everything is
>> alright with the CPU running within its specs, I removed one of the
>> drives while copying some large files yesterday. Initially, everything
>> seemed to work out nicely, and by the morning, the rebuild had finished.
>> Again, I unmounted the filesystem and ran badblocks -svn on the LVM. It
>> ran without gripes for some hours, but just now I saw md had started to
>> rebuild the array again out of the blue:
>>
>> Dec  1 20:04:49 quassel kernel: usb 4-5.2: reset high speed USB device
>> using ehci_hcd and address 4
>> Dec  2 01:06:02 quassel kernel: md: data-check of RAID array md0
>                                      ^^^^^^^^^^
>> Dec  2 01:06:02 quassel kernel: md: minimum _guaranteed_  speed: 1000
>> KB/sec/disk.
>> Dec  2 01:06:02 quassel kernel: md: using maximum available idle IO
>> bandwidth (but not more than 200000 KB/sec) for data-check.
>                                                  ^^^^^^^^^^
>> Dec  2 01:06:02 quassel kernel: md: using 128k window, over a total of
>> 488383936 blocks.
>> Dec  2 03:57:24 quassel kernel: usb 4-5.2: reset high speed USB device
>> using ehci_hcd and address 4
>>
>
> This isn't a resync, it is a data check.  "Dec  2" is the first Sunday
> of the month.  You probably have a crontab entries that does
>   echo check > /sys/block/mdX/md/sync_action
>
> early on the first Sunday of the month.  I know that Debian does this.
>
> It is good to do this occasionally to catch sleeping bad blocks.

While we are on the subject of bad blocks, is it possible to do what 3ware 
raid controllers do without an external card?

They know when a block is bad and they remap it to another part of the 
array etc, where as with software raid you never know this is happening 
until the disk is dead.

For example with 3dm2 it notifies you if you have e-mail alerts set to 2 
(warn) it will e-mail you every time there is a sector re-allocation, is 
this possible with software raid or does it *require* HW raid/external 
controller?

Justin.
