From: Michal Soltys <soltys@ziu.info>
Subject: Re: migrate single disk to RAID 1?
Date: Tue, 14 Jul 2009 18:15:04 +0200
Message-ID: <4A5CAF08.1080408@ziu.info>
References: <479b70ed0907140016u5ec6b3d7x6320147dbdcbd17f@mail.gmail.com>	 <4A5C588D.4000400@anonymous.org.uk> <479b70ed0907140844p16b0081fh28bb1386a28afb1a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479b70ed0907140844p16b0081fh28bb1386a28afb1a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Beuchler <insyte@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ben Beuchler wrote:
>>> umount /dev/sdb4
>>> mdadm --build /dev/md0 --level=1 -n2 /dev/sdb4 missing
>>> mount /dev/md0 /mail
>>> mdadm --add /dev/md0 /dev/sda4
>>>
>>> Will that work?  Or am I misunderstanding something fundamental?
>>
>> It'll work but you'll be using a legacy array without superblocks, so you
>> can't have various features that come with superblocks
> 
> Right; for this particular application I'm willing to give up
> superblocks.  Just to be 100% sure, thought:  the way I've described
> the process would be non-destructive of the data on sdb4?
> 
> Thanks!

Actually, if on that sdb4 is a shrinkable filesystem, you can create md 
raid with superblock at the end. So the process would be something like:

- resize2fs filesystem on sdb4 a bit (shrink)
- mdadm stuff with e.g. 1.0 superblock
- resize2fs filesystem again, this time on md0

According to md(4) you shouldn't need to shrink more than 128KB, but be 
sure to get a healthy margin. Or do simple test with some tiny 
partition, or md-on-lvm.
