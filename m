From: Andrew Clayton <andrew@digital-domain.net>
Subject: Re: RAID 5 performance issue.
Date: Wed, 3 Oct 2007 21:20:37 +0100
Message-ID: <20071003212037.1c983765@alpha.digital-domain.net>
References: <20071003105321.06943824@zeus.pccl.info>
	<87r6kcccfv.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r6kcccfv.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 03 Oct 2007 19:53:08 +0200, Goswin von Brederlow wrote:

> Andrew Clayton <andrew@pccl.info> writes:
> 
> > Hi,
> >
> > Hardware:
> >
> > Dual Opteron 2GHz cpus. 2GB RAM. 4 x 250GB SATA hard drives. 1
> > (root file system) is connected to the onboard Silicon Image 3114
> > controller. The other 3 (/home) are in a software RAID 5 connected
> > to a PCI Silicon Image 3124 card. I moved the 3 raid disks off the
> > on board controller onto the card the other day to see if that
> > would help, it didn't.
> 
> I would think the onboard controller is connected to the north or
> south bridge and possibly hooked directly into the hyper
> transport. The extra controler is PCI so you are limited to
> theoretical 128MiB/s. For me the onboard chips do much better (though
> at higher cpu cost) than pci cards.

Yeah, I was wondering about that. It certainly hasn't improved things,
it's unclear if it's made things any worse..

> MfG
>         Goswin


Cheers,

Andrew
