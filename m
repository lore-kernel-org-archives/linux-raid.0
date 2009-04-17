From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Converting system to raid
Date: Fri, 17 Apr 2009 08:49:25 +0100
Message-ID: <20090417074924.GA16386@cthulhu.home.robinhill.me.uk>
References: <00f301c9ba23$032025f0$0a00a8c0@vorg> <20090410215129.GD21242@cthulhu.home.robinhill.me.uk> <019701c9ba66$aeed5630$0a00a8c0@vorg> <f19d625d0904110729y30e8bc80m41fcd8f2c3298d49@mail.gmail.com> <007001c9bad6$2525c610$0a00a8c0@vorg> <001201c9bb09$3161e9d0$0a00a8c0@vorg> <20090412111107.GA19413@cthulhu.home.robinhill.me.uk> <000b01c9bba8$a5b08a40$0a00a8c0@vorg> <20090414093015.GA19074@cthulhu.home.robinhill.me.uk> <002e01c9bef6$0c84c5b0$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <002e01c9bef6$0c84c5b0$0a00a8c0@vorg>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Apr 16, 2009 at 05:47:10PM -0700, Timothy D. Lenz wrote:

> Welllll, tried to switch the other system over to raid boot and
> something went wrong ether with the copy or with menu.lst change or
> with grub, I think. I changed the boot order moving the ide below the
> 3 sata drives and before the grub boot menu came up I got an "error
> 2"
>=20
> This system is booting from hda1 and will be booting from md0 like the
> other system. This system has 3 sata drives, so md0 and md1 where
> setup has raid1 plus spare.
>=20
Why have a spare?  You'd be better running 3-drive RAID1 arrays.

> To set up group I used:
> sudo grub --no-floppy
>=20
> Grub> device (hd0) /dev/sda
> Grub> root (hd0,0)
> Grub> setup (hd0)
>=20
> Grub> device (hd0) /dev/sdb
> Grub> root (hd0,0)
> Grub> setup (hd0)
>=20
> Grub> device (hd0) /dev/sdc
> Grub> root (hd0,0)
> Grub> setup (hd0)
> Grub> quit
>=20
> it gave me errors for sdc because it is not formated as formating was
> done on after the array was made. I assume that madadm will take care
> of boot setup if it activates it?
>=20
Not sure what you mean here, but you _must_ have the root filesystem
available before running grub.  What the setup command in grub does is
install the stage1 bootloader (in this case to the MBR), setting a
pointer to the on-disk location of the stage 1.5 bootloader (which
includes the relevant filesystem support, allowing the stage 2
bootloader & menu to be read).  If the stage 1.5 bootloader is moved
on-disk (or doesn't exist in the first place) then booting will fail.

I'd recommend:
    - growing each of the arrays to 3 disks.  This will give improved
      performance; remove the lack of redundancy when a drive fails (as
      you don't have to wait for the array to rebuild); and ensure the
      3rd disk is actually working (having the drive fail during a
      rebuild is not a nice experience).  The downsides will be a
      slightly increased power usage, and increased wear on the drive
      (though I've not heard any concrete evidence that this actually
      has any impact on drive failure).
    - rerun the grub setup for all drives (once the arrays are all
      synched).  This will ensure the boot loader is pointing to the
      correct on-disk location.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAknoNIQACgkQShxCyD40xBJTAQCg1F6898QuE+rbIzfGywdAHJoe
dusAoMVntVJLMo/8I7p7N6FtW+LFMBkU
=ybzV
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
