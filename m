From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: RAID5 software general crash
Date: Wed, 04 Jun 2003 10:15:37 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EDDAAA9.6010203@hum.auc.dk>
References: <3EDDA693.1D6D2AF2@cdc.u-cergy.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EDDA693.1D6D2AF2@cdc.u-cergy.fr>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Compte centre de calcul UCP wrote:
> Hi,
>=20
> I'm newbie in RAID5 Software.
> I need some help (direct answer on the list or links) to understand a=
nd
> repair my NFS server turning with RAID5 software.

[snip]

> Sunday morning there was a crash. I don't now what happened exactly
> until now, but the raid stopped.

[snip]

> sde1's event counter: 0000003f
> sdd1's event counter: 0000003c
> sdc1's event counter: 0000003c
> sdb1's event counter: 0000003c
> sda1's event counter: 0000003c
> md: superblock update time inconsistency -- using the most recent one
> freshest: sde1

Your superblocks are not in sync. See item 6.1 "Recovery from a multipl=
e=20
disk failure" in the Linux Software RAID howto.
If you set /dev/sde1 as failed-disk instead of raid-disk in you=20
/etc/raidtab, and do a mkraid on the array, hotadd /dev/sde1 to the arr=
ay=20
and set /dev/sde1 back to raid-disk, you should be back in business.

--=20
Mads Peter Bach
Systemadministrator,  Det Humanistiske Fakultet, Aalborg Universitet
Kroghstr=E6de 3 - 5.111, DK-9220 Aalborg =D8st - (+45) 96358062
# whois MPB1-DK@whois.dk-hostmaster.dk

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
