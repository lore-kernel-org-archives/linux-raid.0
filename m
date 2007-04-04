From: Ric Wheeler <ric@emc.com>
Subject: Re: parity check for read?
Date: Wed, 04 Apr 2007 09:35:32 -0400
Message-ID: <4613A9A4.1060800@emc.com>
References: <461254DF.3050503@web.de> <17938.49705.840745.66635@notabene.brown> <46138C06.5020903@web.de>
Reply-To: ric@emc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46138C06.5020903@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mirko Benz <mirko.benz@web.de>
Cc: Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Mirko Benz wrote:
> Neil,
>=20
> Exactly what I had in mind.
>=20
> Some vendors claim they do parity checking for reads. Technically it=20
> should be possible for Linux RAID as well but is not implemented =96 =
correct?
>=20
> Reliability data for unrecoverable read errors:
> - enterprise SAS drive (ST3300655SS): 1 in 10^16 bits transfered, ~ 1=
=20
> error in 1,1 PB
> - enterprise SATA drive (ST3500630NS): 1 in 10^14 bits transfered, ~ =
1=20
> error in 11 TB
>=20
> For a single SATA drive @ 50 MB/s it take on average 2,7 days to=20
> encounter an error.
> For a large RAID with several drives this becomes much lower or am I=20
> viewing this wrong?
>=20
> Regards,
> Mirko

One note is that if the drive itself notices the unrecoverable read err=
or, MD=20
will see this as an IO error and rebuild the stripe.

What you need the parity check on read for is to validate errors not at=
 the disk=20
sector level, but rather ones that sneak in from DRAM, HBA errors or wi=
re level=20
uncorrected errors.

ric
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
