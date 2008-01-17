From: James Andrewartha <jamesa@daa.com.au>
Subject: SX8 docs (was: The SX4 challenge)
Date: Fri, 18 Jan 2008 00:42:06 +0900
Message-ID: <1200584526.7112.19.camel@zarvora>
References: <478EA794.8080608@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <478EA794.8080608@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux IDE mailing list <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux RAID list <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Wed, 2008-01-16 at 19:55 -0500, Jeff Garzik wrote:
> Promise just gave permission to post the docs for their PDC20621 (i.e. 
> SX4) hardware:
> http://gkernel.sourceforge.net/specs/promise/pdc20621-pguide-1.2.pdf.bz2
> 
> joining the existing PDC20621 DIMM and PLL docs:
> http://gkernel.sourceforge.net/specs/promise/pdc20621-pguide-dimm-1.6.pdf.bz2
> http://gkernel.sourceforge.net/specs/promise/pdc20621-pguide-pll-ata-timing-1.2.pdf.bz2
> 
> 
> So, the SX4 is now open.  Yay :)  I am hoping to talk Mikael into 
> becoming the sata_sx4 maintainer, and finally integrating my 'new-eh' 
> conversion in libata-dev.git.
> 
> But now is a good time to remind people how lame the sata_sx4 driver 
> software really is -- and I should know, I wrote it.

Hi Jeff,

What are the chances of the SX8 docs being opened? The vendor GPL driver
has bitrotted and the kernel driver offers poor performance or data
corruption. IIRC it's not part of libata but its own block device,
although you were considering porting it to get ATAPI support?

Thanks,

James Andrewartha
