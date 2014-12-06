From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: On RAID5 read error during syncing - array .A.A
Date: Sat, 6 Dec 2014 18:56:00 +0000
Message-ID: <20141206185600.GA2343@cthulhu.home.robinhill.me.uk>
References: <CAB_L8sZoinCMbp7wrjYaQ=XgCOiBWZBLHkMsV_g+nUyM9pc7CQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAB_L8sZoinCMbp7wrjYaQ=XgCOiBWZBLHkMsV_g+nUyM9pc7CQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Emery Guevremont <emery.guevremont@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat Dec 06, 2014 at 01:35:50pm -0500, Emery Guevremont wrote:

> The long story and what I've done.
>=20
> /dev/md0 is assembled with 4 drives
> /dev/sda3
> /dev/sdb3
> /dev/sdc3
> /dev/sdd3
>=20
> 2 weeks ago, mdadm marked /dev/sda3 as failed. cat /proc/mdstat showed
> _UUU. smarctl also confirmed that the drive was dying. So I shutdown
> the server and until I received a replacement drive.
>=20
> This week, I replaced the dying drive with my new drive. Booted into
> single user mode and did this:
>=20
> mdadm --manage /dev/md0 --add /dev/sda3  a cat of /proc/mdstat
> confirmed the resyncing process. The last time I checked it was up to
> 11%. After a few minutes later, I noticed that the syncing stopped. A
> read error message on /dev/sdd3 (have a pic of it if interested)
> appear on the console. It appears that /dev/sdd3 might be going bad. A
> cat /proc/mdstat showed _U_U. Now I panic, and decide to leave
> everything as is and to go to bed.
>=20
> The next day, I shutdown the server and reboot with a live usb distro
> (Ubuntu rescue remix). After booting into the live distro, a cat
> /proc/mdstat showed that my /dev/md0 was detected but all drives had
> an (S) next to it. i.e. /dev/sda3 (S)... Naturally I don't like the
> looks of this.
>=20
> I ran ddrescue to copy /dev/sdd onto my new replacement disk
> (/dev/sda). Everything, worked, ddrescue got only one read error, but
> was eventually able to read the bad sector on a retry. I followed up
> by also cloning with ddrescue, sdb and sdc.
>=20
> So now I have cloned copies of sdb, sdc and sdd to work with.
> Currently running mdadm --assemble --scan, will activate my array, but
> all drives are added as spares. Running mdadm --examine on each
> drives, shows the same Array UUID number, but the Raid Devices is 0
> and raid level is -unknown- for some reason. The rest seems fine and
> makes sense. I believe I could re-assemble my array if I could define
> the raid level and raid devices.
>=20
> I wanted to know if there are a way to restore my superblocks from the
> examine command I ran at the beginning? If not, what mdadm create
> command should I run? Also please let me know if drive ordering is
> important, and how I can determine this with the examine output I'll
> got?
>=20
> Thank you.
>
Have you tried --assemble --force? You'll need to make sure the array's
stopped first, but that's the usual way to get the array back up and
running in that sort of situation.

If that doesn't work, stop the array again and post:
 - the output from mdadm --assemble --force --verbose /dev/md0 /dev/sd[bcd]3
 - any dmesg output corresponding with the above
 - --examine output for all disks
 - kernel and mdadm versions

Good luck,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEUEARECAAYFAlSDUUAACgkQShxCyD40xBLrdACgn9fcQDJ83qi0UWi/KZ+BQkDT
9IgAmJ/MtJI7F/zWwD0KzS8/zcTKzSM=
=tA4S
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
