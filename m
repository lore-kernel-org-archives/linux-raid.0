From: Rick Bragg <lists@gmnet.net>
Subject: RE: fsck problems.  Can't restore raid
Date: Sat, 26 Dec 2009 14:44:25 -0500
Message-ID: <1261856665.10448.1087.camel@vibe>
References: <B4.00.01567.F5A563B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B4.00.01567.F5A563B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi 

Thanks, it was an array that was up and running for a long time, and all
of a sudden, this happened.  so there were formatted and up and running
fine.

If I run, `mdadm --examine /dev/sda` etc. on all my disks, I get the
following error on all disks:
mdadm: No md superblock detected on /dev/sda.  
thats on all disks... (sda, sdb, sdc, and sdd)

When I run fdisk on /dev/sda I get the following error:
Unable to read /dev/sda

However, running fdisk on all other disks shows that they are up and
formatted with "raid" file type.

Not sure what I can do next...

Thanks
Rick






On Sat, 2009-12-26 at 12:47 -0600, Leslie Rhorer wrote:
> 	I take it from your post the drives are not partitioned, and the
> RAID array consists of raw disk members?  First, check the superblocks of
> the md devices:
> 
> 	`mdadm --examine /dev/sda`, etc.  If 2 or more of the superblocks
> are corrupt, then that's your problem.  If not, then it should be possible
> to get the array mounted one way or the other.  Once you get the array
> assembled again, then you can repair it, if need be.  Once that is done, you
> can repair the file system if it is corrupted.  Once everything is clean,
> you can mount the file system, and if necessary attempt to recover any lost
> files.
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Rick Bragg
> > Sent: Friday, December 25, 2009 9:13 PM
> > To: Linux RAID
> > Subject: Re: fsck problems. Can't restore raid
> > 
> > On Fri, 2009-12-25 at 21:47 -0500, Rick Bragg wrote:
> > > On Fri, 2009-12-25 at 20:33 -0500, Rick Bragg wrote:
> > > > Hi,
> > > >
> > > > I have a raid 10 array and for some reason the system went down and I
> > > > can't get it back.
> > > >
> > > > during re-boot, I get the following error:
> > > >
> > > > The superblock could not be read or does not describe a correct ext2
> > > > filesystem.  If the device is valid and it really contains an ext2
> > > > filesystem (and not swap or ufs or something else), then the
> > superblock
> > > > is corrupt, and you might try running e2fsck with an alternate
> > > > superblock:
> > > >     e2fsck -b 8193 <device>
> > > >
> > > > I have tried everything I can think of and I can't seem to do an fsck
> > or
> > > > repair the file system.
> > > >
> > > > what can I do?
> > > >
> > > > Thanks
> > > > Rick
> > > >
> > >
> > >
> > > More info:
> > >
> > > My array is made up of /dev/sda, sdb, sdc, and sdd.  However they are
> > > not mounted right now.  My OS is booted off of /dev/sde.  I am running
> > > ubuntu 9.04
> > >
> > > mdadm -Q --detail /dev/md0
> > > mdadm: md device /dev/md0 does not appear to be active.
> > >
> > > Where do I take if from here?  I'm not up on this as much as I should be
> > > at all.  In fact I am quite a newbe to this... Any help would be greatly
> > > appreciated.
> > >
> > > Thanks
> > > Rick
> > >
> > 
> > 
> > Here is even more info:
> > 
> > # mdadm --assemble --scan
> > mdadm: /dev/md0 assembled from 2 drives - not enough to start the array.
> > 
> > # mdadm --assemble /dev/sda /dev/sdb /dev/sdc /dev/sdd
> > mdadm: cannot open device /dev/sdb: Device or resource busy
> > mdadm: /dev/sdb has no superblock - assembly aborted
> > 
> > Is my array toast?
> > What can I do?
> > 
> > Thanks
> > Rick
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



