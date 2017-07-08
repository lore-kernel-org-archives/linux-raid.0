From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: My MD is too big to resize ext4.
Date: Sat, 8 Jul 2017 17:22:20 -0500
Message-ID: <8ead21dd-d52a-42cd-ee0c-bc403b56a63f@gmail.com>
References: <6c827d07-19d8-017b-ca95-5e6f84b7821a@gmail.com>
 <20170708065040.GA3682@metamorpher.de>
 <ae47b321-07d1-2157-c217-844447e51ce2@gmail.com>
 <20170708194427.GA15208@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170708194427.GA15208@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/08/2017 02:44 PM, Andreas Klauer wrote:
> On Sat, Jul 08, 2017 at 01:12:11PM -0500, Ram Ramesh wrote:
>>      1. My MD uses partitions sd{b,c,d,e,f,g}1 instead of full disks. So
>> I can create partitions on the drive instead of on the MD.
>>      2. This means I need to shrink my current md device to smaller size
>> (say 12TB-14TB) - need to check my current
>>            active ext4 data size. It is definitely less than 16TB.
>>      3. Repartition the disks to create sd{b-g}2 for the reamining unused
>> 6xnTB area.
>>      4. Created md1 with sd{b-g]2 to get md1.
>>      5. Mount and use md1.
> Should work; you have to shrink the filesystem first, (or stick to
> whatever size it has now), then the md, then the partition.
>
> What makes this risky is that you have to pick the correct sizes.
> When growing you can't go wrong. When shrinking, you have to be
> careful not to shrink too much. Filesystems don't like it at all
> if their end is missing, and md doesn't like it if the block device
> is smaller than what it says in the metadata.
>
> So you have to determine the exact filesystem size (tune2fs -l),
> and take mdadm data offsets into account.
>
> Not necessary if you know what you're doing but if in doubt,
> you can leave a safety margin with each of these steps.
>
> Regards
> Andreas Klauer
My df shows that I use 10431258240 blocks (1K) in my ext4 on the md. 
This is less than 10T. So, resize2fs to 11T should be fine. I will 
shrink md to 11.5T and partition to 12T. I will use 2^30 to mean TB. Is 
0.5T enough margin in each case?

I can also stretch the limit to 15TB for ext4 and 15.5 for md and 16TB 
for partiton. Is this better because it maxes out the 32bit
ext4? Somehow something tells me pushing the limit is always a bad idea 
as mistakes generally happen on checking  boundary conditions.

Alternatively, I can do resize2fs with -M to minimal size, but the man 
says calculations are not perfect for 1/2K block sizes. However, I see 
that dumpe2fs says I have 4K blocks.

Ramesh

