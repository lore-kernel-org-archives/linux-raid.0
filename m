From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Recovering from a disaster...
Date: Mon, 2 Dec 2002 13:27:19 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021202122719.GB6155@unthought.net>
References: <C65F89D1AC0BB54B865127151A24DA780BAD6494@nbexchm2.aliant.icn>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C65F89D1AC0BB54B865127151A24DA780BAD6494@nbexchm2.aliant.icn>
To: "Shaw, Marco" <marco.shaw@nbtel.nb.ca>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Nov 28, 2002 at 08:53:59AM -0400, Shaw, Marco wrote:
> Going for my RHCE in a few weeks...  Always wondered:
>=20
> 1. Are there any gotchas in a corrupted software RAID filesystem?  Fo=
r example, /dev/md0 is an RAID1 MD device, and either the 1st superbloc=
k on /dev/md0 or maybe the underlying /dev/sda1 partition is zero'ed ou=
t.  How does one go about fixing it?  Will a simple fsck here work?  Bu=
t in the above case, is fsck run against md0 or sda1?

Well, with RAID-1 you know that the underlying partitions *should*
contain identical information.  So if your array is screwed, there is a
chance that one of the partitions actually contains good information.

If you array isn't running at all, try mounting the two partitions - se=
e
which one contains good data.  If any of the two are good, get a backup
of that one.

I'm sure you can assemble the array again, telling the MD code to
rebuild the array from a specific partition, using mdadm (but I can't
tell you how).   Can anyone shed some light on this one  ?   :)

If your array is running, non-degraded, then the underlying partitions
are identical, and there is little else you can do except for fsck.

>=20
> 2. If one knows that /dev/md0 is in trouble (composed of /dev/sda1 an=
d /dev/sdb1), but /dev/sda1 is fine, can one, upon boot, simply change =
LILO/GRUB from trying to mount root from /dev/md0 to /dev/sda1?  My gue=
ss is no, since the disk label is different.

On the kernel command line, specify root=3D/dev/sda1 or root=3D/dev/sdb=
1 -
you can tell your boot-loader to do this.

Disk labels don't matter here.

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
