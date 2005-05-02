From: Herta Van den Eynde <herta.vandeneynde@cc.kuleuven.be>
Subject: mdadm: /dev/md3 has wrong uuid.
Date: Mon, 02 May 2005 13:38:52 +0200
Message-ID: <4276114C.1090705@cc.kuleuven.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just upgraded my Red Hat Advanced Server 2.1 systems from
2.4.9-e.59enterprise to 2.4.9-e.62enterprise.  The systems were running=
=20
mdadm-1.4.0-1.

During startup, they complained that

md: mount(pid 869) used obsolete MD ioctl, upgrade your software to use=
=20
new ictls.

So I picked up mdadm-1.11.0.tgz,  and on one of the system ran "make"=20
and "make install", and rebooted.

This time, startup throws me a bunch of

SCSI device sdc: 71132959 512-byte hdwr sectors (
36420 MB)
sdc: unknown partition table

messages (one for each of the 14 devices).  I had this happen a couple=20
of times before, and re-fdisk-ing so far always got me out of the jam.=20
So I fdisk all the devices, specifying fd (linux raid autodetect) as ty=
pe.

Now, it pretty much looks like the UUIDs have been erased.
# mdadm -E -s; echo $?
0
# mdadm -Asv
mdadm: looking for devices for /dev/md3
mdadm: no RAID superblock on /dev/md3
mdadm: /dev/md3 has wrong uuid.
mdadm: no RAID superblock on /dev/md2
mdadm: /dev/md2 has wrong uuid.
mdadm: no RAID superblock on /dev/md1
mdadm: /dev/md1 has wrong uuid.
mdadm: no RAID superblock on /dev/md0
mdadm: /dev/md0 has wrong uuid.
mdadm: no RAID superblock on /dev/md7
mdadm: /dev/md7 has wrong uuid.
mdadm: no RAID superblock on /dev/md6
mdadm: /dev/md6 has wrong uuid.
mdadm: no RAID superblock on /dev/md5
mdadm: /dev/md5 has wrong uuid.
mdadm: no RAID superblock on /dev/sdp1
mdadm: /dev/sdp1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdp
mdadm: /dev/sdp has wrong uuid.

Any suggestions, both for the current system and the other ones?  I got=
=20
backups, but it's a lot of data to pull over, so I'd prefer to avoid=20
that if I can.

Kind regards,

Herta
--=20
Herta Van den Eynde              -=3D- Toledo system management
K.U. Leuven - Ludit              -=3D- phone: +32 (0)16 322 166
                                  -=3D- 50=B051'27" N 004=B040'39" E

"I wish I were two little cats.  Then I could play together."
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
