From: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Subject: Re: Alignment of RAID on specific boundary
Date: Tue, 5 Jan 2010 15:02:04 +0200
Message-ID: <7b3edae11001050502x69afeab8t57d704af0cd7ce30@mail.gmail.com>
References: <7b3edae11001041130n42d053fcpc4923b22278c5671@mail.gmail.com>
	 <72dbd3151001041314w511385deh38b54add67e098e0@mail.gmail.com>
	 <7b3edae11001041351o141b2616x381e2e671f4a2987@mail.gmail.com>
	 <13153813.Bnqmn4ZX5I@rnqqfki.eternal-september.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <13153813.Bnqmn4ZX5I@rnqqfki.eternal-september.org>
Sender: linux-raid-owner@vger.kernel.org
To: ap23563m@gmx.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010/1/5 Michal Soltys <soltys@ziu.info>:
> Michael Evans wrote:
>
> Regarding lvm, you can use --dataalignment and --metadatasize for that
> purpose. Recent lvm versions, when creating directly on md raid (and
> assuming recent kernel), should align themselves automatically:
>
> http://www.redhat.com/archives/linux-lvm/2009-September/msg00092.html
>

Yes, i used the latest lvm and it aligned correctly automatically. I am
interested in aligning the RAID itself.

2010/1/5 Antonio Perez <ap23563m@gmx.com>:
>> I have read this post and it is very good but it mentions alignment
>> of the partitions using special CHS values and LVM/ext4 options.
>
> Yes, and that seems to be the only way to align partitions to a 128k
> boundary. You do need to use such rules to create aligned partitions.
>
> Then, you need to align RAID created from such partitions to 128k Blocks, by
> setting the chunk-size to 128k: "mdadm --chunk=128k" ( well, a multiple of
> that, anyway ).
>
> And, then, align LVM ( with the --dataalignment option for pvcreate ) and
> the Filesystem ( with the -E stripe-width= to the mkfs command ) to such
> boundaries as well. That applies to ext3 AND ext4 filesystems AFAIK.
>

These non-default CHS values are used with MBR partitioning scheme
to make aligning easy. fdisk (when it is ran without the -u option) aligns
partitions on a cylinder boundary and because the cylinder size is a multiple
of 128K all the partitions (except the first) are automatically aligned.
But i use GPT so i don't need them. If you read my original post i manually
created the partitions to be aligned with 128K.

As for the RAID, i chose the default 512K chunk which is multiple of 128K
so this is fine too. But i read in the "mdadm -E" output that there is a
"136 sectors data offset". If i understand this correctly the start of the
md device is 136 sectors from the start of the underlying partition. This
breaks the alignment with the partition and all correct alignments on top
of RAID.

There is of course possibility that i didn't understand it correctly and
this "data offset" means something else. Mr. Brown can clariffy that.

Thank you again for your time.
