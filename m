From: "Zoe May" <Zoe.May@Cartesian.co.uk>
Subject: RE: Aacraid - terrible performance on RHES3 pedge 2450
Date: Wed, 8 Dec 2004 14:58:52 -0000
Message-ID: <7B3248565B589149B35D353FB966388E4DE47A@bunny.cartesian.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After trying various Linux distros without success I decided to take the
hardware RAID out of the equation.
If I put the raid card into scsi mode and configure the disks (my system
has 4) as volumes my problem goes away - except that I now can't boot
into Linux. (install completes without issue).

I get as far as the controller picking up the volumes then at the point
when it would normally go into grub I just get a blinking cursor. 
I can see my install by using linux rescue and when I run my disk i/o
tests the results are good -  virtually no CPU wait at all. 
I've tried using one volume with no software RAID, 4 volumes with
software RAID 5, 2 volumes with software RAID 1, all had the same
result.
Tried clearing nvram, flashing the BIOS, flashing the controller. In
desperation removed the RAID rom and ram and set the main BIOS
controller setting to SCSI. The system won't boot (stops just after
processor detection) or let me into 
BIOS when I have this option set. I had to put the RAID hardware back in
just to access the BIOS!

Anyone any suggestions? I can't see any way out of this and it's held up
an upgrade project for weeks now.
At this stage I would be willing to suggest buying another controller if
there is a better one that's 
guaranteed to work with the 2450 and RHEL3. 
Thing I'm worried about is that the next server in the upgrade chain has
exactly the same hardware...

Cheers

Zoe

-----Original Message-----
From: Zoe May 
Sent: Wednesday, November 24, 2004 2:07 PM
To: 'Salyzyn, Mark'
Cc: 'Matt_Domsch@dell.com'
Subject: RE: Aacraid - terrible performance on RHES3 pedge 2450

I tried this but unfortunately no improvement. 
I really need to get this box in to production so I'm going to drag
myself away from AS3 try some different distros. Tried Fedora C2 this
morning but had the same issues. 
Interestingly when I tried using Knoppix I didn't see much improvement
in disk i/o but vmstat didn't output the same high CPU wait times that
seem to be the cause of stopping everything else on the box running as
soon as I start writing to disk.

Thanks for your help

Zoe
-----Original Message-----
From: Salyzyn, Mark [mailto:mark_salyzyn@adaptec.com]
Sent: Thursday, November 18, 2004 4:06 PM
To: Zoe May
Cc: Matt_Domsch@dell.com
Subject: RE: Aacraid - terrible performance on RHES3 pedge 2450

Yes on the directory. No need to rebuild the kernel (if a past build is
sitting there), just do (2.4 kernel):

# make SUBDIRS=drivers/scsi/aacraid modules

and use the replacement module.

Sincerely -- Mark Salyzyn



-----Original Message-----
From: Zoe May [mailto:Zoe.May@Cartesian.co.uk]
Sent: Thursday, November 18, 2004 10:26 AM
To: Salyzyn, Mark
Cc: Matt_Domsch@dell.com
Subject: RE: Aacraid - terrible performance on RHES3 pedge 2450

Hi

After saying I would try the driver attached I opened the attachment and
realised I wasn't sure what to do with the files. Do I need to replace
the files in /usr/src/linux-xxx/drivers/scsi/aacraid with these and
rebuild the kernel?

Thanks

Zoe

-----Original Message-----
From: Salyzyn, Mark [mailto:mark_salyzyn@adaptec.com]
Sent: Monday, November 01, 2004 4:08 PM
To: Zoe May; Matt Domsch
Cc: linux-raid@vger.kernel.org
Subject: RE: Aacraid - terrible performance on RHES3 pedge 2450

Vary_io was added in 1.1.5-2326 to the adaptec aacraid sources, so
probably *none* of these. Adding a ".vary_io = 1," to the
scsi_host_template in the linit.c file would have to be manually added.

I have enclosed the sources of our latest driver that my comments were
based on. This driver has several performance enhancements (depending on
the adapter, between 15% and 45% improvement separate from the .vary_io
RHEL3 enhancement).

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Zoe May [mailto:Zoe.May@Cartesian.co.uk]
Sent: Monday, November 01, 2004 10:52 AM
To: Matt Domsch; Salyzyn, Mark
Cc: linux-raid@vger.kernel.org
Subject: RE: Aacraid - terrible performance on RHES3 pedge 2450

Thanks for the info

I've upgraded the kernel to 2.4.21-20 and have a very slight increase in
performance but unfortunately not much to write home about.
I have limited experience with kernel compilation and I'm a little
confused as to which aacraid.h I would have to add the #define
SCSI_HAS_VARY_IO 1 to.
 
I have the following aacraid.h files

/usr/src/aacraid-1.1.4-2302/aacraid.h
/usr/src/linux-2.4.21-20.EL/drivers/addon/aacraid_10102/aacraid.h
/usr/src/linux-2.4.21-20.EL/drivers/scsi/aacraid/aacraid.h

Ordinarily I would modify the .h file in the scsi/aacraid dir and then
go through the full kernel recompile but I have updated aacraid using
the Dell rpm. I assume the version in this folder is the old version
that shipped with the 2.4.21-20 source. If there is a way that I can
recompile just the aacraid module without doing a full kernel recompile
I would prefer to do this .


Zoe


-----Original Message-----
From: Matt Domsch [mailto:Matt_Domsch@dell.com]
Sent: Monday, October 25, 2004 2:02 PM
To: Salyzyn, Mark
Cc: Zoe May; linux-raid@vger.kernel.org
Subject: Re: Aacraid - terrible performance on RHES3 pedge 2450

On Mon, Oct 25, 2004 at 08:28:47AM -0400, Salyzyn, Mark wrote:
> Vary_io may be the reason for this.
> 
> The driver needs to have .vary_io set to 1.
> 
> There are no kernel clues to its existence (that I know of), but the 
> driver has an SCSI_HAS_VARY_IO to enable. Our build system will 
> produce correct binaries, but the DKMS tool does not differentiate.
> 
> There is a need to ship a different driver source in the DKMS package 
> for RHEL3 as a result (Add a #define SCSI_HAS_VARY_IO in the aacraid.h

> file).

We could do this easily in DKMS with its PATCH_MATCH mechanism, making
it match RHEL kernel names and apply the patch only then which sets
.vary_io=1.

--
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux Linux on Dell
mailing lists @ http://lists.us.dell.com
