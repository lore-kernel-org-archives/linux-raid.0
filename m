From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: "Enhanced" MD code avaible for review
Date: Tue, 30 Mar 2004 12:15:07 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4069AB1B.90108@pobox.com>
References: <760890000.1079727553@aslan.btc.adaptec.com> <200403261315.20213.kevcorry@us.ibm.com> <1644340000.1080333901@aslan.btc.adaptec.com> <200403270939.29164.kevcorry@us.ibm.com> <842610000.1080666235@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <842610000.1080666235@aslan.btc.adaptec.com>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Kevin Corry <kevcorry@us.ibm.com>, linux-kernel@vger.kernel.org, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-raid.ids

Justin T. Gibbs wrote:
> The dm-raid1 module also appears to intrinsicly trust its mapping and the
> contents of its meta-data (simple magic number check).  It seems to me that 
> the kernel should validate all of its inputs regardless of whether the
> ioctls that are used to present them are only supposed to be used by a
> "trusted daemon".

The kernel should not be validating -trusted- userland inputs.  Root is 
allowed to scrag the disk, violate limits, and/or crash his own machine.

A simple example is requiring userland, when submitting ATA taskfiles 
via an ioctl, to specify the data phase (pio read, dma write, no-data, 
etc.).  If the data phase is specified incorrectly, you kill the OS 
driver's ATA host state machine, and the results are very unpredictable. 
  Since this is a trusted operation, requiring CAP_RAW_IO, it's up to 
userland to get the required details right (just like following a spec).


> I honestly don't care if the final solution is EMD, DM, or XYZ so long
> as that solution is correct, supportable, and covers all of the scenarios
> required for robust RAID support.  That is the crux of the argument, not
> "please love my code".

hehe.  I think we all agree here...

	Jeff




