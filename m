From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 replace ignored error?
Date: Tue, 18 Feb 2014 14:46:57 +1100
Message-ID: <20140218144657.28b7601e@notabene.brown>
References: <52F0AC42.5080407@sbcglobal.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0G2FDNOcn0hMp9SHHxEMDJM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F0AC42.5080407@sbcglobal.net>
Sender: linux-raid-owner@vger.kernel.org
To: Bill <billstuff2001@sbcglobal.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/0G2FDNOcn0hMp9SHHxEMDJM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 04 Feb 2014 03:00:50 -0600 Bill <billstuff2001@sbcglobal.net> wrote:

> Hi,
>=20
> I had something weird happen during a replace in a raid5 array on kernel=
=20
> 3.10.28 -
> it appears an error in writing to / communicating with the replacement=20
> disk was ignored.
>=20
> I have this array:
>=20
> md3 : active raid5 sda1[0] sdd1[3] sdb1[1] sdf1[4] sdc1[2]
>        3900742144 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
>        bitmap: 0/233 pages [0KB], 2048KB chunk
>=20
> I tried replacing sdf1 with sde1.
>=20
>      [106666.129833] md: recovery of RAID array md3
>      [106666.129836] md: minimum _guaranteed_  speed: 20000 KB/sec/disk.
>      [106666.129837] md: using maximum available idle IO bandwidth (but=20
> not more than 200000 KB/sec) for recovery.
>      [106666.129842] md: using 128k window, over a total of 975185536k.
>=20
> 1/2 hour later I got a flood of errors in dmesg:
>=20
>      [108334.974861] ata5.00: exception Emask 0x10 SAct 0x7fffffff SErr=20
> 0x480100 action 0x6 frozen
>      [108334.974864] ata5.00: irq_stat 0x08000000, interface fatal error
>      [108334.974866] ata5: SError: { UnrecovData 10B8B Handshk }
>      [108334.974868] ata5.00: failed command: WRITE FPDMA QUEUED
>      [108334.974872] ata5.00: cmd 61/00:00:10:97:9e/04:00:15:00:00/40=20
> tag 0 ncq 524288 out
>      [108334.974872]          res 40/00:b0:10:f7:9e/00:00:15:00:00/40=20
> Emask 0x10 (ATA bus error)
>      [108334.974873] ata5.00: status: { DRDY }
>      .
>      .(29 more of the same message)
>      .
>      [108344.976877] ata5: softreset failed (1st FIS failed)
>      [108344.976883] ata5: hard resetting link
>      [108349.874854] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 30=
0)
>      [108349.901025] ata5.00: configured for UDMA/133
>      [108349.901055] ata5: EH complete
>=20
> There were no md error messages, the recovery continued, and finished a=20
> few hours later.
>=20
>      [122443.805899] md: md3: recovery done.
>=20
>=20
> Afterwards I did a QC check and found a mismatch in one file which I=20
> mapped to the area
> being updated when this error was logged.
>=20
> What should happen in this case?
> Should the "replace" have failed or is there something else going on here?

Hi Bill,
 sorry for the delay.

Were there any message like:
   end_request: I/O error, dev sde, sector NNNNNNNN

??
If not, then the error never got up to md - the driver thinks that it manag=
ed
to recovery.
If so, then md really should have marked the replacement as faulty - or
possible recorded a bad-block if the device has a badblock log on it (mdadm
-E would tell you).

If the write actually failed, but md wasn't told, then that is a problem in
the driver or device.
If the md was told, then it certainly would be a bug in md.

NeilBrown

--Sig_/0G2FDNOcn0hMp9SHHxEMDJM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUwLXsTnsnt1WYoG5AQLggw/+MuewhBUUrKUKtWVfjMNOnRS0mbN0fA+T
GnAVY3xQso9MCJIIykFthBFy+tKLXQwapHB/G5KEai0wJKQ0rEZlW1R/9sHbyy6C
Cf/i6I7M9LZQA+d8IU1SRXxGiPjfnMd2t3d6NsDcj88QJ2tkX0PwEDYa2LLO2drW
cvRdWmb+ggdJC/0cNrI6PXuAvcjRaaVttdXIEc77uZVErx4mKakHhYpaB0LAGTXZ
kB2FaYbVxYrl3B0Y/gDt9lNDwkoNemWQHMrmYJ5YZAn1pPzUG5sUy5+X/Mg43bwi
jmXprJcs+xvdyfxrQ8MhBT0q9Tu+GFF9/oktxcJsPrjYDlmnSyAZK9sfaNA8ZOwc
lHF1SH45x2/KBh8xOinyANTF8IUKY2HRUNeTrZ43lU04XNYauwXkPOHSGTlWAHXo
MvcsvxTqTQXt0UWqsZKyIGCJwEdg2RYVbF38uFCb+B6CiIzLM1Vf64qDlMgadi0x
pEulCR40CYyxRuq5sjoLV54XCtclPWBfYccPs6PvuPAvAn/l08h9q7wWIP8ZeHzA
hadTBz1SBWhbKJ/xNxG3BVRIkAAEyC0zmZ/gf4KQ4+gKcV8tc1bCVBjBRhBWSTn3
K4OS5SAMmx00MlSXp/Ux71pODZB5v9KXWJ8H0wP9gonSAZUJVFNeOfkYuFqhdP/H
p27QC+KosY8=
=BxlY
-----END PGP SIGNATURE-----

--Sig_/0G2FDNOcn0hMp9SHHxEMDJM--
