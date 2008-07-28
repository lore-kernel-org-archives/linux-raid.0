From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: System hangs on raid md recovery/resync
Date: Sun, 27 Jul 2008 19:08:36 -0500
Message-ID: <488D0E04.3000505@gmail.com>
References: <da290bd50807260519v293851c9ue4bef88b1fc52013@mail.gmail.com>	 <da290bd50807271505k4bf5734bp9734883a219e9d53@mail.gmail.com>	 <488CF4F5.9030707@gmail.com> <da290bd50807271639o1dd585edwe121c156743a4199@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <da290bd50807271639o1dd585edwe121c156743a4199@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad <brad46526@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad wrote:
> Roger, thanks for your reply.

> 
> My system is 7 months old; the motherboard is a Gigabyte GA-P35-DS4.
> It has an Intel ICH9R northbridge with 6 SATA 2 ports and a 'Gigabyte'
> (JMicron 20360/20363) southbridge with 2 SATA 2 ports.  I have two
> 500GB Western Digital SATA 2 internal disks, one on each controller, in
> an MD raid1 mirror.  I've experienced these problems while plugging in
> a third Western Digital 500GB drive into the ICH9R controller and
> adding it as a third mirror element to the raid1 MD device.
> 
> Other than this 'hang' problem with MD I've never had a problem with
> any of the disks.  For example, after yesterday failing to synchronise the third
> disk with the MD raid1 device, I proceeded to do a filesystem-level copy, using
> cpio to copy all the files from the MD device to the (separately mounted) third
> disk.  That worked fine (took a lot longer, though, because of the huge number
> of small files I have on the filesystem).  A follow-up rsync to
> 'catch' files that
> had been modified during the cpio also succeeded.
> 
> I just now ran a dd test as you suggested of each disk, and each ran fine, with
> dd reporting speeds of 66.1, 68.6 and 70.5 MB/s.  One 'hard resetting link'
> error/event was logged for one of the three SATA 2 ports without the dd process
> for that link seeing any error.  I saw absolutely no such errors
> logged at all with
> my 'hang' problems in synchronising the raid1 device yesterday.  Everything
> would proceed fine until the resync operation simply stopped - with
> /sys/block/md1/md/sync_completed static, showing no further
> progress - and the system then 'hanging' on anything that tried
> to access a disk.


The Intel stuff tends to be pretty decent, where I have ran into the most issues 
is with anything that the MB vendor adds on, so I would try putting all 3 on the 
Intel, and in the past the Intel controllers I have tested have been able to run 
all disks at full speed (or close to it) even when multiple disks are being 
actively used, this would at least eliminate the jmicron controller from the mix.

The sync will slow down quite a bit if other things are causing reads/writes 
that are causing the disks to seek around.

How much power does the PS have on the 12V line?    So long as it is either a 
split 12V supply or has more than 15-20A (non-split PS) you should be OK.  I 
have had issues with non-split PS's that only had 15A on the 12V resulting in 
odd happenings with the disk.

I would also setup the sysrq keys and the next time it happens do a "alt-sysrq" 
with a "T" "W" and a "Q" to test sysrq and make sure it is working do a 
"alt-sysrq-S" (sync) as this should produces messages in dmesg and show that 
things are enabled and working.

You did run the dd on all 3 disks at the same time?

The hard resetting link usually indicates something bad happened, though that 
could be caused by a lot of things.

                                 Roger
