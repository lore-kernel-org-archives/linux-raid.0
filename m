From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Reason for md raid 01 blksize limited to 4 KiB?
Date: Fri, 25 May 2012 14:35:57 +0200
Message-ID: <4FBF7CAD.7000307@profitbricks.com>
References: <4FBA0047.5050208@profitbricks.com> <20120522092817.1b5946b8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120522092817.1b5946b8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On 22/05/12 01:28, NeilBrown wrote:
> 
> This should be fixed in linux 3.4 with commit 6b740b8d79252f13bcb7e5d3c1d
> 

I've tested the RAID 01 with kernel 3.4 and it isn't fixed. It is even
worse, because direct IO doesn't work any more on the raid1 device (with
kernel 3.2 it worked).

There are still 4k chunks which aren't merged in the raid0 devices below
(blkparse -i md100 -i md200 -i md300 | less).
Could you also check this on your setup, please?

Cheers,
Sebastian


Btw. this is my test script:

#!/bin/bash
if [ "`lsmod | grep brd`" == "" ]; then
        modprobe brd rd_nr=4 rd_size=524288
fi
mdadm -C /dev/md100 --force --assume-clean -n 2 -l raid0 /dev/ram0 /dev/ram1
mdadm -C /dev/md200 --force --assume-clean -n 2 -l raid0 /dev/ram2 /dev/ram3
blktrace /dev/md100 &
pid=$!
dd if=/dev/zero of=/dev/md100 bs=1M oflag=direct
kill -2 $pid
blktrace /dev/md200 &
pid=$!
dd if=/dev/zero of=/dev/md200 bs=1M oflag=direct
kill -2 $pid
mv md100* r0_only/
mv md200* r0_only/

mdadm -C /dev/md300 --force --assume-clean -n 2 -l raid1 /dev/md100
/dev/md200
blktrace -d /dev/md100 -d /dev/md200 -d /dev/md300 -b 4096 &
pid=$!
# Kernel 3.4 doesn't support direct IO on the md300 device
dd if=/dev/zero of=/dev/md300 bs=1M
kill -2 $pid
