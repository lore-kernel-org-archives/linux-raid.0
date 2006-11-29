From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: mdadm --assemble weirdness?
Date: Wed, 29 Nov 2006 11:59:05 -0800
Message-ID: <456DE689.7000407@ucolick.org>
References: <1162293818.32109.113.camel@kenny>	<17735.14472.835153.186432@cse.unsw.edu.au>	<456CE109.7000202@ucolick.org> <17772.60765.661612.780701@cse.unsw.edu.au> <456D0751.80507@ucolick.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBCC1F86EF127F81C1763783D"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <456D0751.80507@ucolick.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBCC1F86EF127F81C1763783D
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable

Patrik Jonsson wrote
> I just got the LATEST off of your website, whatever the number was. I
> got the array running, i noticed that in the dmesg from booting it said=

> something about "kicking non-fresh drive sdxyz" so I did a --assemble
> --scan --force and then re-added the final drive which got the array
> back to syncing. I would have prefered not to resync but whatever. The
> strange thing is how they came to be non-fresh, these were the drives
> that had changed controller. They were always there and I never did
> anything to the array apart from trying to assemble it.

Ouch! -- resync failed because of a read error on another drive... If
I'm correct, the data should still be safe because the resyncing drive
should have been rewritten with identical data, right? So it should
still be possible to recreate the array with --assume-clean and not lose
data? Now I'm getting sufficiently close to the edge that I want to
reconfirm the steps, though.

To successfully do a recreate I need the correct device order, right?
Currently, mdadm says:

/dev/md5:
        Version : 00.90.03
  Creation Time : Thu Jun 16 18:44:56 2005
     Raid Level : raid5
     Array Size : 2193136704 (2091.54 GiB 2245.77 GB)
    Device Size : 243681856 (232.39 GiB 249.53 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 5
    Persistence : Superblock is persistent

    Update Time : Tue Nov 28 18:24:47 2006
          State : clean, degraded
 Active Devices : 8
Working Devices : 9
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : b438b4a3:de389878:2cbbe06c:ebaab31f
         Events : 0.4455550

    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       1       8      129        1      active sync   /dev/sdi1
       2       8      113        2      active sync   /dev/sdh1
       3       0        0        3      removed
       4       8        1        4      active sync   /dev/sda1
       5       0        0        5      removed
       6       8       81        6      active sync   /dev/sdf1
       7       8       65        7      active sync   /dev/sde1
       8       8       33        8      active sync   /dev/sdc1
       9       8       49        9      active sync   /dev/sdd1

      10       8      145        -      spare   /dev/sdj1
      11       8       17        -      faulty spare   /dev/sdb1

I'm pretty sure that sdj1 is supposed to go as raiddevice 3 and sdb1 as
5. The correct way to proceed would then be:

mdadm -S /dev/md5   to stop the array
mdadm --create /dev/md5 --assume-clean -l 5 -n 10 /dev/sdg1 /dev/sdi1
/dev/sdh1 /dev/sdj1 /dev/sda1 /dev/sdb1 /dev/sdf1 /dev/sde1 /dev/sdc1
/dev/sdd1  to recreate

mdadm -o /dev/md5   to set readonly
then mount read-only and see if it looks like a file system. If it does
the order was correct if not the order was incorrect.
If order is correct then proceed to do a raid5 "repair" and things
should be safe.

Does this seem reasonable?

Thanks a bunch,

/Patrik


--------------enigBCC1F86EF127F81C1763783D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFbeaOT+KvsdUW5p8RAioQAJ9efwqrnGr067kbH3mu+078vBogxgCfefBg
7DL/9YltA+Gcot2A23f+tck=
=DZJv
-----END PGP SIGNATURE-----

--------------enigBCC1F86EF127F81C1763783D--
