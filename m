From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Aacraid - terrible performance on RHES3 pedge 2450
Date: Mon, 25 Oct 2004 08:01:57 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041025130157.GC25232@lists.us.dell.com>
References: <60807403EABEB443939A5A7AA8A7458B40B9C9@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B40B9C9@otce2k01.adaptec.com>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Zoe May <Zoe.May@Cartesian.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 25, 2004 at 08:28:47AM -0400, Salyzyn, Mark wrote:
> Vary_io may be the reason for this.
> 
> The driver needs to have .vary_io set to 1.
> 
> There are no kernel clues to its existence (that I know of), but the
> driver has an SCSI_HAS_VARY_IO to enable. Our build system will produce
> correct binaries, but the DKMS tool does not differentiate.
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
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
