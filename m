From: Frank Blendinger <fb@intoxicatedmind.net>
Subject: Two disk failure in RAID5 during resync, wrong superblocks
Date: Thu, 16 Mar 2006 13:19:56 +0100
Message-ID: <20060316121956.GE27570@intoxicatedmind.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="brEuL7wsLY8+TuWz"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--brEuL7wsLY8+TuWz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I have just added the missing fourth disk to my RAID5 and waited for the
resync to finish. This morning I had to see this in my /proc/mdstat:

md2 : active raid5 hde1[4] hdg1[5](F) hdk1[2] hdi1[1]
      730948992 blocks level 5, 64k chunk, algorithm 2 [4/2] [_UU_]

hde is the added fourth disk the array was syncing to and hdg seems to
have failed during this. From my syslog from yesterday:

Mar 14 21:09:17 localhost kernel: [  717.345236] md: bind<hdg1>
Mar 14 21:09:17 localhost kernel: [  717.633915] raid5: device hdg1 operational as raid disk 0
Mar 14 21:09:17 localhost kernel: [  717.687884]  disk 0, o:1, dev:hdg1
Mar 14 22:29:19 localhost kernel: [ 5529.025214] hdg: dma_intr: status=0x51 { DriveReady SeekComplete Error }
Mar 14 22:29:19 localhost kernel: [ 5529.025242] hdg: dma_intr: error=0x84 { DriveStatusError BadCRC }
Mar 14 22:29:19 localhost kernel: [ 5529.180163] hdg: dma_intr: status=0x51 { DriveReady SeekComplete Error }
Mar 14 22:29:19 localhost kernel: [ 5529.180187] hdg: dma_intr: error=0x84 { DriveStatusError BadCRC }
[...]
Mar 14 23:27:15 localhost kernel: [ 9006.977466] PDC202XX: Secondary channel reset.
Mar 14 23:27:15 localhost kernel: [ 9009.060757] PDC202XX: Primary channel reset.
Mar 14 23:27:15 localhost kernel: [ 9009.061102] ide3: reset: master: error (0x00?)

I guess the disk was then kicked out of the array.


So I'm left with to working disks (hdk and hdi), one probably broken
disk (hdg) with valuable data on it and one disk (hde) with not enough
information on it to assemble the array.

I think that leaves me two options:

1) I'll try to reboot and force the array to be assembled with the
   broken hdg, add hde and pray that a resync will finish.

2) I'll dd_rescue hdg to hde and create the array with hde, hgk and hdi.
   Then add hdg and see if a resync works.

What would you suggest me to do? Is there maybe a better approach that I
have missed? Any hints on how to force mdadm to assemble the array with
the faulty hdg?


Thanks in advance,
Frank

--brEuL7wsLY8+TuWz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFEGVfscs96QQvy/noRAsv7AJ9r5iV4Kfl0NxXb4QRvWzcsqi/IQwCghowH
Xk23VkxS5fw9hJz9z0AOHJY=
=4GFw
-----END PGP SIGNATURE-----

--brEuL7wsLY8+TuWz--
