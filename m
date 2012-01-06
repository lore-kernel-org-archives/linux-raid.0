From: Johannes Truschnigg <johannes@truschnigg.info>
Subject: Re: What just happened to my disks/RAID5 array?
Date: Fri, 6 Jan 2012 11:51:43 +0100
Message-ID: <20120106105143.GA2932@vault.local>
References: <4E6F13F7.6070507@truschnigg.info>
 <4E6F4091.7050206@turmel.org>
 <4E6FA76A.90206@truschnigg.info>
 <4E7092F1.5010209@turmel.org>
 <4E70EFA8.4080706@truschnigg.info>
 <4E70FE5B.5080601@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E70FE5B.5080601@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--pvezYHf7grwyp3Bc
Content-Type: multipart/mixed; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello again Phil and everyone else who's having a peek,

you see, I finally had the chance to migrate all the disks to a new machine,
and figured I'd try my luck at getting back the data on my precious array.
It's been a while since I had access to it, but having that data available =
all
the time is not as important as having it at all, as I use the box mostly to
store old(er) backups. I definitely would like to have them back at some po=
int
in time, however ;)

So yesterday, I upgraded all the software on the boot drive (running Gentoo=
),
and now I have Kernel 3.2.0 and mdadm 3.1.5, and all the drives attached to=
 an
AMD SB850 in AHCI mode. Drive-wise, everything looks as expected - all devi=
ce
nodes are there, fdisk reports the correct size, and SMART data can be read
w/o problems. Assemling the array, however, fails, and I promised in a
previous mail in this thread that I were to come back to the list and post =
the
info I got before venturing forth. Well, here I am now:

I have the array in stopped state, so /proc/mdstat contains no arrays at th=
is
time. Now I run the following command which yields this output:

--- snip ---
# mdadm -v --assemble -u "19e260e6:db3cad86:0541487d:a1bae605" /dev/md0=20
mdadm: looking for devices for /dev/md0
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has wrong uuid.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sdf is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sde is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdd is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdc is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
mdadm: added /dev/sdb to /dev/md0 as 0
mdadm: added /dev/sdd to /dev/md0 as 2
mdadm: added /dev/sdf to /dev/md0 as 3
mdadm: added /dev/sdc to /dev/md0 as 4
mdadm: added /dev/sde to /dev/md0 as 1
mdadm: /dev/md0 assembled from 2 drives - not enough to start the array.
--- snip ---


It seems that mdadm would be able to identify all five original components =
of
my array, but later decides that it found only two of them, and therefore
can't start the array. /proc/mdstat, at this point in time, shows the
following:

--- snip ---
md0 : inactive sde[1](S) sdc[5](S) sdf[3](S) sdd[2](S) sdb[0](S)
      7325687800 blocks super 1.2
--- snip ---

The (S) should indicate the component being marked as "spare", right (mdstat
really should have a manpage with a short overview of the most commonly
observed abbreviations, symbols and terms - I guess I'll volunteer if you
don't tell me that's already documented somewhere)?

Shall I just try "-A --force" and that's supposed to kick the array enough =
to
start again? Or is there anything else you could and would recommend before
resorting to that?

One thing I forgot to mention is that I cannot guarantee that the order of =
the
drives is still the same as it was in the old box (device node names for the
component disks could have changed), but I'm convinced that's not a problem
and I mention it only for the sake of completeness.

I have attached a file with the output of `mdadm -E` for each of the
components for your viewing pleasure - thanks in advance for anyone's time =
and
effort who's looking into this!

--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www:   http://johannes.truschnigg.info/
phone: +43 650 2 133337
xmpp:  johannes@truschnigg.info

Please do not bother me with HTML-eMail or attachments. Thank you.

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-examine-disks.txt"

# mdadm -E /dev/sdb
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 19e260e6:db3cad86:0541487d:a1bae605
           Name : virtue:0  (local to host virtue)
  Creation Time : Tue Dec 21 10:25:32 2010
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 11721097216 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a1a06197:c5a7727d:5f527b15:01941ba2

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Sep 11 20:11:23 2011
       Checksum : 29ad30c - correct
         Events : 3926

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA ('A' == active, '.' == missing)


# mdadm -E /dev/sdc
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 19e260e6:db3cad86:0541487d:a1bae605
           Name : virtue:0  (local to host virtue)
  Creation Time : Tue Dec 21 10:25:32 2010
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 11721097216 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 67a52c17:6f69b41c:696ce995:5b845991

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Sep 11 20:11:23 2011
       Checksum : 9153a3e4 - correct
         Events : 3926

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAA ('A' == active, '.' == missing)


# mdadm -E /dev/sdd
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 19e260e6:db3cad86:0541487d:a1bae605
           Name : virtue:0  (local to host virtue)
  Creation Time : Tue Dec 21 10:25:32 2010
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 11721097216 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 697750ec:0391a119:1bac7a98:1cb374d6

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Sep 11 20:11:23 2011
       Checksum : ab110beb - correct
         Events : 3926

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAA ('A' == active, '.' == missing)


# mdadm -E /dev/sde
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 19e260e6:db3cad86:0541487d:a1bae605
           Name : virtue:0  (local to host virtue)
  Creation Time : Tue Dec 21 10:25:32 2010
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 11721097216 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : bd1fc7fb:00ed1072:1fd7d01a:415255a0

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Sep 13 06:07:24 2011
       Checksum : 5f2bb793 - correct
         Events : 3929

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : .A.A. ('A' == active, '.' == missing)


# mdadm -E /dev/sdf
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 19e260e6:db3cad86:0541487d:a1bae605
           Name : virtue:0  (local to host virtue)
  Creation Time : Tue Dec 21 10:25:32 2010
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 11721097216 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 2a781a8a:ed3a6a97:29df74d2:bfcbe831

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Sep 13 06:07:24 2011
       Checksum : 5c0fdf77 - correct
         Events : 3929

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : .A.A. ('A' == active, '.' == missing)

--UugvWAfsgieZRqgk--

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8G0j8ACgkQnnUApj8OcoLVBQCfRc6fJrMVfu6ruvVWoRAWQHMM
bd0AnjpTnYPtbykl0WL91rqmV4jZVWdH
=zxD+
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
