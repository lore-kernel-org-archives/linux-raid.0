From: NeilBrown <neilb@suse.com>
Subject: Re: Troubleshooting "Buffer I/O error" on reading md device
Date: Tue, 02 Jan 2018 15:28:42 +1100
Message-ID: <87373og9z9.fsf@notabene.neil.brown.name>
References: <1z_MZ4Xqld_IRMUbGJE66v2VUhXkBhlHnWJEfLASWNcv5s3Wo3A1YeuQBJBuksxJtFPpmsPbg1_F8PC3Sj4HrzL6Go3aIanVihzcC-4ZHEQ=@protonmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1z_MZ4Xqld_IRMUbGJE66v2VUhXkBhlHnWJEfLASWNcv5s3Wo3A1YeuQBJBuksxJtFPpmsPbg1_F8PC3Sj4HrzL6Go3aIanVihzcC-4ZHEQ=@protonmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: RQM <rqm@protonmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 01 2018, RQM wrote:

> Hello everyone,
>
> I hope this list is the right place to ask the following:
>
> I've got a 5-disk RAID-5 array that's been built by a QNAP NAS device, wh=
ich has recently failed (I suspect a faulty SATA controller or backplane).
> I migrated the disks to a desktop computer that runs Debian stretch (kern=
el 4.9.65-3+deb9u1 amd64) and mdadm version 3.4. Although the array can be =
assembled, I encountered the following error in my dmesg output ([1], recor=
ded directly after a recent reboot and fsck attempt) when running fsck:
>
> Buffer I/O error on dev md0, logical block 1598030208, async page read
>
> I can reliably reproduce that error by trying to read from the md0 device=
. It's always the same block, also across reboots.
>
> I have suspected that possibly, one of the drives involved is faulty. Alt=
hough smart errors have been logged [2], the errors are not recent enough t=
o correlate with the fsck run. Also, I had sha1sum complete without error o=
n every one of the individual disk devices /dev/sd[b-f], so reading from th=
e drives does not provoke an error.
>
> Finally, I tried scrubbing the array by writing repair to md/sync_action.=
 The process completed without any output to dmesg or signs of trouble in /=
proc/mdstat. However, reading from the array still fails at the same block =
as above, 1598030208.
>
> Here's the output of mdadm --detail /dev/md0: [3]
>
> I assume the md driver would know what exactly the problem is, but I don'=
t know where to look to find that information. How can I proceed troublesho=
oting this issue?
>
> FYI, I had posted this on serverfault [4] previously, but unfortunately d=
idn't arrive at a conclusion.
>
> Thank you very much in advance!
>
> [1] https://paste.ubuntu.com/26303735/
> [2] https://paste.ubuntu.com/26303737/
> [3] https://paste.ubuntu.com/26303754/
> [4] https://serverfault.com/questions/889687/troubleshooting-buffer-i-o-e=
rror-on-software-raid-md-device

This is truly weird.  I'd even go so far as to say that it cannot
possibly happen (but I've been wrong before).

Step one is confirm that it is easy to reproduce.
Does
  dd if=3D/dev/md0 bs=3D4K skip=3D1598030208 count=3D1 of=3D/dev/null

trigger the message reliably?
To check that "4K" is the correct blocksize, run
  blockdev --getbsz /dev/md0

use whatever number if gives as 'bs=3D'.

If you cannot reproduce like that, try a larger count and then a smaller
skip with a large count.

Once you can reproduce with minimal IO, do
  echo file:raid5.c +p > /sys/kernel/debug/dynamic_debug/control
  # repeat experiment
  echo file:raid5.c -p > /sys/kernel/debug/dynamic_debug/control

and report the messages that appear in 'dmesg'.
Also report "mdadm -E" of each member device, and kernel version (though
I see that is in the serverfault report :  4.9.30-2+deb9u5).

Then run
  blktrace /dev/md0 /dev/sd[acdef]
in one window while reproducing the error again in another window.
Then interrupt the blktrace.  This will produce several blocktrace*
files.  create a tar.gz of these and put them somewhere that I can get
them - hopefully they won't be too big.

With all this information, I can poke around and will hopefully be able
to explain if fine detail exactly why this cannot possible happen
(unless it turns out that I'm wrong again).

Thanks,
NeilBrown

=20=20

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlpLCnsACgkQOeye3VZi
gbl0Jw//cQ8rh11XDIiL4lX8PdhI/8OMkshB9rZpTKP6DGS5fdMPSqEhHtCMxgzT
4qMg9ByRq5Al94DWVnfVd/11XLRsKz8/iKDRdSedlhXVyMswov4sXnxET71xsXGi
XQciS1s02HfxYAwsWWVQtmLMchw2pXsNeSNd5XszeuUH9yJHjcH/BZSMvW5na6Cg
VyaHO6MPF/axkIfPm+jLDeVsHSPmbLIzcvz0hbborxZ3SWf7qBPhRM21CF/dSWFX
q/zyRSNe1ZFT9cGysN27mSVJWS2npynXkereDpkg91hgPA6ehWw6VM003GTP91L0
p+dtdPXvIqwZxg35SBa50zZrczNbrbwhex9nZ/N6HY5RG/8ttrbDItz0pL96JxaV
770YropJsYMC33TFfWVnjT72UHSYpqUDgmfgWGrK9LsXi5MNvwA6Gk3cUHPpiFGK
LBcJ0KTCb3XwAW2GyiNQO0WqxVVynwTcD4ZqY5mESjELig8HT3OS5f8SlojLp389
YhesK42XV/xuclxuB39254oRJk1IqaDZ+qeLH3B8UnxavsnwelfQgpOrUW8awbY/
VmoNbFzcgaHBgUgn8QqmmaSvSiKeCTn+Odn3rgsF9dxA8YW7PUPk5pyoWRQ9kR0W
AAFDjbxJCu7zR2R+Rptqtux1C/22PmBO0IAejGeRb2BMg08PUeI=
=rDIv
-----END PGP SIGNATURE-----
--=-=-=--
