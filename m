From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Software RAID and Fakeraid
Date: Wed, 2 Feb 2011 15:12:17 -0600
Message-ID: <8E.67.19545.3B8C94D4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTinDrmxhSFbj5assuCPEPY-eAxeuVs-4D4xqhKi=@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinDrmxhSFbj5assuCPEPY-eAxeuVs-4D4xqhKi=@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of hansbkk@gmail.com
> Sent: Wednesday, February 02, 2011 10:09 AM
> To: linux-raid@vger.kernel.org
> Cc: grub-devel@gnu.org
> Subject: Re: Software RAID and Fakeraid
>=20
> On Tue, Feb 1, 2011 at 11:26 PM, Lennart Sorensen
> <lsorense@csclub.uwaterloo.ca> wrote:
> > I personally consider soft raid on raw devices so convluted that I
> > have never done it.

	Convoluted?  It simply removes an unnecessary layer of management.
If anything, it is less convoluted, and one needn't worry about partiti=
on
types and their associated limitations.  I currently have 24 un-partiti=
oned
drives in my two RAID systems.

> > I would rather have something I know works with my
> > bootloader and other tools, than gain that extra 1MB (at most) that=
 not

	Modern bootloaders don't require partitions, either, IIRC, although
in fact I do partition my boot drives.

> > having partitions gives. =A0Also given many PCs won't boot from a d=
rive
> > without a partition table, it isn't even an option then.

	Do you have an example?  I'm not aware of any.  In any case, as I
said, I do recommend partitioning the boot drive, at a minimum into a r=
oot
and a swap partition.  I also like to keep the /boot target separate, b=
ut
then /boot is tiny.
=20
> For others googling this later, another very good reason for *never*
> RAID'ing raw block devices (ie always creating at least one partition
> first) is that if you ever mistakenly boot into some flavors of
> Windows (even from some optical discs, perhaps unknowingly left ina
> drive), your disks will automatically get "helpfully" initialized, as
> windoze thinks it's a brand new empty drive being offered up like a
> virgin for sacrifice - **poof** there goes all your data.
>=20
> Speaking from experience 8-(

	This is only true with very old versions of Windows.  What's more,
the data certainly can be recovered.  None of my data drives are
partitioned.  There's really no point.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
