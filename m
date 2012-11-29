From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: System runs with RAID but fails to reboot [explanation?]
Date: Wed, 28 Nov 2012 22:42:11 -0800
Message-ID: <1354171331.31993.41.camel@corn.betterworld.us>
References: <1353517137.5795.55.camel@corn.betterworld.us>
	 <20121122155236.0e7689c6@notabene.brown>
	 <1353716131.18439.29.camel@corn.betterworld.us>
	 <1353973722.7078.51.camel@markov.biostat.ucsf.edu>
	 <20121127131527.4d0d81d5@notabene.brown>
	 <1354071275.27664.90.camel@corn.betterworld.us>
	 <20121129124509.55f3194b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121129124509.55f3194b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: ross@biostat.ucsf.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2012-11-29 at 12:45 +1100, NeilBrown wrote:
> On Tue, 27 Nov 2012 18:54:35 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrote:
> 
> > It still doesn't seem to me the 1 device arrays should have been
> > started, since they were inconsistent with mdadm.conf and not subject to
> > incremental assembly.  This is an understanding problem, not an
> > operational problem: I'm glad the arrays did come up.  Details below,
> > along with some other questions.
> 
> Probably "mdadm -As"  couldn't find anything to assemble based on the
> mdadm.conf file, so tried to auto-assemble anything it could find without
> concern for the ARRAY details in mdadm.conf.
That would explain why they came up, but seems to undercut the "must
match" condition given in the man page for mdadm.conf (excerpted just
below).
[deletions]
> > > 
> > > >                                 Since I did not regenerate this after
> > > > changing the array sizes, it was 2 for both arrays.  man mdadm.conf says
> > > > ARRAY  The ARRAY lines identify actual arrays.  The second word on  the
> > > >     line  should  be  the name of the device where the array is nor-
> > > >     mally assembled, such as /dev/md1.   Subsequent  words  identify
> > > >     the  array,  or  identify  the  array as a member of a group. If
> > > >     multiple identities are given,  then  a  component  device  must
> > > >     match  ALL  identities  to be considered a match. [ num-devices is
> > > > one of the identity keywords].
> > > > 
> > > > This was fine for md0 (unless it should have been 3 because of the
> > > > failed device), 
> > > 
> > > It should be the number of "raid devices"  i.e. the number of active devices
> > > when the array is optimal.  It ignores spares.
[xxxx]
> > > > 
> > > > I do not know if the "must match" logic applies to --num-devices (since
> > > > the manual says the option is mainly for compatibility with the output
> > > > of --examine --scan), nor do I know if the --run option overrides the
> > > > matching requirement.  But md0's components might match the num-devices
> > > > in mdadm.conf, while md1's current components do not match. md1's old
> > > > commponent does match.
> > > 
> > > Yes, "must match" means "must match".
> > > 
[xxx--thanks for the info on incremental assembly]
> > > 
> > > > 
> > > > However, it is awkward for this account that after I set the array sizes
> > > > to 1 for both md0 and md1 (using partitions from sda)--which would be
> > > > inconsistent with the size in mdadm.conf--they both came up.  There were
> > > > fewer choices at that point, since I had removed all the other disks.
> > > 
> > > I guess that as "all" the devices with a given UUID were consistent, mdadm -I
> > > accepted them even as "not present in mdadm.conf".
> > Here's the problem. mdadm -I did not run, and the num-devices in the
> > component metadata was 1, which did not match mdadm.conf.
> > 
> > So why did the arrays come up anyway?
> 
> mdadm does 'auto assembly' both with "mdadm -I" and "mdadm -As".
> I was assuming it was the former, but maybe it is the latter.
The initrd scripts --assemble --scan, but neither they nor the udev
rules do mdadm -I that I can see.  So I think it's just -As.
> 
> Can you shut down the arrays will the system is still up (obviously not if
> one holds '/').
> If so you could try that, then
> 
>  mdadm -Asvvv
> 
> and see what it says.
I'm not sure doing things with the system up will recreate what
happened, since I also pulled some of the drives out (that is, in
addition to bringing the arrays up with one disk each and "growing" the
arrays to have size 1--done from Knoppix).

