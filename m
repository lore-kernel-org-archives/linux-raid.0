From: Tapani Tarvainen <raid@tapanitarvainen.fi>
Subject: Re: linux disk access when idle
Date: Sat, 22 Aug 2009 08:04:17 +0300
Message-ID: <20090822050416.GA9202@musti.tarvainen.info>
References: <20090820163522.GA29215@sewage> <4A8F190B.9010406@tmr.com> <20090821231039.GB22331@sewage>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090821231039.GB22331@sewage>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Just a data point: I've got a box (Debian Lenny) with five disks,
system disk plus 4-disk RAID5 array, used as a backup server
(rsnapshot), and I power the disks in the raid array down after
running the backup - and they stay powered down, even though I don't
umount the filesystems let alone stop the array. When accessed (like
for restoring something from the backup), they wake up, so I've got an
hourly cron job powering them down again - but most days (when
there're no restores) they are powered up only during the backup run.

So it can be done. It's not filesystem type dependent either, there's
one jfs and one ext3 in the array.

The system disk stays up, though. Some experimenting suggested
that getting it to stay down would require putting /tmp and parts
of /var on a ramdisk (/var/log at least), but I didn't go to
the trouble of tracking down all disk-awakening services.

-- 
Tapani Tarvainen
