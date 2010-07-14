From: Jim Paris <jim@jtan.com>
Subject: Re: mapping ataXX.YY to a /dev/sdX
Date: Wed, 14 Jul 2010 15:05:41 -0400
Message-ID: <20100714190541.GA27855@psychosis.jim.sh>
References: <alpine.DEB.1.10.1007081214590.23489@uplift.swm.pp.se>
 <20100708104422.GA32564@cthulhu.home.robinhill.me.uk>
 <alpine.DEB.1.10.1007081259560.23489@uplift.swm.pp.se>
 <20100708232631.014a5ade@atak.bl.pg.gda.pl>
 <alpine.DEB.1.10.1007082348190.23489@uplift.swm.pp.se>
 <4C37FA32.8020008@wasp.net.au>
 <4C381BC4.9040903@grumpydevil.homelinux.org>
 <4C38C8BD.4050604@garzik.org>
 <4C390703.80703@grumpydevil.homelinux.org>
 <AANLkTiluwfd9LTH7Tb0J9N3NBvp1FbZdoJYUYj1g8BJz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTiluwfd9LTH7Tb0J9N3NBvp1FbZdoJYUYj1g8BJz@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
Cc: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Jeff Garzik <jeff@garzik.org>, Brad Campbell <brad@wasp.net.au>, Mikael Abrahamsson <swmike@swm.pp.se>, Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

J=E9r=F4me Poulin wrote:
> On Sat, Jul 10, 2010 at 7:49 PM, Rudy Zijlstra
> <rudy@grumpydevil.homelinux.org> wrote:
> > Jeff Garzik wrote:
> >>
> >> On 07/10/2010 03:05 AM, Rudy Zijlstra wrote:
> >>>
> >>> Judging from my dmesg and lsscsi on a system with both scsi and S=
ATA,
> >>> ataX translates into scsi X:0:0:0
> >>
> >>
> >> There is no translation.
> >>
> >> It is random, based on driver load order.
> >
> > This then begs the question whether it can be dependingly derived f=
rom dmesg
> > messages. Like messages
> >
> > [ =A0 =A02.268315] ata7.00: configured for UDMA/133
> > [ =A0 =A02.277452] scsi 7:0:0:0: Direct-Access =A0 =A0 ATA =A0 =A0 =
=A0WDC WD7500AAKS-0
> > 30.0 PQ: 0 ANSI: 5
> >
> > always following each other, thus making identification possible.
>
> I find it rather confusing in my log, and there are situation when yo=
u
> hotplug the disk which does not make it show up right after the ataX
> line, also if the logs overflow, then you can't know anyway. (I know
> there's syslog too)
>=20
> There doesn't seem to be any mapping in /sys I though lshw would show
> it but it isn't.

=46or a scsi_host driven by libata, the number in /sys/class/scsi_host/=
host?/unique_id
should match the ataX value.  You can check /sys/class/scsi_host/host?/=
proc_name
to see the driver for a particular scsi_host.

-jim
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
