From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Really need RESYNC at the time of RAID1&5 creation?
Date: Tue, 1 Jul 2003 00:03:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030630220308.GQ12240@marowsky-bree.de>
References: <00b901c33f4f$715be540$6401a8c0@bmoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00b901c33f4f$715be540$6401a8c0@bmoon>
To: bmoon <bo@anthologysolutions.com>, Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-06-30T14:34:51,
   bmoon <bo@anthologysolutions.com> said:

> Hi Neil & Raiders,
>=20
> I am not quite sure if we really need to resync the array at the time=
 of
> RAID 1 or RAID 5 array creation. I tried and tested without RESYNC by
> modifying "case1" and "case2" from MDADM source below, I could not no=
tice
> any problems or issues.

It's necessary to ensure consistency of the RAID, so that later, you ca=
n
detect whether the RAID has scrambled some of your disk.

Otherwise, you'd never know whether it wouldn't still be an artifact
leftover from the creation of the array.

Another option would be a bitmap of used chunks so you could tell one
from the other, but that wouldn't make as much sense on a heavily used
array. So just initialize it once.


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
