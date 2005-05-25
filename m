From: danci@agenda.si
Subject: Re: Is there any way to delay reconstruction
Date: Wed, 25 May 2005 10:25:20 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0505251019280.16854@desktop.agenda.si>
References: <Pine.LNX.4.61.0505250811520.16854@desktop.agenda.si>
 <Pine.LNX.4.62.0505250925360.6360@webhosting.rdsbv.ro>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0505250925360.6360@webhosting.rdsbv.ro>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 25 May 2005, Catalin(ux aka Dino) BOIE wrote:

> > So I need to know if there is any way (kernel parameter would be 
> > ideal) to delay reconstruction for X seconds/minutes?
> > 
> > Any other suggestions to deal with the problem?
> 
> You can hot-remove the previous failed disk (anyway, it just started to
> resync). Then, activate DMA, then hot-add the disk to array.
> 
> Hope it helps.

Thanks for the suggestion - this may be the last resort (I'd like to keep 
the init-scripts as clean as possible).

I forgot to mention that I'm using 2.4 kernels (2.4.27 at the moment, 
2.4.30 on the test machine - but it does the same thing).

There is a module 'piix.o' that needs to be loaded before I can use DMA at 
all. It's loaded via init scripts - I will try putting it in the initrd.

 D.

