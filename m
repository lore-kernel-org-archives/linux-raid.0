From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: Problems after extending partition
Date: Fri, 31 Aug 2012 21:21:07 -0700
Message-ID: <1346473267.11608.14.camel@corn.betterworld.us>
References: <504009DF.4070408@biostat.ucsf.edu>
	 <5040178C.1070900@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5040178C.1070900@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: ross@biostat.ucsf.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2012-08-31 at 11:46 +1000, Adam Goryachev wrote:
> On 31/08/12 10:48, Ross Boylan wrote:
> > /dev/md1 was RAID 1 built from hda3 and hdb3.  After increasing the
> > partition size of hd[ab]3, md1 could not be assembled.  I think I
> > understand why and have a solution, but I would appreciate it if
> > someone could check it.  This is with 0.90 format on Debian Lenny with
> > the partitions in raid auto-detect mode.  hda and hdb are virtual
> > disks inside a kvm VM; it would be time-consuming to rebuild it from
> > scratch.
> >
> > The final wrinkle is that when I brought the VM up and dm1 was not
> > constructed one of the partitions was used anyway, so they are now out
> > of sync.
> >
> > Analysis: Growing the partitions meant that the mdadm superblocks were
> > not at the expected offset from the end of the partitions, and so they
> > weren't recognized as part of the array.
> >
> > Solution:  (step 3 is the crucial one)
> > 1. Shut down the VM; call it the target VM.
> > 2. Mount the disks onto a rescue VM (running squeeze) as sdb and sdc.
> > 3. mdadm --create /dev/md1 --UUID=xxxxx --level=mirror
> > --raid-devices=2 /dev/sdb3 missing --spare-devices=1 /dev/sdc3.
> > UUID taken from the target VM.
> I would think something like these two might be easier to save step 5
> 3. mdadm --create /dev/md1 --UUID=xxxxx --level=mirror --raid-devices=2
> /dev/sdb3 missing
> 4. mdadm --manage /dev/md1 --add /dev/sdc3
> 5. wait for it to sync
> 
Thank you for the review and the suggestion.  I am not able to get the
UUID to stick, probably because it is being overridden by the host name:

# mdadm --create /dev/md1 --uuid=6f05ff4e:b4d49c1f:7fa21d88:ad0c50a9 --metadata=0.90 --level=mirror --raid-devices=2 /dev/sdb3 missing
mdadm: array /dev/md1 started.
# mdadm --examine /dev/sdb3
/dev/sdb3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 6f05ff4e:b4d49c1f:f1c4dd81:d9ca9b38 (local to host squeeze00)
  Creation Time : Fri Aug 31 20:59:50 2012
     Raid Level : raid1
  Used Dev Size : 8187712 (7.81 GiB 8.38 GB)
     Array Size : 8187712 (7.81 GiB 8.38 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Fri Aug 31 20:59:50 2012
          State : active
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 39956378 - correct
         Events : 1


      Number   Major   Minor   RaidDevice State
this     0       8       19        0      active sync   /dev/sdb3

   0     0       8       19        0      active sync   /dev/sdb3
   1     0       0        0        0      spare

Also, for the record, the option is uuid, not UUID.

This uuid overriding behavior appears to contradict the man page
(although technically I gave no --homehost option): "Also, using --uuid=
when creating a v0.90 array will silently   override any --homehost=
setting."

Note the hostname on the system from which I am manipulating the RAID is
not the same as for the target system.

The target system for the array is running Debian lenny.
I am manipulating it from a Debian squeeze system (which apparently does
not default to 0.90 format).

There is an additional future complication that the UUID seems to get
rewritten by homehost during at least some lenny->squeeze upgrades
(http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=570516).  The main
point of this exercise is to test such an upgrade in a VM.

Any ideas?
Ross


> Another option might have been to create the RAID1 onto the older drive
> (sdc3) and then copy the content of the new drive into the array, and
> then add sdb3 into this new array. This might also allow you to use a
> different md version
> > 4. wait for it to sync.
> > 5. maybe do some kind of command to say the raid no longer has a
> > spare.  It might be
> > mdadm --grow /dev/md3 --spare-devices=0
> > 6. Shut the rescue VM and start the target VM.
> >
> > Does it matter if I call the device /dev/md1 in step 3?  It is known
> > as that in the target VM.
> >
> Hope that help,
> 
> Regards,
> Adam
> 

