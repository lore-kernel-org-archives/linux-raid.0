From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: Add ability for disable bad block management
Date: Wed, 7 Dec 2011 12:52:55 +1100
Message-ID: <20111207125255.51382e59@notabene.brown>
References: <20111124121953.5509.28118.stgit@gklab-128-013.igk.intel.com>
	<20111130111403.7efd3875@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A054C28@IRSMSX101.ger.corp.intel.com>
	<20111206170525.1f4e32ab@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A055919@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/I_kztFreehjYFeLQFj8L4AK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A055919@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/I_kztFreehjYFeLQFj8L4AK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Dec 2011 13:02:21 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

>=20
>=20
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Tuesday, December 06, 2011 7:05 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Willia=
ms,
> > Dan J
> > Subject: Re: [PATCH] md: Add ability for disable bad block management
> >=20
> > On Wed, 30 Nov 2011 08:17:32 +0000 "Kwolek, Adam"
> > <adam.kwolek@intel.com>
> > wrote:
> >=20
> > >
> > >
> > > > -----Original Message-----
> > > > From: NeilBrown [mailto:neilb@suse.de]
> > > > Sent: Wednesday, November 30, 2011 1:14 AM
> > > > To: Kwolek, Adam
> > > > Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin;
> > > > Williams, Dan J
> > > > Subject: Re: [PATCH] md: Add ability for disable bad block
> > > > management
> > > >
> > > > On Thu, 24 Nov 2011 13:19:53 +0100 Adam Kwolek
> > > > <adam.kwolek@intel.com> wrote:
> > > >
> > > > > When external metadata doesn't support BBM, mdadm cannot answer
> > > > > correctly for BBM requests. It causes reshape process being stopp=
ed.
> > > > >
> > > > > Add ability for external metadata /mdadm/ to disable BBM via sysf=
s.
> > > > > md will ignore bad blocks as it is for metadata v0.90.
> > > >
> > > > This should not be necessary.
> > > >
> > > > The intention is that a device with a bad block looks exactly like a
> > > > device with a failed device.  i.e. 'faulty' and 'blocked' appear in=
 the 'state'
> > > > file.
> > > >
> > > > If the metadata doesn't support a bad-block list, it will record
> > > > that the device has failed and will unblock the device.  At that po=
int the
> > failure is forced.
> > > > If the metadata does support a bad block list it will just record
> > > > the bad blocks and acknowledge them, and the unblock the device.  At
> > > > that point the device won't be failed, the 'faulty' state will
> > > > disappear, and it will continue to be used with the known bad block=
s.
> > > >
> > > > What exactly is going wrong that makes you think you need this patc=
h?
> > >
> > >
> > > When degradation occurs during migration BBM is signaled to mdmon and
> > mdmon /monitor.c/ tries to mark disk  '-blocked'
> > > This operation fails. Momon goes in to loop, and nothing can be done =
/I
> > cannot make it using sysfs/ to signal or remove device.
> > > In sysfs device is present in /sys/block/mdXXX/md but entry
> > /sys/block/mdXXX/md/dev-sdX/~block is missing /disk was pulled out/.
> >=20
> >=20
> > I've found a couple of issues.  I'm not sure if they completely explain=
 what
> > you are seeing.  Could you please test with these two fixes and tell me=
 the
