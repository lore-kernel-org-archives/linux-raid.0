From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: What hardware for RAID5? (PCIe controller or fast onboard)
Date: Wed, 18 Mar 2009 19:53:54 +0100
Message-ID: <873adak6gt.fsf@frosties.localdomain>
References: <200903181833.39469.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200903181833.39469.Dexter.Filmore@gmx.de> (Dexter Filmore's
	message of "Wed, 18 Mar 2009 18:33:39 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dexter Filmore <Dexter.Filmore@gmx.de> writes:

> I want to upgrade server hardware here, currently I have 5 Samsungs (sATA II) 
> sitting on the onboard controller of an Asus K8N-E Socket754 board.
> I guess the controller chips are both connected via PCI hence performance 
> isn't really hot.
>
> Basically I need either a board with at least 6x sATA-II attached via PCIe or 
> a "dumb" PCIe 4x or 8x controller card.
>
> Any recommendations?
>
> Dex

Anything that is not pci. PCIe or PCI-X will both be way
faster. Server boards with 6x SATA-II onboard are hard to miss. And
any cheap PCIe/PCI-X controler will probably do.

One important thing to think about is hotplug support. Do you need it
or not?

Look for a board and then check out http://linux-ata.org/ for support.

MfG
        Goswin
