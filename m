From: Thomas Steudten <alpha@steudten.com>
Subject: Re: swap on raid 1
Date: Tue, 14 Oct 2003 16:30:54 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F8C089E.3040205@steudten.com>
References: <2507.146.201.32.254.1066131297.squirrel@english3.fsu.edu> <200310141536.30248.dusty@strike.wu-wien.ac.at>
Reply-To: alpha@steudten.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310141536.30248.dusty@strike.wu-wien.ac.at>
To: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

USB, SCSI, PATA, SATA or whatever, this are buses, and only one device
keeps a line down or high from this bus, every device can=B4t work corr=
ect
any more.
So to be fault resistence, you need two controllers with only one devic=
e
connected to it, or two controllers connected to every one device
(dual channel). So if one controller fails, the device can talk over
the other one. And if the device fails, you can HOPE that it won=B4t
keep the two (SCSI) interfaces in a invalid state.
On the other hand with two controllers, you have only one systemboard o=
r cpu
which can fail too.
With raid you can catch device errors like, bad-blocks, disk error, but
not that the device/ disk keeps the bus.. (HW Error in the interface ci=
rcuit).

Tom

Hermann Himmelbauer wrote:

>=20
> Anyway - what exactly happens when a PATA harddisk dies? Will this on=
ly lead=20
> to logentries in the syslog, or will this crash the machine due to ha=
rdware=20
> reasons? Probably there would also be a difference if you would do RA=
ID on=20
> the same channel (e.g. hda, hdb) as a mulfunction of one device could=
 jam the=20
> whole IDE channel.
>=20
> The same thing can apply to SCSI, too - I once experienced this mysel=
f when a=20
> fautly SCSI-CDROM jammed the whole SCSI-bus and crashed my machine.
>=20
> I hope that SATA will be a lot less critical, it should support hotpl=
ugging=20
> (at least with SATA 1.1, it's a pity that it's not supported with 1.0=
 right=20
> away) and there is only one device per channel.
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
