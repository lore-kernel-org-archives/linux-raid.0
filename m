From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 removing failed disk returns EBUSY
Date: Mon, 17 Nov 2014 10:03:49 +1100
Message-ID: <20141117100349.1d1ae1fa@notabene.brown>
References: <20141027162748.593451be@jlaw-desktop.mno.stratus.com>
	<20141029084113.57f6ae6a@notabene.brown>
	<20141029133604.59f9549a@jlaw-desktop.mno.stratus.com>
	<20141113090549.296a13ee@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/byJ4W3Ed6KaAsP6FSdviJQ7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141113090549.296a13ee@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org, Bill Kuzeja <william.kuzeja@stratus.com>
List-Id: linux-raid.ids

--Sig_/byJ4W3Ed6KaAsP6FSdviJQ7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Nov 2014 09:05:49 -0500 Joe Lawrence <joe.lawrence@stratus.com>
wrote:

> On Wed, 29 Oct 2014 13:36:04 -0400
> Joe Lawrence <joe.lawrence@stratus.com> wrote:
>=20
> > On Wed, 29 Oct 2014 08:41:13 +1100
> > NeilBrown <neilb@suse.de> wrote:
> >=20
> > > On Mon, 27 Oct 2014 16:27:48 -0400 Joe Lawrence <joe.lawrence@stratus=
.com>
> > > wrote:
> > >=20
> > > > Hi Neil,
> > > >=20
> > > > We've encountered changes in MD and mdadm that have broken our auto=
mated
> > > > disk removal script.  In the past, we've been able to run the follo=
wing
> > > > after a RAID1 disk component removal:
> > > >=20
> > > > % echo fail > /sys/block/md3/md/dev-sdr5/state
> > > > % echo remove > /sys/block/md3/md/dev-sdr5/state
> > > >=20
> > > > However, the latest RHEL6.6 code drop has rebased to sufficiently r=
ecent
> > > > MD kernel and mdadm changes, in which the previous commands occasio=
nally
> > > > fail like so:
> > > >=20
> > > > * MD array is usually resyncing or checking
> > > > * Component disk /dev/sdr removed via HBA sysfs PCI removal
> > > > * Following UDEV rule fires:
> > > >=20
> > > > SUBSYSTEM=3D=3D"block", ACTION=3D=3D"remove", ENV{ID_PATH}=3D=3D"?*=
", \
> > > >         RUN+=3D"/sbin/mdadm -If $name --path $env{ID_PATH}"
> > > >=20
> > > > % mdadm --detail /dev/md3
> > > > /dev/md3:
> > > >         Version : 1.1
> > > >   Creation Time : Tue Oct 14 17:31:59 2014
> > > >      Raid Level : raid1
> > > >      Array Size : 25149440 (23.98 GiB 25.75 GB)
> > > >   Used Dev Size : 25149440 (23.98 GiB 25.75 GB)
> > > >    Raid Devices : 2
> > > >   Total Devices : 2
> > > >     Persistence : Superblock is persistent
> > > >=20
> > > >   Intent Bitmap : Internal
> > > >=20
> > > >     Update Time : Wed Oct 15 14:22:34 2014
> > > >           State : active, degraded
> > > >  Active Devices : 1
> > > > Working Devices : 1
> > > >  Failed Devices : 1
> > > >   Spare Devices : 0
> > > >=20
> > > >            Name : localhost.localdomain:3
> > > >            UUID : 40ed68ee:ba41d4cd:28c361ed:be7470b8
> > > >          Events : 142
> > > >=20
> > > >     Number   Major   Minor   RaidDevice State
> > > >        0      65       21        0      faulty
> > > >        1      65        5        1      active sync   /dev/sdj5
> > > >=20
> > > > All attempts to remove this device fail:=20
> > > >=20
> > > > % echo remove > /sys/block/md3/md/dev-sdr5/state
> > > > -bash: echo: write error: Device or resource busy
> > > >=20
> > > > This can be traced to state_store():
> > > >=20
> > > >         } else if (cmd_match(buf, "remove")) {
> > > >                 if (rdev->raid_disk >=3D 0)
> > > >                         err =3D -EBUSY;
> > > >=20
> > > > After much debugging and systemtapping, I think I've figured out th=
at the
> > > > sysfs scripting may fail after the following combination of changes:
> > > >=20
> > > > mdadm  8af530b07fce "Enhance incremental removal."
> > > > kernel 30b8feb730f9 "md/raid5: avoid deadlock when raid5 array has =
unack
> > > >                      badblocks during md_stop_writes"
> > > >=20
> > > > With these two changes:
> > > >=20
> > > > 1 - On the user side, mdadm is trying to set the array_state to rea=
d-auto
> > > >     on incremental removal (as invoked by UDEV rule).=20
> > > >=20
> > > > 2 - Kernel side, md_set_readonly() will set the MD_RECOVERY_FROZEN =
flag,
> > > >     wake up the mddev->thread and if there is a sync_thread, it wil=
l set
> > > >     MD_RECOVERY_INTR and then wait until the sync_thread is set to =
NULL.
> > > >=20
> > > >     When md_check_recovery() gets a chance to run as part of the
> > > >     raid1d() mddev->thread, it may or may not ever get to
> > > >     an invocation of remove_and_add_spares(), for there are but *ma=
ny*
> > > >     conditional early exits along the way -- for example, if
> > > >     MD_RECOVERY_FROZEN is set, the following condition will bounce =
out of
> > > >     the routine:
> > > >=20
> > > >                 if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev-=
>recovery) ||
> > > >                     test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))=
            =20
