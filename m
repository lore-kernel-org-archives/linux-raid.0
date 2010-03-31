From: Neil Brown <neilb@suse.de>
Subject: Re: Auto Rebuild on hot-plug
Date: Wed, 31 Mar 2010 12:30:31 +1100
Message-ID: <20100331123031.1400fd7a@notabene.brown>
References: <20100325113543.0e2124c5@notabene.brown>
	<4BAB6EBD.2030503@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BAB6EBD.2030503@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, linux-raid@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On Thu, 25 Mar 2010 14:10:05 +0000
John Robinson <john.robinson@anonymous.org.uk> wrote:


> >  Part 1.
> > 
> >   A newly hotplugged device may have metadata for RAID (0.90, 1.x, IMSM, DDF,
> >   other vendor metadata) or LVM or a filesystem.  It might have a partition
> >   table which could be subordinate to or super-ordinate to other metadata.
> >   (i.e. RAID in partitions, or partitions in RAID).  The metadata may or may
> >   not be stale.  It may or may not match - either strongly or weakly -
> >   metadata on devices in currently active arrays.
> 
> Or indeed it may have no metadata at all - it may be a fresh disc. I 
> didn't see that you stated this specifically at any point, though it was 
> there by implication, so I will: you're going to have to pick up hotplug 
> events for bare drives, which presumably means you'll also get events 
> for CD-ROM drives, USB sticks, printers with media card slots in them etc.

Correct.  We would expect that "domain path=" matching to say that those
should only be used if they already have recognisable metadata on them.
To make use of a device with no metadata already present, it would need to
appear at a path for which auto-rebuild was explicitly enabled.


> 
> >   A newly hotplugged device also has a "path" which we can see
> >   in /dev/disk/by-path.  This is somehow indicative of a physical location.
> >   This path may be the same as the path of a device which was recently
> >   removed.  It might be one of a set of paths which make up a "RAID chassis".
> >   It might be one of a set of paths one which we happen to find other RAID
> >   arrays.
> 
> Indeed, I would like to be able to declare any 
> /dev/disk/by-path/pci-0000:00:1f.2-scsi-[0-4] to be suitable candidates 
> for hot-plugging, because those are the 5 motherboard SATA ports I've 
> hooked into my hot-swap chassis.
> 
> As an aside, I just tried yanking and replugging one of my drives, on 
> CentOS 5.4, and it successfully went away and came back again, but 
> wasn't automatically re-added, even though the metadata etc was all there.

No.  That is because we have not yet implemented anything that has been
described in this document...

Thanks,
NeilBrown
