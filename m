From: NeilBrown <neilb@suse.de>
Subject: Re: Re-assembling faulty array
Date: Wed, 16 May 2012 08:59:45 +1000
Message-ID: <20120516085945.303c30f8@notabene.brown>
References: <1336765276.10557.30.camel@foxtrot.cjac.ntr.f5net.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lYEPGeEtey3XvHGQe.EsjdW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1336765276.10557.30.camel@foxtrot.cjac.ntr.f5net.com>
Sender: linux-raid-owner@vger.kernel.org
To: "C.J. Adams-Collier KF7BMP" <cjac@colliertech.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lYEPGeEtey3XvHGQe.EsjdW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 May 2012 12:41:16 -0700 "C.J. Adams-Collier KF7BMP"
<cjac@colliertech.org> wrote:

> Hey all,
>=20
> I've got an array that seems to have failed while I was re-synchronizing
> one of the disks.  sde fell out when I moved six disks from one chassis
> to another.  I re-added it and it was 98.8% done with 300 minutes left
> in the process when I went to sleep last night.  When I woke up, the
> array was in a FAILED state, sdg was marked failed and sde was marked
> spare.  I removed sdg from the array and re-booted and now the array
> won't start.
>=20
> Is there a way to re-add sdg back in to slot 5 rather than having it
> added as a spare?  AFAICT, no writes have been made to sdg or md0 since
> I removed it from the array, so it should be pretty close to its active
> state.  sde must be nearly ready to be added in as an active participant
> in the array, too.
>=20
> Is there anything I can do to re-build the array at this point?
>=20
> Cheers,
>=20
> C.J.
>=20

 From the "mdadm -E" you sent me separately :

        Version : 0.90.00
     Raid Level : raid5
  Used Dev Size : 972848128 (927.78 GiB 996.20 GB)
     Array Size : 4864240640 (4638.90 GiB 4980.98 GB)
   Raid Devices : 6

and "grep this" show:

this     3       8       18        3      active sync   /dev/sdb2
this     4       8       34        4      active sync   /dev/sdc2
this     2       8       50        2      active sync   /dev/sdd2
this     6       8       66        6      spare   /dev/sde2
this     1       8       82        1      active sync   /dev/sdf2
this     6       8       98        6      spare   /dev/sdg2

"grep Events" shows:

         Events : 34795
         Events : 34795
         Events : 34795
         Events : 34795
         Events : 34795
         Events : 34794

So you are missing device '0' and '5'.

So presumably sdg reported an error before sde finished recovery, so
sde remains a spare.  I cannot see why "sdg"  is marked as a spare though.
It should still be marked as a member of the array.  Maybe you tried to add
it after removing it?

What you need to do is decide which of 'e' and 'g' you trust most (probably
g, but I don't know the full history) and which slot it should be in (0 or =
5,
you might be able to tell from a recent "RAID conf printout" in kernel logs=
).
Then
 mdadm -S /dev/md0
 mdadm -C /dev/md0 -l5 -n6 -e 0.90 -c 64 /dev/sdg2 /dev/sdf2 /dev/sdd2 \
        /dev/sdb2 /dev/sdc2 missing

The order of devices is important.  This puts 'g2' in slot 0 and 'missing'
in slot 5.

Then 'fsck -n /dev/md0' or whatever is appropriate given what sort of data
you have on md0.  If that is happy, add the other device (g2 or e2) and let
it recovery.

NeilBrown

--Sig_/lYEPGeEtey3XvHGQe.EsjdW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7Lf4Tnsnt1WYoG5AQJlPw//fXU5bP1Gfl2fKrQRDOFYQ/woh8x0j3nc
YbKvzTVCVczjs1qIB+43se5IlrhmQKUwuFdkmk0iRpE+/JYhxAKE4+YEPBY/5RP7
SdI8dm47gqUnILL8Z4Xq80frL38c6ZHMg03rOH9GZ92DCL5wtF8JzKQ84Ph8AeC+
CM+ZD0YDf8STwIhhaJWqRFAm6BCGA+UzqMZJZlhXUp2KFp7XgRv2JQiCkTkhyBWe
ThOKqk/6ESCBp7+V2C5IwgUQdMKOQsYmB6M6e7tJv3d9kZVhKrb9akt5mtEpxRnK
deShuOuRhVLwxL3SY3V/JJ0fJaMYa5KIMOW8rRkWbzrrYYIATDBDETMliD4n+zJw
ASHsPk9eHGcftT3M4Bx0d8YOLJp8llfoJWhwO5/dh0MEHwgc1v+FIzVpcuQLc0iD
Dp+nK/X+PacPkQW6X5aIdgE7DHmL3kB7XfrWt8QixNFHV1KCJED/SgdIIVONyi45
/7lFQJp0hlf1bOxikzQUzsYHkU/OWA3b04j9+ZpeJxT16RGYQKVhxy2GPhrDU6vw
9rnVXFM63ypCbWkUICl9Fcr+gxrCAWf1arXB8gO5JVAqRFydMrm/SLDk+jQQXVAZ
/AjZ5xLOFn6+RQj/C4QrMBDWF/1LbRVtkN2C/a5HeYXqCkl5ZIyw351jDcjmNeW7
REz+2c3eTWQ=
=/SEq
-----END PGP SIGNATURE-----

--Sig_/lYEPGeEtey3XvHGQe.EsjdW--
