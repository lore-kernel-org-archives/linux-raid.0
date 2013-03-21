From: NeilBrown <neilb@suse.de>
Subject: Re: Strange / inconsistent behavior with mdadm -I -R
Date: Thu, 21 Mar 2013 12:22:05 +1100
Message-ID: <20130321122205.3fdca38c@notabene.brown>
References: <51422D10.3040000@arcor.de>
	<20130318103510.45bdd4a8@notabene.brown>
	<5148AE98.9020203@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6B_4X/dSwzilmaV8Kqt=Qmi"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5148AE98.9020203@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6B_4X/dSwzilmaV8Kqt=Qmi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Mar 2013 19:29:44 +0100 Martin Wilck <mwilck@arcor.de> wrote:

> On 03/18/2013 12:35 AM, NeilBrown wrote:
>=20
> > With -R, it only stays inactive until we have the minimum devices neede=
d for
> > a functioning array.  Then it will switch to 'read-auto' or, if the arr=
ay is
> > known and all expected devices are present, it will switch to 'active'.
>=20
> That's the point - I see the array switch to active *before* all
> expected devices are present. That causes further additions to fail.
>=20
> > Maybe if you could provide a sequence of "mdadm" commands that produces=
 an
> > outcome different to what you would expect - that would reduce the chan=
ce
> > that I get confused.
>=20
> Here is the sequence of mdadm commands to illustrate what I mean.
> I have a RAID10 array and I add the devices using mdadm -I -R in the
> sequence 1,3,2,4. After adding device 3, the array will be started in
> auto-read-only mode, which is fine.
>=20
> But then as soon as the next disk (/dev/tosh/rd2) is added, the array
> switches to "active" although it is neither written to, nor all disks
> have been added yet. Consequently, adding disk 4 fails.
>=20
> I expected the array to remain "auto-read-only" until either all 4
> devices are present, or it is opened for writing. This is how the
> container case is behaving (almost - it doesn't switch to active
> automatically until it's written to).
>=20
> # ./mdadm -C /dev/md0 -l 1 -n 4 /dev/tosh/rd[1-4] -pn2
> mdadm: array /dev/md0 started.
> (wait for initial build to finish)
> # mdadm -S /dev/md0
> mdadm: stopped /dev/md0
> # ./mdadm -v -I /dev/tosh/rd1 -R
> mdadm: /dev/tosh/rd1 attached to /dev/md/0, not enough to start (1).
> # ./mdadm -v -I /dev/tosh/rd3 -R
> mdadm: /dev/tosh/rd3 attached to /dev/md/0, which has been started.
> # cat /proc/mdstat
> Personalities : [raid1] [raid10]
> md0 : active (auto-read-only) raid10 dm-6[2] dm-4[0]
>       2094080 blocks super 1.2 512K chunks 2 near-copies [4/2] [U_U_]
> # ./mdadm -v -I /dev/tosh/rd2 -R; cat /proc/mdstat
> mdadm: /dev/tosh/rd2 attached to /dev/md/0 which is already active.
> Personalities : [raid1] [raid10]
> md0 : active raid10 dm-5[1] dm-6[2] dm-4[0]
>       2094080 blocks super 1.2 512K chunks 2 near-copies [4/2] [U_U_]
>       [>....................]  recovery =3D  0.0% (0/1047040)
> finish=3D1090.6min speed=3D0K/sec
> (wait for recovery to finish)
> # ./mdadm -v -I /dev/tosh/rd4 -R
> mdadm: can only add /dev/tosh/rd4 to /dev/md/0 as a spare, and
> force-spare is not set.
> mdadm: failed to add /dev/tosh/rd4 to existing array /dev/md/0: Invalid
> argument.
>=20
> Thanks,
> Martin

Thanks, that makes is all very clear.

The problem is that the ADD_NEW_DISK ioctl automatically converts from
read-auto to active.
There are two approaches I could take to addressing this.
1/ change ADD_NEW_DISK to not cause that conversion.  I think that would ne=
ed
   to be conditional as some times it really should be changed.
2/ change mdadm to not use ADD_NEW_DISK but instead add the disk my setting=
 it
   up via sysfs.

I'm not sure which is best and neither is completely straight forward.
So for now:  I'll get back to you.

Thanks,
NeilBrown

--Sig_/6B_4X/dSwzilmaV8Kqt=Qmi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUUpgvTnsnt1WYoG5AQK5rw/+IOjh0YGT9wVG3sB/U6U4ISB8oeRxvaB5
rmIIFwF9wbhgulrx7Y4KuufN9scyVBS8kNuWLzT2szFP+iiQj7mAdhQM0Ld3WwGG
zYAd/io6urb0a9kAcE7ezdWh1k1rp/QOQgEi3t7Z72xgnTA4cUTxSNqjitfzhagZ
VBJ5QRLCwxpuV6qAziejcZZK9OGPK1OLAEgLSEnBuD0Q5tX/AC7+W3GiddlZ2pvQ
bzG6D2svg2j/ON9Dl9te+90Vktn+SU/gKKEfBjFeGqe/GwLy771iFCkeI9glz+WB
zEBYMyU3KCFxwoTt8Lrk8q+CKmHGMyEXveBTTk9/J7iMA9N2LGORacs8xNpCVYBV
c1+KrHHde8Bz62/6/2lvTz49xldnSgZL8ayDPIIeB4gMuSbFVIJ5eEo6Shz1KA1K
8F4eObA0rNzvJfUxVi+NOF+vYNUm1m3qe8B9PzKsh2sPW1zzMtz6MLdJGyhtGDy2
frXbfUYDnoix/9YcOv5K55sUYZwvJXVfRYa2sjFiVRCh8pwLYOY9kbTRXNmIAdda
Wb7jt9nPiDW5JjT3flvDtyJ1h/VVBviAd1JkYlcjpspm/PfUZb0SC8Y64x5TJQII
Uj3USsLEcWHU2iYir7hyOoEkBL/ymscnXSObvMyZc05ncYp9urOtl5QNfECb83b/
EvGViswhiqM=
=yX+4
-----END PGP SIGNATURE-----

--Sig_/6B_4X/dSwzilmaV8Kqt=Qmi--