> > results?
> >=20
> > Firstly, I find that writing "-blocked" succeeds (no error returned) bu=
t the
> > "blocked" flag does not get cleared, which is certainly confusing.
> >=20
> > This is fixed by:
> >=20
> > diff --git a/drivers/md/md.c b/drivers/md/md.c index 4adcbb4..7258dc1
> > 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -2562,7 +2562,8 @@ state_show(struct md_rdev *rdev, char *page)
> >  		sep =3D ",";
> >  	}
> >  	if (test_bit(Blocked, &rdev->flags) ||
> > -	    rdev->badblocks.unacked_exist) {
> > +	    (rdev->badblocks.unacked_exist
> > +	     && !test_bit(Faulty, &rdev->flags))) {
> >  		len +=3D sprintf(page+len, "%sblocked", sep);
> >  		sep =3D ",";
> >  	}
> >=20
> >=20
> > Secondly mdmon writes "-blocked" even when the "blocked" flag is not se=
t.
> > This succeeds so state_store() calls
> > 		sysfs_notify_dirent_safe(rdev->sysfs_state);
> >=20
> > so mdmon/monitor.c is woken up to go around the loop again and it write=
s "-
> > blocked" again and so it continues in a loop.
> >=20
> > This is fixed by:
> >=20
> > diff --git a/monitor.c b/monitor.c
> > index b002e90..29bde18 100644
> > --- a/monitor.c
> > +++ b/monitor.c
> > @@ -339,7 +339,8 @@ static int read_and_act(struct active_array *a)
> >  			a->container->ss->set_disk(a, mdi->disk.raid_disk,
> >  						   mdi->curr_state);
> >  			check_degraded =3D 1;
> > -			mdi->next_state |=3D DS_UNBLOCK;
> > +			if (mdi->curr_state & DS_BLOCKED)
> > +				mdi->next_state |=3D DS_UNBLOCK;
> >  			if (a->curr_state =3D=3D read_auto) {
> >  				a->container->ss->set_array_state(a, 0);
> >  				a->next_state =3D active;
> >=20
> >=20
> > Finally, when a badblock is added to the list we don't currently notify
> > rdev->sysfs_state so mdmon doesn't notice straight away and so is
> > rdev->delayed in
> > taking action.  It will only notice when a write blocks.
> >=20
> > This is fixed by:
> >=20
> > diff --git a/drivers/md/md.c b/drivers/md/md.c index 4adcbb4..9cc7983
> > 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -7940,6 +7941,7 @@ int rdev_set_badblocks(struct md_rdev *rdev,
> > sector_t s, int sectors,
> >  				  s + rdev->data_offset, sectors,
> > acknowledged);
> >  	if (rv) {
> >  		/* Make sure they get written out promptly */
> > +		sysfs_notify_dirent_safe(rdev->sysfs_state);
> >  		set_bit(MD_CHANGE_CLEAN, &rdev->mddev->flags);
> >  		md_wakeup_thread(rdev->mddev->thread);
> >  	}
> >=20
> >=20
> > With these 3 changes in place I get substantially improved behaviour on=
 my
> > simple test (just doing resync, not reshape).
> >=20
> > Thanks,
> > NeilBrown
>=20
> I've applied those changes and:
> 1.  Migration:
> 	a) with additionally disabled BBM, reshape continues after degradation a=
nd performance is not lower (without your patches performance was poor and =
mdmon goes in to "crazy" run).
> 	b) with enabled BBM (without my change), metadata is updated correctly a=
nd md stops. mdstat shows that reshape is in progress but it is not moving =
forward
> 2. Rebuild:
> 	a) with additionally disabled BBM, rebuild is stopped  correctly in md a=
nd metadata just after degradation (I've got few additional corrections for=
 metadata rebuild finalization, I'll post it shortly).=20
> 	b) with enabled BBM (without my change), metadata is updated correctly a=
nd md stops. mdstat shows that rebuild is in progress but it is not moving =
forward
>=20
>=20
> It seems that those changes helps for reshape performance drop after degr=
adation and "crazy" mdmon run.=20
> In md without blocking BBM still md_do_sync() doesn't finish on degradati=
on during reshape and rebuild. This causes process to be stopped.
> The last information from md is print out from md_error() and it probably=
 waits on BBM confirmation.
>=20
> What can be different in my tests is that I physically pull out disks to =
get raid degraded (I'm not using sysfs to do this). After this rdev link in=
 md device is invalid.
>=20
> Please let me know if you want to any additional tests made by me /any sp=
ecific logs?/.
>=20
>

I cannot reproduce this.
I didn't physically remove devices, but I used
   echo 1 > /sys/block/sdc/device/delete

which should be nearly identical from the perspective of md and mdadm.

If you could give me the exact set of steps that you follow to produce the
problem that would help - maybe a script?  Just a description is OK.

Also you say it is blocking in md_do_sync.  Is that at the=20

	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));

call just after the "out:" label?

What is the raid thread doing at this point? =20
   cat /proc/PID/stack
might help.

What are the contents of all the sysfs files?
   grep . /sys/block/mdXXX/md/*
   grep . /sys/block/mdXXX/md/dev-*/*

Thanks,
NeilBrown


--Sig_/I_kztFreehjYFeLQFj8L4AK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt7G9znsnt1WYoG5AQKfTBAAurDhaHizEQYpmxF3LLEPWbtGAfy6tILJ
JP51LrTbveMGcJmkAgdZJCWT84zPtFn/+EF3XGjLNUQlz1mGuzdlFbU51PyGy9Sf
MVJ0sIllCfuA5aSE766aDrffBLUnjQpSlKwoyfZN2SCw6odzWNHRDF9/ooeQmNEL
Di4EtBZPeQn9+LxTeTJAsHVAIse3D9/fNGITAWqDcION9ybsf8Q7wQHvERCfP/Ks
tPFuPsFAB7KgSulhKVPokcRYB3ylrdiceVwLuI7YUU/aMxoOD5/MHJDLoSFUo+fq
hG7DdcAYWxM+3oHcdgwTNfV2Il+6LIwTMt2JBRoDScuLaDdXM+xGAwO/Ranq3UWo
jPwKuFyITMhaVDkr2bZ7wf4hyFj8Je7QsILgPrt7Huns8KEDFnsGjIRsdoiVQpOg
Ktl3ysxcodAgBmJw4Ck5ctQzAVmiy4dRx76cnfADQ4uSkQA72IW8RPRyqmo6SeYz
+k9qGUWhrgZkX0JsqtEaE6K9lq/OJ9QiMPcAPCXQ8V/TW9M1vgmHfIKi98joEIgF
342Vx8WNB1P7pGE8kBwaWPIjjkz+R6I9JrDixbqqF7FQ8bZwvrsmTJjkZDDwoh2L
mB2iHd3DJ4xWkpsbYxg04+46aDfGOxfHEUed0zd5z/bNTt1/skk1KYTH5NYOWjlh
Cq3bHNF+qZ4=
=PnCH
-----END PGP SIGNATURE-----

--Sig_/I_kztFreehjYFeLQFj8L4AK--
