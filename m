From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Fri, 2 Oct 2009 17:06:41 +0200
Message-ID: <20091002150641.GB4342@rap.rap.dk>
References: <babafd2f0910012046i46f77e82lc1a75bbee3b1a6d8@mail.gmail.com> <887103.5263.qm@web38801.mail.mud.yahoo.com> <babafd2f0910020754i4818043aw3d4a15e91eec9eb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <babafd2f0910020754i4818043aw3d4a15e91eec9eb8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ben DJ <bendj095124367913213465@gmail.com>
Cc: chimera_god@yahoo.com, robin@robinhill.me.uk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 02, 2009 at 07:54:04AM -0700, Ben DJ wrote:
> Hi everybody,
>=20
> 2009/10/2 Keld J=F8rn Simonsen <keld@dkuug.dk>:
> > You can boot from a raid-10,n2 with the superblock last, standard
> > raid10,n2 will do. But the normal thing is to boot from raid-1
> >
> > There is a description of a setup at
> > http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_d=
isk
>=20
> Thanks for the URL.  Is there a reason that raid-1 is the "normal
> thing"? Just popularity or something technical?

it is because raid1 is what traditionally worked. raid10,n2 will not wo=
rk
in some situations.  raid10 is "new" and "dangerous" (FUD). Many people
do not know about raid10, and its wonders.

> In your reference it says "The root file system can be on another rai=
d
> than the /boot partition. We recommend an raid10,f2, as the root file
> system will mostly be reads, and the raid10,f2 raid type is the
> fastest for reads, while also sufficiently fast for writes. Other
> relevant raid types would be raid10,o2 or raid1." and "a small /boot
> partition. We recommend something like 200 MB on an ext3 raid1".
>=20
> How or why did you arrive at "raid-10,n2 with the superblock last"?

what lilo and grub really do is that they just read from one disk, so i=
f
the raid type happens to be the same layout as  a non-raid partition, i=
t
works. raid10,n2 default layout (ver 0.90) is equivalent with non-raid,
as the raid superblock is in the end of the partition. I understand tha=
t
other versions of the superblock are put other places, such as in the
beginning of the partition.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
