From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 5 performance issue.
Date: Fri, 5 Oct 2007 10:07:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710051006370.21185@p34.internal.lan>
References: <20071003105321.06943824@zeus.pccl.info>
 <Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
 <20071003211910.439ded54@alpha.digital-domain.net>
 <72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
 <20071004150831.6edbf926@zeus.pccl.info> <Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>
 <Pine.LNX.4.64.0710041009530.8275@p34.internal.lan> <20071004154441.31addcfe@zeus.pccl.info>
 <Pine.LNX.4.64.0710041219240.25506@p34.internal.lan>
 <20071004192653.25eb333b@alpha.digital-domain.net>
 <Pine.LNX.4.64.0710050621350.8433@p34.internal.lan> <20071005115719.4a71ab89@zeus.pccl.info>
 <Pine.LNX.4.64.0710050707490.8433@p34.internal.lan> <20071005135312.04856211@zeus.pccl.info>
 <20071005143023.2bce96e9@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-524429598-1191593267=:21185"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071005143023.2bce96e9@zeus.pccl.info>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Clayton <andrew@pccl.info>
Cc: Andrew Clayton <andrew@digital-domain.net>, David Rees <drees76@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-524429598-1191593267=:21185
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Fri, 5 Oct 2007, Andrew Clayton wrote:

> On Fri, 5 Oct 2007 13:53:12 +0100, Andrew Clayton wrote:
>
>
>> Unfortunately problem remains.
>>
>> I'll try the noop scheduler as I don't think I ever tried that one.
>
> Didn't help either, oh well.
>
> If I hit the disk in workstation with a big dd then in iostat I see it
> maxing out at about 40MB/sec with > 1 second await. The server seems to
> hit this with a much lower rate, < 10MB/sec maybe
>
> I think I'm going to also move the raid disks back onto the onboard
> controller (as Goswin von Brederlow said it should have more bandwidth
> anyway) as the PCI card doesn't seem to have helped and I'm seeing soft
> SATA resets coming from it.
>
> e.g
>
> ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata6.00: irq_stat 0x00020002, device error via D2H FIS
> ata6.00: cmd 35/00:00:07:4a:d9/00:04:02:00:00/e0 tag 0 cdb 0x0 data 52428=
8 out
>         res 51/84:00:06:4e:d9/00:00:02:00:00/e2 Emask 0x10 (ATA bus error=
)
> ata6: soft resetting port
> ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata6.00: configured for UDMA/100
> ata6: EH complete
>
>
> Just to confirm, I was seeing the problem with the on board controller
> and thought moving the disks to the PCI card might help (at =A335 it was
> worth a shot!)
>
> Cheers,
>
> Andrew
>

Yikes, yeah I would get them off the PCI card, what kind of motherboard is=
=20
it?  If you don't have a PCI-e based board it probably won't help THAT=20
much but it still should be better than placing 3 drives on a PCI card.

Justin.
---1463747160-524429598-1191593267=:21185--
