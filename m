From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Updated md multipath extensions available (vs 2.4.21pre5)
Date: Fri, 14 Mar 2003 14:26:37 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030314132637.GT1211@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: mingo@redhat.com, neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil and Ingo,

I've rediffed the md-mp patch vs 2.4.21pre5.

The new diff also includes a bugfix where the multipath mode would not
correctly switch to a spare path if the only active path failed. It als=
o
includes a slightly different fix for the "do not derefence sb if
disk_faulty".

Please consider for inclusion in 2.4.21. If it can't go in yet, please =
tell me
what kind of changes you'd like to have for 2.4.22 instead.

I understand that in particular the CLEAN_PATH ioctl might not be consi=
dered a
good thing; I gather that you seem to prefer the hot remove / hot add c=
ycle
instead; I think the CLEAN_PATH ioctl is nicer though.

The patch, together with necessary changes to mdadm to take advantage o=
f this
functionality is at ftp://ftp.suse.com/pub/people/lmb/md-mp/md-mp-2, as=
 soon
as the mirrors have catched up.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
Principal Squirrel=20
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
