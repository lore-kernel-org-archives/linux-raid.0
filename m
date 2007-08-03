From: David Greaves <david@dgreaves.com>
Subject: Re: Problem creating software raid - Device or resource busy.
Date: Fri, 03 Aug 2007 09:54:11 +0100
Message-ID: <46B2ED33.8040303@dgreaves.com>
References: <11978339.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11978339.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: Basheer <subs@nmcexquisite.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Basheer wrote:
> Hi,
Hi

I'm not familiar with your kernel or mdadm versions - please say.

> Drive 1
> ----------
> /dev/sda1 = swap
> /dev/sda2 = linux raid   (os & data is here)
> /dev/sda3 = linux raid  

Are you describing partition types here (ie 0xfd = raid autodetect in fdisk)?

> Drive 2
> ----------
> /dev/sdb1 = swap
> /dev/sdb2 = linux resiser
> /dev/sdb3 = linux reiser
Do you mean you actually have live filesystems here?

You seem to indicate that there are filesystems on disk 2 but none on disk 1. 
Yet you say "os & data is here" ?
What do you mean by that?

Please show:
* partitions of both disks
* existing filesystems on both disks


FYI A raid device is usually made from empty partitions (devices) and you create 
a new filesystem inside the raid device. You can't usually just 'raid' them 
after the fact.


> Using mdadm I managed to create /dev/md0 in raid 1 (mirror). 
What command?

> /dev/sda3 & /dev/sdb3 where added to this set.
That would make sense - but a normal md device has a superblock and this would 
overwrite bits of your filesystem if you already have data on the disk. That is bad.

> Good so far....
hmmmm.... debatable :)

> now for the problem....
> 
> Problems Area
> -----------------------
> Using mdadm I  failed to create /dev/md1 in raid 1 (mirror). 
> /dev/sda2 & /dev/sdb2 where part of  this set.
> I get this error: mdadm: cannot open device /dev/sda2: Device or 
> resource busy.
yes. It sounds like you've got some confusion about creating a mirrored 
filesystem. I suspect you have a mounted filesystem on /dev/sda2

Have a look at the FAQ stuff here:
http://linux-raid.osdl.org/

> I booted from rescue CD, and ran the mdam command to create /dev/md1 
> ... and it worked! I let the raid sync.
Well, it would :)
The rescue system won't have mounted anything.

 > How to do I solve this?

I think you need to:
* repair any damage to your data
* prepare your kernel and init system
* go to a rescue system
* create a 'broken' mirror using your empty disk (disk2?).
* make a filesystem on the broken mirror
* copy the good filesystems to the broken mirror
* add the now free partitions from disk1 to the broken mirror
* wait for a resync
* reboot



David
