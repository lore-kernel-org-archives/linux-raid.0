From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: "Enhanced" MD code avaible for review
Date: Thu, 25 Mar 2004 16:46:51 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1035780000.1080258411@aslan.btc.adaptec.com>
References: <760890000.1079727553@aslan.btc.adaptec.com> <16480.61927.863086.637055@notabene.cse.unsw.edu.au> <40624235.30108@pobox.com> <200403251200.35199.kevcorry@us.ibm.com> <40632804.1020101@pobox.com> <40632994.7080504@pobox.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40632994.7080504@pobox.com>
Content-Disposition: inline
To: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org
Cc: Kevin Corry <kevcorry@us.ibm.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Jeff Garzik wrote:
> 
> Just so there is no confusion...  the "failing over...in userland" thing I
> mention is _only_ during discovery of the root disk.

None of the solutions being talked about perform "failing over" in
userland.  The RAID transforms which perform this operation are kernel
resident in DM, MD, and EMD.  Perhaps you are talking about spare
activation and rebuild?

> Similar code would need to go into the bootloader, for controllers that do
> not present the entire RAID array as a faked BIOS INT drive.

None of the solutions presented here are attempting to make RAID
transforms operate from the boot loader environment without BIOS
support.  I see this as a completely tangental problem to what is
being discussed.

--
Justin

