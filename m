From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Tue, 13 Apr 2010 15:04:04 -0400
Message-ID: <4BC4C024.10209@redhat.com>
References: <4BBA1289.4010705@redhat.com>	<20100407113035.3ca437f2@notabene.brown>	<4BBBE7D2.6090608@redhat.com>	<20100409093153.690ea963@notabene.brown> <20100409103330.37d9dff5@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig279436DA4E1990788A2DD243"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100409103330.37d9dff5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig279436DA4E1990788A2DD243
Content-Type: multipart/mixed;
 boundary="------------070307080105080009080903"

This is a multi-part message in MIME format.
--------------070307080105080009080903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/08/2010 08:33 PM, Neil Brown wrote:
> On Fri, 9 Apr 2010 09:31:53 +1000
> Neil Brown <neilb@suse.de> wrote:
>=20
>> On Tue, 06 Apr 2010 22:02:58 -0400
>> Doug Ledford <dledford@redhat.com> wrote:
>>
>>> Let me know if you want me to redo/resend any of it.
>>>
>>
>> not necessary, but some remove would be appreciated.
>>
> I suspect you cope graciously with most of my typos, but this one is
> ridiculous!
>=20
>    s/remove/review/
>=20
> :-(
>=20
> NeilBrown
>=20
> P.S.  When could the word "remove" be used in that context?  The only e=
xcuse
> I can think of is that a "remove" is a palette cleanser at a banquet.
> So "some remove" would be "some crystallized fruit or ginger bread" - a=
lways
> appreciated :-)

I've already sent two minor patches, the touchup patch from my original
submission (which hasn't hit your git repo yet but needs to) and the one
to resolve the segfault in your initial patch.  I also have these two
additional patches that apply on top of your hotunplug branch.  With
these applied, the code is back to the same basic functionality as the
patch I posted originally.  However, don't take that to mean it's done
;-)  Of note, there are still a couple lingering issues:

1)  The kernel won't let us set a device faulty if the array is a
non-redundant array type.  This is true of mdadm -If $name and also
mdadm <mddevice> -f <device>.  We need to fix this.  I suspect the
reason that the kernel doesn't set non-redundant array types as failed
in this situation is on the hopes that the underlying device will come
back.  If it does, and we haven't failed the device yet, then
theoretically we could pick up where we left off instead of ever having
to fail at all, where as if we fail at all, the entire array goes down.
 As it turns out, this is a pipe dream.  The reason I say that this is a
pipe dream is that our continued holding of a reference to the device
simply guarantees that even if it came back, it's going to come back
with a different device name and major/minor pair, so we will *never* be
able to pick up where we left off.  So once that device goes away, our
array is toast whether we like it or not.

2) IMSM containers are still a bit flaky on their incremental remove/add
support.  I've been speaking with Dan about this and we've agreed that
the fact that they incrementally assemble differently than regular md
raid arrays is problematic, especially for udev rules files, and so he
was going to work some on the issue (I also have a patch that gets
things minimally functional here, but I'm not attaching that to this emai=
l).

My IMSM rules in the udev file are dracut specific.  I don't know which
distros will end up switch to dracut from mkinitrd, but we already have
for a couple releases of Fedora now.  They could be modified for other
boot initramfs builders as well, but they basically default imsm array
handling to mdadm in the absence of the rd_NO_MDIMSM command line option.=


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband

--------------070307080105080009080903
Content-Type: text/plain;
 name="0003-udev-rules-imsm-arrays-are-a-different-ID_FS_TYPE-so.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0003-udev-rules-imsm-arrays-are-a-different-ID_FS_TYPE-so.pa";
 filename*1="tch"

=46rom 506c331a6030531fe647c7a654bd87ae32373543 Mon Sep 17 00:00:00 2001
From: Doug Ledford <dledford@redhat.com>
Date: Tue, 13 Apr 2010 14:38:44 -0400
Subject: [PATCH 3/4] udev rules: imsm arrays are a different ID_FS_TYPE, =
so check for them as
 well as regular mdadm arrays.  Check to see if we were told on the boot
 command line to ignore IMSM arrays first though (aka, rd_NO_MDIMSM is no=
t
 empty).

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 udev-md-raid.rules |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/udev-md-raid.rules b/udev-md-raid.rules
index da52058..712c5e5 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -4,7 +4,9 @@ SUBSYSTEM!=3D"block", GOTO=3D"md_end"
=20
 # handle potential components of arrays
 ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", ACTION=3D=3D"remove", RUN+=3D"=
