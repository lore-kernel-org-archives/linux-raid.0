From: Neil Brown <neilb@suse.de>
Subject: Re: reboot before reshape from raid 5 to raid 6 (was in state
 resync=DELAYED). Doesn't assemble anymore.
Date: Wed, 13 Oct 2010 11:08:23 +1100
Message-ID: <20101013110823.54d41db2@notabene>
References: <20101012142752.GA16007@leontine.pompomgali.com>
	<20101013074612.6abbb698@notabene>
	<201010130059.52624.simon@sehier.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201010130059.52624.simon@sehier.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Simon =?UTF-8?B?U8OJSElFUg==?= <simon@sehier.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 13 Oct 2010 00:59:52 +0200
Simon S=C3=89HIER <simon@sehier.fr> wrote:

> On 12 oct. 2010 22:46:12, Neil Brown wrote :
> > On Tue, 12 Oct 2010 16:27:53 +0200
> >=20
> > Simon S <simon@sehier.fr> wrote:
> > > Hi all,
> > >=20
> > > I had a config with 5 disks and 3 raid 5 arrays:
> > >=20
> > > md2 : system root
> > > md3 : swap
> > > md4 : data
> > >=20
> > > I added a 6th disk with the intention of growing my raid5 into ra=
id6.
> > >=20
> > > The step I used were :
> > >=20
> > > # mdadm /dev/mdX -a  /dev/newdiskX
> > > # mdadm -G --level 6 -n 6 /dev/mdX --backup-file /mdXbackup
> > >=20
> > >  (yes, with backup file on root partition md2...)
> >=20
> > Bad idea..  Very bad idea.
> >=20
> > > The md3 array reshaped without any problem.
> > > md2 seemed to reshape well until it reaches 50.4%, then the rebui=
ld speed
> > > stalled at 14Kb/s.
> >=20
> > This is the expected consequence of that bad idea.  Unfortunately i=
t would
> > be hard to reliably get mdadm to complain about that, though I gues=
s the
> > common cases are easy to protect against ... added to 'todo' list
> >=20
> > > md4 was still in the state "resync=3DDELAYED" then.
> > >=20
> > > As the rebuild process seemed hung, I restart the machine ... bad=
 idea.
> >=20
> > Not really, nothing else would have worked.
> >=20
> > > Now mdadm refuses to assemble md2 and md4, and displays this mess=
age :
> > >   mdadm: Failed to restore critical section for reshape, sorry.
> > >  =20
> > >     Possibly you needed to specify the --backup-file
> > >=20
> > > md2 is my linux installation, not very bad if I lose this one.
> > >=20
> > > md4 however contains valuable data.
> > >=20
> > > While md4 was still in the state resync=3DDELAYED before the shut=
down, I
> > > expect it should not has been (to much) modified and can be recov=
ered.
> >=20
> > Very true.
> >=20
> > > Any idea on how I could safely do it ?
> > >=20
> > > Should I give a try to the hack "Get 'Grow_restart' to always ret=
urn 0."
> > > mentionned by Neil Brown on 22 april 2010 in this mailing list ?
> >=20
> > That is your best bet.  I plan to make that easier to do in mdadm-3=
=2E2 (no
> > recompile necessary).
> >=20
> > Before you do, check "mdadm -E /dev/newdiskX" and make sure the "Re=
shape
> > position" is 0.  If it is you should be fine.  I
> >=20
> > It won't be for md2 of course.  So md will quite possible have some
> > corruption.  Run fsck on it an it will probably be mostly OK, but t=
here is
> > a reasonable chance that some files will be corrupted.  Whether and=
 when
> > you will notice is impossible to guess.
>=20
> Thanks for your answer Neil,=20
>=20
> I recompiled mdadm 3.1.4 with return 0 in the beginning of the functi=
on=20
> Grow_restart (mistake was made with 3.1.2). I have one more question =
:
>=20
> I first tried assembling the least valued array, md2. It starts resha=
ping from=20
> where it stops, in the first seconds around 1300 K/s, and rapidly abo=
ve 10K/s.
>=20
> While my backup file for md4 (the array I care about) was also on md2=
=2E Do I=20
> have to expect a problem assembling md4 with the modified version of =
mdadm, or=20
> can I go without worying md2 (rootfs)  isn't assembled ?

The backup file for md4 would have been essentially empty.  It can be c=
reated
anew elsewhere.  I probably wouldn't rick using the original backup fil=
e
even if you can access it, as it could be corrupted.
So when you assemble md4, give it a fresh backup file in some stable lo=
cation,
and use the hacked mdadm.

NeilBrown


>=20
>=20
> >=20
> > NeilBrown
> >=20
> > > Thank for any advices,
> > >=20
> > > Cheers,
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
