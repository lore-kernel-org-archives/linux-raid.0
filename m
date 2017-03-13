From: NeilBrown <neilb@suse.com>
Subject: Re: on assembly and recovery of a hardware RAID
Date: Tue, 14 Mar 2017 08:32:37 +1100
Message-ID: <87tw6weubu.fsf@notabene.neil.brown.name>
References: <CAAZLhTdaVM4fagN5=bqWpPx-DjyU6UZ69bJFf51FWMX7oeyJNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAZLhTdaVM4fagN5=bqWpPx-DjyU6UZ69bJFf51FWMX7oeyJNw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alfred Matthews <asm13243546@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Mar 10 2017, Alfred Matthews wrote:

> Hello list. I'm facing a non-redundant Western Digital hardware RAID,
> for which, hardware seems to cause a kernel panic at about 3 seconds
> running time.
>
> I've assembled the customary testing. The drives appear to be striped RAID 0.
>
> Output: http://pastebin.com/c361jGVx
>
> Evidently WD metadata changes over time, since a new console (adding
> USB) will not recognize the drives without erasing them. Files are
> visible as files for the short period of controller health.
>
> I imagine I'm trying to assemble a 2 x 3TB RAID array from the
> original WD disks when mounted as SATA.
>
> Seeking input on proper mdadm configuration for this.
>
> Then I imagine that I may recover files-as-files from this 2 x 3TB to
> standalone disks. Ultimately they would need to move to a new RAID.
>
> Failing: WD My Book Thunderbolt Duo, 2x3TB
> New, incompatible: WD My Book Pro, 2x3TB.
>
> Thanks for any comment.
>
> Thanks for your time.
>

Does
  dmraid -b /dev/sda /dev/sdb /dev/sdc
tell you anything useful?


You will probably want a command like:

 mdadm --build /dev/md0 -l0 -n2 --chunk=SOMETHING /dev/sdXX /dev/sdYY

where SOMETHING is the chunk size. e.g. 64K or 512K or something.
Doing this is non-destructive so you can try several different times,
using "mdadm --stop /dev/md0" to reset before trying again.

After building the array, try "cfdisk /dev/md0" or maybe "fdisk
/dev/md0" to look at the partition table.

What filesystem(s) did you have on the device? Maybe "fsck -n /dev/md0p1"
might tell you if the filesystem looks OK.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljHD/UACgkQOeye3VZi
gbmU1g/+IlUGlm/a6zd4h35XaLqZ4xTeCDjxa2CYpc6guw5hiFc45hqZLRh3Phsy
h/UPtBxxIt6Bw9u7d2y0c27zld4DKHv61H0W9U7FwCu1pZDzI5WLyAJl+bLahCos
4DXqaca96Iq0zPyXLVrdfCr2xnLqCGppBLw1xV8M2oBwsUF24IcqsXcsVywdCeeq
aLJ0seJAwuDs+2VcvjLwlQMxZ+N+Z2y9wP3IJFZaL+VT18CUpmy/uBTgArjYCCiX
RIHS+TU+fLk5qDjUzruJbIhpSSWgzB+OOFXBudOS0A0K4vaFwah0wGHlUacIAO9r
Z1WmycXJ4FXP6SC1bSMHW75WmnCygDrHkOhKgImJuhwMxKclEa+FZG7m/p5jzYrL
pgdC4uRIvdkR90+tSqB166Ww/XaQ7Vg7fS28gLbYza7NFdXDNAyMVhelAP0r3WSK
DQjlGcOou6YEO8ZMqb1hFGxA/U9/v6/sxec+ZQQ1r31aQqse5FJWzqTvTe7qqZYq
2yGvkuyIQNfjtQ0GZyNS+hkpQUkTz/82LoLKdSO4P7C72ts0RIxlZuNgJzqU1sZQ
YP/6ruqTEMWquUtqbOWsYL5dqACWVebcsQWFXgdyCwwK9BCBBJ+1rpU8wiAIoc02
TcARZ/XCYS1DIFBWVd55ent3Gfwlx/a2tnjZN36BW7laDnNaDGw=
=PSWH
-----END PGP SIGNATURE-----
--=-=-=--
