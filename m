From: NeilBrown <neilb@suse.com>
Subject: Re: Troubleshooting "Buffer I/O error" on reading md device
Date: Wed, 03 Jan 2018 08:27:59 +1100
Message-ID: <87r2r8dk80.fsf@notabene.neil.brown.name>
References: <1z_MZ4Xqld_IRMUbGJE66v2VUhXkBhlHnWJEfLASWNcv5s3Wo3A1YeuQBJBuksxJtFPpmsPbg1_F8PC3Sj4HrzL6Go3aIanVihzcC-4ZHEQ=@protonmail.com> <87373og9z9.fsf@notabene.neil.brown.name> <XUhdgUHMsoit8A9Qw13P1q6NQUxsgqNZCsgx6us_8kHu50GPOvQoOBwP-ryQz54CBi6Js7J2xwC8jgKQ5geXi5AdVLT27YlucQ4tWH-8xlM=@protonmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <XUhdgUHMsoit8A9Qw13P1q6NQUxsgqNZCsgx6us_8kHu50GPOvQoOBwP-ryQz54CBi6Js7J2xwC8jgKQ5geXi5AdVLT27YlucQ4tWH-8xlM=@protonmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: RQM <rqm@protonmail.com>
Cc: "linux-raid\\@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 02 2018, RQM wrote:

> Hello,
>
> thanks for the quick and helpful responses! Answers inline:
>
> =E2=80=8B> Step one is confirm that it is easy to reproduce.
>> Does
>> dd if=3D/dev/md0 bs=3D4K skip=3D1598030208 count=3D1 of=3D/dev/null
>>
>> trigger the message reliably?
>> To check that "4K" is the correct blocksize, run
>> blockdev --getbsz /dev/md0
>>
>> use whatever number if gives as 'bs=3D'.
>
>
> blockdev does indeed report a blocksize of 4096, and the dd line does rel=
iably trigger
> dd: error reading '/dev/md0': Input/output error
> and the same line in dmesg as before.
>
>> Once you can reproduce with minimal IO, do
>> echo file:raid5.c +p > /sys/kernel/debug/dynamic_debug/control
>>repeat experiment
>>
>>echo file:raid5.c -p > /sys/kernel/debug/dynamic_debug/control
>>
>> and report the messages that appear in 'dmesg'.
>
> I had to replace the colon with a space in those two lines (otherwise I w=
ould get "bash: echo: write error: Invalid argument"), but after that, this=
 is what I got in dmesg:
> https://paste.ubuntu.com/26305369/

[Tue Jan  2 11:14:47 2018] locked=3D0 uptodate=3D0 to_read=3D1 to_write=3D0=
 failed=3D2 failed_num=3D3,2

So for this stripe. Two devices appear to be failed: 3 and 2.
As the two devices clearly are thought to be working there must be a bad
block recorded.

>
>> Also report "mdadm -E" of each member device, and kernel version (though
>> I see that is in the serverfault report :  4.9.30-2+deb9u5).
>
> mdadm -E says: https://paste.ubuntu.com/26305379/

I needed "mdadm -E" the components of the array, so the partitions
rather than the whole devices. e.g. /dev/sdb1, not /dev/sdb.

This will show a non-empty bad block list on at least two devices.

You can remove the bad block by over-writing it.
  dd if=3D/dev/zero of=3D/dev/md0 bs=3D4K seek=3D1598030208 count=3D1
though that might corrupt some file containing the block.

(note "seek" seeks in the output file, "skip" skips over the input
file).

How did the bad block get there?
A possible scenario is:
 - A device fails and is removed from array
 - read error occurs on another device.  Rather than failing the whole
   device, md records that block as bad.
 - failed device is replaced (or found to be a cabling problem) and
   recovered.  Due to the bad block the stripe cannot be recovered,
   so a bad block is recorded in the new device.

If the read error was really a cabling problem, then the original data
might still be there.  If it is, you could recover it and write it back
to the array rather then writing from /dev/zero.
Finding out which file the failed block is part of is probably possible,
but not necessarily easy.  If you want to try, the first step is
reporting what filesystem is on md0.  If it is ext4, then debugfs can
help.  If something else - I don't know.

NeilBrown

=20

> The kernel has been updated between the serverfault post and my first mai=
l to this list to 4.9.65-3+deb9u1. No changes since.
>
>>
>> Then run
>> blktrace /dev/md0 /dev/sd[acdef]
>> in one window while reproducing the error again in another window.
>> Then interrupt the blktrace.  This will produce several blocktrace*
>> files.  create a tar.gz of these and put them somewhere that I can get
>> them - hopefully they won't be too big.
>
> I had to adjust the last blktrace argument to /dev/sd[b-f] since after th=
e last reboot the names of the drives have changed, but here's the output:
> https://filebin.ca/3mnjUz1OIXqm/blktrace-out.tar.gz
> I also included the blktrace terminal output in there.
>
> Thank you so much for the effort! Please let me know if you need anything.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlpL+WAACgkQOeye3VZi
gbnCpBAAszmnOaBMc+QB+2pne6ojqeT/v3ymWva7VePXdMREeAm2cQ2BCWpXQqbj
f4VIjFlGJipYEEuMQ4C1CXc/rGX43qdzwhJHSMqRK5L9Aegsak4TKPx904JKni4l
uH2Xrc4KoBQlEEN8MpjE5BmYwQJ0Ksp2stXH8ulak417gM8KG8SlNQxjjC7D/K98
uueC69ZDNXUTzC8for/bbi2ZXMM3IE645Cn9SW01K2XVDuBd4tgHBrvgSjZe2vt0
QfDQgORlcP1LBWA+SFP+kTl4LW0EXa0RZbNcfqvfCSVCNqCxRz8bGaBpvrRJyz0n
ZGmR3w3pfPJKa/PRdYU10FRA5QK7VCtF/dR5gg4kJZSrr0cq5bYJnB0zslA5N3cN
hWu3JLw9WoUBXLpF15Ie0huegpg2IMvTeWc+Dj4lq6gyxjRVlFleHlyuoZI5VGMU
QPx8Oph7aX8wtwtQRqw2n/ELyr2f9lyX2p10yJGnLJGa4DWrj9YeTnICCs3Wgju1
r+5CrLOrTrzQOwqd9v9VTyD5KVaJX62u7QoAADGqfJN2qkQqJyZoh9gb9man1l7j
TY6l4ZmfkxluQfYthIYEzKSn8T3UDmNuT9whjyDgTA9O6RaNblNCilmZhJ2REWGl
7LKznCTO6DgE7f8RCa1K80cFAVj1AiVjjaJvl72/NSy4tff0u/0=
=hC4B
-----END PGP SIGNATURE-----
--=-=-=--
