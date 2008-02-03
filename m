From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  RAID needs more to survive a power hit, different /boot
	layout for example (was Re: draft howto on making raids for
	surviving a disk crash)
Date: Sun, 3 Feb 2008 22:01:58 +0000
Message-ID: <20080203220158.GC22004@cthulhu.home.robinhill.me.uk>
References: <47A612BE.5050707@pobox.com> <20080203200150.GB22004@cthulhu.home.robinhill.me.uk> <47A6283E.1000706@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47A6283E.1000706@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Feb 03, 2008 at 02:46:54PM -0600, Moshe Yudkowsky wrote:

> Robin Hill wrote:
>
>> This is wrong - the disk you boot from will always be hd0 (no matter
>> what the map file says - that's only used after the system's booted).
>> You need to remap the hd0 device for each disk:
>> grub --no-floppy <<EOF
>> root (hd0,1)
>> setup (hd0)
>> device (hd0) /dev/sdb
>> root (hd0,1)
>> setup (hd0)
>> device (hd0) /dev/sdc
>> root (hd0,1)
>> setup (hd0)
>> device (hd0) /dev/sdd
>> root (hd0,1)
>> setup (hd0)
>> EOF
>
> For my enlightenment: if the file system is mounted, then hd2,1 is a=20
> sensible grub operation, isn't it? For the record, given my original scri=
pt=20
> when I boot I am able to edit the grub boot options to read
>
> root (hd2,1)
>
> and proceed to boot.
>
Once the file system is mounted then hdX,Y maps according to the
device.map file (which may actually bear no resemblance to the drive
order at boot - I've had issues with this before).  At boot time it maps
to the BIOS boot order though, and (in my experience anyway) hd0 will
always map to the drive the BIOS is booting from.

So initially you may have:
        SATA-1: hd0
        SATA-2: hd1
        SATA-3: hd2

Now, if the SATA-1 drive dies totally you will have:
        SATA-1: -
        SATA-2: hd0
        SATA-3: hd1

or if SATA-2 dies:
        SATA-1: hd0
        SATA-2: -
        SATA-3: hd1

Note that in the case where the drive is still detected but fails to
boot then the behaviour seems to be very BIOS dependent - some will
continue to drive 2 as above, whereas others will just sit and complain.

So to answer the second part of your question, yes - at boot time
currently you can do "root (hd2,1)" or "root (hd3,1)".  If a disk dies,
however (whichever disk it is), then "root (hd3,1)" will fail to work.

Note also that the above is only my experience - if you're depending on
certain behaviour under these circumstances then you really need to test
it out on your hardware by disconnecting drives, substituting
non-bootable drives, etc.

HTH,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHpjnWShxCyD40xBIRAt/CAJoCYtrqqx9IbgLTqVYV20HewnEDjQCfS8uG
Zwq/nmzabh0CZez3EHOyLlc=
=5Yg6
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
