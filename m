From: NeilBrown <neilb@suse.de>
Subject: Re: raid startup on a live CD?
Date: Tue, 15 Nov 2011 16:03:58 +1100
Message-ID: <20111115160358.5653769c@notabene.brown>
References: <CABTDG88XS6HeGbhj1=iApvsFfifbdjLrO-eoJ4TxNcEcNoyRQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LMvn2aY_Y1ATWCv.OQDQOMN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABTDG88XS6HeGbhj1=iApvsFfifbdjLrO-eoJ4TxNcEcNoyRQg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hank Barta <hbarta@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/LMvn2aY_Y1ATWCv.OQDQOMN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



Could you try again, but add --verbose to --incremental --scan,
report the output, and any message that appear in 'dmesg'.

thanks,
NeilBrown



On Mon, 14 Nov 2011 22:56:40 -0600 Hank Barta <hbarta@gmail.com> wrote:

> Hi folks,
> On occasion I boot a live CD and need to have the md RAID devices
> running. Ordinarily (with Ubuntu live CDs) I find that I need to
> install the mdadm package after booting the live CD. At that point my
> recollection is that the RAID devices get started by the scripts that
> perform the installation (and probably run the startup scripts that
> are in /etc/init.d/...)
>=20
> Earlier today I did this with a distro that is derived from Debian and
> under development. I was happy to see that 'mdadm' was already
> installed. (I had asked for this in fact.) But then I started
> encountering difficulties. The /proc/mdstat file existed but listed no
> RAID personalities and none of my devices were started. I tried 'mdadm
> --assemble -scan' which reported no errors but did not improve the
> situation. I manually loaded the raid0 and raid1 modules (which caused
> the personalities to be listed in /prod/mdstat) and pulled in other
> raid related kernel modules. However 'mdadm --assemble -scan' still
> did not start my devices. I thrashed around a bit before finding a
> command that probed drives and listed the md devices and their UUIDs.
> I was then able to start them using 'mdadm --assemble /dev/md<n>
> --uuid <UUID>' individually for the RAID devices I wanted to start.
>=20
> I'd like to report back to the person working on this distro the
> difficulties I had with the RAID and beyond that, I'd like to provide
> the information that they need to set up RAID so it just works (like
> on a normal boot) if possible and desirable.
>=20
> First... Are there reasons that other live CDs I've used have not set
> up RAID? Live CDs by their nature are somewhat lightweight so if
> adding mdadm uses significant resources perhaps it is best left as a
> manual operation.
>=20
> Is there something I overlooked in getting it started in this
> particular situation?
>=20
> Where should I be looking for documentation that would help
> configuring RAID on a Live CD? I did some searching and the most
> promising thing I found was
> https://raid.wiki.kernel.org/articles/r/a/i/RAID_Boot_bac9.html which
> directs me to a text file in the kernel source tree.
> (http://lxr.linux.no/#linux+v3.1.1/Documentation/filesystems/ramfs-rootfs=
-initramfs.txt)
> And that points to other documentation. I'd appreciate pointers to
> documentation that is particularly relevant to md RAID form a live CD.
>=20
> many thanks,
> hank
>=20
> --
> '03 BMW F650CS - hers
> '98 Dakar K12RS - "BABY K" grew up.
> '93 R100R w/ Velorex 700 (MBD starts...)
> '95 Miata - "OUR LC"
> polish visor: apply squashed bugs, rinse, repeat
> Beautiful Sunny Winfield, Illinois
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/LMvn2aY_Y1ATWCv.OQDQOMN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsHyvjnsnt1WYoG5AQI9AQ/8CEa+6o+wViK6AfFOPe98DeVf8H6578Dn
HEr+pJ5JchjPxbaWbO9BRuqMOF3bix4MZXXQ4Mhd95E9nunNzTQRm6n40LlCRLJG
av+v92CxTFDMnxWYv0Hft8P+2R8HrFE31TtGVDDov57axxcN5zMVqqKItU0TioNz
9f+MB44Fd48p6RCmQ9bnVSyZ5CtkftRYGwKkq7S4MF9omWhLzKYjlEkOSu7eLALh
ex794wJ3Re23quRN9LDijouGGtec/scRLJhjhEeSLfHeUvi4XBWJJLmrd0FH6Cwz
EVDYTS7qTWDItxKsKJUbxB4yi6h5vSfj8ZU+/pMKMVJeRixYPL//cTo1i2sOio1J
QrC4WY63P8y7VecM+fAobk14tV4gMJRMJBe9IRHE5HWiVDzOw3td2A5g2pM4Zt0R
u8owpvE9YB+0Bz9dcwmLP5iTWRJH7rsKDcww4hdRR9dxgamk/m+mgULIuYUYqHfd
Amptm/gaRSM4E9JxJBrt/6G5SXvWsRIO83kovnVmPM+WPgzQ+GFB5hLeyEE7hh8J
obTI1W+XdkNlkra8VyXOE2ho6oUdGWRMrNex782wVxO4H7rKQIyMFjwjY6AOJHeJ
hFcESbf8/cCOmMEgjycTnBSTF++Gl3nmObcxrgrdZvoxhb2daBRWWpdE5DQrgIuE
hLgreCZXx/Y=
=+V/6
-----END PGP SIGNATURE-----

--Sig_/LMvn2aY_Y1ATWCv.OQDQOMN--
