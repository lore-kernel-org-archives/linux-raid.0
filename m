From: Doug Ledford <dledford@redhat.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Thu, 25 Oct 2007 02:40:06 -0400
Message-ID: <1193294406.10336.76.camel@firewall.xsintricity.com>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com>
	 <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>
	 <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com>
	 <471FA485.6010705@tmr.com>  <47202D17.3040000@amfes.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Lds645MQQYzE/FFBKW18"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47202D17.3040000@amfes.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Daniel L. Miller" <dmiller@amfes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-Lds645MQQYzE/FFBKW18
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-24 at 22:43 -0700, Daniel L. Miller wrote:
> Bill Davidsen wrote:
> >>>> Daniel L. Miller wrote:
> >> Current mdadm.conf:
> >> DEVICE partitions
> >> ARRAY /dev/.static/dev/md0 level=3Draid10 num-devices=3D4=20
> >> UUID=3D9d94b17b:f5fac31a:577c252b:0d4c4b2a auto=3Dpart
> >>
> >> still have the problem where on boot one drive is not part of the=20
> >> array.  Is there a log file I can check to find out WHY a drive is=20
> >> not being added?  It's been a while since the reboot, but I did find=20
> >> some entries in dmesg - I'm appending both the md lines and the=20
> >> physical disk related lines.  The bottom shows one disk not being=20
> >> added (this time is was sda) - and the disk that gets skipped on each=20
> >> boot seems to be random - there's no consistent failure:
> >
> > I suspect the base problem is that you are using whole disks instead=20
> > of partitions, and the problem with the partition table below is=20
> > probably an indication that you have something on that drive which=20
> > looks like a partition table but isn't. That prevents the drive from=20
> > being recognized as a whole drive. You're lucky, if the data looked=20
> > enough like a partition table to be valid the o/s probably would have=20
> > tried to do something with it.
> > [...]
> > This may be the rare case where you really do need to specify the=20
> > actual devices to get reliable operation.
> OK - I'm officially confused now (I was just unofficially before).  WHY=20
> is it a problem using whole drives as RAID components?  I would have=20
> thought that building a RAID storage unit with identically sized drives=20
> - and using each drive's full capacity - is exactly the way you're=20
> supposed to!

As much as anything else this can be summed up as you are thinking of
how you are using the drives and not how unexpected software on your
system might try and use your drives.  Without a partition table, none
of the software on your system can know what to do with the drives
except mdadm when it finds an md superblock.  That doesn't stop other
software from *trying* to find out how to use your drives though.  That
includes the kernel trying to look for a valid partition table, mount
possibly scanning the drive for a file system label, lvm scanning for an
lvm superblock, mtools looking for a dos filesystem, etc.  Under normal
conditions, the random data on your drive will never look valid to these
other pieces of software.  But, once in a great while, it will look
valid.  And that's when all hell breaks loose.  Or worse, you run a
partition program such as fdisk on the device and it initializes the
partition table (something that the Fedora/RHEL installers do to all
disks without partition tables...well, the installer tells you there's
no partition table and asks if you want to initialize it, but if someone
is in a hurry and hits yes when they meant no, bye bye data).

The partition table is the single, (mostly) universally recognized
arbiter of what possible data might be on the disk.  Having a partition
table may not make mdadm recognize the md superblock any better, but it
keeps all that other stuff from even trying to access data that it
doesn't have a need to access and prevents random luck from turning your
day bad.

Oh, and let's not go into what can happen if you're talking about a dual
boot machine and what Windows might do to the disk if it doesn't think
the disk space is already spoken for by a linux partition.

And, in particular with mdadm, I once created a full disk md raid array
on a couple disks, then couldn't get things arranged like I wanted, so I
just partitioned the disks and then created new arrays in the partitions
(without first manually zeroing the superblock for the whole disk
array).  Since I used a version 1.0 superblock on the whole disk array,
and then used version 1.1 superblocks in the partitions, the net result
was that when I ran mdadm -Eb, mdadm would find both the 1.1 and 1.0
superblocks in the last partition on the disk.  Confused both myself and
mdadm for a while.

Anyway, I happen to *like* the idea of using full disk devices, but the
reality is that the md subsystem doesn't have exclusive ownership of the
disks at all times, and without that it really needs to stake a claim on
the space instead of leaving things to chance IMO.

>   I should mention that the boot/system drive is IDE, and=20
> NOT part of the RAID.  So I'm not worried about losing the system - but=20
> I AM concerned about the data.  I'm using four drives in a RAID-10=20
> configuration - I thought this would provide a good blend of safety and=20
> performance for a small fileserver.
>=20
> Because it's RAID-10 - I would ASSuME that I can drop one drive (after=20
> all, I keep booting one drive short), partition if necessary, and add it=20
> back in.  But how would splitting these disks into partitions improve=20
> either stability or performance?

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-Lds645MQQYzE/FFBKW18
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHIDpGTzP9PM7pjw8RAiGbAJ0VLPYvcuRqZcxNGWF2yOHJHYhYqgCfdURC
D+1F39tEUOf1yzLpyvz8BCk=
=eDj+
-----END PGP SIGNATURE-----

--=-Lds645MQQYzE/FFBKW18--

