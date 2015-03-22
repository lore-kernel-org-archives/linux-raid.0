From: NeilBrown <neilb@suse.de>
Subject: Re: is mdadm RAID1 disk full sync
Date: Sun, 22 Mar 2015 16:38:09 +1100
Message-ID: <20150322163809.407c6ddb@notabene.brown>
References: <CAN+bsqhy0Bao1hAn3R-KtXWOjYb8O2LDo+E1jNdktWdduUL4vw@mail.gmail.com>
	<20150322142033.0af10b1a@notabene.brown>
	<CAN+bsqg2wp4VMCA8O0b2rUfbGDGXZY=mFvj1hA=tWaVkdCMXtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/w5aWgd4CsDL_PLo=.vsM/CT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAN+bsqg2wp4VMCA8O0b2rUfbGDGXZY=mFvj1hA=tWaVkdCMXtA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: lingli tang <tanglingli001@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/w5aWgd4CsDL_PLo=.vsM/CT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Mar 2015 13:00:54 +0800 lingli tang <tanglingli001@gmail.com>
wrote:

> Thanks for reply.
>=20
> I have create a raid1 with two fusion io PCIe flash disk:
> mdadm --create /dev/md/master --name=3Dmaster --level=3D1 --raid-devices=
=3D2
> /dev/fioa2 /dev/mapper/mpathc
> /dev/fioa2 is local disk on server A and /dev/mapper/mpathc is a iscsi
> load disk export from server B.
>=20
> After that we mkfs.ext4 on /dev/md/master and mount with 'sync' option on=
 /data1
> and we will run mysql binlog on it.
> In order to avoid data loss  of mysql binlog we have set
> sync_binlog=3D1. so every sql commit will call fsync() to flush to disk.
>=20
> according to your description. if we reboot the server A, the two disk
> data on different server will be the same.
> but after the server A restarted, we assemble the two disk on two
> server, data is different on the two server, disk on server B lost
> more than one sql commit.

What exactly do you mean by "reboot"??
Is this a clean shutdown or do you remove the power or something like that.

If you remove the power, then it is very possible that some requests will
have been submitted to one device but not the other.
If you have a clean shutdown, then the two devices should be identical.

NeilBrown


>=20
> I have checked it with strace 'mysqld' on Server A.
> I found a sql commit and fsync() on binlog file handle on server A but
> this sql can not find in assembled disk on server B.
>=20
> I also test it with two SAS disk, Server B still has more than one sql
> commit lost.
>=20
>=20
> 2015-03-22 11:20 GMT+08:00 NeilBrown <neilb@suse.de>:
> > On Sat, 21 Mar 2015 19:01:54 +0800 lingli tang <tanglingli001@gmail.com>
> > wrote:
> >
> >> I am a newbie of mdadm. I have a question but find no answer in
> >> document or google for last 10 days.
> >>
> >> The question is : RAID1 made by mdadm is full sync? for example, I
> >> have two disk(sdb and sdc) to make RAID1 disk (/dev/md127), if I
> >> commit an IO to the RAID1 disk (md127), it will return back to me when
> >> all the two disk commit successfully      or      it will return back
> >> to me once just one of the disk successfully commit.
> >
> > The write request will not return until it has been submitted to all, a=
nd
> > returned by, all working devices.
> >
> >>
> >> I have test with xfs and ext4 with sync option, and it seems that two
> >> disk have lots of commit difference after reboot the server. is that
> >> means mdadm return success when one of the disk is commit
> >> successfully?
> >
> > That certainly shouldn't happen.  I would need more details of the expe=
riment
> > that you performed.
> >
> > NeilBrown
> >
> >
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >


--Sig_/w5aWgd4CsDL_PLo=.vsM/CT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVQ5VQjnsnt1WYoG5AQKNIhAAt5LfAzmbBsGVEnd95Hz5e4l6DWLh/VVn
dvYRFNzJvhL++PWknT58z8tK2vtNmicq//ZnBrlGLn9nCbExwtwjOVMNrg975FGx
ioTnxZfYfUkCh8LXqFSIOdamQ6+mdFQc7yM5VdOMM6AJ0kydXk/A09qUd5YQA5g6
AN8+l/G6gFVHG1y+vfySsOxHW1I32Jrp3CagQJ3gBUd372/XRz+oYXFfcI4Oy53M
YqOOeyDboRj5HyJ/gL+0hTsDhZiQHgMyRir5Pl+r09rDP+slMXe2v2S/1dCm+HZR
Amm3L6B15LYbniFNewrHY0572lVYSBUSrFB+FNgB+KGbrbxCrQwS1IUklZXh1P67
BHUQEMX047bElIfUf+cooViFdhYZPS778zBkrQ9CjRCb0VyYEbFfhwDzNgOAJ2O0
Mrmz/fpZpqk24p6qJFh4AYc72oomu811SEwQitrIbV54WMhWJG6txLvnmHycb/2V
APwD3FLkc0/0NF+9/aTREH/3IyAR+Gn4AqZgY3D7/dhdQbDxmhDfHUvNVPLBxefP
o+QIgVa2GYkg0eZykJxNdXArbNEnoSg1yG7fb+iNvjCNt0WHdK1BWKg7d9UNvfnl
DuFcE6U8jHumiTljHt8Xx6pPgO5JOFuxzzXepGUB/9BrlYEUx+8/z0PnuRX34vK9
Pu7qdE2lDq4=
=lk6m
-----END PGP SIGNATURE-----

--Sig_/w5aWgd4CsDL_PLo=.vsM/CT--
