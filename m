From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: draft howto on making raids for surviving a disk crash
Date: Wed, 6 Feb 2008 16:45:39 +0100
Message-ID: <20080206154538.GC16090@rap.rap.dk>
References: <20080202194131.GA7875@rap.rap.dk> <20080206090557.GA19764@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080206090557.GA19764@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 06, 2008 at 10:05:58AM +0100, Luca Berra wrote:
> On Sat, Feb 02, 2008 at 08:41:31PM +0100, Keld J=F8rn Simonsen wrote:
> >Make each of the disks bootable by lilo:
> >
> >  lilo -b /dev/sda /etc/lilo.conf1
> >  lilo -b /dev/sdb /etc/lilo.conf2
> There should be no need for that.
> to achieve the above effect with lilo you use
> raid-extra-boot=3Dmbr-only
> in lilo.conf
>=20
> >Make each of the disks bootable by grub
> install grub with the command
> grub-install /dev/md0

I have already changed the text on the wiki. Still I am not convinced i=
t=20
is the best advice that is described.

best regards
keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
