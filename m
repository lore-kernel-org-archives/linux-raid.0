From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: "Enhanced" MD code avaible for review
Date: Thu, 25 Mar 2004 13:48:52 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40632994.7080504@pobox.com>
References: <760890000.1079727553@aslan.btc.adaptec.com> <16480.61927.863086.637055@notabene.cse.unsw.edu.au> <40624235.30108@pobox.com> <200403251200.35199.kevcorry@us.ibm.com> <40632804.1020101@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40632804.1020101@pobox.com>
To: linux-kernel@vger.kernel.org
Cc: Kevin Corry <kevcorry@us.ibm.com>, Neil Brown <neilb@cse.unsw.edu.au>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Garzik wrote:
> My take on things...  the configuration of RAID arrays got a lot more 
> complex with DDF and "host RAID" in general.  Association of RAID arrays 
> based on specific hardware controllers.  Silently building RAID0+1 
> stacked arrays out of non-RAID block devices the kernel presents. 
> Failing over when one of the drives the kernel presents does not respond.
> 
> All that just screams "do it in userland".

Just so there is no confusion...  the "failing over...in userland" thing 
I mention is _only_ during discovery of the root disk.

Similar code would need to go into the bootloader, for controllers that 
do not present the entire RAID array as a faked BIOS INT drive.

	Jeff



