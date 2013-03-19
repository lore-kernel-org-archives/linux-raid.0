From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0 of 2 - v2] DM RAID: Add message/status support for
 changing sync action
Date: Wed, 20 Mar 2013 10:43:17 +1100
Message-ID: <20130320104317.16a8d9c7@notabene.brown>
References: <1363713352.11184.15.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EdWJMHe/vPnlmtwLHtVK_f9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1363713352.11184.15.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, agk@redhat.com
List-Id: linux-raid.ids

--Sig_/EdWJMHe/vPnlmtwLHtVK_f9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Mar 2013 12:15:52 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
>=20
> I've made the updates which Alasdair suggested, re-worked the patch to
> apply to 3.9.0-rc3 instead of 3.8.0, and split the patch into two
> pieces:
> - export reap_sync_thread: to ensure completion of "idle"/"frozen"
> commands
> - Add message/status support for changing sync action

Thanks - look good.  Hopefully will appear in my -next some time this
week.... unless they should  go through the dm tree(?).

>=20
> I still have two questions though:
> 1)  The mismatch_count is only valid after a "check" has been run,
> right?  If I run a "repair", I would expect it to be reset upon
> completion, but it is not - not until "check" has been run again.  Is
> this the expected behavior?

mismatch count is the number of mismatches (in sectors) found in the last
check or repair - and possibly sync depending on how sync is implemented for
that personality.

So you run 'check' and then mismatch_cnt says how many mismatches were
found but not repaired.
Then you run 'repair' and  mismatch_cnt says how many mismatches were
found and repaired, hopefully the same number as with 'check'.
Then you run 'check' again and hopefully mismatch_cnt will be '0'.

i.e. it isn't how many mismatches there "are", only how many were "found".


> 2)  It is possible to issue "frozen" on an array that is undergoing
> "resync" and then issue a "check".  I would expect an EBUSY or
> something.  Additionally, checkpointing seems to be done and seems to
> make it possible to e.g. "resync" the first 25%, "check" the second 25%
> and then finish the last half with a "resync" again.  This would be
> really stupid of the user, but should we catch it?  (This would probably
> be a follow-on patch if "yes".)

There are 3 distinct operations: sync, reshape, and recovery.  Only one of
these can be happening at a time.  If sync or reshape are needed/requested,
they take priority over recovery.  And  sync takes priority over reshape.

There are 3 varieties of sync:
  normal sync
  'check'
  'repair'

normal sync will only process blocks that might not be in sync, so it checks
with the bitmap and the "recovery_cp".  If you try to trigger a sync when
none is needed, then no blocks will be synced.

check and repair ignore the bitmap and the recovery_cp and process every
block, always checking, possibly repairing.

So if a sync is needed and a 'check' is requested then there are several
options:
 - the 'check' request could be rejected
 - those blocks that require 'sync' could get synced anyway, others get
   'checked'.
 - all blocks get 'check'ed, but the bitmap and recovery_cp don't get updat=
ed
   so a subsequent 'sync' (which will happen automatically) will fix
   everything that needs fixing.

I don't feel strongly between these, but I do think it would be wrong if the
'check' causes a 'sync' not to happen, but still updated the bitmap and
recovery_cp.

I think I lean slightly toward the third option, but then we would need to =
be
careful never to allow a 'sync' to start beyond the current 'recover_cp', as
then the accounting would almost certainly get messed up.

So if you would like to examine the code to see exactly what does happen,
propose which of those three you would prefer, and provide a patch which
makes it happen, that would make me quite happy :-)

Thanks,
NeilBrown


