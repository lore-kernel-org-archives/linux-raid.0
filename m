From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Trouble increasing md component size
Date: Wed, 18 Jun 2008 21:22:05 +0200
Message-ID: <4859605D.90509@rabbit.us>
References: <20080618182622.GA29468@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080618182622.GA29468@arachsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Webb wrote:
> Hi. I'm having some trouble increasing the component size of arrays to match
> changes in the underlying block devices. I'm running mdadm 2.6.7 against a
> stock 2.6.24.4 kernel.
> 
> I'm seeing the problem in a cluster management application I'm writing, but I
> can reproduce it simply using two LV block devices, 150M each:
> 
>   2# blockdev --getsz /dev/disk.4/{one,two}
>   311296
>   311296
> 
> I build an array that only fills two thirds of the component disks:
> 
>   2# mdadm --create /dev/md4 --level=1 --raid-disks=2 --size 102400 \
>            --metadata=1.2 /dev/disk.4/{one,two}
>   mdadm: largest drive (/dev/disk.4/one) exceed size (102400K) by more than 1%
>   Continue creating array? y
>   mdadm: array /dev/md4 started.
>   2# blockdev --getsz /dev/md4
>   204800
> 
> When the array is fully synced and up [UU], I try to grow the array to use
> more of the component disks:
> 
>   2# mdadm --grow /dev/md4 --size max
>   2# blockdev --getsz /dev/md4
>   311272
> 
> and so this has worked fine.
> 
> However, if I increase the size of the underlying block devices:
> 
>   2# lvm lvresize -L 200M /dev/disk.4/one
>     Extending logical volume one to 200.00 MB
>     Logical volume one successfully resized
>   2# lvm lvresize -L 200M /dev/disk.4/two
>     Extending logical volume two to 200.00 MB
>     Logical volume two successfully resized
>   2# blockdev --getsz /dev/disk.4/{one,two}
>   409600
>   409600
> 
> and then try to grow the array:
> 
>   2# mdadm --grow /dev/md4 --size max
>   2# blockdev --getsz /dev/md4
>   311272
>   2# mdadm --grow /dev/md4 --size 155637 just 1kB more
>   mdadm: Cannot set device size for /dev/md4: No space left on device
> 
> it fails. Somehow, the change in the underlying component device sizes doesn't
> seem to be noticed even though the kernel's idea (as returned by blockdev/ioctl
> BLKGETSIZE[64]) has correctly changed. I can even remove and re-add both drives
> in turn without it noticing the size change and allowing me to grow the array.
> 
> Trying to do something like
> 
>   echo 155637 > /sys/block/md4/md/component_size
> 
> doesn't work either. It'll accept values up as far as the size of the block
> device when the array was created, but no larger.
> 
> The only recipe I've found which works is, for each drive in turn, to fail it,
> remove it, zero the superblock and then re-add it. This seems to mean the md
> driver sees is as a new component (e.g. different desc_nr in /proc/mdstat) and
> therefore re-reads its size? This isn't at all friendly to the raid array,
> though. While each device is out, any redundancy has gone. Is there some less
> drastic way to persuade the array to grow?
> 

Hi Chris,

I had exactly the same problem some months ago. The key is in the (obscure) 
assembly option --update=devicesize. Find it in the mdadm manpage and the 
whole picture will come together instantly. The wisdom is not very widespread 
as this affects only V1.1 and 1.2 superblocks.

Cheers
