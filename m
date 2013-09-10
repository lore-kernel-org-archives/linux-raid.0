From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm 3.3: issue with mdmon --takeover
Date: Wed, 11 Sep 2013 09:35:18 +1000
Message-ID: <20130911093518.794bbb21@notabene.brown>
References: <CAC9WiBjg4Tbv_UM4o66-8jtFEYGvh3kuP6xSdnz7uL+fq3fZTQ@mail.gmail.com>
	<20130904160832.3627bcb8@notabene.brown>
	<CAC9WiBiHkOjqY4nDwMh4S8td9NMz2mrdqK0R7cZp7nKSMyhBvg@mail.gmail.com>
	<20130905121123.27968f9f@notabene.brown>
	<CAC9WiBiHcS126iFv91250d83sMrBYmRbvoqYAEhjJWjb2p5J3A@mail.gmail.com>
	<CAC9WiBgRiu_YL1TpzD4dtLXv=LiA-RERn+C6Q+i=P_WTNdw3+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fOsO7K1priWZ55=WW_+v1tQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBgRiu_YL1TpzD4dtLXv=LiA-RERn+C6Q+i=P_WTNdw3+w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/fOsO7K1priWZ55=WW_+v1tQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Sep 2013 11:03:14 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> On Thu, Sep 5, 2013 at 9:04 AM, Francis Moreau <francis.moro@gmail.com> w=
rote:
> > Hi Neil,
> >
> > On Thu, Sep 5, 2013 at 4:11 AM, NeilBrown <neilb@suse.de> wrote:
> >> On Wed, 4 Sep 2013 09:36:27 +0200 Francis Moreau <francis.moro@gmail.c=
om>
> >> wrote:
> >
> > [...]
> >
> >>> no arrays to monitor... exiting
> >>>
> >>
> >> The line
> >>
> >>> mdmon: ddf_open_new: subarray 0 doesn't exist
> >>
> >> is the problem.  mdmon read the metadata from the array but didn't find
> >> subarray '0' in there even though the previous mdmon clearly did:
> >>
> >>> ddf_open_new: new subarray 0, GUID: Linux-MDdeadbeef00000000?Ob79e0c8=
b1n
> >>
> >> This suggests that even though it succeeded in reading the metadata (i=
t would
> >> have printed
> >>     Cannot load metadata for md127
> >> and exited if it had), the metadata is somehow inconsistent.
> >>
> >> Could you trying running each mdmon under strace:
> >>   strace -f -o /tmp/str-1 ./mddmon --takeover --all
> >>
> >> and attach the two /tmp/str-? files?
> >
> > This is weird: if I'm doing that the first strace process is put in a
> > uninterruptible state at some point:
> >
> > # ps aux | grep dmon
> > root      2297  0.1  0.0   4468   736 tty1     D+   08:39   0:00
> > strace -f -o /tmp/str-1 ./mdmon --takeover --all
> > root      2301  0.6  1.0  15156 11056 ?        SLsl 08:39   0:00
> > ./mdmon --takeover md127
> >
> > Starting the second straced mdmon does the same result, and the system
> > is becoming unusable as soon as it tries to write something to the
> > disk/raid I guess.
> >
> > Note that /tmp on my system is not a tmpfs filesystem but is part of /
> > which is ext4.
> >
> > I gave a second shot but this time I tried to put the strace output
> > files on /dev/shm which is a tmpfs FS. This time I didn't have the
> > issue describes above where strace is put in D state. But since after
> > the second run of mdmon, there was no running mdmon process anymore,
> > it was hard to retrieve the 2 strace output files.
> >
> > Anyways I'm attaching the 2 files now.
> >
> >>
> >> Also what is the difference between
> >>   mdadm --examine /dev/sda
> >> and
> >>   mdadm --examine /dev/sdb
> >> ??
> >>
> >
> > After the system finish booting:
> >
> > # diff -u sda sdb
> > --- sda 2013-09-05 09:00:59.554291764 +0200
> > +++ sdb 2013-09-05 09:01:01.634279757 +0200
> > @@ -1,4 +1,4 @@
> > -/dev/sda:
> > +/dev/sdb:
> >            Magic : de11de11
> >          Version : 01.02.00
> >  Controller GUID : 4C696E75:782D4D44:20202020:2020206C:6F63616C:686F7374
> > @@ -23,5 +23,5 @@
> >
> >   Physical Disks : 2
> >        Number    RefNo      Size       Device      Type/State
> > -         0    2cf00056   2064384K /dev/sda        active/Online
> > -         1    b342fbdc   2064384K                 active/Online
> > +         0    2cf00056   2064384K                 active/Online
> > +         1    b342fbdc   2064384K /dev/sdb        active/Online
> >
> > After starting the first mdmon process:
> >
> > # mdadm --examine /dev/sda >sda
> > Segmentation fault
> >
> > It looks like mdadm is running an infinite loop or something before seg=
faulting.
> >
>=20
> I don't know if that can help but it seems to start failing here:
>=20
> # strace ./mdadm --examine /dev/sda
> ...
> write(2, "mdmon: Failed to load secondary "..., 55) =3D 55

