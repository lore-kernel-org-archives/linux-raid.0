From: Antonio Perez <ap23563m@gmx.com>
Subject: Re: Alignment of RAID on specific boundary
Date: Tue, 05 Jan 2010 04:24:48 -0400
Message-ID: <13153813.Bnqmn4ZX5I@rnqqfki.eternal-september.org>
References: <7b3edae11001041130n42d053fcpc4923b22278c5671@mail.gmail.com> <72dbd3151001041314w511385deh38b54add67e098e0@mail.gmail.com> <7b3edae11001041351o141b2616x381e2e671f4a2987@mail.gmail.com>
Reply-To: ap23563m@gmx.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Khelben Blackstaff wrote:

> Hello Mr. Rees and thank you for replying.
> 
> I have read this post and it is very good but it mentions alignment
> of the partitions using special CHS values and LVM/ext4 options.

Yes, and that seems to be the only way to align partitions to a 128k 
boundary. You do need to use such rules to create aligned partitions.

Then, you need to align RAID created from such partitions to 128k Blocks, by 
setting the chunk-size to 128k: "mdadm --chunk=128k" ( well, a multiple of 
that, anyway ).

And, then, align LVM ( with the --dataalignment option for pvcreate ) and 
the Filesystem ( with the -E stripe-width= to the mkfs command ) to such 
boundaries as well. That applies to ext3 AND ext4 filesystems AFAIK.
 
> My partitions and both LUKS/LVM are aligned properly (at least i think
> they are). I am worried about the alignment of RAID itself.

On that link I read this comment:

	If your SSD has an 128k erase block size, and you are creating the file
	system with the default 4k block size, you just have to specify a strip
	width when you create the file system, like so:

	# mke2fs -t ext4 -E stripe-width=32,resize=500G /dev/ssd/root

So, to align your Raid to the SSD boundary, you need to use the "stripe-
with" parameter while creating the filesystem. Assuming the partition start 
has been set to a 128k boundary as commented before.

> 2010/1/4 David Rees <drees76@gmail.com>:
>> On Mon, Jan 4, 2010 at 11:30 AM, Khelben Blackstaff
>> <eye.of.the.8eholder@gmail.com> wrote:
>>> Is there a way to make the RAID data start at a particular offset ?
>>> (In my case 512 sectors) ?
>>
>> http://thunk.org/tytso/blog/2009/02/20/aligning-filesystems-to-an-ssds-
erase-block-size/
>>
>> May have to tweak your fdisk parameters a bit.
>>
>> Don't worry about aligning your /boot partition since you don't
>> read/write from that much.
>>
>> -Dave

-- 
Antonio Perez

