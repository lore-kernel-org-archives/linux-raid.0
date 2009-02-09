From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: RAID-10 unbalanced reads
Date: Tue, 10 Feb 2009 00:11:39 +0100
Message-ID: <20090209231138.GB13450@rap.rap.dk>
References: <20090209202728.GA11996@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090209202728.GA11996@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 09, 2009 at 09:27:28PM +0100, Piergiorgio Sartor wrote:
> Hi all.
> 
> I've setup a system with two RAID volumes.
> One is a small RAID-1, /dev/md0, with the /boot
> content, the other is a RAID-10 f2, with LVM,
> for the rest of the system.
> 
> I just noticed that /dev/sdb, which is not the
> boot disk, I assume, has more reads than /dev/sda.
> Writes are the same, here is the output of "iostat":
> 
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda              10.08       183.15       408.74     755018    1684972
> sda1              0.04         1.24         0.02       5118         66
> sda2             10.03       181.71       408.72     749071    1684880
> sdb              10.49       187.64       408.74     773532    1684972
> sdb1              0.03         1.17         0.02       4837         66
> sdb2             10.44       186.26       408.72     767832    1684880
> md1              62.95       367.26       391.79    1513976    1615112
> md0               0.02         0.18         0.00        724          8
> 
> Note that sda1 has more reads than sdb1.
> This is possibly due to the fact that it is
> used during boot.
> 
> What is strange, is sdb2, which has by far
> more reads than sda2. Both belong to /dev/md1.
> 
> Note also the /dev/sdb is the slowest of the
> two drives.
> 
> Is that somehow normal?
> If not, is it possible to find out what or
> why the reads are unbalanced?

What kernel are you using?
Before 2.6.25 you could have differences in usage.

Anyway, I think the difference is too small to be of inportance
for the performance. Or did you notice a difference?

best regards
keld
