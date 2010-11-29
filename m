From: Michele Bonera <mbonera@gmail.com>
Subject: Re: Problems after reshaping of Raid5 array
Date: Mon, 29 Nov 2010 21:04:39 +0100
Message-ID: <1291061079.5909.84.camel@bellatrix.morrisoft.local>
References: <AANLkTinUU6Mh-cYbyCF_vL2PzGzFKMcqSZmPULxctquh@mail.gmail.com>
	 <4CF3FB20.2040100@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CF3FB20.2040100@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Il giorno lun, 29/11/2010 alle 20.12 +0100, Jan Ceuleers ha scritto:

> I've had similar problems, which I resolved by changing the partition 
> type from fd (Linux RAID autodetect) to 83 (Linux), ensuring that the 
> initrd is able to assemble the RAID.
> Worth a shot.
> HTH, Jan

Thanks for the reply, Jan, but the problem is not at raid level, or
better, the raid just finished to reshape and now has 5/5 of his
components and is active:

root@mizar:~# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
[raid1] [raid10] 
md6 : active raid5 sdf1[2] sdb1[0] sda1[1] sdc[4] sde1[3]
      3438905344 blocks level 5, 128k chunk, algorithm 2 [5/5] [UUUUU]


The problem is that I added a device partition (sdc1) but after the
crash the array has sdc (the device) as one of his components. The
partition table on the disk was wiped-out.

The result is that the filesystem on it (dev/md6) is unreadable and
fsck.ext3 can't fix it.

Bye
--
Michele Bonera
linux user group brescia

