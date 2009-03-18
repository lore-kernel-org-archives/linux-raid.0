From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: What hardware for RAID5? (PCIe controller or fast onboard)
Date: Thu, 19 Mar 2009 08:10:58 +1100
Message-ID: <49C16362.40006@eyal.emu.id.au>
References: <200903181833.39469.Dexter.Filmore@gmx.de> <873adak6gt.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <873adak6gt.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A word of caution. 6 on-board SATA is not always enough. It is often the case
that using all will hit internal bandwidth limits. I find it common for 4 disks
to be handled OK but 5 are too much.

A simple test of 5 concurrent dd's will tell you if all disks are going full speed.
Some time one combination of 5 out of 6 (or 8) on-board sockets will perform better
than other and it is worth checking.

Eyal

Goswin von Brederlow wrote:
> Dexter Filmore <Dexter.Filmore@gmx.de> writes:
> 
>> I want to upgrade server hardware here, currently I have 5 Samsungs (sATA II) 
>> sitting on the onboard controller of an Asus K8N-E Socket754 board.
>> I guess the controller chips are both connected via PCI hence performance 
>> isn't really hot.
>>
>> Basically I need either a board with at least 6x sATA-II attached via PCIe or 
>> a "dumb" PCIe 4x or 8x controller card.
>>
>> Any recommendations?
>>
>> Dex
> 
> Anything that is not pci. PCIe or PCI-X will both be way
> faster. Server boards with 6x SATA-II onboard are hard to miss. And
> any cheap PCIe/PCI-X controler will probably do.
> 
> One important thing to think about is hotplug support. Do you need it
> or not?
> 
> Look for a board and then check out http://linux-ata.org/ for support.
> 
> MfG
>         Goswin

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