>=20
> Thanks,
>  brassow
>=20
> P.S.  Here is the expected (and tested) output of the various states if
> interested:
> Initial (automated) sync:
> - health_chars should all be 'a'
> - sync_ratio should show progress
> - sync_action should be "resync"
> [root@bp-01 ~]# dmsetup table vg-lv; dmsetup status vg-lv
> 0 10485760 raid raid1 3 0 region_size 1024 2 254:3 254:4 254:5 254:6
> 0 10485760 raid raid1 2 aa 5029120/10485760 resync 0
>=20
> Nominal state:
> - health_chars should all be 'A'
> - sync_ratio should show 100% (same numerator and denominator)
> - sync_action should be "idle"
> [root@bp-01 ~]# dmsetup table vg-lv; dmsetup status vg-lv
> 0 10485760 raid raid1 3 0 region_size 1024 2 254:3 254:4 254:5 254:6
> 0 10485760 raid raid1 2 AA 10485760/10485760 idle 0
>=20
> Rebuild/replace a device:
> - health_chars show devices being replaced as 'a', but others as 'A'
> - sync_ratio should show progress
> - sync_action should be "recover"
> [root@bp-01 ~]# dmsetup table vg-lv; dmsetup status vg-lv
> 0 10485760 raid raid1 3 0 region_size 1024 2 254:8 254:9 254:5 254:6
> 0 10485760 raid raid1 2 aA 655488/10485760 recover 0
>=20
> Check/scrub:
> - health_chars should all be 'A'
> - sync_ratio should show progress of "check"
> - sync_action should be "check"
> [root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
> 0 10485760 raid raid1 3 0 region_size 1024 2 254:3 254:4 254:5 254:6
> 0 10485760 raid raid1 2 AA 1310976/10485760 check 0
>=20
> Repair:
> - health_chars should all be 'A'
> - sync_ratio should show progress of "repair"
> - sync_action should be "repair"
> [root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
> 0 10485760 raid raid1 3 0 region_size 1024 2 254:3 254:4 254:5 254:6
> 0 10485760 raid raid1 2 AA 655488/10485760 repair 0
>=20
> Check/scrub (when devices differ):
> - health_chars should all be 'A'
> - sync_ratio should show progress of "check"
> - sync_action should be "check"
> - mismatch_cnt should show a count of discrepancies
> [root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
> 0 10485760 raid raid1 3 0 region_size 1024 2 254:8 254:9 254:5 254:6
> 0 10485760 raid raid1 2 AA 655488/10485760 check 81920
>=20
> Repair:
> - health_chars should all be 'A'
> - sync_ratio should show progress of "repair"
> - sync_action should be "repair"
> - IS MISMATCH_CNT INVALID UNTIL A "check" IS RUN AGAIN?
> - SHOULD "repair" RESET MISMATCH_CNT WHEN FINISHED?
> [root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
> 0 10485760 raid raid1 3 0 region_size 1024 2 254:8 254:9 254:5 254:6
> 0 10485760 raid raid1 2 AA 655488/10485760 repair 81920
> [root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
> 0 10485760 raid raid1 3 0 region_size 1024 2 254:8 254:9 254:5 254:6
> 0 10485760 raid raid1 2 AA 10485760/10485760 idle 81920
>=20
> Possible issues:
> - We can freeze initialization and then start a check instead.
>   SHOULD THIS PRODUCE AN ERROR (like EBUSY)?
> [root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
> 0 10485760 raid raid1 3 0 region_size 1024 2 254:3 254:4 254:5 254:6
> 0 10485760 raid raid1 2 aa 2715136/10485760 resync 0
> [root@bp-01 linux-upstream]# dmsetup message vg-lv 0 frozen
> [root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
> 0 10485760 raid raid1 3 0 region_size 1024 2 254:3 254:4 254:5 254:6
> 0 10485760 raid raid1 2 aa 5558784/10485760 frozen 0
> [root@bp-01 linux-upstream]# dmsetup message vg-lv 0 check
> [root@bp-01 linux-upstream]# dmsetup table vg-lv; dmsetup status vg-lv
> 0 10485760 raid raid1 3 0 region_size 1024 2 254:3 254:4 254:5 254:6
> 0 10485760 raid raid1 2 AA 655488/10485760 check 0
>=20
>=20


--Sig_/EdWJMHe/vPnlmtwLHtVK_f9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUUj4FTnsnt1WYoG5AQJz7Q/+ILRtCeTedbgqk2P8hvllTvMwFtozN6Cy
Ouopz4LpIi5d2wgIH8CX6bXp3+zmn5GVqGyuf2vvdKLwn/6QVAszHyh0C7SdC91L
PTF1yjOixyAJAImv4s6Pjqgh6+M0H9cg6rwlOG40Ab/g2/FQqtoIiQ3Qfo2ht7dF
ijEX3lKqYdcxgI32qqK3+vuipJk6Dg0Jl95duOJiTWLycaxteLyS8CaGoKRGsIV7
90Q9g8xRvygoFdnCbvZzVg8YET8sbfO7kgpZS4ehZa7f3QiJc7EKBKcgMA9XiXQ2
RD+II82L35jc8puNPoJmO+eOQVdKezZI4Zp4saw02LGNvvZcxoLHG3IJ6D0SEmGr
XqfmAbBuyxKjI/Cz9stxNN/023XE2pUkDAXaDbV86/AxOckTGELnVOt2IcMtD2Qv
45GT+JkcLEZwuccUQk6d7F/Ru2XCILtAfW43YQU5o73ibHS8AWbMtXJC3hObx733
fU2WOxKZ9fosvjLCxfsdpynKcpBdiRticXjg7dWNsxh/DhHNBH4sBoY8FkRdvj+9
Oi8iBLgjY6MxgvwnMyUCphellI6kD3jFDyZkTrVF1ch+JOME7rCvLmjr90FDZw12
z1cRrGpZ68tOH8gjNwrIcfciiw35ftqI8D9WRC+qoYclnQ9zGClY+CbyhfTP+aT3
qA/2iBMwi00=
=umQU
-----END PGP SIGNATURE-----

--Sig_/EdWJMHe/vPnlmtwLHtVK_f9--
