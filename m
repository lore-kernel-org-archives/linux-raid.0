From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: Disks keep disapearing
Date: Sat, 10 May 2003 19:01:38 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EBD3072.4090205@hum.auc.dk>
References: <Pine.GSO.4.30.0305091654350.23888-100000@multivac.sdsc.edu> <3EBD2D2C.1050900@visiarc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EBD2D2C.1050900@visiarc.com>
To: =?ISO-8859-1?Q?Johan_Sch=F6n?= <johan.schon@visiarc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Johan Sch=F6n wrote:

> The disk itself doesn't appear to know about any failures
> (using smartctl), and it works again when hotadded to the raidset. I'=
ve
> also had a multiple drive "failure" twice, both times with two drives
> using the same IDE channel.

Using more than one drive on an IDE channel is considered risky by many=
=2E If a=20
drive fails, it's likely to bring down the entire channel.
In any case, don't put more than one drive of an array on the same chan=
nel.

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
