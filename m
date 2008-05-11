From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Has anyone compared SWRAID for (JBOD@HW-RAID) vs. (Regular Sata PCI-e cards)?
Date: Sun, 11 May 2008 09:39:36 +0200
Message-ID: <20080511073936.GB20335@rap.rap.dk>
References: <181601c8b2a7$12fe0489$5209f40a@exchange.rackspace.com> <alpine.DEB.1.10.0805101014200.1844@p34.internal.lan> <4825D7DA.2050608@garzik.org> <20080510222817.GA26706@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080510222817.GA26706@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, David Lethe <david@santools.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 11, 2008 at 12:28:17AM +0200, Keld J=F8rn Simonsen wrote:
> On Sat, May 10, 2008 at 01:14:02PM -0400, Jeff Garzik wrote:
> >=20
> > And of course, there are plenty of other factors to consider.  I wr=
ote a=20
> > bit on this topic at http://linux.yyz.us/why-software-raid.html
>=20
> So that is you writing this page! I think it is one of the more usefu=
l
> pages on raid (many others are quite outdated).=20
>=20
> I have a suggestion for an advantage for SW raid, that you could
> consider for your page:
>=20
> - potential for increased performance, due to more intelligent layout=
s,
>   for example the linux raid10,f2 has more than double the performanc=
e
>   for both sequential reads and random reads compared to most hardwar=
e
>   RAID1, and Linux SW RAID1.
>=20
> - potential for better error handling, due to more intelligent driver=
s.
>   Linux raid10 has better error handling than linux RAID1 and possibl=
y
>   also HW RAID1.
>=20
> And then, if you could link to our HOWTO pages at
> http://linux-raid.osdl.org/ that would improve the visibility for our
> pages. It seems like not many are referencing our pages, so if people=
 on
> this list would make a link to http://linux-raid.osdl.org/ that would
> increase the chance of our information to be seen.
>=20
> Best regards
> keld

Another advantage of SW raid:

- SW RAID is more flexible. On a set of drives you can with SW RAID mix
  different types of raid, for example the /boot partition could be
  RAID1 so that it can be booted by grub/lilo, the / partition could be=
=20
  raid10,f2 for greater read performance, and the data partition could =
be=20
  raid5 to get more effective space out of your drives. In HW RAID you =
can
  only allocate whole disks to one RAID type.

best regards
Keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
