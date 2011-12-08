From: NeilBrown <neilb@suse.de>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Fri, 9 Dec 2011 09:50:33 +1100
Message-ID: <20111209095033.06136f92@notabene.brown>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu>
	<20111208075709.587ac227@notabene.brown>
	<654BF752-029F-444F-A4AB-68C3CEA7F8D5@ucsc.edu>
	<20111208091651.2a56dd5b@notabene.brown>
	<2866C99D-B573-4EF3-8FD0-0A40B0C20118@ucsc.edu>
	<20111209065140.107aa286@notabene.brown>
	<46200D05-2D7F-44F8-9323-DCFF720776D2@ucsc.edu>
	<20111209075931.29b26b5e@notabene.brown>
	<D1EB6C45-E127-4EC6-BFDD-BDFCC4607981@ucsc.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/f2R8yAzspiBFr_glFxvH.Uo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D1EB6C45-E127-4EC6-BFDD-BDFCC4607981@ucsc.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Morris <ermorris@ucsc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/f2R8yAzspiBFr_glFxvH.Uo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Dec 2011 13:42:44 -0800 Eli Morris <ermorris@ucsc.edu> wrote:

>=20
> On Dec 8, 2011, at 12:59 PM, NeilBrown wrote:
>=20
> > On Thu, 8 Dec 2011 12:39:10 -0800 Eli Morris <ermorris@ucsc.edu> wrote:
> >=20
> >>=20
> >=20
> >>=20
> >> and here is the verbose assemble output:
> >>=20
> >> [root@stratus log]# mdadm --verbose --assemble /dev/md5 --force /dev/s=
da1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /=
dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1=20
> >> mdadm: looking for devices for /dev/md5
> >> mdadm: /dev/sda1 is identified as a member of /dev/md5, slot 0.
> >> mdadm: /dev/sdb1 is identified as a member of /dev/md5, slot -1.
> >> mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 2.
> >> mdadm: /dev/sdd1 is identified as a member of /dev/md5, slot 3.
> >> mdadm: /dev/sde1 is identified as a member of /dev/md5, slot 4.
> >> mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 5.
> >> mdadm: /dev/sdg1 is identified as a member of /dev/md5, slot 6.
> >> mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 7.
> >> mdadm: /dev/sdi1 is identified as a member of /dev/md5, slot -1.
> >> mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 9.
> >> mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 10.
> >> mdadm: /dev/sdl1 is identified as a member of /dev/md5, slot 11.
> >> mdadm: /dev/sdm1 is identified as a member of /dev/md5, slot 12.
> >> mdadm: /dev/sdn1 is identified as a member of /dev/md5, slot 13.
> >> mdadm: /dev/sdo1 is identified as a member of /dev/md5, slot -1.
> >> mdadm: no uptodate device for slot 1 of /dev/md5
> >> mdadm: added /dev/sdc1 to /dev/md5 as 2
> >> mdadm: added /dev/sdd1 to /dev/md5 as 3
> >> mdadm: added /dev/sde1 to /dev/md5 as 4
> >> mdadm: added /dev/sdf1 to /dev/md5 as 5
> >> mdadm: added /dev/sdg1 to /dev/md5 as 6
> >> mdadm: added /dev/sdh1 to /dev/md5 as 7
> >> mdadm: no uptodate device for slot 8 of /dev/md5
> >> mdadm: added /dev/sdj1 to /dev/md5 as 9
> >> mdadm: added /dev/sdk1 to /dev/md5 as 10
> >> mdadm: added /dev/sdl1 to /dev/md5 as 11
> >> mdadm: added /dev/sdm1 to /dev/md5 as 12
> >> mdadm: added /dev/sdn1 to /dev/md5 as 13
> >> mdadm: no uptodate device for slot 14 of /dev/md5
> >> mdadm: no uptodate device for slot 15 of /dev/md5
> >> mdadm: added /dev/sdb1 to /dev/md5 as -1
> >> mdadm: added /dev/sdi1 to /dev/md5 as -1
> >> mdadm: failed to add /dev/sdo1 to /dev/md5: Device or resource busy
> >> mdadm: added /dev/sda1 to /dev/md5 as 0
> >> mdadm: /dev/md5 assembled from 12 drives and 2 spares - not enough to =
start the array.
> >>=20
> >>=20
> >=20
> > Thank.
> >=20
> > I know what the 'busy' thing is now.
> > sdo1 appears the be the 'same' as some other device in some way.
> >=20
> > Also it looks like you might have turned some drives into spares
> > unintentionally, though I'm not sure
> >=20
> > Could you pleas send "mdadm --examine" output for all of these drives a=
nd
> > I'll have a look.
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >=20
> >=20
>=20
> Thanks Neil. I wasn't sure if you wanted the output of all the drives or =
just the 'removed' ones, so here is the output for all the drives in the ar=
ray.
>=20
> Just FYI, I don't know what I could have done to make these spares. Betwe=
en when things worked fine and when they did not, I did not make any hardwa=
re or configuration changes to the array.
>=20

