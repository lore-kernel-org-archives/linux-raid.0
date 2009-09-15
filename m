From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID1 assembled broken array
Date: Tue, 15 Sep 2009 16:00:30 -0400
Message-ID: <9F2F4760-DF0C-4416-89AC-C689177AD4ED@redhat.com>
References: <h8ophd$n8p$6@ger.gmane.org>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-29--140276364"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <h8ophd$n8p$6@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-29--140276364
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Sep 15, 2009, at 3:22 PM, Matthias Urlichs wrote:
> I had a somewhat strange error today.
>
> One of my servers has a RAID1 array. Two partitions at the end of the
> disk; the RAID superblocks are at the end of the partition.
>
> After a hard reboot today, one of the disks managed to not have its
> partition table scanned correctly, most probably because the disk was
> hung and the ("intelligent") controller got confused about it. After  
> the
> initial scan, however, it came up correctly.
>
> This error caused mdadm to "successfully" build a RAID1 from /dev/sda3
> and /dev/sdb (instead of /dev/sdb3). Needless to say, the resulting
> volume was somewhat unuseable. To say the least.
>
> My server's mdadm.conf has a 'DEVICE=partitions' line. I suppose that
> replacing these with a pattern that explicitly only matches  
> partitions,
> not disks, would make the problem go away, and that the lesson from
> today's disaster recovery effort is to always explicitly list the  
> allowed
> partition names, instead of being lazy and using 'DEVICE=partitions'.


Wrong lesson.  The correct lesson to gather from this is to prefer  
version 1.1 or 1.2 superblocks wherever possible.  Superblocks at the  
beginning of the device disappear when there is no partition table,  
superblocks at the end can be confused for superblocks belonging to  
the whole device when there is no partition table.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-29--140276364
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.12 (Darwin)

iEYEARECAAYFAkqv8l4ACgkQg6WylM+/8ZQ93ACfXdSHUpfWCRoul6o+g9SAymzp
wGcAoJfHWdGGeRKqBHUGQ+g7o3VBHema
=4Xte
-----END PGP SIGNATURE-----

--Apple-Mail-29--140276364--
