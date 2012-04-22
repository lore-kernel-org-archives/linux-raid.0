From: NeilBrown <neilb@suse.de>
Subject: Re: Removing a failing drive from multiple arrays
Date: Mon, 23 Apr 2012 08:55:34 +1000
Message-ID: <20120423085534.4f0074f5@notabene.brown>
References: <4F905F66.6070803@tmr.com>
	<20120420075212.4574111a@notabene.brown>
	<4F948740.8000605@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wKJIhwrTmhopWkVRZYup=L5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F948740.8000605@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/wKJIhwrTmhopWkVRZYup=L5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Apr 2012 18:33:36 -0400 Bill Davidsen <davidsen@tmr.com> wrote:

> NeilBrown wrote:
> > On Thu, 19 Apr 2012 14:54:30 -0400 Bill Davidsen<davidsen@tmr.com>  wro=
te:
> >
> >> I have a failing drive, and partitions are in multiple arrays. I'm
> >> looking for the least painful and most reliable way to replace it. It's
> >> internal, I have a twin in an external box, and can create all the par=
ts
> >> now and then swap the drive physically. The layout is complex, here's
> >> what blkdevtra tells me about this device, the full trace is attached.
> >>
> >> Block device sdd, logical device 8:48
> >> Model Family:     Seagate Barracuda 7200.10
> >> Device Model:     ST3750640AS
> >> Serial Number:    5QD330ZW
> >>       Device size   732.575 GB
> >>              sdd1     0.201 GB
> >>              sdd2     3.912 GB
> >>              sdd3    24.419 GB
> >>              sdd4     0.000 GB
> >>              sdd5    48.838 GB [md123] /mnt/workspace
> >>              sdd6     0.498 GB
> >>              sdd7    19.543 GB [md125]
> >>              sdd8    29.303 GB [md126]
> >>              sdd9   605.859 GB [md127] /exports/common
> >>     Unpartitioned     0.003 GB
> >>
> >> I think what I want to do is to partition the new drive, then one array
> >> at a time fail and remove the partition on the bad drive, and add a
> >> partition on the new good drive. Then repeat for each array until all
> >> are complete and on a new drive. Then I should be able to power off,
> >> remove the failed drive, put the good drive in the case, and the arrays
> >> should reassemble by UUID.
> >>
> >> Does that sound right? Is there an easier way?
> >>
> > I would add the new partition before failing the old but that isn't a b=
ig
> > issues.
> >
> > If you were running a really new kernel, used 1.x metadata, and were ha=
ppy to
> > try out code that that hasn't had a lot of real-life testing you could =
(after
> > adding the new partition) do
> >     echo want_replacement>  /sys/block/md123/md/dev-sdd5/state
> > (for example).
> >
> > Then it would build the spare before failing the original.
> > You need linux 3.3 for this to have any chance of working.
> >
> > NeilBrown
>=20
> I expect to try this in a real world case tomorrow. Am I so lucky that wh=
en=20
> rebuilding the failing drive will be copies in a way which uses a recover=
ed=20
> value for the chunk if there's a bad block? And only if there's a bad blo=
ck, so=20
> that possible evil on the other drives would not be a problem unless they=
 were=20
> at the same chunk?

That's the theory, yes.

>=20
> As soon as the pack of replacements arrives I'll let you know how well th=
is=20
> worked, if at all.
>=20
>=20

Thanks.

NeilBrown


--Sig_/wKJIhwrTmhopWkVRZYup=L5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5SMZjnsnt1WYoG5AQLJ7g//fKXRaZVX8UCVNz8vkujprRqMO7n3U2fh
E81KD1mU0IgZiGawnG/hzqd9Is8Fc74R2zpSrpg1QGGuY2PtGrT0iFMeHxqOtHjY
xP+QsQ/uLMgTTgLLP/z8iysANJhqz3nlTUTn2EQAIkSveJhPXyjRKiJCw5EgVPw2
jaCxJ8NYYtKQ1b7Ey3bbF3sh2OXWeRglTMGeRDxRY8Or4z00d+MI7cktJmjSmbqD
293LvndfKiJqC5X/bieMIePteROnSNFkyp/zOf6S/z7TLPnI5LEs3blcLEuBgyeA
tCOgouSHgof6PcRDu1Rjk/T5ubzRUXHHnv4qC5rFxb8sAVnJT4tkd77yyF26Rbbt
Qy6bCrAy0qMYNEjI9mMMtb9PPm0GP2ZyxTsw7GvA0VJ7+BBenm4OsimXXLQPic5S
mX07z/jnW+wkewLo2FoLBHA34U5JXlDgI2y7TYxsm493shcNoSq6RyrEdWBI9MbQ
Dag+kLNeYqNShczKwAvmkL8IN+J8AI/R8oHXW5jOKia7Yn4/1l4rgN578whRbqIC
14BkX6ytcakAmbxaY4CbyHRXE/260OVkURXJPTZGKfg7J82bOYN9LGggjRvx5FqE
kIkEr8AkjUp9/Cn0/DQV+VNy+X9Aj+jHil4vro8Aj9TguNu+mzPRN/esgXX1JWL4
/EKP8PE6Wb0=
=PgAJ
-----END PGP SIGNATURE-----

--Sig_/wKJIhwrTmhopWkVRZYup=L5--
