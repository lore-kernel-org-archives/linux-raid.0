From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: System runs with RAID but fails to reboot
Date: Fri, 23 Nov 2012 16:15:31 -0800
Message-ID: <1353716131.18439.29.camel@corn.betterworld.us>
References: <1353517137.5795.55.camel@corn.betterworld.us>
	 <20121122155236.0e7689c6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121122155236.0e7689c6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: ross@biostat.ucsf.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2012-11-22 at 15:52 +1100, NeilBrown wrote:
> On Wed, 21 Nov 2012 08:58:57 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrote:
> 
> > I spent most of yesterday dealing with the failure of my (md) RAID
> > arrays to come up on reboot.  If anyone can explain what happened or
> > what I can do to avoid it, I'd appreciate it.  Also, I'd like to know if
> > the failure of one device in a RAID 1 can contaminate the other with bad
> > data (I think the answer must be yes, in general, but I can hope).
> > 
> > In particular, I'll need to reinsert the disks I removed (described
> > below) without getting everything screwed up.
> > 
> > Linux 2.6.32 amd64 kernel.
> > 
> > I'll describe what I did for md1 first:
> > 
> > 1. At the start, system has 3 physically identical disks. sda and sdc
> > are twins and sdb is unused, though partitioned. md1 is a raid1 of sda3
> > and sdc3.  Disks have DOS partitions.
> > 2. Add 2 larger drives to the system.  They become sdd and sde.  These 2
> > are physically identical to each other, and bigger than the first batch
> > of drives.
> > 3. GPT format the drives with larger partitions than sda.
> > 4. mdadm --fail /dev/md1 /dev/sdc3
> > 5. mdadm --add /dev/md1 /dev/sdd4.  Wait for sync.
> > 6. madadm --add /dev/md1 /dev/sde4.
> > 7. mdadm --grow /dev/md1 -n 3.  Wait for sync.
> > 
> > md0 was same story except I only added sdd (and I used partitions sda1
> > and sdd2).
> > 
> > This all seemed to be working fine.
> > 
> > Reboot.
> > 
> > System came up with md0 as sda1 and sdd2, as expected.
> > But md1 was the failed sdc3 only.  Note I did not remove the partition
> > from md1; maybe I needed to?
> > 
> > Shutdown, removed disk sdc for the computer.  Reboot.
> > /md0 is reassembled to but md1 is not, and so the system can not not
> > come up (since root is on md0).  BTW, md1 is used as a PV for LVM; md0
> > is /boot.
> > 
> > In at least some kernels the GPT partitions were not recognized in the
> > initrd of the boot process (Knoppix 6--same version of the kernel,
> > 2.6.32, as my system, though I'm not sure the kernel modules are same as
> > for Debian).  I'm not sure if the GPT partitions were recognized under
> > Debian in the initrd, though they obviously were in the running system
> > at the start.
> 
> Well if your initrd doesn't recognise GPT, then that would explain your
> problems.
I later found, using the Debian initrd, that arrays with fewer than the
expected number of devices (as in the n= paramter) do not get activated.
I think that's what you mean by "explain your problems." Or did you have
something else in mind?

At least I  think I found arrays with missing parts are not activated;
perhaps there was something else about my operations from knoppix 7
(described 2 paragraps below this) that helped.

The other problem with that discovery is that the first reboot activated
md1 with only 1 partition, even though md1 had never been configured
with <2.

Most of my theories have the character of being consistent with some
behavior I saw and inconsistent with other observed behavior.  Possibly
I misperceived or misremembered something.
> 
> > 
> > After much trashing, I pulled all drives but sda and sdb.  This was
> > still not sufficient to boot because the md's wouldn't come up. md0 was
> > reported as assembled, but was not readable.  I'm pretty sure that was
> > because it wasn't activated (--run) since md was waiting for the
> > expected number of disks (2).  md1, as before, wasn't assembled at all. 
> > 
> > >From knoppix  (v7, 32 bit) I activated both md's and shrunk them to size
> > 1 (--grow --force -n 1).  In retrospect this probably could have been
> > done from the initrd.
> > 
> > Then I was able to boot.
> > 
> > I repartitioned sdb and added it to the RAID arrays.  This led to hard
> > disk failures on sdb, though the arrays eventually were assembled.  I
> > failed and removed the sdb partitions from the arrays and shrunk them.
> > I hope the bad sdb has not screwed up the good  sda.
> 
> Its not entirely impossible (I've seen it happen) but it is very unlikely
> that hardware errors on one device will "infect" the other.
Our local sysadmin also believes the errors in sdb were either
corrected, or resulted in an error code, rather than ever sending bad
data back.  I'm proceeding on the assumption sda is OK.
> 
> > 
> > Thanks for any assistance you can offer.
> 
> What sort of assistance are you after?
I'm trying to understand what happened and how to avoid having it happen
again.

I'm also trying to understand under what conditions it is safe to insert
disks that have out of date versions of arrays in them.

> 
> first questions is: does the initrd handle GPT.  If not, fix that first.
That is the first thing I'll check when I'm at the machine.  The problem
with the "initrd didn't recognize GPT theory" was that in my very first
reboot md0 was assemebled from two partitions, one of which was on a GPT
disk. (another example of "all my theories have contradictory evidence")

Ross


