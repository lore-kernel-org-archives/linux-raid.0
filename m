From: "Robin Bowes" <robin-lists@robinbowes.com>
Subject: Re: Multi-channel ATA controller cards
Date: Mon, 10 May 2004 22:24:48 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2089.192.168.1.2.1084224288.squirrel@192.168.1.2>
References: <S263851AbUEHXGM/20040508230612Z+21001@vger.kernel.org>
    <11d001c43584$438fcfb0$cf01a8c0@internal.kbs.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11d001c43584$438fcfb0$cf01a8c0@internal.kbs.net.au>
To: linux-raid@vger.kernel.org
Cc: Paul <paul@kbs.net.au>, Mark Hahn <hahn@physics.mcmaster.ca>
List-Id: linux-raid.ids

On Sun, May 9, 2004 6:11, Paul said:
>
> The best cost effective given speed and storage size is promise fast =
track
> tx4 and 250gb sata disks.
> Use one or two controllers and have upto 1terrabyte. Then you can str=
ipe,
> span or jbod them.
> 2.4.26 with 2.4.27-pre1 patch update and libata patch works awesome. =
we
> have
> it running on several test boxes.
> fast and economical solution. ata is old technology. cost of ata vs s=
ata
> isn't much, $20 per controller or disk difference.

Then, on Sun, May 9, 2004 6:12, Paul said:
>
> I've got an adaptec 1200 at home with 4 x 120GB raid5 and I find it s=
low
> and disk access is hampered.
> They're all segate 8mb cache drives. The controller has a 128mb ecc r=
am
> chip also. Go for sata

And a little later, on Sun, May 9, 2004 6:49, Mark Hahn said:
>> I'm putting together a (relatively) large capacity Raid 5 storage
>> solution
>
> large raid with pata is often a cabling nightmare.  I wouldn't consid=
er
> going larger than 6-8 disks without a custom case (and I'd call 8x250=
G
> pretty small-medium today.)
>
>> drives. I've been looking into various controller options, both PATA=
 and
>> SATA, and have decided that PATA will give me best price/capacity.
>
> why?  I prefer 4-port promise sata controllers ($60).  disk prices ar=
e
> not much different per GB.
>
>> So far, the most likely candidate (on a cost basis) is the Acard
>> AEC6885S
>> (http://www.acard.com/eng/product/adapter/pc/ide/aec-6885.html) whic=
h is
>> a
>
> ugh, choosing a non-mainstream card is usually a mistake.
>
>> Finally, does anyone know of any other 4-channel (or 6-channel) ATA
>> controllers that would be worth my checking out?
>
> 3ware is the natural conservative choice

Thanks for these replies guys.

The reason I was considering the PATA controller was cost - both of the
controller and the disks. I have since found the Promise SATA150 TX4 fo=
r
less than the ACard controller. The SATA version of the Maxtor MaxLine =
II
Plus 250GB drive is =A3146.88 compared to =A3134.76 for the PATA versio=
n. For
a six-disk system, that's a premium of =A372.12 for SATA over PATA.

I think I'll be going the SATA route.

Next job, work out how to install it all - but that's a separate topic!

R.
--=20
http://robinbowes.com

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
