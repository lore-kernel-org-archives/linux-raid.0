From: "Zoe May" <Zoe.May@Cartesian.co.uk>
Subject: RE: Aacraid - terrible performance on RHES3 pedge 2450
Date: Mon, 1 Nov 2004 15:51:55 -0000
Message-ID: <7B3248565B589149B35D353FB966388E4DD70B@bunny.cartesian.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
