From: Brandon Evans <maillists@hosttuls.com>
Subject: Re: Kernal Panic when booting redhat.  Raid devices mount fine underKnoppix
Date: Thu, 11 Dec 2003 14:16:09 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FD8ECA9.9080209@hosttuls.com>
References: <3FD7A643.7060602@hosttuls.com> <3FD822D4.2030501@ratnet.stw.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FD822D4.2030501@ratnet.stw.uni-erlangen.de>
To: schmidt@naa.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Norman Schmidt wrote:
> Brandon Evans schrieb:
> 
>> The Raid devices mount fine
>> under knoppix 3.3, but when I try to boot Redhat 7.3, the servers can 
>> not read the superblock on the root device (/dev/md1), so the system 
>> panics.
>> This has happened on 2 servers so far.
> 
> 
> What partition types do the partitions hda1 hda2 hdd1 hdd2 have?
>
All the partitions are ext3



> Can it mount root (or does it give a kernel panic - unable to mount 
> root)? Could you give the exact boot error messages?

Root does not mount.  The exact errors are still on my notes that I 
again left at home.
But I will be down at the data center today trying it again, and I will 
post them

I'm thinking (hoping) that the fact that I didnt run resize2fs on the 
/dev/mdX devices is the problem.
If it isnt, then I don't know what else it could be.




-- 
Thanks,
     Brandon E.
