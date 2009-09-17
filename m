From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: recommended 4port SATA controller ?
Date: Thu, 17 Sep 2009 07:57:31 -0700 (PDT)
Message-ID: <671739.32513.qm@web51309.mail.re2.yahoo.com>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
List-Id: linux-raid.ids




--- On Thu, 17/9/09, Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at> =
wrote:

> From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
> Subject: recommended 4port SATA controller ?
> To: linux-raid@vger.kernel.org
> Date: Thursday, 17 September, 2009, 12:44 PM
> hi,
>=20
> I need to move my 4 disk raid5 array from a motherboard
> with 4 onboard SATA ports to a mainboard with just 2 ports.
> therefore I'm looking for a reliable and inexpensive 4port
> PCI controller.
>=20
> the less raid features it has the better since I fear that
> a raid controller may initially write some management
> informationen (signatures etc.) to the disks and therefore
> damage the linux raid5 setup.
>=20
> And, if possible, it should have low power consumption
> since it is about to be used in a small server powered by
> photovoltaic panels.
>=20
> any recommendations aprreciated.
>=20
> thanks and best regards.
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20

Assuming PCI-E

Adaptec 1430SA x4 Port SATA II (300mbps) PCI-E Raid Card *Oem*

http://www.scan.co.uk/Products/Adaptec-1430SA-x4-Port-SATA-II-%28300mbp=
s%29-PCI-E-Raid-Card-Oem

if not then there also a plethora of other cards. Aria also do some VER=
Y cheap PCI 2 port controllers - but I had problems with 2 of these in =
at a time...

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its ow=
n.'
-----------------------


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
