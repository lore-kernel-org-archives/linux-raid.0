From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: strange performance of raid0
Date: Wed, 18 Feb 2004 00:26:41 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040217232640.GD12078@rap.rap.dk>
References: <20040215100432.GA19002@rap.rap.dk> <4032545D.4070105@linuxweasel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4032545D.4070105@linuxweasel.com>
To: Gregory Leblanc <gleblanc@linuxweasel.com>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 17, 2004 at 09:50:21AM -0800, Gregory Leblanc wrote:
> Keld J=F8rn Simonsen wrote:
>=20
> >Hi
> >
> >I have some strange performance results on a raid0
> >I have 4 IDE disks on two controllers, the one on the=20
> >motherboard of the duron 1 GHz mackine, the other a promise TX2 plus=
=20
> >SATA + PATA controller. I run kernel 2.4.22
> >
> >The disks and hdparm -t on each of them
> >
> >/dev/hdc1 seagate 80 GB                   16 MB/s
> >/dev/sda1 maxtor sata 200 GB              50 MB/s
> >/dev/sdb7 maxtor 160 GB                   54 MB/s
>=20
> Well, if you're lucky, these might be useful as comparative numbers=20
> between the different drives on the same system.  Just as likely not,=
=20
> though, hdparm rather sucks as a benchmark.

Yes, I only use them as crude benchmark measuers, but they seem
indicative.

> >The partitions are al about 5 GB each.
> >
> >If I make a raid0 device of all of them I get a thruput of 45 MB/s
> >IIf I exclude the hdc1 partition, I get around 75 MB/s.
> >The system is a little loaded - but that would be normal operating
> >conditions. CPU is 90 % idle. I have about 100 MB free RAM.
>=20
> Let's assume that the above numbers have a basis in reality.  :)  If=20
> you've got disks with widely varying speeds, then the best performanc=
e=20
> can often be hand from setting up a linear RAID volume, rather than a=
=20
> RAID0.  RAID 0 is really designed to have matching disks, as it=20
> distributes data evenly across them.  With Linear, and ext2 (erm, I'm=
=20
> assuming 3 as well, I haven't heard anything different), you can=20
> sometimes get better performance with smaller writes, because ext2=20
> "scatters" data around the filesystem, in order to avoid fragmentatio=
n.=20

Yes, that would be an idea. Anyway I replaced the hdc1 with hda1 on
a seagate 40 GB disk, which hdparm said could do about 40 MB/s,
and then - when I was lucky, I could actually get about 120 MB/s
thruput on a "cat file >/dev/null", 681 MB in 5.63 secs.=20
This on a mildly loaded production system. Not bad!
Then I am beginning to hit the 1 Gbit/s limit on the PCI bus.

Best regards
Keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
