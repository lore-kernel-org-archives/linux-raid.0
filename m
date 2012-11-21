From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: mdadm --fail doesn't mark device as failed?
Date: Wed, 21 Nov 2012 17:53:58 +0100
Message-ID: <50AD0726.9090509@profitbricks.com>
References: <1353514677.5795.14.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1353514677.5795.14.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21.11.2012 17:17, Ross Boylan wrote:
> After I failed and removed a partition, mdadm --examine seems to show
> that partition is fine.
>
> Perhaps related to this, I failed a partition and when I rebooted it
> came up as the sole member of its RAID array.
>
> Is this behavior expected?  Is there a way to make the failures more
> convincing?

Yes, it is expected behavior. Without "mdadm --fail" you can't remove a
device from the array. If you stop the array with the failed device,
then the state is stored in the superblock.

There is a difference in the way mdadm does it and the sysfs method.
mdadm sends an ioctl to the kernel. With the sysfs command the faulty
state is stored immediately in the superblock.

# echo faulty > /sys/block/md0/md/dev-sdb1/state

If you reassemble that you'll get the message:
mdadm: device 0 in /dev/md0 has wrong state in superblock, but /dev/sdb1
seems ok

There is a limit of how many errors are allowed on the device (usually 20).

If you do the following additionally, your device won't be used for
assembly anymore.
# echo 20 > /sys/block/md0/md/dev-sdb1/errors

I guess this is related to: /sys/block/md0/md/max_read_errors.

> The drive sdb in the following excerpt does appear to be experiencing
> hardware problems.  However, the failed partition that became the md on
> reboot was on a drive without any reported problems.
>

