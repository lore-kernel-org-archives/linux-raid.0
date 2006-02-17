From: William Marques <william@scinergy.com.br>
Subject: Problems with invalid superblock
Date: Fri, 17 Feb 2006 19:59:53 -0200
Message-ID: <43F64759.1060503@scinergy.com.br>
Reply-To: william@scinergy.com.br
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I trying to setup a raid0 without success, using the mdadm 2.3.1
package, compiled from sources.
No matters if its linear or stripping raid0 mode, the errors are the same:

master# mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2
/dev/sda2 /dev/sda3
master:~# mdadm -E /dev/md0
mdadm: No md superblock detected on /dev/md0.

I made  a lot's of tests with this, trying to recriate, but without sucess.

The strange thing is that the Raid is running:
master:~# mdadm -Q -D /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Fri Feb 17 19:35:21 2006
     Raid Level : raid0
     Array Size : 1052096 (1027.61 MiB 1077.35 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Feb 17 19:35:21 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

           UUID : ad53c04e:73590c3f:8ea811aa:f81097e1
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8        3        1      active sync   /dev/sda3
But I cant mount the device:
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       missing codepage or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so


I'm using a Debian Sarge box, updated, but with mdadm compiled from
sources. With Debian binaries, the same error occours.
Kernel 2.6.8-2-686
Tested with ubuntu 5.10, kernel 2.6.12 compiled from source with the
same resoults.
Is it a problem if the devices are on the same HD? I'm trying this way
because it's a test. If, so thats ok, in real life we will be using 2
SATA 160GB discs.
Has anyone else that I can do?

If anyone has any clue about this, please, let me know, as it is part of
a important project I'm working on, and I gave this solution to "merge"
the hard discs in one bigger device.

Thanks in advance,

- --
William Marques
Consultor Linux - TI
LPIC-1: LPI000058633
Scinergy Consulting Ltda.
Fone: +55 21 2224-3224
http://www.scinergy.com.br
Rio de Janeiro - Brasil
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFD9kdZbwzoNUPCOg8RAtvDAJ9gLoNsEF47VjmkhDyIyXmXMpHaUwCfewFG
wyuUjlS4+QhM96XVoS7b8mE=
=hmqJ
-----END PGP SIGNATURE-----
