From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Considering a complete rework of RAID on my home compute server
Date: Sun, 9 Jan 2011 17:45:18 -0800
Message-ID: <AANLkTik3+QSvvuegLtSXGnghDkjfsCDQCDWUktq-W1zR@mail.gmail.com>
References: <AANLkTikxViM45MfjZvMCDAobeVVwBqMZHrm_Ws-bsAQt@mail.gmail.com>
	<68.C0.13137.77E4A2D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <68.C0.13137.77E4A2D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jan 9, 2011 at 4:10 PM, Leslie Rhorer <lrhorer@satx.rr.com> wro=
te:
<SNIP>
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0What I meant was, you currently have a 2 d=
isk RAID0. =C2=A0Why not buy a
> larger disk and move the 2 drives currently tied up in the RAID0 to a=
 5 disk
> RAID6 array with no partitions? =C2=A0The function currently provided=
 by the 2nd
> RAID1 can be taken over by the single drive, and the function of the =
RAID0
> can be taken over by a directory on the main array. =C2=A0This makes =
better
> functional use of the space and may provide performance benefits, not=
 to
> mention being much simpler. =C2=A0I'm a fan of having a separate, sma=
ll disk for
> booting. =C2=A0My servers both have a pair of small drives each parti=
tioned into
> three sections. =C2=A0Each of the partition pairs are in turn assembl=
ed into a
> RAID array for a total of 3 mounts:
>
> md1 - a tiny /boot
> md2 - a small /
> md3 - swap.
>

I believe that is essentially what I'm doing:

- 2 drive RAID0 using 500GB drives is 1TB
- 3 drive RAID1 using 500GB drives is 500GB

- 5 drive RAID6 using 500GB drives is 1.5TB

The RAID0 is moving to the RAID6
The RAID1 is moving to the RAID6

I'll purchase 1 additional 500GB drive to sit cold in my office in
case I drop a drive in the RAID6.

Sounds like it should work out well.

I'll investigate using a different drive for booting.

Thanks,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
