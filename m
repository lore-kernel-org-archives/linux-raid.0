From: Lars Marowsky-Bree <lmb@suse.de>
Subject: multipath bug in 2.5
Date: Wed, 19 Mar 2003 13:47:02 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030319124702.GB18650@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've just casually glanced over 2.5 code to see how much work it would =
be to
port forward, and I think I noticed a bug in multipath_add_disk:

        for (path=3D0; path<mddev->raid_disks; path++)
                if ((p=3Dconf->multipaths+path)->rdev =3D=3D NULL) {
                        p->rdev =3D rdev;
                        conf->working_disks++;
                        rdev->raid_disk =3D path;
                        rdev->in_sync =3D 1;
                        found =3D 1;
                }

Is it just me or will that fill in every empty path? Might make sense t=
o add
a break in there.

But otherwise, wow, the code is looking so much nicer, finally no longe=
r all
thos replicated datastructures, bit fields, ordered lists etc to keep i=
n
sync... This is going to be a big step forward.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
SuSE Labs - Research & Development, SuSE Linux AG
 =20
"If anything can go wrong, it will." "Chance favors the prepared (mind)=
=2E"
  -- Capt. Edward A. Murphy            -- Louis Pasteur
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