The problem is actually a bit earlier, but it does relate to the secondary
copy of the metadata.

The first sign of trouble is that str-1 has=20

2435  lseek(6, 2131022336, SEEK_SET)    =3D 2131022336
2435  read(6, "3333\27.3#Linux-MD20130828\3143\177\"\373\324\32\230"..., 51=
2) =3D 512

while str-2 has

2452  lseek(6, 2131022336, SEEK_SET)    =3D 2131022336
2452  read(6, "\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377=
\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377"..., 5=
12) =3D 512

 From the same offset, very different data is read.

Presumably it was written by the first write of mdmon.
Looking further in str-1 we find:

2436  lseek(7, 18446744073709551104, SEEK_SET) =3D -1 EINVAL (Invalid argum=
ent)
2436  write(7, "\336\21\336\21~.\307}Linux-MD\336\255\276\357\0\0\0\0?O\267=
2\2045b=3D"..., 512) =3D 512

That is a big number:  "-1 << 9".

mdmon is trying to write the secondary metadata but there isn't any.
So it writes it in the wrong place and makes a mess.

I think this patch will help.  The last hunk in particular should make the
difference.

Please let me know if it fixes the problem.

Thanks,
NeilBrown


diff --git a/super-ddf.c b/super-ddf.c
index 636d7b4..86f9bb0 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -880,7 +880,7 @@ static int load_ddf_headers(int fd, struct ddf_super *s=
uper, char *devname)
 			super->primary.openflag && !super->secondary.openflag)
 			)
 			super->active =3D &super->secondary;
-	} else if (devname)
+	} else if (devname && super->anchor.secondary_lba !=3D ~(__u64)0)
 		pr_err("Failed to load secondary DDF header on %s\n",
 		       devname);
 	if (super->active =3D=3D NULL)
@@ -2810,7 +2810,8 @@ static int add_to_super_ddf(struct supertype *st,
 	} while (0)
 	__calc_lba(dd, ddf->dlist, workspace_lba, 32);
 	__calc_lba(dd, ddf->dlist, primary_lba, 16);
-	__calc_lba(dd, ddf->dlist, secondary_lba, 32);
+	if (ddf->dlist =3D=3D NULL || ddf->dlist->secondary_lba !=3D ~(__u64)0)
+		__calc_lba(dd, ddf->dlist, secondary_lba, 32);
 	pde->config_size =3D dd->workspace_lba;
=20
 	sprintf(pde->path, "%17.17s","Information: nil") ;
@@ -2892,6 +2893,8 @@ static int __write_ddf_structure(struct dl *d, struct=
 ddf_super *ddf, __u8 type)
 	default:
 		return 0;
 	}
+	if (sector =3D=3D ~(__u64)0)
+		return 0;
=20
 	header->type =3D type;
 	header->openflag =3D 1;

--Sig_/fOsO7K1priWZ55=WW_+v1tQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi+stjnsnt1WYoG5AQKilRAApDrZwP+Ag58HzZWYXzGthJE+ycjGBf/i
tRRQ8PL/hEAIGtIer+pUoiYePgdrlGroDcsR+pU3Tb1fKfRvdomglL4NzPED9Y7T
hX/Kge6Si85BC/YMrq7hu+dmqkPOLDHuKvRQDQKEBk+qQ4icnpcMOlM2D0hwX5dO
23pKcpKU4w1yGo6z97893LBxYg1PcAlrHV6/xNoEohP/74zotLchAjuvAXyg7V+q
5fMLhsWFv+kEtsWFVmj0Uzmxk9SlNUfbaLX4mVpN6ZXS0ArnH90VgploWk3b/rub
Qy/wm058+WXPBy/d5oaXCd2GIp0Q0gHlIiMy08UlQOqpP85GwHH4cAZcQGmOGBjp
0OHLI1e69rbc/+CDPUAnamNKpe5QJsQIbnbSEWHSkzbCREnFJSbENgkKNWtojHMD
YAVeql+fwy8eLt7MbMt0HiPaPqL+nwYXp2jkHbyfmEpi7pdRMbjw+QCllrFAl239
eC8tv9sL7Pe3avSATkL9RnikMpDdznEfx6nqq9kAfv6Kie5y0fnJU3uQqIPuAZbA
52p7MZLU6OoGMtgnq9y/qv6EpX5BqqRcihL1cEAgImsqh83yFKetoAEKna/S/yDE
teJHyZxJgsfEdyciQSGhQ7ptoLUBLCeTkplX4Y951bnrbWBotZRYmUFTIKwDRQK6
dlDT5OyFRRc=
=dgqs
-----END PGP SIGNATURE-----

--Sig_/fOsO7K1priWZ55=WW_+v1tQ--