> > > >                         goto unlock;
> > > >=20
> > > >     the next time around, MD_RECOVERY_NEEDED will have been cleared=
, so
> > > >     all future tests will return 0 and the negation will always tak=
e the
> > > >     early exit path.
> > > >=20
> > > >     Back in md_set_readonly(), it may notice that the MD is still i=
n use,
> > > >     so it clears the MD_RECOVERY_FROZEN and then returns -EBUSY, wi=
thout
> > > >     setting mddev->ro.  But the damage has been done as conditions =
have
> > > >     been set such that md_check_recovery() will never call
> > > >     remove_and_add_spares().
> > > >=20
> > > > This would also explain why an "idle" sync_action clears the wedge:=
 it
> > > > sets MD_RECOVERY_NEEDED allowing md_check_recovery() to continue ex=
ecuting
> > > > to remove_and_add_spares().
> > > >=20
> > > > As far as I can tell, this is what is happening to prevent the "rem=
ove"
> > > > write to /sys/block/md3/md/dev-sdr5/state from succeeding.  There a=
re
> > > > certainly a lot of little bit-states between disk removal, UDEV mda=
dm, and
> > > > various MD kernel threads, so apologies if I missed an important
> > > > transition.
> > > >=20
> > > > Would you consider writing "idle" to the MD array sync_action file =
as a
> > > > safe and reasonable intermediate workaround step for our script?
> > > >=20
> > > > And of course, any suggestions to whether this is intended behavior=
 (ie,
> > > > the removed component disk is failed, but stuck in the array)?
> > > >=20
> > > > This is fairly easy for us to reproduce with multiple MD arrays per=
 disk
> > > > (one per partition) and interrupting a raid check on all of them
> > > > (especially when they are delayed waiting for the first to finish) =
by
> > > > removing the component disk via sysfs PCI removal.  We can provide
> > > > additional debug or testing if required.
> > > >=20
> > >=20
> > > Hi Joe,
> > >  thanks for the details analysis!!
> > >=20
> > > I think the correct fix would be that MD_RECOVERY_NEEDED should be se=
t after
> > > clearing MD_RECOVERY_FROZEN, like the patch below.
> > > Can you confirm that it works for you?
> > >=20
> > > Writing 'idle' should in general be safe, so that could be used as an=
 interim.
> > >=20
> > > Thanks,
> > > NeilBrown
> > >=20
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index c03d87b6890a..2c73fcb82593 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -5261,6 +5261,7 @@ static int md_set_readonly(struct mddev *mddev,=
 struct block_device *bdev)