My main array, md1, has / and almost everything else.  I could bring
down md0 on a live system since it has /boot.  It doesn't ordinarily get
updated; I don't know if that's important for testing.  It wouldn't
surprise me if there were some writes to md0 updating last access time
for files or number of times the drive came up.

Working with md0 also has the advantage that resync takes a few minutes,
as opposed to 4+ hours per component for md1.

Ross

I'll leave the narrative of my actions below, since it includes the last
steps with pulling the disks.  Aside from a few comments there's no new
material.

> > > > Third, my recent experience suggests something more is going on, and
> > > > perhaps the count considerations just mentioned are not that important.
> > > > I'll put what happened at the end, since it happened after everything
> > > > else described here.
> > > > > > > 
> > > > > > > Shutdown, removed disk sdc for the computer.  Reboot.
> > > > > > > /md0 is reassembled to but md1 is not, and so the system can not not
> > > > > > > come up (since root is on md0).  BTW, md1 is used as a PV for LVM; md0
> > > > > > > is /boot.
[speculation that my initrd couldn't recognize GPT disks deleted, since
it testing shows it can]
> > > > > > > 

> > > > > I later found, using the Debian initrd, that arrays with fewer than the
> > > > > expected number of devices (as in the n= paramter) do not get activated.
Note this was a statement about the info in the md superblock, not
mdadm.conf.
> > > > > I think that's what you mean by "explain your problems." Or did you have
> > > > > something else in mind?
> > > > > 
> > > > > At least I  think I found arrays with missing parts are not activated;
> > > > > perhaps there was something else about my operations from knoppix 7
> > > > > (described 2 paragraps below this) that helped.
> > > > > 
> > > > > The other problem with that discovery is that the first reboot activated
> > > > > md1 with only 1 partition, even though md1 had never been configured
> > > > > with <2.
> > > > > 
> > > > > Most of my theories have the character of being consistent with some
> > > > > behavior I saw and inconsistent with other observed behavior.  Possibly
> > > > > I misperceived or misremembered something.
> > > > > > 
> > > > > > > 
> > > > > > > After much trashing, I pulled all drives but sda and sdb.  This was
> > > > > > > still not sufficient to boot because the md's wouldn't come up. md0 was
> > > > > > > reported as assembled, but was not readable.  I'm pretty sure that was
> > > > > > > because it wasn't activated (--run) since md was waiting for the
> > > > > > > expected number of disks (2).  md1, as before, wasn't assembled at all. 
> > > > > > > 
> > > > > > > >From knoppix  (v7, 32 bit) I activated both md's and shrunk them to size
> > > > > > > 1 (--grow --force -n 1).  In retrospect this probably could have been
> > > > > > > done from the initrd.
> > > > > > > 
> > > > > > > Then I was able to boot.
> > > > > > > 
...
> > > > After running for awhile with both RAIDs having size 1 and using sda
> > > > exclusively, I shut down the sytem, removed the physically failing sdb,
> > > > and added the 2 GPT disks, formerly known as sdd and sde.  sdd has
> > > > partitions that were part of md0 and md1; sde has a partition that was
> > > > part of md1.  For simplicity I'll continue to refer to them as sdd and
> > > > sde, even though they were called sdb and sdc in the new configuration.
> > > > 
> > > > This time, md0 came up with sdd2 (which is old) only and md1 came up
> > > > correctly with sda3 only.  Substantively sdd2 and sda1 are identical,
> > > > since they hold /boot and there have been no recent changes to it.  
> > > > 
> > > > This happened across 2 consecutive boots.  Once again, the older device
> > > > (sdd2) was activated in preference to the newer one (sda1).
> > > > 
> > > > In terms of counts for md0, mdadm.conf continued to indicate 2; sda1
> > > > indicates 1 device; and sdd2 indicates 2 devices + 1 failed device.
> > > 
> > > That is why mdadm preferred sdd2 to sda1 - it matched mdadm.conf better.
Whereas for md1 it was a toss-up: mdadm says 2 devices, sda3 indicates 1
device and sdd4 and sde4 indicate 3 devices.  So this behavior now seems
explained.
> > > 
> > > I strongly suggest that you remove all "devices=" entries from mdadm.conf.
I've done that, which might also interfere with my ability to retest the
behavior.  However, I have yet to make an initrd with the new
mdadm.conf.


