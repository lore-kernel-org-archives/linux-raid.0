From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Aacraid - terrible performance on RHES3 pedge 2450
Date: Mon, 25 Oct 2004 08:28:47 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <60807403EABEB443939A5A7AA8A7458B40B9C9@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Matt Domsch <Matt_Domsch@dell.com>, Zoe May <Zoe.May@Cartesian.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Vary_io may be the reason for this.

The driver needs to have .vary_io set to 1.

There are no kernel clues to its existence (that I know of), but the
driver has an SCSI_HAS_VARY_IO to enable. Our build system will produce
correct binaries, but the DKMS tool does not differentiate.

There is a need to ship a different driver source in the DKMS package
for RHEL3 as a result (Add a #define SCSI_HAS_VARY_IO in the aacraid.h
file).

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Matt Domsch
Sent: Monday, October 25, 2004 8:22 AM
To: Zoe May
Cc: linux-raid@vger.kernel.org
Subject: Re: Aacraid - terrible performance on RHES3 pedge 2450

On Mon, Oct 25, 2004 at 11:31:07AM +0100, Zoe May wrote:
> 
> I am experiencing disk performance issues (very slow) with hardware
and
> software combo listed below.
> 
> Poweredge 2450 
> Perc 3/si controller.
> RH linux ES3 (2.4.21-4.Elsmp)

up2date your system to kernel-smp-2.4.21-20.EL and see how much that
helps.

You're not the only person who has seen slow disk performance with the
-4.EL kernel.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
