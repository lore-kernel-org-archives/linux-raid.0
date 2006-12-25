From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Can I abuse md like this?
Date: Mon, 25 Dec 2006 14:10:42 -0500
Message-ID: <45902232.6000706@tmr.com>
References: <458DF579.1090603@tmr.com> <17805.63419.748876.939243@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17805.63419.748876.939243@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Saturday December 23, davidsen@tmr.com wrote:
>   
>> I hope I can use the md code to solve a problem, although in a way 
>> probably not envisioned by the author(s).
>>
>> I have a disk image, a physical dump of every sector from start to 
>> finish, including the partition table. What I hope I can do is to create 
>> a one drive RAID-1 partitionable array, and then access it with fdisk or 
>> similar. These partitions are not "nice" types such as FAT, VFAT, ext2, 
>> etc, this is an odd disk, and I "saved it" by saving everything. Now I'd 
>> like to start dismembering the information and putting it into useful 
>> pieces. I even dare to hope that I could get the original software 
>> running on a virtual machine at some point.
>>
>> The other alternative is to loopback mount it, I'm somewhat reluctant to 
>> do that if I can avoid it.
>>
>> Yes, the partition table is standard in format if not in content.
>>     
>
> Maybe...
> Is this image in a file?
> md only works with block devices, so you would need to use the 'loop'
> driver to create a block-device "/dev/loopX".
>   
I was thinking nbd, actually.
> But as loop devices cannot be partitioned, you could then
>   mdadm -Bf /dev/md/d9 -amdp8 -l1 -f -n1 /dev/loopX
>   
> and then look at the partitions in /dev/md/d9_*
>
> Should work.
Sounds worth a try. Will be a learning experience if nothing else.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

