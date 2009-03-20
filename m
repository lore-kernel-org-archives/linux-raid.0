From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: What hardware for RAID5? (PCIe controller or fast onboard)
Date: Fri, 20 Mar 2009 09:28:51 -0400
Message-ID: <7d86ddb90903200628k23e10c3cqd53e4c719ea4467e@mail.gmail.com>
References: <200903181833.39469.Dexter.Filmore@gmx.de>
	 <873adak6gt.fsf@frosties.localdomain> <49C16362.40006@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49C16362.40006@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am using an LSI 1068 SAS PCIe controller. I have 7 drives connected
and am getting excellent performance. Depending on the layout of the
case you can pickup a Supermicro version for less than $100. The issue
is the components are mounted on the reverse side for the Supermicro
UIO slot, so it takes up two bracket slots on a normal PCIe slot.

Ryan

On Wed, Mar 18, 2009 at 5:10 PM, Eyal Lebedinsky <eyal@eyal.emu.id.au> =
wrote:
> A word of caution. 6 on-board SATA is not always enough. It is often =
the
> case
> that using all will hit internal bandwidth limits. I find it common f=
or 4
> disks
> to be handled OK but 5 are too much.
>
> A simple test of 5 concurrent dd's will tell you if all disks are goi=
ng full
> speed.
> Some time one combination of 5 out of 6 (or 8) on-board sockets will =
perform
> better
> than other and it is worth checking.
>
> Eyal
>
> Goswin von Brederlow wrote:
>>
>> Dexter Filmore <Dexter.Filmore@gmx.de> writes:
>>
>>> I want to upgrade server hardware here, currently I have 5 Samsungs=
 (sATA
>>> II) sitting on the onboard controller of an Asus K8N-E Socket754 bo=
ard.
>>> I guess the controller chips are both connected via PCI hence perfo=
rmance
>>> isn't really hot.
>>>
>>> Basically I need either a board with at least 6x sATA-II attached v=
ia
>>> PCIe or a "dumb" PCIe 4x or 8x controller card.
>>>
>>> Any recommendations?
>>>
>>> Dex
>>
>> Anything that is not pci. PCIe or PCI-X will both be way
>> faster. Server boards with 6x SATA-II onboard are hard to miss. And
>> any cheap PCIe/PCI-X controler will probably do.
>>
>> One important thing to think about is hotplug support. Do you need i=
t
>> or not?
>>
>> Look for a board and then check out http://linux-ata.org/ for suppor=
t.
>>
>> MfG
>> =A0 =A0 =A0 =A0Goswin
>
> --
> Eyal Lebedinsky (eyal@eyal.emu.id.au)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