Thanks.  I did want it all (it is always better to give too much than to
little - so thanks).

Those devices have be turned into spares.  Maybe an "--add" command or
possibly even a "--re-add" though it shouldn't.  Newer versions of mdadm are
more careful about this.

You need to re-"Create" the array.  This doesn't affect the data, just writ=
es
new metadata.
It looks like it is safe to assume that none of the devices have been
renamed.  However if you have any reason to believe that the devices don't
belong in the array in the 'obvious' order, you should let me know or adjust
the command below accordingly.

You want to create the array exactly as it was, and you want to make sure
it doesn't immediately start to resync, just in case something goes wrong a=
nd
we want to try again.

All the 'Data Offset's are the same and are 2048 (1M) which is the current
default so that is good.

So:
  mdadm --create /dev/md5 -l5 --layout=3Dleft-symmetric --chunk=3D512 \
  --raid-disks=3D16  --assume-clean /dev/sd[a-p]

This will over-write all the metadata but not touch the data.

Then you probably want to
  fsck -n /dev/md5

to make sure it looks good.  If it does,

 echo check > /sys/block/md5/md/sync_action

That will read all blocks and  make sure parity is correct.  When it finish=
es
check
   /sys/block/md5/md/mismatch_cnt

if this is zero or close to zero, then it is looking very good.
If it is a lot more than zero (as  > 10000) then we probably need to think
again.
If it is small but non-zero, then "echo repair > ...the same /sync_action"
will fix it up.

If fsck showed any issues, run
  fsck -f /dev/md5
to fix them, then mount the filesystem and all should be good.

What version of mdadm do you have?

Thanks,
NeilBrown


--Sig_/f2R8yAzspiBFr_glFxvH.Uo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuE/OTnsnt1WYoG5AQJ1wA//eg63AaJxsm/s8Y6JKXKS7I7GvQtRcIus
wMlGdFwC2neoUaFFH30XMKlOsHna8nQ40fW/FjAXSA6zjEUNPHcaiWjAfB7hVtFc
X2FWyPZHn/PAudMka5qoWziE4esFENJhzP0Cp7xqSRVf9gHzjO8BhdZWrGBZPXgj
WAp4JkTkLtSn2/RCy2U+WFQcEXISnA7UjLjtT45hQsiEKInnROjvp08QuE0aD4Ok
Gx8HVy+S7y+Fdh9eTuY1tSXh4HJ53PxJa+kEXnRcPoJRMht3ttCQhLxyGnFh4EC+
DD7zaLLjOX2uO/EQa4tTSub0uXkbKTeQGN7OHU0FIFcWfTPztBaa5Lk219PpKa8q
9NseDlJ5rbAqrFfO9n2I0BPAp6jO9PEc3g+Bl6ingMwX3E+4yTgyKlSEVpiOK3wL
1CJf2PeDG/HzRSB12togtlzZP9RgpMJ9PnRXN+MKBw+LF+ttBOXBWrfUdutRxoBm
Vb8zpBp4H6D8bvLm+pqOQtugHRJY6oXQQOprN9OBSez01VG8MC2wp/j2cwAV+/DJ
UPkfBMmKAwbNdaAXnEuUQe8lfNn4I+tWQoxec96A/lhqG3TCyUbl5etjvi5Zyq2a
dll00wByilW4bkCuoMgDT0E0ofEqBZ4+qkru/uKI96Q3wcdFGaagqd6sRgxBC+d3
amg0O1s/QKQ=
=74Iv
-----END PGP SIGNATURE-----

--Sig_/f2R8yAzspiBFr_glFxvH.Uo--
