From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: "Enhanced" MD code avaible for review
Date: Thu, 25 Mar 2004 19:01:09 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <406372C5.600@pobox.com>
References: <760890000.1079727553@aslan.btc.adaptec.com> <16480.61927.863086.637055@notabene.cse.unsw.edu.au> <40624235.30108@pobox.com> <200403251200.35199.kevcorry@us.ibm.com> <40632804.1020101@pobox.com> <40632994.7080504@pobox.com> <1035780000.1080258411@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1035780000.1080258411@aslan.btc.adaptec.com>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-kernel@vger.kernel.org, Kevin Corry <kevcorry@us.ibm.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin T. Gibbs wrote:
>>Jeff Garzik wrote:
>>
>>Just so there is no confusion...  the "failing over...in userland" thing I
>>mention is _only_ during discovery of the root disk.
> 
> 
> None of the solutions being talked about perform "failing over" in
> userland.  The RAID transforms which perform this operation are kernel
> resident in DM, MD, and EMD.  Perhaps you are talking about spare
> activation and rebuild?

This is precisely why I sent the second email, and made the 
qualification I did :)

For a "do it in userland" solution, an initrd or initramfs piece 
examines the system configuration, and assembles physical disks into 
RAID arrays based on the information it finds.  I was mainly implying 
that an initrd solution would have to provide some primitive failover 
initially, before the kernel is bootstrapped...  much like a bootloader 
that supports booting off a RAID1 array would need to do.

	Jeff
