From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid10 ... (was: Re: ANNOUNCE: mdadm 1.7.0)
Date: Sat, 14 Aug 2004 00:28:29 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408140428.i7E4ST318129@watkins-home.com>
References: <20040814041814.56d1e6c9.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040814041814.56d1e6c9.pegasus@nerv.eu.org>
To: =?utf-8?Q?'Jure_Pe=C3=A8ar'?= <pegasus@nerv.eu.org>, linux-raid@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: linux-raid.ids

Many years ago HP had a product called an AutoRAID (12 and 12H).  It wa=
s similar to what you describe.  If you added a disk it used it as need=
ed.  Even the "spare" was used for live data.  It used a combination of=
 RAID1 and RAID5.  Writes were to the RAID1 area, during low usage time=
s it would move the RAID1 data to the RAID5 area.  It would also balanc=
e the disks during low usage times.  When you added a disk, it would be=
 out of balance, later it would start to balance the disks.  Any unallo=
cated space (not used for LUNs) was used as extra RAID1 space to improv=
e performance, as was the spare.

It was a real good idea!  The performance sucked....

Guy

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.=
kernel.org] On Behalf Of Jure Pe=C3=A8ar
Sent: Friday, August 13, 2004 10:18 PM
To: linux-raid@vger.kernel.org
Cc: dm-devel@redhat.com
Subject: raid10 ... (was: Re: ANNOUNCE: mdadm 1.7.0)

On Thu, 12 Aug 2004 09:04:21 +1000
Neil Brown <neilb@cse.unsw.edu.au> wrote:

> Data is laid out in a raid0 style, but multiple copies of each chunk
> are possible.  There can be "near" copies, where copies of the one
> block are at the same or similar offsets in different drives, and
> "far" copies, where copies of the one block are at a substantial
> offset from one drive to the next.

=2E.. this really fuels my imagination.

Imagine having a pool of drives, where chunks of data are distributed e=
venly
across all drives in a redundant manner. If one drive dies, the chunks =
that
are not redundant anymore get their copies on the remaining drives, pro=
vided
that there's enough space left; if one or more drives are added to the
array, new chunks are written there until the balance is reached again.

Disk space could be the first key for balancing across the drives, with
transfer rate or seek time maybe added later. Maybe the pool could even
adapt dinamically to the i/o patterns ...=20

Am i dreaming (it's well over 4am here :) ? Or is something like this
possible? Maybe not with a md personality, but by some daemon that woul=
d be
taking care of a dm map?


--=20

Jure Pe=C4=8Dar
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
