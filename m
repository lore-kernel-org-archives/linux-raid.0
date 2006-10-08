From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Stopping and starting a RAID1 :Invalid argument
Date: Sun, 8 Oct 2006 11:46:56 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0610081115440.20412@lion.drogon.net>
References: <d0383f90610080305x4d06d307yfc497f39761f073c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d0383f90610080305x4d06d307yfc497f39761f073c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Brown <ianbrn@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 8 Oct 2006, Ian Brown wrote:


> Then I created a RAID1 by running:
>
> mdadm --create /dev/md0 --level=raid1 --raid-devices=2 /dev/sdb1 /dev/sdb2
>
> I got : mdadm: array /dev/md0 started
>
> cat /proc/mdstat shows:
>
> Personalities : [raid1]
> md0 : active raid1 sdb2[1] sdb1[0]
>       16000 blocks [2/2] [UU]
>       [==>..................]  resync = 12.5% (2112/16000)
> finish=0.7min speed=301K/sec
> unused devices: <none>

So far so good. Nothing out of the ordinary here for your testing
environment.

> I created ext3 fs on /dev/md0 and /dev/sdb1 and /dev/sdb2.

Eeek!

You have created a filesystem on md0, which uses /dev/sdb1 and /dev/sdb2,
THEN you fiddled with the underlying devices, /dev/sdb1 and /dev/sdb2...

What you have done is effectively corrup the filesystem on /dev/md0, and
possibly even wiped out the superblock on the /dev/md0 device. (which may
be why you can't start it again)

Once you have created a RAID array, you only ever deal with the mdX
device. Leave the underlying devices well alone. They are now owned by the
md device driver.

Start again, and don't fiddle with the underlying /dev/sdbX devices. Do
not mkfs them, and do not mount them.

All you need to do is this:

  mdadm --create /dev/md0 -l1 -n2 /dev/sdb{1,2}
  mkfs -t ext3 /dev/md0
  mount /dev/md0 /mnt

and there you have it.

Use
	df -h /mnt
to let you see the size of your new mounted volume - it'll be 30MB or so.


There is a case under RAID-1 where you can mount the underlying devices,
but thats only in an emergency, with the mdX drivers stopped, and you need
to make absulutely sure you know what you are doing if you do this, and if
you mount then read-write, the you must not re-enable and mount the
overlying mdX device as it won't know which of the 2 mirrors is the
current one and you might get old data. ie. it's a one-way process in an
emergency, mount the underlying device, get the data off and re-create
from scratch, and you can only do this with RAID-1 devices.

Gordon
