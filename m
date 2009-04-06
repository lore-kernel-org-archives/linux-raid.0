From: Doug Ledford <dledford@redhat.com>
Subject: mdadm udev rules change
Date: Mon, 6 Apr 2009 10:57:16 -0400
Message-ID: <3B6F676A-5ADD-4741-8269-D7D655C4E21E@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-29-877115622"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid RAID <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-29-877115622
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

I'm not attaching a patch for this because it's so simple.  Long story  
short, watching both add and change events in udev rules is bad for md  
devices.  Specifically, the kernel will generate a change event on  
things like array stop, and on things like fdisk close.  In the case  
of array stop, it can result in the array being assembled again  
immediately.  In the case of fdisk close, the situation is worse.   
Let's say you stop all the md devices on some block device in order to  
repartition.  You run fdisk, change the partition table, then issue a  
write of the table.  The write of the table triggers the change event  
*before* the kernel updates the partition table in memory for the  
block device, causing udev to rerun the incremental rules on the old  
partition table and restart all the arrays you just stopped with the  
old partition table layout, at which point the kernel is unable to  
reread the partition table.  So, once you've enable incremental  
assembly, it becomes apparent that what we really want is to only  
start devices on add, not on add|change.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-29-877115622
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknaGE0ACgkQQ9aEs6Ims9ipBACgjeVXoq5XZjkGHIQsmkKF800c
nUkAoOu90KopBXSX8g2ioLugauFcL7te
=jdy8
-----END PGP SIGNATURE-----

--Apple-Mail-29-877115622--
