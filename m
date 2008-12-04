From: "Sean Hildebrand" <silverwraithii@gmail.com>
Subject: Re: Crash while increasing RAID5 from 3 disks to 5, array won't build.
Date: Thu, 4 Dec 2008 18:49:02 -0500
Message-ID: <fa037c550812041549w2f93239se43d39150fe2dd47@mail.gmail.com>
References: <fa037c550812030743i70236951g964b444163425d39@mail.gmail.com>
	 <06bc99a2784b75f8d7c2a4e563f576c4.squirrel@neil.brown.name>
	 <fa037c550812031245u594ffd56q4d0b701456d81f1b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa037c550812031245u594ffd56q4d0b701456d81f1b@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 3, 2008 at 3:45 PM, Sean Hildebrand
<silverwraithii@gmail.com> wrote:
> On Wed, Dec 3, 2008 at 3:21 PM, NeilBrown <neilb@suse.de> wrote:
>> On Thu, December 4, 2008 2:43 am, Sean Hildebrand wrote:
>>> blkid reports that all five disks have the same UUID.
>>>
>>> Specifying disks by UUID results in "mdadm: no devices found for
>>> /dev/md0".
>>>
>>> Specifying disks based on their positions, /dev/sd[abcef]1 in this
>>> case, results in "mdadm: superblock on /dev/sda1 doesn't match others
>>> - assembly aborted" and it'll continue doing that with [bcef]1 if a is
>>> removed.
>>>
>>> mdadm --detail --scan outputs nothing.
>>>
>>> I've tried assembling the original three disks sans the two new ones
>>> to no avail.
>>
>> Please:
>>   git clone git://neil.brown.name/mdadm
>>   cd mdadm
>>   make
>>
>> and try the 'mdadm' that creates.
>> If that still doesn't work, please report the output of
>>   mdadm -E /dev/sd[abcdef]1
>> and
>>   mdadm -Avv /dev/md0 /dev/sd[abcdef]1
>>
>> NeilBrown
>>
>>
>
> That did it. Built, mounted and back to rebuilding.
>
> Thanks.
>

Having an issue right now, I am unsure of what's going on. When I
resized my array from 5 disks to 3 some months ago, the filesystem was
automatically made smaller.

I'd assume the same happens when growing the array. However, conky and
my file manager report that the partition is 1.35TB. fdisk and gparted
output the correct 2.73 TB.

Does mdadm automatically resize the partition when increasing the
number of disks?