> > >  		printk("md: %s still in use.\n",mdname(mddev));
> > >  		if (did_freeze) {
> > >  			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> > > +			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > >  			md_wakeup_thread(mddev->thread);
> > >  		}
> > >  		err =3D -EBUSY;
> > > @@ -5275,6 +5276,8 @@ static int md_set_readonly(struct mddev *mddev,=
 struct block_device *bdev)
> > >  		mddev->ro =3D 1;
> > >  		set_disk_ro(mddev->gendisk, 1);
> > >  		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> > > +		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > > +		md_wakeup_thread(mddev->thread);
> > >  		sysfs_notify_dirent_safe(mddev->sysfs_state);
> > >  		err =3D 0;
> > >  	}
> > > @@ -5318,6 +5321,7 @@ static int do_md_stop(struct mddev *mddev, int =
mode,
> > >  		mutex_unlock(&mddev->open_mutex);
> > >  		if (did_freeze) {
> > >  			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> > > +			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > >  			md_wakeup_thread(mddev->thread);
> > >  		}
> > >  		return -EBUSY;
> >=20
> > Hi Neil,
> >=20
> > In my tests, the UDEV "mdadm -If" invocation fails *and* removes the
> > pulled disk from the MD array.  This is okay for our intentions, but I
> > wanted to make sure that it's okay to skip any failed-but-not-removed
> > state.
> >=20
> > Tested-by: Joe Lawrence <joe.lawrence@stratus.com>
> >=20
> > and should this have a
> >=20
> > Fixes: 30b8feb730f9 ("md/raid5: avoid deadlock when raid5 array has una=
ck badblocks during md_stop_writes")
> >=20
> > tag to mark for stable?
>=20
>=20
> Hi Neil,
>=20
> Would you like me to write up a proper patch, or is this one in the queue?
>=20

Several times over the last week I've thought that I should probably push
that patch along ... but each time something else seemed more interesting.
But it's a new week now.  I've just posted a pull request.

Thanks for the prompt (and the report and testing of course).

NeilBrown

--Sig_/byJ4W3Ed6KaAsP6FSdviJQ7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVGktVTnsnt1WYoG5AQLnuQ//UTJzflqucgaW3TVq/MCp/FWolBM9LmPt
hHxfTIGdr9HApPcxKnZvDuj+5qySMO8A6qdmApR5VyyetV8L9nbwdbEemyiw1ube
7pJwVQHipqHn5nzNVODlX5zViK/2WSp+KN9UUaIz5DMX1RR7xYhxwVZtYrVgDM6r
2yYr7NkOB3t3KL+1G6Utt4hL6zMJx8ypsD2asqxCCPpJivDfItc8Y8sHAtjxl7f1
9t+FLx7QlfaNrmMHtBKLSFAiOI6BApnQT1sJ7kd/l5Wq7yNgavyd/CQJ9Ojq0NA0
sRDIrFo8yIFwbpPWJ3spWeXAuX1/sYOlQ1uZX9v5EYriYDx5uB3NziXMysaUxNFF
IOTExLBgtU/859ACBSQ1AL6T9PUxylulPchRJhopO6BHNdeSnoLbHkpfm0QNcqQQ
5CWR75JikhestEtbV5Ct6XpNyWt5l7qhNEpXZIxS4LEQt7shfMLUAjR4VxXzsd+c
ETShgZPJ9N4NoJZYUQqiRFkFepUpmc9w7Y217J08h2cV4rmRvAZHB38yG/t5VmgD
UgIn2iXd+hioNWGV9lHOyRPn8gJGo7dkJEcDJU2Q7NnXQpkocWuk1qAaQa7/V3/U
ERd8BeAYfHfmqZ0NO9mdFih0MbfnQXvyX3TaVJlw7Xtsi7aYT+b8Vn+iB+WsEGYI
j1I5tR94oVo=
=+7Y2
-----END PGP SIGNATURE-----

--Sig_/byJ4W3Ed6KaAsP6FSdviJQ7--
