From: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@inprovide.com>
Subject: Re: Checking if RAID does work?
Date: Wed, 19 Jan 2005 23:52:27 +0100
Message-ID: <yw1xfz0xxc9g.fsf@ford.inprovide.com>
References: <20050117010355.GH347@unthought.net> <200501192217.29258.maarten@ultratux.net>
 <yw1xk6q9xgg6.fsf@ford.inprovide.com>
 <200501192259.46359.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten <maarten@ultratux.net> writes:

> On Wednesday 19 January 2005 22:22, M=E5ns Rullg=E5rd wrote:
>> maarten <maarten@ultratux.net> writes:
>> > To the OP: Yes, every part of a raid-1 array (but only a raid-1
>> > array) will / should be mountable and have the same filesystem as
>> > the array has.  HOWEVER you should never ever mount the array AT T=
HE
>> > SAME TIME as one of its underlying devices!  Always umount first,
>> > and only then mount the other.
>>
>> Furthermore, never ever mount a raid-1 component alone in read-write
>> mode.  Modifying the mirrors individually will almost certainly resu=
lt
>> in breakage when the array is activated again.
>
> Speaking from personal experience, I _think_ that modifying a drive t=
hat's=20
> part of an array gets noticed by md (somehow).  At least it always le=
ad to a=20
> mirror breakage with me, and thus a re-add and a resync was in order.
>
> I'm not sure if it really does that, and neither how it is done, but =
I'm led=20
> to believe it does get noticed. Maybe md (or the kernel?) writes a ma=
rker=20
> just before deactivation which signifies "drive was shutdown @..." ?

If the array is stopped, and then the disks tampered with, there is no
way md is noticing it.  It's possible, however, that md will notice if
a disk is accessed directly while the array is active.

--=20
M=E5ns Rullg=E5rd
mru@inprovide.com

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
