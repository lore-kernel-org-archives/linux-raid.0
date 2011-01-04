From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: [Slightly OT] Cheap 4-port PCI-E SATA card?
Date: Tue, 04 Jan 2011 14:03:36 +0000
Message-ID: <4D2328B8.4070608@anonymous.org.uk>
References: <4D20E9F7.2080800@anonymous.org.uk> <4D216FA1.5010502@hardwarefreak.com> <4D21F2BB.3020905@anonymous.org.uk> <4D224B22.6070007@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D224B22.6070007@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/01/2011 22:18, Stan Hoeppner wrote:
> John Robinson put forth on 1/3/2011 10:00 AM:
>> On 03/01/2011 06:41, Stan Hoeppner wrote:
[...]
> When using PMPs one will always have less theoretical b/w per drive t=
han
> what that drive can push on paper with a streaming read.  Considering
> that over 90% of real world workloads are random IO heavy, not
> streaming, it's unlikely you'll ever run out of b/w using a PMP based
> setup.  I haven't.

That's probably true but I don't like making compromises if I can=20
possibly avoid it :-)

>> I doubt my motherboard supports FIS PMPs. It's an Asus P5Q Pro, Inte=
l
>> P45+ICH10R, and I'm pretty sure the ICH10R doesn't support PMPs even=
 if
>> the original spec said it would.
>
> I just looked it up, and the ICH10R does _NOT_ support PMP.  Neither
> does the onboard Silicon Image 5723 chip, which actually connects to =
the
> southbridge via a SATA II port (stupid).

Must be connected to the Marvell 88SE6111's SATA port. Well, the spec=20
says 88SE6111 but my lspci shows an 88SE6121. The 88SE6121 ought to hav=
e=20
two SATA ports, but I've found odd behaviour with the two non-ICH10R=20
ports on the board when testing - basically if I use the second port bu=
t=20
not the first port, nothing appears, even with Asus' Drive Xpert=20
disabled. This is presumably the SilI 5723's contribution, hanging off=20
the Marvell chip's SATA port, and clearly no use for RAID where a drive=
=20
might die but we want to carry on, so I'll be ignoring the on-board=20
Marvell/SilI stuff.

> BTW, the P5Q Pro has 3 PCIe x1 slots and 2 PCIe x16/x8 slots, plus 2 =
PCI
> slots.  You told us the only slot you have available is 1 PCIe x16/x8=
=2E
> What is consuming the 3 PCIe x1 slots?  The PCIe x1 slot just North o=
f
> the top x16 slot should be free.  I'm guessing the other 2 are blocke=
d
> by your GPU cooler, correct?

Ah, I'm sorry, no I didn't say I only the PCIe x16/x8 slot available, o=
r=20
at least that's not what I meant. I do need PCIe because both PCI slots=
=20
are taken, but I do have all three PCIe x1 slots and one PCIe x8/x16=20
slot available. The graphics card is only single thickness and could=20
indeed be moved.

I know I could easily put two $30 2-port cards in, but for neatness I'd=
=20
prefer one card with 4 ports, which is what I started this thread to=20
look for. One 2-port card and a PMP is a reasonable solution that I=20
might yet go for.

NB My PCI slots are occupied by a TV tuner card and a SCSI card which=20
serves my tape library, and in any case I want to avoid the limitation=20
of the PCI bus which would have half the bandwidth of one PCIe x1 v1=20
slot even if it wasn't sharing with two other highish-bandwidth devices=
=2E

[...]
> I recommended the Marvell based card strictly because it does PCIe x1
> rev 2 for 500MB/s.  I only use the Silicon Image based cards, but I u=
se
> more than one if I have more than 4 drives in an array.  The cost com=
es
> out the same at $40 as the Marvell card, but the SI route requires 2
> PCIe slots, and you only have one.

As noted I do have more PCIe slots, and I've just found a Lycom PE-115=20
PCIe x1 2-port SATA-III card for =C2=A320, which some third-party sites=
 say=20
has a Marvell 88SE912x chip, and is PCIe v2.0, so that'd be my=20
multi-card solution - two of them would give me the 4 ports I need to a=
dd.

[...]
> Well, you've given us conflicting requirements that are impossible to
> meet with any solution:
>
> 1.  Low cost
> 2.  Full b/w per drive
> 3.  Only one PCIe slot availiable
>
> There is not a solution available to meet all of your criteria.

My own research had got me that far, that's why I was asking here. If=20
this is unreasonable, please excuse the noise...

>> Nevertheless, thank you very much for taking the time for such a
>> considered reply.
>
> You're welcome.  I think you're finding yourself in that "I want to h=
ave
> my cake, but eat it too" situation.  You can't get what you want at t=
he
> price point you want.

Don't we all want to have our cake and eat it sometimes? ;-)

Thanks again for your thoughts.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
