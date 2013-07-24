From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Help creating filesystem (xfs) and partitioning
Date: Wed, 24 Jul 2013 14:35:20 -0500
Message-ID: <51F02C78.6090104@hardwarefreak.com>
References: <CAH3kUhFqX5fB0=eYbECxrR_52Yv3_v5oodG=6Z-8L_gcTwiC4Q@mail.gmail.com> <51EF7AA2.9000604@hardwarefreak.com> <CAH3kUhHoQiyhVotNpNDq-rcQ36vZbRrZvoEsUzyo0=9mz8=+3w@mail.gmail.com> <CAH3kUhEZLBZD79WW75gWF4a5dvhQas=1+oR6vaTbuNtTBRfayg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhEZLBZD79WW75gWF4a5dvhQas=1+oR6vaTbuNtTBRfayg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/24/2013 12:07 PM, Roberto Spadim wrote:

> Could i use ext3 or ext4 for boot filesystem?  I need crash security (ok a
> ups is the best solution) xfs could be used too?

Again, Roberto, a journaling filesystem is not necessary for /boot.  It
will not make files in /boot any more crash resistant.  Files in /boot
are only modified when you replace (upgrade) your kernel.  Corruption
can only occur when file writes are in flight but not completely on
disk.  Therefore, to corrupt files in /boot, the machine must crash or
lose power while you're installing a new kernel, i.e. within a window of
about 10 seconds.  There are 31,536,000 seconds in a year.  So the odds
of a crash/power loss during any one of your kernel upgrades are, if my
math is close, approximately

1 in 3,153,600

> If i need a home directory with crypt filesystem, what should i use? Two
> partitions one with xfs and other with dmcrypt (for example) and xfs, or
> only one partition and a loop mount with crypt and quota limit for home
> directory?

Is this a workstation, personal server, or multiuser server with decent
load?  If the load is light you can get away with multiple XFS
filesystem on a single spindle, separate rootfs and home.

-- 
Stan


