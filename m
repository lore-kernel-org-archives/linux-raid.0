From: Gregory Leblanc <gleblanc@linuxweasel.com>
Subject: Re: strange performance of raid0
Date: Tue, 17 Feb 2004 09:50:21 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4032545D.4070105@linuxweasel.com>
References: <20040215100432.GA19002@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040215100432.GA19002@rap.rap.dk>
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:

> Hi
>=20
> I have some strange performance results on a raid0
> I have 4 IDE disks on two controllers, the one on the=20
> motherboard of the duron 1 GHz mackine, the other a promise TX2 plus=20
> SATA + PATA controller. I run kernel 2.4.22
>=20
> The disks and hdparm -t on each of them
>=20
> /dev/hdc1 seagate 80 GB                   16 MB/s
> /dev/sda1 maxtor sata 200 GB              50 MB/s
> /dev/sdb7 maxtor 160 GB                   54 MB/s

Well, if you're lucky, these might be useful as comparative numbers=20
between the different drives on the same system.  Just as likely not,=20
though, hdparm rather sucks as a benchmark.

> The partitions are al about 5 GB each.
>=20
> If I make a raid0 device of all of them I get a thruput of 45 MB/s
> IIf I exclude the hdc1 partition, I get around 75 MB/s.
> The system is a little loaded - but that would be normal operating
> conditions. CPU is 90 % idle. I have about 100 MB free RAM.

Let's assume that the above numbers have a basis in reality.  :)  If=20
you've got disks with widely varying speeds, then the best performance=20
can often be hand from setting up a linear RAID volume, rather than a=20
RAID0.  RAID 0 is really designed to have matching disks, as it=20
distributes data evenly across them.  With Linear, and ext2 (erm, I'm=20
assuming 3 as well, I haven't heard anything different), you can=20
sometimes get better performance with smaller writes, because ext2=20
"scatters" data around the filesystem, in order to avoid fragmentation.=
=20
  HTH,
	Greg
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
