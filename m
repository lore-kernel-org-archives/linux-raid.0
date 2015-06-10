From: Pierre Wieser <pierre.wieser@gadz.org>
Subject: Re: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Wed, 10 Jun 2015 21:37:41 +0200 (CEST)
Message-ID: <1056149272.1412.1433965061737.JavaMail.zimbra@wieser.fr>
References: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

> I currently have an almost full RAID 5 built with 4 x 2 TB disks.
> I wonder if it would be possible to migrate it to a bigger RAID 5
> with 3 x 6TB new disks.

Due to all suggestions, and I'd wish another time thank all contributions,
I've spent some hours reading the mailing list archives, surfing the web
with more appropiate keywords, and so on..

So, here what I now plan to do:

First, I hace cancelled my order for the new 6TB desktop-grade disks, 
replacing it with 4TB WD RedPro, and one 6TB desktop-grade (see below its use)

As the full RAID5 array I planned to migrate is already my backup system,
I cannot rely on a restore :(. So the first thing is to rsync the current
array to the directly attached 6TB disk. I don't thing I have a free SATA 
port on my motherboard, but at worst I will be able to use the one currently
used for the DVD drive.

I've chosen to build new RAID10 arrays.
I've moved away the RAID6 suggestion due to its known bad write performance,
and also because I'm willing/able to put a bit more money to get better perfs.

The 4x4TB new disks will be partitioned as:
- 512MB to be a RAID1 array mounted as /boot
- 8GB to be a RAID10 array used as swap
- two 25 GB parts to be two RAID10 arrays used as root filesystem
  (plus place for an alternate when upgrading the OS)
- the rest of the disk will be splitted in four equal parts (about 930 MB 
I think), each of which being member of a separate data RAID10 array.

I am conscious that this seems as a waste of space, and especially for the
/boot partition. But this scheme will let me:
a) have banalized disks: all disks have same rules, are partitioned identically
b) replace my system disk which is not part of any RAID system as of today,
thus gaining actually both a SATA port for the RAID systems and more security
for the boot and root filesystems
c) also because I use to use LVM on top of RAID to get advantages of its
flexibility (so several PVs which may or may not be aggregated later)

Other suggestions include the use of smartctl tool. I've checked that the 
daemon was already running. But I didn't use the '-x' option that I understand
is hardly an option !

I plan to build these RAID devices out of CentOS 7 standard install process
(I'm currently downloading a CentOS Live iso), thus presenting to the install
some predefined partitions.

I expect about 5-10 days to get these orders delivered. So more news at this time :)

Thank you all for your help. I keep reading the list that I discovered for 
the occasion...

Regards
Pierre
