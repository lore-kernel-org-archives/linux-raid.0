From: Lewis Shobbrook <mylists@blue-matrix.org>
Subject: Re: raid1 boot issues
Date: Fri, 26 Aug 2005 11:59:55 +1000
Message-ID: <200508261159.55418.mylists@blue-matrix.org>
References: <200508251903.47194.mylists@blue-matrix.org> <430D8333.9020606@ruisantos.com> <200508261132.00591.mylists@blue-matrix.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200508261132.00591.mylists@blue-matrix.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 26 August 2005 11:32 am, you wrote:

Thanks for the help guys,
I've given up for now, cp'd the boot to the md1 device and reflagged the 
partitions as bootable and just not mounting /dev/md0 anymore.  It's most 
probably some strange artefact from the raidtools & mkraid when the devices 
were originally created.  It's only a testing system.  I've not deleted 
the /dev/md0 just toggled the boot flags off for the hd[ac]1 partitions.  All 
the info should int theory still be present if anyone is curious to find out 
more info about this.

> >
> >     Are the boot sectors of your HD's clean? Or have you copied lilo
> > onto them?
> >     If not, are you shure that both you md0 partitions are marked as
> > bootable?
> >     Are the partitions marked 0xFD ?
>
> The bootsectors are clean.  The system boots fine it just won't mount
> /dev/md0 correctly during startup.  What surprises me is that /dev/md1
> mounts.  Often these type of problems are associated with the initrd
> modules, and result in kernel panic earlier in the boot process.  I'd
> expect that if one raid1 device is mounted then all required modules are
> present.
>
> Hmmmm....
>
> > Rui Santos
> >
> > Lewis Shobbrook wrote:
> > >Hi All,
> > >I have a problem attempting to boot a raid 1 system from lilo.  I have
> > >succeeded at this many times in the past, but am completely stumped as
> > > to what the issue is in this instance. I have the boot and root
> > > partitions seperate on /dev/md0 & /dev/md1 respectively, both raid1.
> > >The mdadm examination  for  the components is clean and the superblocks
> > > appear as they ought.  I'm using Debian unstable with std. apt
> > > kernel-image.  The correct modules are in place for the initrd.
> > >The boot partition fails to mount during  the boot process...
> > >fsck.ext3: invalid argument while trying to open /dev/md0
> > >The superblock can not be read or does not describe a correct ext2
> > >filesystem.... omitted usual stuff...
> > >Root password for maintenance or Control-D to continue...
> > >
> > >The bizarre thing is that it appears perfectly clean, I've re-zero'd the
> > >superblocks and completely recreated the device, but the result is
> > > always the same.
> > >mdrun loads /dev/md0 in a clean state straight away and it mounts
> > >cleanly.  /dev/md1 is no problem.
> > >mdadm -E of the components is clean, as is mdadm -d for the device.
> > >My fstab & mtab are the same as systems running the same kernel that
> > > work fine.
> > >
> > >I found the system laying around from about 12 months ago which had
> > > originally been set-up using raidtools.  I upgraded the system using
> > > dist-upgrade installed mdadm; after zeroing all superblocks for both
> > > drives and component partitions, I created the devices with the
> > > following ...
> > >
> > >mdadm -C /dev/md0 -l1 -n2 /dev/hda1 missing
> > >reformatted ext3 and restored the files before adding the missing
> > > devices and resyncing.
> > >I'm stumped!
> > >Anyone got any ideas?
> > >
> > >Cheers,
> > >
> > >Lewis
> > >
Lewis
