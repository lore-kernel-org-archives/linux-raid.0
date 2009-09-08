From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: Adaptec 1430SA
Date: Tue, 8 Sep 2009 11:00:57 -0400
Message-ID: <7d86ddb90909080800n738d7266kb9aa88b222a6459e@mail.gmail.com>
References: <316071.56440.qm@web51305.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <316071.56440.qm@web51305.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@ehardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had bought one of these to use with my Intel D955XBK board and ended
up returning it. I could not get the Adaptec controller BIOS screen to
come up. It kept saying something about not having enough memory. Not
sure why it wasn't compatible as Adpatec adapters are normally good.

I ended up returning and it purchasing a Supermicro AOC-USAS-L8i
adapter which uses the LSI SAS 1068E chip. You can get these cheap off
eBay. The only downside is theses are made for the PCI Express UIO
slot on the Supermicro boards. I didn't realize it at the time, but
the UIO boards have the components mounted on the opposite side. I had
to swap out the PCI bracket so I could secure it in the case and it
takes up the space of two slots. If this isn't a big deal to you then
the card works great.

There are three different firmware modes available from Supermicro for
that card. I have the IT mode firmware which disables the RAID support
of the card. The drives are passed straight through to the OS without
having to configure anything in the card's BIOS. I can even use the
smartmontools to monitor the drives health.

Ryan

On Tue, Sep 8, 2009 at 9:56 AM, Jon Hardcastle<jd_hardcastle@yahoo.com>=
 wrote:
> Does anyone have any experience with Adaptec controllers? Namely
>
> http://www.adaptec.com/en-US/support/sata/sataii/AAR-1430SA/
>
> I want to increase my machines drive capacity and reply the existing =
2 port pci-e with this bad boy.
>
> Also; any ideas of a good price? Have seen for ~=A370 + p&p
>
> -----------------------
> N: Jon Hardcastle
> E: Jon@eHardcastle.com
> 'Do not worry about tomorrow, for tomorrow will bring worries of its =
own.'
> -----------------------
>
>
>
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
