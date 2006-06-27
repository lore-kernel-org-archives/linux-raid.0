From: Chris Allen <chris@cjx.com>
Subject: Re: Multiple raids on one machine?
Date: Tue, 27 Jun 2006 12:33:55 +0100
Message-ID: <44A117A3.5040203@cjx.com>
References: <449F100D.6030509@cjx.com> <871wtahqgo.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871wtahqgo.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Nix wrote:
> On 25 Jun 2006, Chris Allen uttered the following:
>> Back to my 12 terabyte fileserver, I have decided to split the storage
>> into four partitions each of 3TB. This way I can choose between XFS
>> and EXT3 later on.
>>
>> So now, my options are between the following:
>>
>> 1. Single 12TB /dev/md0, partitioned into four 3TB partitions. But how do
>> I do this? fdisk won't handle it. Can GNU Parted handle partitions this big?
>>
>> 2. Partition the raw disks into four partitions and make /dev/md0,md1,md2,md3.
>> But am I heading for problems here? Is there going to be a big performance hit
>> with four raid5 arrays on the same machine? Am I likely to have dataloss problems
>> if my machine crashes?
> 
> There is a third alternative which can be useful if you have a mess of
> drives of widely-differing capacities: make several RAID arrays so as to tesselate
> space across all the drives, and then pile an LVM on the top of all of them to
> fuse them back into one again.
> 

But won't I be stuck with the same problem? ie I'll have a single 12TB 
lvm, and won't be able to use EXT3 on it?
