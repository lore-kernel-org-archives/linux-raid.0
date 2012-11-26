From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: System runs with RAID but fails to reboot [explanation?]
Date: Mon, 26 Nov 2012 15:48:42 -0800
Message-ID: <1353973722.7078.51.camel@markov.biostat.ucsf.edu>
References: <1353517137.5795.55.camel@corn.betterworld.us>
	 <20121122155236.0e7689c6@notabene.brown>
	 <1353716131.18439.29.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1353716131.18439.29.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: ross@biostat.ucsf.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I may have an explanation for what happened, including why md0 and md1
were treated differently.
On Fri, 2012-11-23 at 16:15 -0800, Ross Boylan wrote:
> On Thu, 2012-11-22 at 15:52 +1100, NeilBrown wrote:
> > On Wed, 21 Nov 2012 08:58:57 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrote:
> > 
> > > I spent most of yesterday dealing with the failure of my (md) RAID
> > > arrays to come up on reboot.  If anyone can explain what happened or
> > > what I can do to avoid it, I'd appreciate it.  Also, I'd like to know if
> > > the failure of one device in a RAID 1 can contaminate the other with bad
> > > data (I think the answer must be yes, in general, but I can hope).
> > > 
> > > In particular, I'll need to reinsert the disks I removed (described
> > > below) without getting everything screwed up.
> > > 
> > > Linux 2.6.32 amd64 kernel.
> > > 
> > > I'll describe what I did for md1 first:
> > > 
> > > 1. At the start, system has 3 physically identical disks. sda and sdc
> > > are twins and sdb is unused, though partitioned. md1 is a raid1 of sda3
> > > and sdc3.  Disks have DOS partitions.
> > > 2. Add 2 larger drives to the system.  They become sdd and sde.  These 2
> > > are physically identical to each other, and bigger than the first batch
> > > of drives.
> > > 3. GPT format the drives with larger partitions than sda.
> > > 4. mdadm --fail /dev/md1 /dev/sdc3
> > > 5. mdadm --add /dev/md1 /dev/sdd4.  Wait for sync.
> > > 6. madadm --add /dev/md1 /dev/sde4.
> > > 7. mdadm --grow /dev/md1 -n 3.  Wait for sync.
> > > 
> > > md0 was same story except I only added sdd (and I used partitions sda1
> > > and sdd2).
> > > 
> > > This all seemed to be working fine.
> > > 
> > > Reboot.
> > > 
> > > System came up with md0 as sda1 and sdd2, as expected.
> > > But md1 was the failed sdc3 only.  Note I did not remove the partition
> > > from md1; maybe I needed to?
First, the Debian initrd I'm using does recognize GPT partitions, and so
unrecognized partitions did not cause the problem.

Second, the initrd executes mdadm --assemble --scan --run --auto=yes.
This uses conf/conf.d/md and etc/mdadm/mdadm.conf.   The latter includes
--num-devices for each array.  Since I did not regenerate this after
changing the array sizes, it was 2 for both arrays.  man mdadm.conf says
ARRAY  The ARRAY lines identify actual arrays.  The second word on  the
    line  should  be  the name of the device where the array is nor-
    mally assembled, such as /dev/md1.   Subsequent  words  identify
    the  array,  or  identify  the  array as a member of a group. If
    multiple identities are given,  then  a  component  device  must
    match  ALL  identities  to be considered a match. [ num-devices is
one of the identity keywords].

This was fine for md0 (unless it should have been 3 because of the
failed device), and at least consistent with the metadata on sdc3,
formerly part of md1.  It was inconsistent with the metadata for md1 on
its current components, sda3, sdd4, and sde4, all of which indicates a
size of 3 (or 4 if failed devices count).

I do not know if the "must match" logic applies to --num-devices (since
the manual says the option is mainly for compatibility with the output
of --examine --scan), nor do I know if the --run option overrides the
matching requirement.  But md0's components might match the num-devices
in mdadm.conf, while md1's current components do not match. md1's old
commponent does match.

I don't know if, before all that, udev triggers attempts to assemble
arrays incrementally.  Nor do I know how such incremental assembly works
when some of the candidate devices are out of date.

So the mismatch between the array size for md0, but not md1, might
explain why md0 came up as expected, but md1 came up as a single, old
partition instead of the 3 current ones.

However, it is awkward for this account that after I set the array sizes
to 1 for both md0 and md1 (using partitions from sda)--which would be
inconsistent with the size in mdadm.conf--they both came up.  There were
fewer choices at that point, since I had removed all the other disks.

