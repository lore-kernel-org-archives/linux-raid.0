From: "Majed B." <majedb@gmail.com>
Subject: Re: Port Multipliers
Date: Thu, 10 Sep 2009 19:11:14 +0300
Message-ID: <70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If you're looking at port multipliers, you need to find PCI-Express
modules if you want them to be fast. The PCI ones are gonna be very
slow when you have more than 2 disks per card.

An alternative would be buying server motherboards that have 10+
ports. I found a few on newegg before. Here're some:
http://www.newegg.com/Product/Product.aspx?Item=3DN82E16813131287
http://www.newegg.com/Product/Product.aspx?Item=3DN82E16813131239

They have 6 SATA & 8 SAS (SATA disks work on SAS ports, but SAS disks
don't work on SATA ports) 3 PCI-E ports! (If you get a 4-port PCI-e
card, then you get 12 ports in addition to the built-in 14).

You might want to checkout Supermicro's offerings as well.

I hope this helps.

On Thu, Sep 10, 2009 at 3:56 PM, Drew<drew.kay@gmail.com> wrote:
> Hi,
>
> I've been reading up on port multipliers and I was wondering if
> anyone's had any experience with them they'd like to share. From what
> I've read of them I would expect the performance to be slower but how
> much slower are they in the real world?
>
> I ask because I'm exploring options for my organization and we're
> looking at some large JBOD enclosures that can handle up to 15 SATA
> drives and I'm trying to minimize performance impact on the drives
> while at the same time minimize the amount of cabling between the
> openfiler and the enclosure. The server using the enclosure will be
> running openfiler as a backend iSCSI target(?) for a couple of VMware
> ESXi hosts and while the hosts won't be running anything heavy duty,
> mainly just filesharing & email, I'm hoping to keep things running as
> fast as possible.
>
>
> --
> Drew
>
> "Nothing in life is to be feared. It is only to be understood."
> --Marie Curie
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
