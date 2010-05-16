From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: mdadm: failed devices become spares!
Date: Sun, 16 May 2010 14:56:03 -0500
Message-ID: <9D.D3.23029.CDD40FB4@cdptpa-omtalb.mail.rr.com>
References: <201005161740.44877.pierre@vigneras.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201005161740.44877.pierre@vigneras.name>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?'Pierre_Vign=E9ras'?= <pierre@vigneras.name>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Pierre Vign=E9ras
> Sent: Sunday, May 16, 2010 10:41 AM
> To: linux-raid@vger.kernel.org
> Subject: mdadm: failed devices become spares!
>=20
> Hi,
>=20
> I encountered a critical problem with mdadm that I submitted to the D=
ebian
> mailing list (it's a debian lenny/stable). They asked me to submit th=
is to
> you. So that's what I do.
>=20
> To prevent duplication of description/information, I give you the URL=
 of
> that
> bug description:
>=20
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D578352
>=20
> If you prefer the full stuff to be copy/pasted to that mailing list, =
just
> ask
> for it.
>=20
> Note: that bug happened again today, on another RAID array. So the go=
od
> news
> is that it is somewhat reproducible! The bad news, is that unless you=
 have
> a
> magic solution, all my data are just lost (half of it was in the back=
up
> pipe!)...
>=20
> Thanks for any help, and regards.
> --
> Pierre Vign=E9ras

	It's not quite clear to me from the link whether your drives are
truly toast, or not.  If they are, then you are hosed.  Assuming not, t=
hen
you need to use=20

`mdadm --examine /dev/sdxx` and `mdadm -Dt /dev/mdyy`

	to determine precisely all the parameters and the order of the block
devices in the array.  You need the chunk size, the superblock type, wh=
ich
slot was occupied by each device in the array (this may not be the same=
 as
when the array was created), the size of the array (if it did not fill =
the
entire partition in every case), the RAID level, etc.  Once you are cer=
tain
you have all the information to enable you to re-create the array, if n=
eed
be, the try to re-assemble the array with

`mdadm --assemble --force /dev/mdyy`

	If it works, then fsck the file system.  (I think I noticed you are
using XFS.  If so, do not use XFS_Check.  Instead, use XFS_Repair with =
the
-n option.)  After you have a clean file system, issue the command

`echo repair > /sys/block/mdyy/md/sync_action`

	to re-sync the array.  If the array does not assemble, then you will
need to stop it and re-create it using the options you obtained from yo=
ur
research above and adding the --assume-clean switch to prevent a resync=
 if
something is wrong.  If the fsck won't work after re-creating the array=
,
then you probably got one or more of the parameters incorrect.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
