From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Mixed controllers on JBOD Raid 6?
Date: Wed, 1 Jul 2015 14:06:51 -0500
Message-ID: <CAAMCDefAchqyfykTkqnMs7GXpBovnUQ8Sb7y5rb=j_QVy9O8kA@mail.gmail.com>
References: <CAOS+5GFJQ10z-VV=06ncxh+wb=ycq9HrHJfJD++y8z8qGnoOrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GFJQ10z-VV=06ncxh+wb=ycq9HrHJfJD++y8z8qGnoOrw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have done it several times.

The only concern is that some of the non-intel and non-amd supplied
cheaper SATA chipset are crap, so carefully read about any issues
around the 2nd controller.

I have an Gigabyte FM2 board (8 build-in AMD supplied SATA ports) + 4
PCI Sil SATA ports (slow but stable).

I had serious issues with a marvell supplied PCIE controller (crashed
on some IO + smartctl commands).    A VIA chipset (ASUS build-into MB
vintage 2006) that would crash under heavy usage.    And read a number
of issues around other PCIE cards enough to make me stay away of the
cheap( add-on card/add-on MB ports).

On Wed, Jul 1, 2015 at 1:27 PM, Another Sillyname
<anothersname@googlemail.com> wrote:
> I'm looking at an Asus Maximus Vii Gene motherboard which has 8 SATA
> controller connectors.....6 Intel and 2 other (can't remember at the
> moment).
>
> Are there any projected issues or concerns about making a 8 Drive
> RAID6 array where I'm using mixed controllers?
>
> TIA
>
> Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
