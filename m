From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Sat, 17 Mar 2012 23:10:43 +0100
Message-ID: <4F650BE3.5010305@gmail.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jessie Evangelista <jessie.evangelista@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dne 15.3.2012 1:30, Jessie Evangelista napsal(a):
> I want to create a raid10,n2 using 3 1TB SATA drives.
> I want to create an xfs filesystem on top of it.
> The filesystem will be used as NFS/Samba storage.
> 
> mdadm --zero /dev/sdb1 /dev/sdc1 /dev/sdd1
> mdadm -v --create /dev/md0 --metadata=1.2 --assume-clean
> --level=raid10 --chunk 256 --raid-devices=3 /dev/sdb1 /dev/sdc1
> /dev/sdd1
> mkfs -t xfs -l lazy-count=1,size=128m -f /dev/md0
> mount -t xfs -o barrier=1,logbsize=256k,logbufs=8,noatime /dev/md0
> /mnt/raid10xfs
> 
> Will my files be safe even on sudden power loss? Is barrier=1 enough?
> Do i need to disable the write cache?
> with: hdparm -W0 /dev/sdb /dev/sdc /dev/sdd
> 
> I tried it but performance is horrendous.
> 
> Am I better of with ext4? Data safety/integrity is the priority and
> optimization affecting it is not acceptable.
> 
> Thanks and any advice/guidance would be appreciated
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I think today you're most safe with old ext3. Maybe data=journal is not
best idea, because it has small user-base. The more aggressive caching
and features leading to awesome performance will bite you harder by
power loss or software bugs.

Limit power loss with UPS unit. You need to cleanly shutdown the system
when UPS reaches it's low level capacity. That's mandatory IMO and still
inexpensive. Next you can think about multiple PSU/UPS units...

But just think in a way that you will never make it 100% safe, so use
damn good backups!

HTH, Z.
