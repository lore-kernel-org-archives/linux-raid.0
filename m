From: Andy Smith <andy@lug.org.uk>
Subject: Replacement disk is slightly smaller
Date: Wed, 9 Nov 2005 02:42:11 +0000
Message-ID: <20051109024211.GS7163@strugglers.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G28fYu3ENAROfdzr"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--G28fYu3ENAROfdzr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I have a machine with 4 Maxtor drives in it.  My sdb died and having
bad experiences with Maxtor in general I decided to buy a Seagate
replacement.  Here's what I get on boot:

scsi0 : sata_nv
  Vendor: ATA       Model: Maxtor 6Y120M0    Rev: YAR5
  Type:   Direct-Access                      ANSI SCSI revision: 05
scsi1 : sata_nv
  Vendor: ATA       Model: ST3120827AS       Rev: 3.42
  Type:   Direct-Access                      ANSI SCSI revision: 05
scsi2 : sata_nv
  Vendor: ATA       Model: Maxtor 6Y120M0    Rev: YAR5
  Type:   Direct-Access                      ANSI SCSI revision: 05
scsi3 : sata_nv
  Vendor: ATA       Model: Maxtor 6Y120M0    Rev: YAR5
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 240121728 512-byte hdwr sectors (122942 MB)
SCSI device sdb: 234441648 512-byte hdwr sectors (120034 MB)
SCSI device sdc: 240121728 512-byte hdwr sectors (122942 MB)
SCSI device sdd: 240121728 512-byte hdwr sectors (122942 MB)

Anyone spotted the current thorn in my side yet?

Yes, thanks Seagate, your "120GB" hard disk is 2908MB smaller than the
3 "120GB" Maxtors.  I did consider this might happen but I could get
the 120GB Seagate quicker whereas a 160GB of any vendor would have
taken a few extra days.  It appears I've been doubly unlucky.

So I haven't even bothered trying to partition it the same as
sd[acd] yet as it's not going to work is it?

The partition table of each of the 3 Maxtors is like this:

Partition       Start sector    End sector      Purpose
1               63              144584          /boot
2               144585          10635029        /stripe
3               10635029        229472460       everything else

/boot is a RAID-1 on sda1 and sdb1 with sdc1 and sdd1 being hot
spares.[1] (md0)

/stripe is/was a RAID-0 across sd[abcd]2 for use as scratch space.
(md1)

"everything else" is a RAID-5 of /dev/sd[abcd]3 which I use as an
LVM PV and carve up lots of LVs for my root filesystem and all other
things.

So the situation right now is:

$ cat /proc/mdstat
Personalities : [raid0] [raid1] [raid5] [multipath]
md2 : active raid5 sdd3[3] sdc3[2] sda3[0]
      344208384 blocks level 5, 256k chunk, algorithm 2 [4/3] [U_UU]

md0 : active raid1 sdd1[1] sdc1[2] sda1[0]
      72192 blocks [2/2] [UU]

unused devices: <none>

md1 (/stripe) is totally screwed and was commented out of /etc/fstab
since it is now dead.  There wasn't anything on it anyway; it really
was scratch space.

I figure I can create sdb3 first and make it the same size as
partition 3 on the other disks.  I can then compromise by taking the
excess out of sdb2, and not bother about sdb1 at all.  md1 will end
up using less than the full extent of sd[acd]2 since sdb2 will still
be smaller than those others, but it's only scratch space so I don't
care.

But what's the easiest way to do this?  I can't start creating
partitions at the end can I?  Or maybe I can, in something other
than fdisk.

It would no doubt be easier to create sdb1 first as the correct size
to match sd[acd]3 then use the rest for sdb2, but then I end up with
a "less pretty" md setup where md2 is made of {sda3, sdb1, sdc3,
sdd3}.

So what would you guys do? :)

Oh, and, will I need to do anything special (like shrink sd[acd]2)
when trying to rebuild the stripe (md1) with the smaller patition
=66rom sdb?

Cheers,
Andy

[1] Did it like that because I wanted /boot on a RAID 1, but I keep it
    read only most of the time and didn't see the point in having it
    a 4-way RAID 1.  But then, there isn't much to do with two
    70-odd MB disk partitions so I made them hot spares.

--G28fYu3ENAROfdzr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDcWIDIJm2TL8VSQsRAplkAJ4tnZv3BXDpvcWjqjQ+mLHMYr3zywCfesBW
3hnCXndcqx8GV5qoPHz0KYg=
=TlrA
-----END PGP SIGNATURE-----

--G28fYu3ENAROfdzr--
