From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: RAID 5 performance issue.
Date: Wed, 03 Oct 2007 19:53:08 +0200
Message-ID: <87r6kcccfv.fsf@informatik.uni-tuebingen.de>
References: <20071003105321.06943824@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071003105321.06943824@zeus.pccl.info> (Andrew Clayton's
	message of "Wed, 3 Oct 2007 10:53:21 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Clayton <andrew@pccl.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Clayton <andrew@pccl.info> writes:

> Hi,
>
> Hardware:
>
> Dual Opteron 2GHz cpus. 2GB RAM. 4 x 250GB SATA hard drives. 1 (root file system) is connected to the onboard Silicon Image 3114 controller. The other 3 (/home) are in a software RAID 5 connected to a PCI Silicon Image 3124 card. I moved the 3 raid disks off the on board controller onto the card the other day to see if that would help, it didn't.

I would think the onboard controller is connected to the north or
south bridge and possibly hooked directly into the hyper
transport. The extra controler is PCI so you are limited to
theoretical 128MiB/s. For me the onboard chips do much better (though
at higher cpu cost) than pci cards.

MfG
        Goswin
