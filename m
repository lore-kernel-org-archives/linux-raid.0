From: Neil Brown <neilb@suse.de>
Subject: Re: reboot before reshape from raid 5 to raid 6 (was in state
 resync=DELAYED). Doesn't assemble anymore.
Date: Wed, 13 Oct 2010 19:37:59 +1100
Message-ID: <20101013193759.4678186e@notabene>
References: <20101012142752.GA16007@leontine.pompomgali.com>
	<20101013074612.6abbb698@notabene>
	<201010130059.52624.simon@sehier.fr>
	<20101013110823.54d41db2@notabene>
	<20101013081833.GA25675@leontine.pompomgali.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101013081833.GA25675@leontine.pompomgali.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon =?UTF-8?B?U8OJSElFUg==?= <simon@sehier.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 13 Oct 2010 10:18:33 +0200
Simon S=C3=89HIER <simon@sehier.fr> wrote:

> On Wed, Oct 13, 2010 at 11:08:23AM +1100, Neil Brown wrote:
> > On Wed, 13 Oct 2010 00:59:52 +0200
> > Simon S=C3=89HIER <simon@sehier.fr> wrote:
> >=20
> > > On 12 oct. 2010 22:46:12, Neil Brown wrote :
> > > > On Tue, 12 Oct 2010 16:27:53 +0200
> > > >=20
> > > > Simon S <simon@sehier.fr> wrote:
> > > > > Hi all,
> > > > >=20
> > > > > I had a config with 5 disks and 3 raid 5 arrays:
> > > > >=20
> > > > > md2 : system root
> > > > > md3 : swap
> > > > > md4 : data
> > > > >=20
> > > > > I added a 6th disk with the intention of growing my raid5 int=
o raid6.
> > > > >=20
> > > > > The step I used were :
> > > > >=20
> > > > > # mdadm /dev/mdX -a  /dev/newdiskX
> > > > > # mdadm -G --level 6 -n 6 /dev/mdX --backup-file /mdXbackup
> > > > >=20
> > > > >  (yes, with backup file on root partition md2...)
> > > >=20
> > > > Bad idea..  Very bad idea.
> > > >=20
> > > > > The md3 array reshaped without any problem.
> > > > > md2 seemed to reshape well until it reaches 50.4%, then the r=
ebuild speed
> > > > > stalled at 14Kb/s.
> > > >=20
> > > > This is the expected consequence of that bad idea.  Unfortunate=
ly it would
> > > > be hard to reliably get mdadm to complain about that, though I =
guess the
> > > > common cases are easy to protect against ... added to 'todo' li=
st
> > > >=20
> > > > > md4 was still in the state "resync=3DDELAYED" then.
> > > > >=20
> > > > > As the rebuild process seemed hung, I restart the machine ...=
 bad idea.
> > > >=20
> > > > Not really, nothing else would have worked.
> > > >=20
> > > > > Now mdadm refuses to assemble md2 and md4, and displays this =
message :
> > > > >   mdadm: Failed to restore critical section for reshape, sorr=
y.
> > > > >  =20
> > > > >     Possibly you needed to specify the --backup-file
> > > > >=20
> > > > > md2 is my linux installation, not very bad if I lose this one=
=2E
> > > > >=20
> > > > > md4 however contains valuable data.
> > > > >=20
> > > > > While md4 was still in the state resync=3DDELAYED before the =
shutdown, I
> > > > > expect it should not has been (to much) modified and can be r=
ecovered.
> > > >=20
> > > > Very true.
> > > >=20
> > > > > Any idea on how I could safely do it ?
> > > > >=20
> > > > > Should I give a try to the hack "Get 'Grow_restart' to always=
 return 0."
> > > > > mentionned by Neil Brown on 22 april 2010 in this mailing lis=
t ?
> > > >=20
> > > > That is your best bet.  I plan to make that easier to do in mda=
dm-3.2 (no
> > > > recompile necessary).
> > > >=20
> > > > Before you do, check "mdadm -E /dev/newdiskX" and make sure the=
 "Reshape
> > > > position" is 0.  If it is you should be fine.  I
> > > >=20
> > > > It won't be for md2 of course.  So md will quite possible have =
some
> > > > corruption.  Run fsck on it an it will probably be mostly OK, b=
ut there is
> > > > a reasonable chance that some files will be corrupted.  Whether=
 and when
> > > > you will notice is impossible to guess.
> > >=20
> > > Thanks for your answer Neil,=20
> > >=20
> > > I recompiled mdadm 3.1.4 with return 0 in the beginning of the fu=
nction=20
> > > Grow_restart (mistake was made with 3.1.2). I have one more quest=
ion :
> > >=20
> > > I first tried assembling the least valued array, md2. It starts r=
eshaping from=20
> > > where it stops, in the first seconds around 1300 K/s, and rapidly=
 above 10K/s.
> > >=20
> > > While my backup file for md4 (the array I care about) was also on=
 md2. Do I=20
> > > have to expect a problem assembling md4 with the modified version=
 of mdadm, or=20
> > > can I go without worying md2 (rootfs)  isn't assembled ?
> >=20
> > The backup file for md4 would have been essentially empty.  It can =
be created
> > anew elsewhere.  I probably wouldn't rick using the original backup=
 file
> > even if you can access it, as it could be corrupted.
> > So when you assemble md4, give it a fresh backup file in some stabl=
e location,
> > and use the hacked mdadm.
> >=20
> > NeilBrown
> >=20
>=20
> I tried=20
>=20
>  # mdadm -A --backup-file=3D/new-empty-md4backup-file /dev/md4
>=20
> but the array is now in "inactive" state with 6 spares :
>=20
> md4 : inactive sdc4[0](S) sdh4[6](S) sdg4[5](S) sdf4[3](S) sde4[2](S)=
 sdd4[1](S)  =20
>       1411288041 blocks super 1.2
>=20
> I'm a bit confuse on what I could do now.

That surprises me a little.
Try:
  mdadm -S /dev/md4
  mdadm -Avv --backup-file=3D/new-empty-md4backup-file /dev/md4
  dmesg | tail -100
  mdadm -E /dev/sd[cd]4

and send all of the output.

NeilBrown


>=20
> # mdadm -E /dev/sd?4 | grep 'Role\|Stat\|pos\|dev.sd\|Lev\|Time\|Even=
'
> /dev/sdc4:
>      Raid Level : raid6
>           State : active
>   Reshape pos'n : 0
>          Events : 97
>    Device Role : Active device 0
>    Array State : AAAAA. ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdd4:
>      Raid Level : raid6
>           State : active
>   Reshape pos'n : 0
>          Events : 97
>    Device Role : Active device 1
>    Array State : AAAAA. ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sde4:
>      Raid Level : raid6
>           State : active
>   Reshape pos'n : 0
>          Events : 97
>    Device Role : Active device 2
>    Array State : AAAAA. ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdf4:
>      Raid Level : raid6
>           State : active
>   Reshape pos'n : 0
>          Events : 97
>    Device Role : Active device 3
>    Array State : AAAAA. ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdg4:
>      Raid Level : raid6
>           State : active
>   Reshape pos'n : 0
>          Events : 97
>    Device Role : Active device 4
>    Array State : AAAAA. ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdh4:
>      Raid Level : raid6
>           State : active
>   Reshape pos'n : 0
>          Events : 97
>    Device Role : spare
>    Array State : AAAAA. ('A' =3D=3D active, '.' =3D=3D missing)
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
