From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: strange performance of raid0
Date: Sun, 15 Feb 2004 13:05:25 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040215120525.GA19434@rap.rap.dk>
References: <20040215100432.GA19002@rap.rap.dk> <1076838850.28006.6.camel@stoneburner.xwredwing.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1076838850.28006.6.camel@stoneburner.xwredwing.net>
To: Matt Thrailkill <xwred1@modestolan.com>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 15, 2004 at 01:54:11AM -0800, Matt Thrailkill wrote:
> The you don't get as good performance because hdc1 is slow enough to
> really drag it down.  Think about it, if reads are all going about
> sequentially, it has to spend alot of time waiting on that 16mb/s dri=
ve
> compared to the others.

I would have thought the disks would have worked towards gaining
performance enhancements in some cumulative way, is that not so, in the=
ory?

So why is 3 disks slower than 2?

> You probably can't get 100mb/s with the two because that would be pre=
tty
> efficient, and there's probably more overhead than that.
>=20
> Shouldn't the 80gb drive be going faster than 16mb/s though?  Have yo=
u
> checked hdparm to make sure dma and all the goodies are turned on for
> it?

I have a 40 GB segate disk also, on the same motherboard IDE
controller, it runs about 40 MB/s. So yes, the hdc1
should go faster, and I have measured something like 40 MB/s
on it in idler times. I think it is because it is running other=20
processes. The machine is a ftp mirror and the disk has RedHat
and Fedora ISO images, so it is quite popular.

> On Sun, 2004-02-15 at 02:04, Keld J=F8rn Simonsen wrote:
> > Hi
> >=20
> > I have some strange performance results on a raid0
> > I have 4 IDE disks on two controllers, the one on the=20
> > motherboard of the duron 1 GHz mackine, the other a promise TX2 plu=
s=20
> > SATA + PATA controller. I run kernel 2.4.22
> >=20
> > The disks and hdparm -t on each of them
> >=20
> > /dev/hdc1 seagate 80 GB                   16 MB/s
> > /dev/sda1 maxtor sata 200 GB              50 MB/s
> > /dev/sdb7 maxtor 160 GB                   54 MB/s
> >=20
> > The partitions are al about 5 GB each.
> >=20
> > If I make a raid0 device of all of them I get a thruput of 45 MB/s
> > IIf I exclude the hdc1 partition, I get around 75 MB/s.
> > The system is a little loaded - but that would be normal operating
> > conditions. CPU is 90 % idle. I have about 100 MB free RAM.
> >=20
> > Why is it slower with 3 disks in the raid0 than
> > 2 disks? Why don't I get approx 100 MB/s out of just the two?
> >=20
> > Best regards
> > Keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
