From: maarten <maarten@ultratux.net>
Subject: Re: combining two raid systems
Date: Thu, 13 Jan 2005 21:27:07 +0100
Message-ID: <200501132127.07764.maarten@ultratux.net>
References: <200501132017.16910.maarten@ultratux.net> <1105645254.3390.12.camel@south.rosestar.lan>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1105645254.3390.12.camel@south.rosestar.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bob Hillegas <bobhillegas@houston.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 13 January 2005 20:40, Bob Hillegas wrote:
> Set the sequence of hard drives to boot from in BIOS. Once you combine
> drives on single server, the drive designations will probably change.
> Need to figure out which sdx to put at the top of list.

No, that's perfectly handled by the autodetection. My drive ID are reassigned 
all over the place (of course) but that goes well.

> Depending how you assemble array, you may at this point also need to
> tweak config file before you get the right drives assembled.

Yes but as I said the config is only read when all the assembling is done so 
that won't help much. (chicken and egg problem)

> Introducing new SCSI devices into the chain is always interesting.

Indeed.

But I think I'm on the right track now anyway;  I did --zero-superblock on the 
unwanted md0 and md1 drives, and rebooted. At this point something 
interesting happened: md1 now indeed was the right array (from system 1). 
Md0 however was still from system 2. So I gathered from that that the SB also 
'knows' which md device number it has so I had two md0's that clashed.
Knowing that I took the risk of fdisk'ing the drives from 0xFD to 0x83 and 
that helped: I'm now booted into my system 1 OS drive.

I'll check if everything works now... gotta do stuff with LVM still at least, 
and tweaking the mdadm.conf. 

Maarten

> BobH
>
> On Thu, 2005-01-13 at 13:17, maarten wrote:
> > Hi,
> >
> > I'm currently combing two servers into one, and I'm trying to figure out
> > the safest way to do that.
> >
> > System one had two md arrays: one raid-1 with the OS and a second one
> > with data (raid-5)  It is bootable through lilo
> >
> > System two had 9 arrays, one with the OS (raid-1) two raid-1's for swap,
> > and 6 md devices that belong in an LVM volume. This system has grub.
> >
> > All md arrays are self-booting 0xFD partitions.
> >
> > I want to boot off system one.  I verified that that boots fine if I
> > disconnect all the [system-2] drives, so that's working okay.
> >
> > Now when I boot I get a lilo prompt, so I know the right disk is booted
> > by the BIOS.  When logged in, I see only the md devices from system two,
> > and thus the current md0 "/" drive is from system two.  Now what options
> > do I have ?
> >
> > If I zero the superblock(s) (or even the whole partitions) from md0 of
> > system 2, it will not boot off of that obviously, but what will now get
> > to be md0 ? It could be the second array from system 2 equally well as
> > the first array from system one, right ?
> >
> > I could experiment with finding the right array by using different kernel
> > root= commandlines, but only grub gives me that possibility, lilo has no
> > boot-time shell (well, it has a commandline...)
> >
> > Another thing that strikes me is that running 'mdadm --detail --scan'
> > also only finds the arrays from system 2. Is that expected since it just
> > reads its /etc/mdadm.conf file, or should it disregard that and show all
> > arrays ?
> >
> > Upon first glance 'fdisk -l' does show all devices fine (there are 10 of
> > them)
> >
> > I think (er, hope, actually) that with mdadm.conf one could probably
> > force the machine to recognize the right drives as md0 as opposed to them
> > being numbered mdX, but is that a right assumption ?  At the time the
> > kernel md code reads / assembles the various 0xFD partitions, the
> > root-partition is not mounted (obviously) so reading /etc/mdadm.conf will
> > not be possible.
> >
> > I'll start to try out some things but I _really_ want to avoid having an
> > unbootable system: for one, this system has no CDrom nor floppy, and even
> > more importantly I don't think my rescue media have all neccessary
> > drivers for the ATA & SATA cards.
> >
> > Anyone have some good advice for me ?
> >
> > Maarten

-- 


