From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: mdadm raid5 single drive fail, single drive out of sync terror
Date: Wed, 26 Nov 2014 16:38:47 +0000
Message-ID: <20141126163847.GB12222@cthulhu.home.robinhill.me.uk>
References: <5475ECDC.6070309@gmail.com>
 <20141126154922.GA12222@cthulhu.home.robinhill.me.uk>
 <5475FC0E.8090701@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5475FC0E.8090701@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Robison, Jon (CMG-Atlanta)" <narfman0@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Nov 26, 2014 at 11:13:02AM -0500, Robison, Jon (CMG-Atlanta) wrote:

> On 11/26/14 10:49 AM, Robin Hill wrote:
> > On Wed Nov 26, 2014 at 10:08:12AM -0500, Jon Robison wrote:
> >
> >> Hi all!
> >>
> >> I upgraded to mdadm-3.3-7.fc20.x86_64, and my raid5 array would no
> >> longer recognize /dev/sdb1 in my raid 5 array (which is normally
> >> /dev/sd[b-f]1). I `mdadm --detail --scan`,  which resulted in a degrad=
ed
> >> array, then added /dev/sdb1, and it started rebuilding happily until 2=
5%
> >> or so, when another failure seemed to occur.
> >>
> >> I am convinced the data is fine on /dev/sd[c-f]1, and that somehow I
> >> just need to inform mdadm about that, but they got out of sync and
> >> /dev/sde1 thinks the array is AAAAA while the others think its AAA.. .
> >> The drives also seem to think e is bad because f said e was bad or some
> >> weird stuff, and sde1 is behind by ~50 events or so. That error hasn't
> >> shown itself recently. I fear sdb is bad and sde is going to go soon.
> >>
> >> Results of `mdadm --examine /dev/sd[b-f]1` are here
> >> http://dpaste.com/2Z7CPVY
> >>
> >> I'm scared and alone. Everything is off and sitting as above, though e
> >> 50 events behind and out of synch. New drives coming Friday and backup
> >> is of course a bit old. I'm petrified to execute `mdadm --create
> >> --assume-clean --level=3D5 --raid-devices=3D5 /dev/md0 /dev/sdf1 /dev/=
sdd1
> >> /dev/sdc1 /dev/sde1 missing`, but that seems my next option unless ya'=
ll
> >> know better. I tried `mdadm --assemble -f /dev/md0 /dev/sdf1 /dev/sdd1
> >> /dev/sdc1 /dev/sde1` and it said something like can't start with only 3
> >> devices (which I wouldn't expect because examine still shows 4, just
> >> that they are out of sync and I thought that was -f's express purpose =
in
> >> assemble mode). Anyone have any suggestions? Thanks!
> > It looks like this is a bug in 3.3 (the checkin logs show something
> > similar anyway). I'd advise getting 3.3.1 or 3.3.2 and retrying the
> > forced assembly.
> >
> > If it failed during the rebuild, that would suggest there's an
> > unreadable block on sde though, which means you'll hit the same issue
> > again when you try to rebuild sdb. You'll need to:
> >      - image sde to a new disk (via ddrescue)
> >      - assemble the array
> >      - add another new disk in to rebuild
> >      - once the rebuild has completed, force a fsck on the array
> >        (fsck -f /dev/md0) as the unreadable block may have caused some
> >        filesystem corruption. It may also cause some file corruption, b=
ut
> >        that's not something that can be easily checked.
> >
> > These read errors can be picked up and fixed by running regular array
> > checks (echo check > /sys/block/md0/md/sync_action). Most distributions
> > have these set up in cron, so make sure that's in there and enabled.
> >
> > The failed disks may actually be okay (sde particularly), so I'd advise
> > checking SMART stats and running full badblocks write tests on them. If
> > the badblocks tests run okay and there's no increase in reallocated
> > sectors reported in SMART, they should be perfectly okay for re-use.
> >
> > Cheers,
> >      Robin
> Thanks you two, I'll check the logs on the machine later. I'm hopeful=20
> about new mdadm, rawhide appears to have 3.3.1 at least... maybe I'll=20
> livecd with 3.3.2..? When I checked yesterday, SMART said everything=20
> (including sdb and sde) was ok, I didn't do badblocks though. dmesg=20
> didn't seem to have anything meaningful, though I'll attach later.
>=20
The full badblocks write test is destructive, so should only be done
once you've got everything recovered from the disks. There is a safe
read-write mode, but that won't do as thorough a test.

> I'm inclined to wait for the disks to come on Friday. When I add them to=
=20
> the backup machine, it should only be ~500GB off, so it could rsync that=
=20
> for a few hours in degraded mode. I'd rather have the 500GB and risk=20
> however many bad blocks. Does that sound logical or will rsyncing with=20
> potential sde bad blocks ruin the whole target filesystem?
>
If the unreadable block contains filesystem metadata or file data which
needs synching, the array will fail when the processing hits it. I'd
expect that to just cause the rsync process to stop, but I wouldn't want
to count on it. I'd run the rsync without deletions first (which should
be safe - worst case is that the file being synced gets corrupted), then
run it with deletions only if everything worked the first time.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlR2AhYACgkQShxCyD40xBKu8gCfWXS4iPeJLM8126WAOWcV0+tr
+roAn1ihmg+KvC05q1xYE+zg6lhfq0r7
=i44x
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
