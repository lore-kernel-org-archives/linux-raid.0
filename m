From: Gregory Leblanc <gleblanc@linuxweasel.com>
Subject: Re: Comments on a raid howto for devil-linux
Date: 24 Jan 2003 01:15:39 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1043399739.17921.15.camel@peecee.linuxweasel.com>
References: <3E2F4731.904@fl.priv.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FYMSxAcIzv160Os12JHv"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E2F4731.904@fl.priv.at>
To: Friedrich Lobenstock <fl@fl.priv.at>
Cc: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-FYMSxAcIzv160Os12JHv
Content-Type: multipart/mixed; boundary="=-n3hQcAfP8h1S/RS7twfQ"


--=-n3hQcAfP8h1S/RS7twfQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

(sent to both the list and Friedrich, since I'm not sure if he's on the
list.  Replies to the list and not me, please)

On Wed, 2003-01-22 at 17:36, Friedrich Lobenstock wrote:
> Hello community!
>=20
> Might someone have a quick glance over my raid howto
> for devil-linux? Just take aside that it's not for a normal
> disk based distro and tell me if anything is really wrong.
>=20
>   ftp://ftp.fl.priv.at/pub/devil-linux/RAID-HOWTO.txt

Sure, I've looked over this, and made a bunch of comments.  A diff
between your copy and mine is attached to this email.  Anything that
begins with <GREG> is a comment from me, and not intended as an actual
change to the document.

You might want to look at the licensing of that document, though.  The
GFDL requires you to include a complete copy of the license along with
the document.  For a document this short, one of the other free licenses
might be better.

Last bit, do you mind if I borrow a few bits of this HOWTO for the
Linux-RAID FAQ?  I'd like to use the commands from your HOWTO in answer
to "4.2. So my RAID set is missing a disk, what do I do now?", as well
as a couple of new questions on testing failure of drives in a RAID
set.  If that's OK, let me know what information you'd like in the
revision history, and I'll make sure you get credit. =20
	Greg

--=20
Gregory Leblanc <gleblanc@linuxweasel.com>

--=-n3hQcAfP8h1S/RS7twfQ
Content-Disposition: attachment; filename=RAID-HOWTO.txt.patch
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=RAID-HOWTO.txt.patch; charset=ISO-8859-1

--- RAID-HOWTO.txt.orig	2003-01-24 00:39:26.000000000 -0800
+++ RAID-HOWTO.txt	2003-01-24 01:01:08.000000000 -0800
@@ -35,7 +35,7 @@
 # Run "save_config" and reboot to test if mdadm gets installed correctly.
 #
 # -----------------------------------------------------------------------
-# If you want to make use of RAID under Devil-Linux 0.6beta you propably=20
+# If you want to make use of RAID under Devil-Linux 0.6beta you probably=20
 # need an updated mountfs script.
 #
 #   Get ftp://ftp.fl.priv.at/pub/devil-linux/0.6/etc/init.d/mountfs
@@ -58,7 +58,7 @@
   For now we assume that we either want to create a RAID-0 or RAID-1 array=
.
   For RAID-5 you just have to add more partitions (and therefor harddisks)=
.
=20
-  Create a partition on each disk with the maximal size "fdisk -l" should
+  Create a partition on each disk with the maximal size. "fdisk -l" should
   show you something like this:
=20
      Disk /dev/hda: 16 heads, 63 sectors, 79780 cylinders
@@ -79,6 +79,15 @@
           partitions for ourselfs. You can of course use the standard
           partition type "83, Linux" - but hey someone might format it ;)
=20
+<GREG> This paragraph is confusing.  Here's an attempted re-write.
+This re-write DOES need review, and probably more work.
+
+  REMARK: Since Devil-Linux does not include RAID autodetect, there's
+          really no need to mark the partititions as type 'fd', we
+          just use the partition type for reference.  You can use the
+          standard partition type (83, Linux), but someone might
+          mistakenly ruin your RAID partition.
+
=20
 RAID-0 (no redundancy!!)
=20
@@ -88,11 +97,9 @@
         --raid-devices=3D2 /dev/hda1 /dev/hdc1
       mdadm: array /dev/md0 started.
=20
-      REMARK: Instead of /dev/md0 use any other md device if /dev/md0 is
-              already in use by another array. You might also want to
-              experiment with the chunk size (eg. 8, 16, 32, 64, 128).
-              Use a harddisk benchmark to check or stay with the default o=
f
-              64k chunk size.
+      REMARK: If /dev/md0 is already in use, use one of the other
+              /dev/md? devices.  You can also try changing the chunk
+              size to improve performance.
=20
   check /proc/mdstat
=20
@@ -113,8 +120,8 @@
         --raid-devices=3D2 /dev/hda1 /dev/hdc1
       mdadm: array /dev/md0 started.
=20
-      REMARK: Instead of /dev/md0 use any other md device if /dev/md0 is
-              already in use by another array
+      REMARK: If /dev/md0 is already in use, use one of the other
+              /dev/md? devices.
=20
   check /proc/mdstat
=20
@@ -128,9 +135,9 @@
=20
       Ok, that looks fine.
=20
-      REMARK: Before rebooting you will have to wait till this resync is
-              done otherwise it will start again after the system is up
-              again.
+      REMARK: You will need to wait until this resync is done before
+              rebooting, otherwise it will re-start once the system
+              has finished booting.
=20
 save the information about the just created array(s)
=20
@@ -143,9 +150,10 @@
   Looks good too!
=20
 #
-# Now you can use the just created arrays to put LVM on top of them
-# to facilitate the auto-mounting of logical volumes in the devil-linux=20
-# volume group.
+# Now you can use LVM on top of the just created arrays to facilitate
+# the auto-mounting of logical volumes in the volume group.
+<GREG> this one probably needs work as well, I'm not quite sure what
+you were driving at here.
 #
=20
 finally run "save_config"
@@ -234,8 +242,8 @@
=20
   # mdadm --fail /dev/md0 /dev/hdc1
=20
-  REMARK: DO NOT run this every on a raid0 or linear device or your
-          data is toasted!
+  REMARK: -DO NOT- run this every on a raid0 or linear device or you
+          -WILL- lose data!
=20
=20
 removing a faulty disk from an array:

--=-n3hQcAfP8h1S/RS7twfQ--

--=-FYMSxAcIzv160Os12JHv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQA+MQQ7nAkVXO6fw4sRArw2AJ9WRH7E8whNR4FlAFOxs1Pp3q5VFgCdEMeq
uMNkFQJ6Fg6QV1PXF/0Eq0E=
=Tx9L
-----END PGP SIGNATURE-----

--=-FYMSxAcIzv160Os12JHv--

