From: Brad <brad46526@gmail.com>
Subject: Re: System hangs on raid md recovery/resync
Date: Mon, 28 Jul 2008 09:39:06 +1000
Message-ID: <da290bd50807271639o1dd585edwe121c156743a4199@mail.gmail.com>
References: <da290bd50807260519v293851c9ue4bef88b1fc52013@mail.gmail.com>
	 <da290bd50807271505k4bf5734bp9734883a219e9d53@mail.gmail.com>
	 <488CF4F5.9030707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <488CF4F5.9030707@gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roger, thanks for your reply.

> If the hardware setup cannot do faster than 35 MB/second nothing you can do
> will make it go faster.

On a straight read of any of the disks, using dd or 'hdparm -t', I can get about
70MB/sec to 75MB/sec out of the disk drives.  I've always thought that the
MD software deliberately 'throttled' a resync/recover operation, slowing things
down if the disks were being used by applications, so I've been happy
with around
35MB/sec for my resyncs, as the system has usually been lightly loaded
with other
programs using the drives.

> What kind of motherboard is it and which chipset is on that MB, and what
> kind of sata ports are the disks on?
>
> If you can get all 3 disks in the machine and working (without a resync)
> then I would try doing "dd if=/dev/sda of=/dev/null bs=1M" for each of the 3
> disks at the same time and see if that causes a hang, if it does it is not a
> MD issue, also I would check the speed of 1 disk, 2 disks, and 3 disks and
> see how bad those ports bottleneck with multiple disks being used.

My system is 7 months old; the motherboard is a Gigabyte GA-P35-DS4.
It has an Intel ICH9R northbridge with 6 SATA 2 ports and a 'Gigabyte'
(JMicron 20360/20363) southbridge with 2 SATA 2 ports.  I have two
500GB Western Digital SATA 2 internal disks, one on each controller, in
an MD raid1 mirror.  I've experienced these problems while plugging in
a third Western Digital 500GB drive into the ICH9R controller and
adding it as a third mirror element to the raid1 MD device.

Other than this 'hang' problem with MD I've never had a problem with
any of the disks.  For example, after yesterday failing to synchronise the third
disk with the MD raid1 device, I proceeded to do a filesystem-level copy, using
cpio to copy all the files from the MD device to the (separately mounted) third
disk.  That worked fine (took a lot longer, though, because of the huge number
of small files I have on the filesystem).  A follow-up rsync to
'catch' files that
had been modified during the cpio also succeeded.

I just now ran a dd test as you suggested of each disk, and each ran fine, with
dd reporting speeds of 66.1, 68.6 and 70.5 MB/s.  One 'hard resetting link'
error/event was logged for one of the three SATA 2 ports without the dd process
for that link seeing any error.  I saw absolutely no such errors
logged at all with
my 'hang' problems in synchronising the raid1 device yesterday.  Everything
would proceed fine until the resync operation simply stopped - with
/sys/block/md1/md/sync_completed static, showing no further
progress - and the system then 'hanging' on anything that tried
to access a disk.


Brad
