From: Matt Thrailkill <xwred1@modestolan.com>
Subject: Re: strange performance of raid0
Date: Sun, 15 Feb 2004 01:54:11 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1076838850.28006.6.camel@stoneburner.xwredwing.net>
References: <20040215100432.GA19002@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040215100432.GA19002@rap.rap.dk>
To: Keld =?ISO-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The you don't get as good performance because hdc1 is slow enough to
really drag it down.  Think about it, if reads are all going about
sequentially, it has to spend alot of time waiting on that 16mb/s drive
compared to the others.

You probably can't get 100mb/s with the two because that would be prett=
y
efficient, and there's probably more overhead than that.

Shouldn't the 80gb drive be going faster than 16mb/s though?  Have you
checked hdparm to make sure dma and all the goodies are turned on for
it?

On Sun, 2004-02-15 at 02:04, Keld J=F8rn Simonsen wrote:
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
>=20
> The partitions are al about 5 GB each.
>=20
> If I make a raid0 device of all of them I get a thruput of 45 MB/s
> IIf I exclude the hdc1 partition, I get around 75 MB/s.
> The system is a little loaded - but that would be normal operating
> conditions. CPU is 90 % idle. I have about 100 MB free RAM.
>=20
> Why is it slower with 3 disks in the raid0 than
> 2 disks? Why don't I get approx 100 MB/s out of just the two?
>=20
> Best regards
> Keld
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
