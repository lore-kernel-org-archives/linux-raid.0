From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: strange performance of raid0
Date: Sun, 15 Feb 2004 17:48:10 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040215164810.GA20252@rap.rap.dk>
References: <20040215100432.GA19002@rap.rap.dk> <1076838850.28006.6.camel@stoneburner.xwredwing.net> <20040215120525.GA19434@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040215120525.GA19434@rap.rap.dk>
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: Matt Thrailkill <xwred1@modestolan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 15, 2004 at 01:05:25PM +0100, Keld J=F8rn Simonsen wrote:
> On Sun, Feb 15, 2004 at 01:54:11AM -0800, Matt Thrailkill wrote:
> > The you don't get as good performance because hdc1 is slow enough t=
o
> > really drag it down.  Think about it, if reads are all going about
> > sequentially, it has to spend alot of time waiting on that 16mb/s d=
rive
> > compared to the others.
>=20
> I would have thought the disks would have worked towards gaining
> performance enhancements in some cumulative way, is that not so, in t=
heory?
>=20
> So why is 3 disks slower than 2?
>=20
> > You probably can't get 100mb/s with the two because that would be p=
retty
> > efficient, and there's probably more overhead than that.
> >=20
> > Shouldn't the 80gb drive be going faster than 16mb/s though?  Have =
you
> > checked hdparm to make sure dma and all the goodies are turned on f=
or
> > it?
>=20
> I have a 40 GB segate disk also, on the same motherboard IDE
> controller, it runs about 40 MB/s. So yes, the hdc1
> should go faster, and I have measured something like 40 MB/s
> on it in idler times. I think it is because it is running other=20
> processes. The machine is a ftp mirror and the disk has RedHat
> and Fedora ISO images, so it is quite popular.

Hmm, I have ext3 filesystems, and they are updating the atime in the
inodes. Could that be it? inode flushing obstructing the striping?

Best regards
Keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
