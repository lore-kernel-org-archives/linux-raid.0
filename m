From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: SW Raid doesn't play nice with devfs?
Date: Mon, 9 Sep 2002 21:11:18 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15740.33238.383316.833368@notabene.cse.unsw.edu.au>
References: <20020909054800.GV3806@merlins.org>
	<15740.15774.911597.853392@notabene.cse.unsw.edu.au>
	<20020909062737.GA3806@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Marc MERLIN on Sunday September 8
To: Marc MERLIN <marc_news@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday September 8, marc_news@merlins.org wrote:
> 
> That said, the problem occurs both with the kernel autorun and raidstart:
> when I load the qla1280 module, the drives get detected, md wakes up and
> tries to create md3 since the partitions have type 0xfd, and fails in the
> same way:
> (...)
> kernel:  /dev/scsi/host3/bus0/target13/lun0: p1
> kernel: SCSI device sdl: 354600001 512-byte hdwr sectors
> kernel:  /dev/scsi/host3/bus0/target14/lun0: p1
> kernel:  [events: 00000002]
> kernel: md: could not lock sdm1, zero-size? Marking faulty.
> (...)
> 

I'm not sure what exactly is going on here, but it isn't regular
auto-detect. That *only* happens at boot time.  Never after module
load.

> Is the kernel autorun code going to be fixed too or will I need to use mdadm
> for the forseable future?

I use and recommend mdadm to all non-root devices.  For a raid
containing the root filesystem I use kernel parameters:
   md=0,/dev/xxxx,/dev/yyyy

though in 2.6, I suspect that initramfs will mean that mdadm is the
best choice for that too.  Don't do in kernel-space that which can
effectively and efficiently be done in user-space.

NeilBrown
