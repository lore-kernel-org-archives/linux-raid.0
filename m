From: Michal Soltys <soltys@ziu.info>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Mon, 15 Nov 2010 13:47:55 +0100
Message-ID: <4CE12BFB.6050003@ziu.info>
References: <4CE00206.4000301@geograph.co.za> <alpine.DEB.1.10.1011141745400.1154@uplift.swm.pp.se> <4CE12741.6070803@geograph.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CE12741.6070803@geograph.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: Zoltan Szecsei <zoltans@geograph.co.za>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15.11.2010 13:27, Zoltan Szecsei wrote:
> On 2010-11-14 18:48, Mikael Abrahamsson wrote:
>>
>>> *What is the correct fdisk or parted method get rid of the DOS & GPT
>>> flags, and create a correctly aligned partition, and should this be a
>>> 0xda partiton (& then I use metatdata 1.2 for mdadm)?
>>
>> I just "dd if=/dev/zero of=/dev/sdX bs=1024000 count=1" to zero the
>> first megabyte of the drive to get rid of the partition table (you get
>> rid of the v1.2 metadata at the same time actually). Then you know for
>> sure you're correctly aligned as well as md is 4k aligned.
> I did this on all 8 drives (/dev/sd[a-h])
> root@gs0:/etc# dd if=/dev/zero of=/dev/sdb bs=1024000 count=1
> 1+0 records in
> 1+0 records out
> 1024000 bytes (1.0 MB) copied, 0.0103209 s, 99.2 MB/s
> root@gs0:/etc# dd if=/dev/zero of=/dev/sdc bs=1024000 count=1
>
> But the GPT id has not disappeared.

You might want to do blockdev --rereadpt /dev/sd[a-h] to make sure 
kernel registers new situation (or do the same with sfdisk -R)

Also, GPT stores backup partition table + gpt header at the end of the 
disk. Kernel might be clever enough to rely on it if you destroy the 
data at the beginning of the disk.

