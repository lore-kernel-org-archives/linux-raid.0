From: Roberto Spadim <roberto@spadim.com.br>
Subject: md lzo
Date: Wed, 30 Mar 2011 12:13:08 -0300
Message-ID: <AANLkTin5xDKto7CjcStdb41UcmN1oZJXw84HNEOSf5pN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi guys, i was thinking in a new device block, could anyone discuss it?
the idea: a LZO block device

think about a block device (/dev/sda)
over it we 'mount' a block device (/dev/lzo0), something like mdadm
--create /dev/lzo0 --level=lzo --device=/dev/sda
what it should do?

read/write compressed information
we could split disks in X B per split (let's think about 32KB)

user will tell us to read 320 KB
we will read information on 10 splits
maybe information will be compressed (50%?!) with this we read less
and have more information
writes will be done like ssd (NAND memory) when we need to write a
information read split, uncompress, put the new information, compress
and write

just a idea
i was seeing some benchmarks about btrfs and LZO and Gzip seens to be
a good optimization on read intensive enviroment
why not use it at block device level? ok it will be a problem with
disk crash since many information can be lost, but user could use
raid1 over it or another secure solution
it's not to expand disk size, it's to make read faster (less disk use,
more cpu/memory use)

any ideas? i don't know about a project like this

-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
