From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: "Enhanced" MD code avaible for review
Date: Tue, 30 Mar 2004 12:46:49 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <4069B289.9030807@pobox.com>
References: <760890000.1079727553@aslan.btc.adaptec.com> <200403261315.20213.kevcorry@us.ibm.com> <1644340000.1080333901@aslan.btc.adaptec.com> <200403270939.29164.kevcorry@us.ibm.com> <842610000.1080666235@aslan.btc.adaptec.com> <4069AB1B.90108@pobox.com> <854630000.1080668158@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <854630000.1080668158@aslan.btc.adaptec.com>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Kevin Corry <kevcorry@us.ibm.com>, linux-kernel@vger.kernel.org, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-raid.ids

Justin T. Gibbs wrote:
>>The kernel should not be validating -trusted- userland inputs.  Root is
>>allowed to scrag the disk, violate limits, and/or crash his own machine.
>>
>>A simple example is requiring userland, when submitting ATA taskfiles via
>>an ioctl, to specify the data phase (pio read, dma write, no-data, etc.).
>>If the data phase is specified incorrectly, you kill the OS driver's ATA
>>host wwtate machine, and the results are very unpredictable.   Since this
>>is a trusted operation, requiring CAP_RAW_IO, it's up to userland to get the
>>required details right (just like following a spec).
> 
> 
> That's unfortunate for those using ATA.  A command submitted from userland

Required, since one cannot know the data phase of vendor-specific commands.


> to the SCSI drivers I've written that causes a protocol violation will
> be detected, result in appropriate recovery, and a nice diagnostic that
> can be used to diagnose the problem.  Part of this is because I cannot know
> if the protocol violation stems from a target defect, the input from the
> user or, for that matter, from the kernel.  The main reason is for robustness

Well,
* the target is not _issuing_ commands,
* any user issuing incorrect commands/cdbs is not your bug,
* and kernel code issuing incorrect cmands/cdbs isn't your bug either

Particularly, checking whether the kernel is doing something wrong, or 
wrong, just wastes cycles.  That's not a scalable way to code...  if 
every driver and Linux subsystem did that, things would be unbearable slow.

	Jeff
