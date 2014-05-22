From: NeilBrown <neilb@suse.de>
Subject: Re: Rebuilding a RAID5 array after drive (hardware) failure
Date: Thu, 22 May 2014 14:49:05 +1000
Message-ID: <20140522144905.50511c1a@notabene.brown>
References: <CAG__1a52uiLi8PAm6deHyx14yQ8JfOmaiOicEn86kYBqJG_1HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zu06TBOMHEWyBxD8x8gfUGr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG__1a52uiLi8PAm6deHyx14yQ8JfOmaiOicEn86kYBqJG_1HQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Duffield <forumscollective@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/zu06TBOMHEWyBxD8x8gfUGr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 22 May 2014 06:31:58 +0200 George Duffield
<forumscollective@gmail.com> wrote:

> I have a RAID5 array comprised of 4 x 3TB Seagate 7200 RPM SATAII
> drives.    The array was created on Ubuntu Server running on a HP
> Microserver N54L using the following command:
>=20
> sudo mdadm --create --verbose /dev/md0 --raid-devices=3D4 --level=3D5
> /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
>=20
> Formatted using:
> mkfs.ext4 -b 4096 -E stride=3D128,stripe-width=3D384 /dev/md0
>=20
> The array is mounted in /etc/fstab by reference to its UUID and is now
> near full.
>=20
> A few days back I turned on the server to access some of the files
> stored on it when I found the server was not present on the network.
> Inspecting the actual server (connected kb & monitor) I noticed that
> the machine had not progressed beyond the BIOS post screen =E2=80=93 one =
of
> the drives had become damaged (2nd drive in same slot in same
> Microserver to be damaged the same way =E2=80=93 drive spins up fine, mac=
hine
> knows it's there, but can't communicat successfully with the drive).
> In any event, suffice it to say the drive is history =E2=80=93 it and the
> Microserver will be RMAd when this is over.
>=20
> So, I'm now left with a degraded array comprising 3x3TB drives. I've
> purchased a replacement drive (same make and model) in the interim
> (and I've yet to boot this machine with the old drive removed or the
> new one inserted i.e. from an OS standpoint Ubuntu/mdadm does not yet
> know the array is degraded).
>=20
> As I've lost complete faith in the Microserver (and it may very well
> damage the new drive during recovery of the array) I've also purchased
> and assembled a 2nd machine with 6 on board SATA ports rather than
> rely on another Microserver.  My intention is to remove the drives
> from the Microserver and install them in the new machine (which I'll
> boot off the same USB flash drive I used to boot the Microserver from
> [to further complicate things it seems my flash drive may also be
> corrupted, so I may have to recover from a fresh Ubuntu install and
> reassemble the array]).
>=20
> A few questions if I may:
> - Is moving the array to another computer and recovering it on the new
> computer running Ubuntu Server likely to present any particular
> challenges?

No.  If you were trying to boot of the array that you moved it might be
interesting.  But as you aren't I cannot see any possible issue (assuming t=
he
hardware functions correctly).

>=20
> - Does the order/ sequence of connection of the drives to the
> motherboard matter?

No.

>=20
> Another way of asking the aforementioned question is whether mdadm
> would care if one swapped drives in Microserver backplane/ PC SATA
> ports such that the physical backplane slot/ SATA port that one/more
> of the drives occupies differs from that it occupied when the array
> was created?

No.  mdadm looks at the content of the devices, not their location.


>=20
> - How would I best approach rebuilding the array, my current thinking
> is as follows:
> =3D Identify with certainty which drive has failed - this will be done
> by removing the OS flash drive from the Microserver and disconnecting
> all drives from the backplane other than the one I believe is faulty
> (first slot on backplane) and booting the machine.  The failed drive
> causes a POST failure and is thus easily identified.
> =3D Remove all drives from the Microserver and install into new PC
> referenced above, at the same time replacing the failed drive with the
> replacement I purchased
> =3D Powering new PC via UPS
> =3D Booting the PC from the flash drive
> =3D Allowing the degraded array to be assembled by mdadm when prompted at=
 boot
> =3D Adding the replacement drive to the array and allowing the array to
> be re-synchronized
> =3D If I'm not able to access the flash drive I will create a fresh
> install of Ubuntu Server and attempt to recreate the array in the
> fresh install.
>=20
> All thoughts/ comments/ guidance much appreciated.

Sounds good.
Though I would discourage the boot sequence from assembling the degraded
array if possible.
Just get the machine up with the drive untouched.  Then use "mdadm -E" to
look at each device and make sure they are what you think they are (e.g.
consistent Event numbers etc).
Then
  mdadm --assemble /dev/mdWHATEVER ..list-of-devices...

Then make sure that looks good.
Then
  mdadm /dev/mdWHATEVER --add new-device

NeilBrown


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/zu06TBOMHEWyBxD8x8gfUGr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU32BwTnsnt1WYoG5AQL4GhAAkFmrACeAjaD4qrx0h0WouZGP6xGWdEep
FyMOFLQ6CP4zvanE9pMRULabEnUHQlr6Jn+FlePwbdTxZMI0FVkAbS2/l1TmMyRw
XDHNk0pCeq/MvyW7j+KaCJPNKLQ09UhuzZ7kIxnnhWIM7k5H26s0Y1ts4CNdQEA+
zJVhRWWl9wkMbavpuwDZxPLVCLuapUmARNhxOAYW35IhoB4arT0EkzdP9bTPwuO1
ffOE5BJnQtFEAMbvQNUQxIInpjPYh3frLmWbrIeRkCMMRFygL2bOnWrsc9dKWQn/
QmNZDLVq5BTLJ5F7985p0GHCsuac5Ybj3lBL6ntTo13q0xQypmRwiPg3zeFbDf9s
OEim5WwfFdOMB3jnp52FXtReJTX58K2aj9+FwntC0P0YmEV6zCwcWRvVUf/GvYht
RNVMsuywResNpRE00zs+i7gg0FOJ8YjtkjmyjjM0Hie+XbDm9rL7K+AaEZ5ZI+86
MBrFMMOkhqwAfJKLnHwmO9idwtfhN+DX1NEaz8DnWh+dTnnCG9ZDiQ8p8YcHxzQX
GatQ5J1xAa4yAmz/iQuUPOitNx3p4gr6ouSjyij+IAoEkBURJY2CHppVPjTwKliY
hvgKkTKWIfNR+wxh+Y8cLHU3mt4HVzS1Ynl1OZrevmY8cO4IgyQmJjN1q1CnsH8n
Xs2x3hDNG/s=
=iNbw
-----END PGP SIGNATURE-----

--Sig_/zu06TBOMHEWyBxD8x8gfUGr--
