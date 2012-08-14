From: NeilBrown <neilb@suse.de>
Subject: Re: Version 3.2.5 and ddf issues (bugreport)
Date: Wed, 15 Aug 2012 09:31:05 +1000
Message-ID: <20120815093105.05402855@notabene.brown>
References: <4D8A4780.2030401@gmail.com>
	<20110324090837.689c5a0e@notabene.brown>
	<5013D0FE.3020906@gmail.com>
	<20120731161115.46b96f90@notabene.brown>
	<50179B62.9020603@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/u4qDz64kN7WOQe3Z5uoc3Gi"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50179B62.9020603@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/u4qDz64kN7WOQe3Z5uoc3Gi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Jul 2012 10:46:26 +0200 Albert Pauw <albert.pauw@gmail.com> wrot=
e:

> On 07/31/2012 08:11 AM, NeilBrown wrote:
> > On Sat, 28 Jul 2012 13:46:06 +0200 Albert Pauw <albert.pauw@gmail.com> =
wrote:
> >
> >> Hi Neil,
> >>
> >> After a hiatus of 1.5 year (busy with all sorts) I am back and tried t=
he
> >> ddf code to see how things improved.
> > Thanks!
> >
> >> I build a VM Centos 6.3 system with 6 extra 1GB disks for testing.
> >> I found several issues in the standard installed 3.2.3 version of mdadm
> >> relating to ddf, but installed the
> >> 3.2.5 version in order to work with recent code.
> >>
> >> However, while version 3.2.3 is able to create a ddf container with
> >> raidsets in it, I found a problem with the 3.2.5 version.
> >>
> >> After initially creating the container:
> >>
> >> mdadm -C /dev/md127 -e ddf -l container /dev/sd[b-g]
> >>
> >> which worked, I created a raid (1 or 5 it doesn't matter in this case)
> >> in it:
> >>
> >> mdadm -C /dev/md0 -l raid5 -n 3 /dev/md127
> >>
> >> However, it stays on resync=3DPENDING and readonly, and doesn't get bu=
ild.
> >>
> >> So I tried to set it to readwrite:
> >>
> >> mdadm --readwrite  /dev/md0
> >>
> >> Unfortunately, it stays on readonly and doesn't get build.
> >>
> >> As said before, this did work in 3.2.3.
> >>
> >> Are you already on this problem?
> > It sounds like a problem with 'mdmon'.  mdmon needs to be running befor=
e the
> > array can become read-write.  mdadm should start mdmon automatically but
> > maybe it isn't.  Maybe it cannot find mdmon?
> >
> > could you check if mdadm is running?  If it isn't run
> >     mdmon /dev/md127 &
> > and see if it starts working.
> Hi Neil,
>=20
> thanks for your reply. Yes, mdmon wasn't running. Couldn't get it=20
> running with a recompiled 3.2.5, the standard one which came with Centos=
=20
> (3.2.3) works fine, I assume the made some changes to the code? Anyway,=20
> I moved to my own laptop, running Fedora 16 and pulled mdadm frm git and=
=20
> recompiled. That works. I also used loop devices as disks.
>=20
> Here is the first of my findings:
>=20
> I created a container with six disks, disk 1-2 is a raid 1 device, disk=20
> 3-6 are a raid 6 device.
>=20
> Here is the table shown at the end of the mdadm -E command for the=20
> container:
>=20
>   Physical Disks : 6
>        Number    RefNo      Size       Device      Type/State
>           0    06a5f547    479232K /dev/loop2      active/Online
>           1    47564acc    479232K /dev/loop3      active/Online
>           2    bf30692c    479232K /dev/loop5      active/Online
>           3    275d02f5    479232K /dev/loop4      active/Online
>           4    b0916b3f    479232K /dev/loop6      active/Online
>           5    65956a72    479232K /dev/loop1      active/Online
>=20
> I now fail a disk (disk 0) and I get:
>=20
>   Physical Disks : 6
>        Number    RefNo      Size       Device      Type/State
>           0    06a5f547    479232K /dev/loop2      active/Online
>           1    47564acc    479232K /dev/loop3      active/Online
>           2    bf30692c    479232K /dev/loop5      active/Online
>           3    275d02f5    479232K /dev/loop4      active/Online
>           4    b0916b3f    479232K /dev/loop6      active/Online
>           5    65956a72    479232K /dev/loop1      active/Offline, Failed
>=20
> Then I removed the disk from the container:
>=20
>   Physical Disks : 6
>        Number    RefNo      Size       Device      Type/State
>           0    06a5f547    479232K /dev/loop2      active/Online
>           1    47564acc    479232K /dev/loop3      active/Online
>           2    bf30692c    479232K /dev/loop5      active/Online
>           3    275d02f5    479232K /dev/loop4      active/Online
>           4    b0916b3f    479232K /dev/loop6      active/Online
>           5    65956a72    479232K                 active/Offline,=20
> Failed, Missing
>=20
> Notice the active/Offline status, is this correct?

To be honest, I don't know.  The DDF spec doesn't really go into that sort =
of
detail, or at least I didn't find it.
Given that the device is Missing, it hardly seems to matter whether it is
Active or Spare or Foreign or Legacy.
I guess if it re-appears we want to know what it was ... maybe.

>=20
> I added the disk back into the container, NO zero-superblock:
>=20
>   Physical Disks : 6
>        Number    RefNo      Size       Device      Type/State
>           0    06a5f547    479232K /dev/loop2      active/Online
>           1    47564acc    479232K /dev/loop3      active/Online
>           2    bf30692c    479232K /dev/loop5      active/Online
>           3    275d02f5    479232K /dev/loop4      active/Online
>           4    b0916b3f    479232K /dev/loop6      active/Online
>           5    65956a72    479232K /dev/loop1      active/Offline,=20
> Failed, Missing
>=20
> It stays active/Offline (this is now correct I assume), Failed (again=20
> correct if had failed before), but also still missing.

I found why this happens.  When I added code to support incremental assembly
of DDF arrays, I broke the ability to hot-add a device which happened to ha=
ve
reasonably good looking metadata on it.  The best approach for now is to
--zero the device first.  I'll push out a patch which does just that.


>=20
> I remove the disk again, do a zero-superblock and add it again:
>=20
> Physical Disks : 6
>        Number    RefNo      Size       Device      Type/State
>           0    06a5f547    479232K /dev/loop2      active/Online
>           1    47564acc    479232K /dev/loop3      active/Online
>           2    bf30692c    479232K /dev/loop5      active/Online
>           3    275d02f5    479232K /dev/loop4      active/Online
>           4    b0916b3f    479232K /dev/loop6      active/Online
>           5    ede51ba3    479232K /dev/loop1      active/Online, Rebuild=
ing
>=20
> This is correct, the disk is seen as a new disk and rebuilding starts.
>=20
>=20
> Regards,
>=20
> Albert

diff --git a/Manage.c b/Manage.c
index f83af65..7f27f74 100644
--- a/Manage.c
+++ b/Manage.c
@@ -786,6 +786,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			return -1;
 		}
