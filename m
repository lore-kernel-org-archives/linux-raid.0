From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: Cheap NAS RAID device
Date: Mon, 05 May 2003 00:05:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EB58E94.7040708@hum.auc.dk>
References: <S261785AbTEDVYF/20030504212405Z+2713@vger.kernel.org> <200305041645.19097.nesta@iceburg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200305041645.19097.nesta@iceburg.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brice B wrote:

>  So far I haven't been able to find any 1U NAS turn-key raid solution=
 for
> anything under $2000 for just the chasis! So this thing is going to h=
ave to
> be hacked together, and this is what I've come up with:
>=20
> 1 EPIA MB w/ VIA C3 800mhz Processor (mini ITX)
> A tailored case [ likely out of a tape deck ]

You might take a look at http://www.linitx.com/ . They have a number of=
 cases.

>  Will the performance of a linux software raid level 5 be sufficient =
w/
> the VIA C3 800mhz Processor?

It should be, yes.

>  Will the data be safe under LSR? ie. If a disk dies, will I be warne=
d?

If you set something (mdadm, for instance) up to monitor your raid, yes=
=2E

> When I shutdown & replace the disk, will data remain?

Yes.

>  Am I better off using a 3Ware Escalade or a Promise FastTrax SX4000 =
to
> handle my array?

If you have the cash to burn, HW raid is a bit easier (IMHO) to use. I =
have=20
nothing but praise for 3ware's controllers (well, except for RAID-5 wri=
te=20
performance).

>  Will I have to have a 4th HD to boot off of.. or can I create a cust=
om
> bootable CD that will bring up my system (kernel, raid, apache, nfs,
> samba) ? Or should I boot directly from RAID?

You can boot from RAID1, so you could create a small RAID1 set, to boot=
 off.

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