/sbin/mdadm -If $name"
-ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", ACTION=3D=3D"add", RUN+=3D"/sb=
in/mdadm --incremental $env{DEVNAME}"
+ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", ACTION=3D=3D"add", RUN+=3D"/sb=
in/mdadm -I $tempnode"
+ENV{ID_FS_TYPE}=3D=3D"isw_raid_member", ENV{rd_NO_MDIMSM}!=3D"?*", ACTIO=
N=3D=3D"remove", RUN+=3D"/sbin/mdadm -If $name"
+ENV{ID_FS_TYPE}=3D=3D"isw_raid_member", ENV{rd_NO_MDIMSM}!=3D"?*", ACTIO=
N=3D=3D"add", RUN+=3D"/sbin/mdadm -I $tempnode"
=20
 # handle md arrays
 ACTION!=3D"add|change", GOTO=3D"md_end"
--=20
1.6.6.1


--------------070307080105080009080903
Content-Type: text/plain;
 name="0004-The-assumption-is-that-if-tfd-0-then-we-have-a-valid.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0004-The-assumption-is-that-if-tfd-0-then-we-have-a-valid.pa";
 filename*1="tch"

=46rom d1f7ba12a4e1ec9ed3a005a84489073d80be8cc9 Mon Sep 17 00:00:00 2001
From: Doug Ledford <dledford@redhat.com>
Date: Tue, 13 Apr 2010 14:44:24 -0400
Subject: [PATCH 4/4] The assumption is that if tfd >=3D 0, then we have a=
 valid major/minor pair
 in stb.st_rdev to use in ioctl calls.  Therefore, even if we use the sys=
fs
 block/dev entry to get our major/minor pair, we should really be using
 tfd and not sysfd as it changes assumptions made later on.

Note: I actually don't like this.  I would prefer that in the case of a
kernel internal name that we skipped tfd altogether and went strait to
sysfs operation exclusively.  But that's just my preference.  I'm
concerned that sometime in the future we'll make the mistake of assuming
that tfd >=3D 0 means dv->devname is a fully qualified path name and not
a kernel internal name.  We don't now, but I could easily see it happenin=
g.

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 Manage.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Manage.c b/Manage.c
index 043e3f6..9e450b9 100644
--- a/Manage.c
+++ b/Manage.c
@@ -386,7 +386,7 @@ int Manage_subdevs(char *devname, int fd,
=20
 		next =3D dv->next;
 		jnext =3D 0;
-		tfd =3D -1;
+		tfd =3D sysfd =3D -1;
=20
 		if (strcmp(dv->devname, "failed")=3D=3D0 ||
 		    strcmp(dv->devname, "faulty")=3D=3D0) {
@@ -461,17 +461,16 @@ int Manage_subdevs(char *devname, int fd,
 			}
=20
 			sprintf(dname, "dev-%s", dv->devname);
-			sysfd =3D sysfs_open(fd2devnum(fd), dname, "block/dev");
-			if (sysfd >=3D 0) {
+			tfd =3D sysfs_open(fd2devnum(fd), dname, "block/dev");
+			if (tfd >=3D 0) {
 				char dn[20];
 				int mj,mn;
-				if (sysfs_fd_get_str(sysfd, dn, 20) > 0 &&
+				if (sysfs_fd_get_str(tfd, dn, 20) > 0 &&
 				    sscanf(dn, "%d:%d", &mj,&mn) =3D=3D 2) {
 					stb.st_rdev =3D makedev(mj,mn);
 					found =3D 1;
 				}
-				close(sysfd);
-				sysfd =3D -1;
+				close(tfd);
 			}
 			if (!found) {
 				sysfd =3D sysfs_open(fd2devnum(fd), dname, "state");
@@ -481,6 +480,7 @@ int Manage_subdevs(char *devname, int fd,
 						dv->devname, devname);
 					return 1;
 				}
+				tfd =3D -1;
 			}
 		} else {
 			j =3D 0;
--=20
1.6.6.1


--------------070307080105080009080903--

--------------enig279436DA4E1990788A2DD243
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvEwCQACgkQg6WylM+/8ZQYSwCfYUUaKcGM+cbEoHLo4Ac2KCII
bLMAnijoGcODgHOAbIHdc5XExoMjeBD/
=0Ja6
-----END PGP SIGNATURE-----

--------------enig279436DA4E1990788A2DD243--
