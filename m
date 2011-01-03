From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: [Slightly OT] Cheap 4-port PCI-E SATA card?
Date: Mon, 03 Jan 2011 16:18:10 -0600
Message-ID: <4D224B22.6070007@hardwarefreak.com>
References: <4D20E9F7.2080800@anonymous.org.uk> <4D216FA1.5010502@hardwarefreak.com> <4D21F2BB.3020905@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D21F2BB.3020905@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson put forth on 1/3/2011 10:00 AM:
> On 03/01/2011 06:41, Stan Hoeppner wrote:

>> http://www.addonics.com/products/host_controller/ad5sapm.asp
>> http://www.buy.com/prod/addonics-ad5sapm-serial-ata-controller-5-x-7=
-pin-serial-ata-300-serial/q/loc/101/213272437.html

>> If your mobo SATA ports support FIS based switching, this PMP will g=
ive
>> you 5 SATA II drive ports.  It doesn't use a PCI slot of any kind.  =
No
>> additional software required.  No kernel driver issues.  300MB/s is
>> sufficient for 5 drives in an mdraid setup isn't it?

> For a backup array, yes, but I'm not sure it is for online storage.
> 300MB/s is an absolute max and there's protocol overhead etc, but eve=
n
> if it's minimal we're still looking at no better than 50MB/s per driv=
e,
> while the drives can manage 125MB/s these days.

When using PMPs one will always have less theoretical b/w per drive tha=
n
what that drive can push on paper with a streaming read.  Considering
that over 90% of real world workloads are random IO heavy, not
streaming, it's unlikely you'll ever run out of b/w using a PMP based
setup.  I haven't.

Also, as has been pointed out, you will be limited by PCIe x1 2.0 b/w
before you are limited by qty 2 SATA II ports:  500 MB/s for PCIe x1
rev2.0 versus 600MB/s for 2xSATA II links.  This is true whether you us=
e
a 4 port PCIe rev 2.0 card with 4 direct attached SATA II drives or 10
drives with 2 PMPs.  You only have one PCIe slot.  To get more
bandwidth, you'll have to use an x4 or x8 card, which is way above your
stated price range.

> I doubt my motherboard supports FIS PMPs. It's an Asus P5Q Pro, Intel
> P45+ICH10R, and I'm pretty sure the ICH10R doesn't support PMPs even =
if
> the original spec said it would.

I just looked it up, and the ICH10R does _NOT_ support PMP.  Neither
does the onboard Silicon Image 5723 chip, which actually connects to th=
e
southbridge via a SATA II port (stupid).

BTW, the P5Q Pro has 3 PCIe x1 slots and 2 PCIe x16/x8 slots, plus 2 PC=
I
slots.  You told us the only slot you have available is 1 PCIe x16/x8.
What is consuming the 3 PCIe x1 slots?  The PCIe x1 slot just North of
the top x16 slot should be free.  I'm guessing the other 2 are blocked
by your GPU cooler, correct?

Picture:
http://www.asus.com/product.aspx?P_ID=3DqH6ZSEJ8EPY6HoNU&templete=3D2

Move your GPU card to the bottom x16 slot and you free up all 3 x1
slots.  This gives you a lot more options to get the solution you want
inexpensively.

> There is a Marvell 88SE6121 SATA+IDE chip on there but it's currently=
 in
> IDE-only mode for the DVD drive and even if I switched over to SATA m=
ode
> and a SATA DVD drive that'd only give me one more SATA port. But it
> might work with a FIS PMP, I suppose.

Originally I was going to propose a $20 Sil 3132 based 2 port card for
use with 2 of the Addonics PMPs, but all those I could find are PCIe re=
v
1 only, for only 250MB/s of b/w.  All of the SI SATA host controller
chips work perfectly with Silicon Image PMPs (3276 chip) and the kernel
drivers have no issues.  If you had two PCIe x1 slots available, using
two such cards with one PMP plugged into each would work very well
indeed.  This is what I do.  Your b/w would max at 500MB/s, but again,
this is more than sufficient for the vast majority of workloads.  Keep
in mind that this bandwidth is bidirectional, so you actually have 1GB/=
s
of throughput with reads and writes in flight simultaneously with
multi-user or multi-threaded workloads, especially with a deep NCQ buff=
er.

> I'd do that too - no problems doing case mods here. I suppose it's
> possible the mounting holes might be able to be made to line up with
> some of the mounting holes on the side of the hot-swap chassis. On th=
e
> other hand I might cheat and use the little plastic mounts with
> double-sided tape on their feet.

Yeah, there are lots of possibilities for mounting these handy little
PMPs.  I've seen folks just put that really thick double sided foam tap=
e
on the back side and stick them to an open spot on the bottom or side o=
f
the chassis.

> [...]
>>   The driver for the Marvell chip is present in kernel
>> 2.6.19 and later.  Considering that 2.6.19 is like 6 years old, I'd =
hope
>> your kernel is newer.
>=20
> It's kernel-2.6.18-194.26.1.el5 so it's stuffed full of backports and
> security updates, it's less than two months old. Yes, I have sata_mv,
> but several people have reported data corruption issues with some
> Marvell controllers - a bad interaction with SMART I think.

I recommended the Marvell based card strictly because it does PCIe x1
rev 2 for 500MB/s.  I only use the Silicon Image based cards, but I use
more than one if I have more than 4 drives in an array.  The cost comes
out the same at $40 as the Marvell card, but the SI route requires 2
PCIe slots, and you only have one.

>> It may be a little more money than you were planning on spending, bu=
t
>> for little more than the cost of one hard drive
>=20
> In this case I'm using consumer-level drives so they're about =C2=A34=
0 ($60),
> so $165 is a bit rich for me, especially since it's potentially limit=
ed
> for throughput.

Well, you've given us conflicting requirements that are impossible to
meet with any solution:

1.  Low cost
2.  Full b/w per drive
3.  Only one PCIe slot availiable

There is not a solution available to meet all of your criteria.  Either
you must spend more on the card to get all the SATA ports and b/w you
want, or you have to go the PMP route to lower costs, and sacrifice som=
e
theoretical performance.

Below is probably the closest you will get to what you want but the
price is higher than what you've said you want to spend.  It'll give yo=
u
8 direct attach SAS/SATA II ports with a PCIe x4 interface:

http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816115057
$149

But you'll have to buy 2 fanout cables:
http://www.satacables.com/sata_multilane_SAS_cables.html
=46AN-OUT-20INCH4X
Which run $20 apiece, $40 total.  So you're up to just under $200.

Your most cost effective option for adding a 5 drive cage, by far, is
this:  http://www.newegg.com/Product/Product.aspx?Item=3DN82E1681612403=
2

But it's only PCIe x1 at 250MB/s.

> Nevertheless, thank you very much for taking the time for such a
> considered reply.

You're welcome.  I think you're finding yourself in that "I want to hav=
e
my cake, but eat it too" situation.  You can't get what you want at the
price point you want.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
