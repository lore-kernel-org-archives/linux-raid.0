From: Neil Brown <neilb@suse.de>
Subject: Re: Linear RAID failure.  How to recreate?
Date: Fri, 29 Jan 2010 23:00:43 +1100
Message-ID: <20100129230043.666c9c92@notabene>
References: <27301741.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27301741.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: anoneironaut84 <anoneironaut@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 24 Jan 2010 19:25:23 -0800 (PST)
anoneironaut84 <anoneironaut@hotmail.com> wrote:

> 
> Hey all,
> 
>      I'm just wondering if there is any way to recreate a linear array.  For
> example in a simple two disk linear RAID array if one disk fail if I replace
> the old drive with a working drive can I stop the linear RAID array, format
> the simple device nodes and recreate the array?  I tried to do something
> like this but failed:

Yes, you could do that.  But mode of the data would be missing, so I don't
really see much point.

> 
> bash# mdadm --manage /dev/md1 -f /dev/sda2
> mdadm: set /dev/sda2 faulty in /dev/md1
> bash# mdadm --manage /dev/md1 -f /dev/sdb2
> mdadm: set /dev/sdb2 faulty in /dev/md1

It doesn't really make sense to set a device in a linear array to faulty as
there is no alternative strategy that can be used to read or write.
So as you notice, the 'faulty' status is not recorded:

> bash# cat /proc/mdstat
> Personalities : [linear] [raid1]
> md1 : active linear sdb2[1] sda2[0]
>       957216768 blocks 64k rounding
> 
> md0 : active raid1 sdb1[1]
>       9775424 blocks [2/1] [_U]
> 
> unused devices: <none>
> bash# mdadm --manage /dev/md1 -r /dev/sdb2
> mdadm: hot remove failed for /dev/sdb2: Device or resource busy
> bash# mdadm --manage /dev/md1 -r /dev/sda2
> mdadm: hot remove failed for /dev/sda2: Device or resource busy
> bash# mdadm --manage /dev/md1 -fr /dev/sda2
> mdadm: hot remove failed for /dev/sda2: Device or resource busy

Similarly you cannot remove individual devices from a linear array.
You can only sort the whole array, then maybe restart it.

> bash# mdadm --manage --stop /dev/md1
> mdadm: fail to stop array /dev/md1: Device or resource busy

Presumably the device is mounted?

> bash# fuser -m /dev/md1
> bash# fuser -m /dev/sda2
> bash# fuser -m /dev/sdb2

I guess no process is using the mounted filesystem?

What does
  cat /proc/mounts

show?

> bash# mdadm --manage --stop /dev/md1
> mdadm: fail to stop array /dev/md1: Device or resource busy
> bash-2.05b# lsof | grep md1
> bash-2.05b#
> 
> Would appreciate some input.
> 
> Thanks!
> 
> -JD
> 
> PS  My system is RHEL-4 running on the 2.6.22 kernel.

NeilBrown
