From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Questions about software RAID
Date: Wed, 20 Apr 2005 21:21:15 -0400
Message-ID: <200504210121.j3L1LKm02745@www.watkins-home.com>
References: <yq1ekd5cutj.fsf@wilson.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1ekd5cutj.fsf@wilson.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "'Martin K. Petersen'" <mkp@mkp.net>
Cc: 'Frank Wittig' <fw@weisshuhn.de>, rv@eychenne.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> From: Martin K. Petersen [mailto:mkp@mkp.net]
> Sent: Wednesday, April 20, 2005 11:49 AM
> To: Guy
> Cc: 'Frank Wittig'; rv@eychenne.org; linux-raid@vger.kernel.org
> Subject: Re: Questions about software RAID
> 
> >>>>> "Guy" == Guy  <bugzilla@watkins-home.com> writes:
> 
> Guy> I want the failed disk to light a red LED.
> Guy> I want the tray the disk is in to light a red LED.
> Guy> I want the cabinet the tray is in to light a red LED.
> 
> That's easy when you have a custom hardware RAID enclosure that you
> have control over.  As you suggest yourself, it's not easy when you
> have off the shelf components.
> 
> What happens in "real" storage systems is that the SCSI bus is
> monitored by a SAF-TE or SES chip.  The OS (in this case the RAID
> controller firmware) will talk to the SAF-TE device or access the SES
> page to get information about hot swap events, failed disks, stopped
> fans, busted power supply, etc.
> 
> I messed with a daemon to monitor enclosures implementing either of
> these two standards during the infancy of hotplug.  I should probably
> look into that again.  But obviously this would only apply to disk
> trays with suitable monitoring hardware.
> 
> 
> Guy> I want the re-build to the new disk to start.
> 
> Are you sure?  How do you know that the disk you just inserted is
> something you want to use for the RAID?  What if you hook up - say - a
> USB storage device to back up data before you start messing with
> things?  You most definitely don't want the RAID to start scribbling
> over any random device you hook up to a system with a failed RAID
> device.

Yes I am sure, but the new disk would be replacing the old disk.  Same bus
same slot same ID/LUN or whatever.  This may not be reasonable with all bus
types, but with SCSI/SCA it is.  Also, my wish list would need to be defined
when the system is setup, I would not expect all systems to work this way.
It would be fine to have a user interface that indicated a "new" disk was
found and prompt the user for permission to use it.

My wish list would have prerequisites!  Maybe EVMS, or some other "special"
layer that can notice a disk has been removed and notice when a different
disk has been installed.  Only 1 partition, or full disk.  You can't (should
not) pull a disk that has 2 or more partitions just because 1 may be bad!
Maybe more prerequisites that I can't determine.  But, assuming I meet the
theoretical prerequisites, I should be able to build a system that can be
maintained by "normal" sysadmins.  These admins may be called operators in
some environments.  But with today's tools you need a Linux expert to
replace a disk.  IMO.  And I don't think that is acceptable!

Don't get me wrong!!!  I love Linux, but I want improvements and features!

Guy

> 
> In the HW RAID enclosure case that's easy - again because the whole
> tray is under the array firmware's control.
> 
> Definining a generic resync-on-hotplug policy is not trivial.  One
> policy that might work for most people is sync if a new disk is
> inserted on the same address (SCSI controller, channel, id, lun).  But
> there's no one size fits all policy.
> 
> And this is not just because Linux sucks.  It's simply that a lot of
> the "easy" HW RAID features are a result of appropriately designed
> hardware.
> 
> We can certainly make Linux work more smoothly on hardware that allows
> for monitoring and predictable addressing, etc.  But in the low end
> it'll have to be a policy defined by the sysadmin.  And we probably
> want to leave it a sysadmin configurable policy even if the hardware
> implements the required magic.
> 
> --
> Martin K. Petersen	Wild Open Source, Inc.
> mkp@wildopensource.com	http://www.wildopensource.com/