=20
+		Kill(dv->devname, NULL, 0, -1, 0);
 		dfd =3D dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
 		if (mdmon_running(tst->container_dev))
 			tst->update_tail =3D &tst->updates;



Thanks,
NeilBrown


--Sig_/u4qDz64kN7WOQe3Z5uoc3Gi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCrfuTnsnt1WYoG5AQLkUxAAkUAKXNwVerYZnUMR9pegw/iulyXIoLLw
0SFb+F98l5TR/x0/9MRS5mYigE4o2iNpWn2C6tJgoeyCKGA9Q309vwqGyVtTOmcL
Khj9sOFb+o9XbxAcwTrZlVOYTEBHDfo7cR+DWuhxrGMgUtuZJh9QfFKAG510wlMY
daoSwd9rHw/VjMDru9Da+zISfpzOkK20ex6DKd9plkoy25VA4iATtzn6yNFmDdBy
1WnqRcDduU2cufZhuVQ9L1nj9yZMm/xTLeIsa6LIQ8Vr1GcQa3tzhgvpH7pImN7Z
mEaWJJC0pue148c/H51Pss5pRMSbx7Vzp8YWjPE+c3ngKjH5vn1af8DfJwGoHJFv
kvtW8JsBrKJjcqUREKeLIukAmIY6mTbmBWpWEYyN7uTvO5/O6f1ymk6GWIf3aDup
lEuXpdJ/Mu/zBuwT+lLxv0fOQJ6twOd/zoi5esk+b61eBwCgFX7dFCTkXZDx0rUT
HjpHkuj06vJ/cGfrYmLcoFVYl7jnXOtTUmvSL+VeDBtIT/IqFxqULl9SunvGvrX7
TQIRUhjoYsCE4WLCqREE8a7tVCS9s3f4ZryWFrEXb2ABCS6ckSdWTmJIcMQOpT2F
ZzfS0M29pyOiJ7UhqN60o6nW+sDK9/kKd80Bs9j6JoRQk7g5NWvfSir3RQO71P9p
wP6gqqEYV3g=
=4LTx
-----END PGP SIGNATURE-----

--Sig_/u4qDz64kN7WOQe3Z5uoc3Gi--
