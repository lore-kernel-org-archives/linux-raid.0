From: Mike Hardy <mhardy@h3c.com>
Subject: Re: SuSE 9.2 and 3ware 8506 card
Date: Mon, 30 Jan 2006 14:58:03 -0800
Message-ID: <43DE99FB.3010301@h3c.com>
References: <5.1.0.14.2.20060130164019.0ce71eb8@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.0.14.2.20060130164019.0ce71eb8@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Tom Peters <tpeters@mixcom.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


It is possible to run SMART commands through to individual drives on
3ware cards, even if you set the drives up as a hardware RAID array
(making them non-addressable otherwise). I'd read up on 'smartmontools'
(the linux SMART protocol implementation) and get ready to set up smart=
d
to scan the drives at least once a week. I do a short scan once a day
and a full one once a week.

Also, 3ware has their own daemon that exports all array status via a
website if you do a hardware array. You'll need to monitor that somehow
or have it send you mail to make sure you know when the array goes degr=
aded.

tw_cli sounds like a non-web version of that, that could help

That's all focused on reliability though (job #1, imho). Your main
concern seems to be around performance.

The only thing I've seen that looked interesting there on this list had
to do with setting read-ahead parameters at all the different layers -
filesystem, software raid, and block devices. You can find good advice
and some scripts for trying combinations in the archives.

Don't forget hdparm -Tt on a JBOD config to check things at the start
for basic hardware baseline, and bonnie++ at the filesystem level once
you think things are working. That's where I start and end, anyway

Good luck...

-Mike

Tom Peters wrote:
>=20
> Hi, brand new newbie (is that redundant?) here, who soon to be the pr=
oud
> owner of a 3ware 8506-4 RAID card, on its way in the mail. I'm runnin=
g
> an old P3 on SuSE 9.2 and would like to know what to read to get up t=
o
> speed on setting this card up and maintaining it once I do. I'm prett=
y
> new to linux and get a lot of advice that is pitched just slightly ab=
ove
> my level of understanding, so please go slow.
>=20
> I'm currently using a Compaq SmartArray 3200 with 8 drives and I've
> about given up getting any kind of reasonable performance out of it.
> That, plus the outrageous cost of SCSI drives, is the reason for the
> switch to SATA. I can borrow a pair of 300 GB drives for a while to
> prove the concept (the 3ware card wasn't that pricey) and if I can ge=
t
> it to work reasonably well, buy some drives. I think there's some voo=
doo
> in the BIOS of a real Compaq server that makes it work properly; for =
me
> it's a dog and writes unbelievably slow.
>=20
> I've been reading this group for a few weeks and hear some hints and
> intimations about things I should probably learn about. For example,
> someone just mentioned tw_cli maint verify, is that a 3ware thing or =
a
> ext3 thing? And the fact that there is a 3ware knowledgebase (e.g.
> http://www.3ware.com/KB/article.aspx?id=3D13247 should help.
>=20
> So what else do I need to know?
>=20
> -T
>=20
>=20
>=20
>=20
>=20
>=20
> [Philosophy] There is nothing that somebody, somewhere, will not
> consider immoral. --Jan.Six@uku.fi
> --... ...--  -.. .  -. ----. --.- --.- -...
> tpeters@nospam.mixcom.com   (remove "nospam") N9QQB (amateur radio)
> "HEY YOU" (loud shouting)  WEB ADDRESS http//www.mixweb.com/tpeters
> 43=B0 7' 17.2" N by 88=B0 6' 28.9" W,  Elevation 815',  Grid Square E=
N53wc
> WAN/LAN/Telcom Analyst, Tech Writer, MCP, CCNA, Registered Linux User
> 385531
>=20
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
