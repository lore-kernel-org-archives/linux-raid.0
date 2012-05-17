From: Anuj Goel <agoel@cs.stonybrook.edu>
Subject: [RAID0] Possible bug in raid0_make_request() function
Date: Thu, 17 May 2012 02:50:28 -0400
Message-ID: <CANSbrrqyj6wL=VBHdgDP7mpjRc+tjZnCQ6rP3_4vHYtPQPqcEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Guys,
I was going through the RAID0 code and found that there could be a
possible bug in the=A0raid0_make_request() function.

Consider the below snippet of this function.

/* This is a one page bio that upper layers
* refuse to split for us, so we need to split it.
*/
if (likely(is_power_of_2(chunk_sects)))
bp =3D bio_split(bio, chunk_sects - (sector &
=A0 (chunk_sects-1)));
else
bp =3D bio_split(bio, chunk_sects -
=A0 =A0 =A0 sector_div(sector, chunk_sects));
raid0_make_request(mddev, &bp->bio1);
raid0_make_request(mddev, &bp->bio2);
bio_pair_release(bp);
return;

In function bio_split(..), if mempool_alloc() fails, we return NULL int=
o bp.
Now the call raid0_make_request(mddev, &bp->bio1) does not check for
bp to be not NULL before de-referencing it.

Could this be a problem ?

--
Best Regards,
Anuj Goel
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