Third, my recent experience suggests something more is going on, and
perhaps the count considerations just mentioned are not that important.
I'll put what happened at the end, since it happened after everything
else described here.
> > > 
> > > Shutdown, removed disk sdc for the computer.  Reboot.
> > > /md0 is reassembled to but md1 is not, and so the system can not not
> > > come up (since root is on md0).  BTW, md1 is used as a PV for LVM; md0
> > > is /boot.
> > > 
> > > In at least some kernels the GPT partitions were not recognized in the
> > > initrd of the boot process (Knoppix 6--same version of the kernel,
> > > 2.6.32, as my system, though I'm not sure the kernel modules are same as
> > > for Debian).  I'm not sure if the GPT partitions were recognized under
> > > Debian in the initrd, though they obviously were in the running system
> > > at the start.
> > 
> > Well if your initrd doesn't recognise GPT, then that would explain your
> > problems.
> I later found, using the Debian initrd, that arrays with fewer than the
> expected number of devices (as in the n= paramter) do not get activated.
> I think that's what you mean by "explain your problems." Or did you have
> something else in mind?
> 
> At least I  think I found arrays with missing parts are not activated;
> perhaps there was something else about my operations from knoppix 7
> (described 2 paragraps below this) that helped.
> 
> The other problem with that discovery is that the first reboot activated
> md1 with only 1 partition, even though md1 had never been configured
> with <2.
> 
> Most of my theories have the character of being consistent with some
> behavior I saw and inconsistent with other observed behavior.  Possibly
> I misperceived or misremembered something.
> > 
> > > 
> > > After much trashing, I pulled all drives but sda and sdb.  This was
> > > still not sufficient to boot because the md's wouldn't come up. md0 was
> > > reported as assembled, but was not readable.  I'm pretty sure that was
> > > because it wasn't activated (--run) since md was waiting for the
> > > expected number of disks (2).  md1, as before, wasn't assembled at all. 
> > > 
> > > >From knoppix  (v7, 32 bit) I activated both md's and shrunk them to size
> > > 1 (--grow --force -n 1).  In retrospect this probably could have been
> > > done from the initrd.
> > > 
> > > Then I was able to boot.
> > > 
> > > I repartitioned sdb and added it to the RAID arrays.  This led to hard
> > > disk failures on sdb, though the arrays eventually were assembled.  I
> > > failed and removed the sdb partitions from the arrays and shrunk them.
> > > I hope the bad sdb has not screwed up the good  sda.
> > 
> > Its not entirely impossible (I've seen it happen) but it is very unlikely
> > that hardware errors on one device will "infect" the other.
> Our local sysadmin also believes the errors in sdb were either
> corrected, or resulted in an error code, rather than ever sending bad
> data back.  I'm proceeding on the assumption sda is OK.
> > 
> > > 
> > > Thanks for any assistance you can offer.
> > 
> > What sort of assistance are you after?
> I'm trying to understand what happened and how to avoid having it happen
> again.
> 
> I'm also trying to understand under what conditions it is safe to insert
> disks that have out of date versions of arrays in them.
> 
> > 
> > first questions is: does the initrd handle GPT.  If not, fix that first.
> That is the first thing I'll check when I'm at the machine.  The problem
> with the "initrd didn't recognize GPT theory" was that in my very first
> reboot md0 was assemebled from two partitions, one of which was on a GPT
> disk. (another example of "all my theories have contradictory evidence")
> 
> Ross
After running for awhile with both RAIDs having size 1 and using sda
exclusively, I shut down the sytem, removed the physically failing sdb,
and added the 2 GPT disks, formerly known as sdd and sde.  sdd has
partitions that were part of md0 and md1; sde has a partition that was
part of md1.  For simplicity I'll continue to refer to them as sdd and
sde, even though they were called sdb and sdc in the new configuration.

This time, md0 came up with sdd2 (which is old) only and md1 came up
correctly with sda3 only.  Substantively sdd2 and sda1 are identical,
since they hold /boot and there have been no recent changes to it.  

This happened across 2 consecutive boots.  Once again, the older device
(sdd2) was activated in preference to the newer one (sda1).

In terms of counts for md0, mdadm.conf continued to indicate 2; sda1
indicates 1 device; and sdd2 indicates 2 devices + 1 failed device.

BTW, by using break=bottom as a kernel parameter one can interrupt the
initrd just after mdadm has run and see if the mappings are right.  For
the 2nd boot I did just that, and then manually shutdown md0 and brought
it back with sda1.  The code appears to offer break=post-mdadm as an
alternative, but that did not work for me (there was no break).  These
are Debian-specific tweaks, I believe.

Ross

