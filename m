From: maarten <maarten@ultratux.net>
Subject: Re: Checking if RAID does work?
Date: Wed, 19 Jan 2005 22:59:46 +0100
Message-ID: <200501192259.46359.maarten@ultratux.net>
References: <20050117010355.GH347@unthought.net> <200501192217.29258.maarten@ultratux.net> <yw1xk6q9xgg6.fsf@ford.inprovide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yw1xk6q9xgg6.fsf@ford.inprovide.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 19 January 2005 22:22, M=E5ns Rullg=E5rd wrote:
> maarten <maarten@ultratux.net> writes:
> > To the OP: Yes, every part of a raid-1 array (but only a raid-1
> > array) will / should be mountable and have the same filesystem as
> > the array has.  HOWEVER you should never ever mount the array AT TH=
E
> > SAME TIME as one of its underlying devices!  Always umount first,
> > and only then mount the other.
>
> Furthermore, never ever mount a raid-1 component alone in read-write
> mode.  Modifying the mirrors individually will almost certainly resul=
t
> in breakage when the array is activated again.

Speaking from personal experience, I _think_ that modifying a drive tha=
t's=20
part of an array gets noticed by md (somehow).  At least it always lead=
 to a=20
mirror breakage with me, and thus a re-add and a resync was in order.

I'm not sure if it really does that, and neither how it is done, but I'=
m led=20
to believe it does get noticed. Maybe md (or the kernel?) writes a mark=
er=20
just before deactivation which signifies "drive was shutdown @..." ?

OTOH, I've also seen that I just modified /etc/fstab on hda1 to reflect=
 that=20
not /de/hda1 was root, but /dev/md0 instead, only to find that after a=20
reboot /dev/md0 is _indeed_ now mounted as root, but that those recent=20
changes in /fstab are gone.  So... maybe I'm just losing my head. (-:

Maarten

--=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
