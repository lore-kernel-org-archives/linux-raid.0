From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Help creating filesystem (xfs) and partitioning
Date: Wed, 24 Jul 2013 12:28:35 -0500
Message-ID: <51F00EC3.90605@hardwarefreak.com>
References: <CAH3kUhFqX5fB0=eYbECxrR_52Yv3_v5oodG=6Z-8L_gcTwiC4Q@mail.gmail.com> <51EF7AA2.9000604@hardwarefreak.com> <CAH3kUhHoQiyhVotNpNDq-rcQ36vZbRrZvoEsUzyo0=9mz8=+3w@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhHoQiyhVotNpNDq-rcQ36vZbRrZvoEsUzyo0=9mz8=+3w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/24/2013 11:06 AM, Roberto Spadim wrote:
> What about fdisk align?

If the disks have 512 bytes per physical sector, the standard for over
30 years, then there is nothing to align.  If the disks have 4096 bytes
per physical sector and 512 per logical sector, i.e. Advanced Format
disks, then you need to make sure your partitions are aligned to 4K
boundaries.  Start your first partition at LBA sector 2048 and you
should be golden.  And make sure each partition is evenly divisible by
4096 bytes.  If you don't partition AF disks properly your 4K filesystem
blocks will straddle two adjacent physical 4K sectors and cause drive
internal read-modify-write.  This can cut performance by up to 50%.

> Em 24/07/2013 03:56, "Stan Hoeppner" <stan@hardwarefreak.com> escreveu:
>>
>> On 7/23/2013 7:06 PM, Roberto Spadim wrote:
>>
>>> /boot with 200mb, xfs filesystem and raid1
>>
>> Using a journaling filesystem for /boot is pointless.  Use EXT2 instead.
>>
>>> swap with 20gb (or 10gb),
>>> / with 100gb, xfs filesystem and raid1
>>> /home with all disk left (near to 400gb), xfs filesystem and raid1
>>
>> It is ill advised to put more than one XFS filesystem on a single
>> (effective) spindle which is what RAID1 is.  Doing so results in too
>> many allocation groups, which results in head thrashing, which results
>> in decreased performance.  Use a single XFS for rootfs and home, manage
>> space by enabling and setting quotas.
>>
>> ...
>>> Now the point is, what's the best fdisk, mdadm, mkfs_xfs, tunefs,
>>> smartctl and others tune tools and /sys /proc parameters?
>>> I want a good align and performace
>>
>> None of these will increase your performance with a RAID1 pair.
>> Switching your elevator from CFQ to deadline, and making sure NCQ is
>> enabled and working properly, is about the best you can do to maximize
>> md RAID1 performance.  And using a single XFS as I described above,
>> instead of 2 or 3.
>>
>> If your workload(s) involve heavy mixed metadata and data changes, i.e.
>> untar a kernel tarball then delete the directory tree, then mounting
>> with inode64 will improve performance a bit.  inode64 has been made the
>> default XFS allocator but I'm not sure with which kernel version that
>> took affect.  To find out simply do "cat /proc/mounts".
>>
>> See mkfs.xfs(8), mount(8)
>> http://xfs.org/index.php/XFS_FAQ
>>
> http://xfs.org/docs/xfsdocs-xml-dev/XFS_Labs/tmp/en-US/html/xfs-quotas-lab.html
>>
>> --
>> Stan
>>
>>
> 

