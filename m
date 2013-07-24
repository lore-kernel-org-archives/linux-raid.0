From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Help creating filesystem (xfs) and partitioning
Date: Wed, 24 Jul 2013 12:41:47 -0700
Message-ID: <CAK2H+ec1OHxwB_A_bWOem-hwsmQ3HUfsyzotYLa2D5414-D2eA@mail.gmail.com>
References: <CAH3kUhFqX5fB0=eYbECxrR_52Yv3_v5oodG=6Z-8L_gcTwiC4Q@mail.gmail.com>
	<51EF7AA2.9000604@hardwarefreak.com>
	<CAH3kUhHoQiyhVotNpNDq-rcQ36vZbRrZvoEsUzyo0=9mz8=+3w@mail.gmail.com>
	<CAH3kUhEZLBZD79WW75gWF4a5dvhQas=1+oR6vaTbuNtTBRfayg@mail.gmail.com>
	<51F02C78.6090104@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F02C78.6090104@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jul 24, 2013 at 12:35 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 7/24/2013 12:07 PM, Roberto Spadim wrote:
>
>> Could i use ext3 or ext4 for boot filesystem?  I need crash security (ok a
>> ups is the best solution) xfs could be used too?
>
> Again, Roberto, a journaling filesystem is not necessary for /boot.  It
> will not make files in /boot any more crash resistant.  Files in /boot
> are only modified when you replace (upgrade) your kernel.  Corruption
> can only occur when file writes are in flight but not completely on
> disk.  Therefore, to corrupt files in /boot, the machine must crash or
> lose power while you're installing a new kernel, i.e. within a window of
> about 10 seconds.  There are 31,536,000 seconds in a year.  So the odds
> of a crash/power loss during any one of your kernel upgrades are, if my
> math is close, approximately
>
> 1 in 3,153,600
>

+1

Also, at least on my personal systems, nothing resides on /boot that
doesn't reside somewhere else under /. The kernels & associated files
are in /usr/src. I periodically will copy grub.conf to /root for safe
keeping. Personally I don't even back up /boot anymore as the biggest
issue I always have if I lose a disk or make some horrible fat
fingered mistake is to reinstall grub which (I believe to be true)
won't be effected by the filesystem choice.

Just my POV.

Cheers,
Mark
