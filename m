From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: md raid6: slow resync if fs is mounted rw
Date: Wed, 26 Feb 2014 10:31:55 +0800
Message-ID: <530D521B.7060509@fnarfbargle.com>
References: <530D1F53.5070703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530D1F53.5070703@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jakob Unterwurzacher <jakobunt@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/02/14 06:55, Jakob Unterwurzacher wrote:
> Dear list,
>
> I am seeing a strange performance issue on a 4 x 4TB md raid6 on kernel
> 3.12. Initial resync goes nice and fast at 130MB/s:
>
>> # cat /proc/mdstat
>> Personalities : [raid1] [raid6] [raid5] [raid4]
>> md1 : active raid6 sda3[0] sdd3[3] sdc3[2] sdb3[1]
>>        7751269376 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] [UUUU]
>>        [=>...................]  resync =  7.5% (293925504/3875634688) finish=458.4min speed=130210K/sec
>>
>> md0 : active raid1 sda2[0] sdd2[3] sdc2[2] sdb2[1]
>>        29280128 blocks super 1.2 [4/4] [UUUU]
>>
>> unused devices: <none>
>
> ...unless the ext4 filesystem on the array is mounted read-write!
> Then, speed plummets to 1 - 7MB/s. The filesystem is empty and totally
> idle; a simple "mount -o remount,ro" restores the speed to 130MB/s.
>

You are probably expeririencing an effect of this :

http://www.thomas-krenn.com/en/wiki/Ext4_Filesystem#Lazy_Initialization

Regards,
Brad
