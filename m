From: NeilBrown <neilb@suse.de>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Thu, 3 Jul 2014 12:40:46 +1000
Message-ID: <20140703124046.74272588@notabene.brown>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
	<20140702204502.6b538fa8@notabene.brown>
	<20140702125434.Horde.abbwKfYRo99Ts-L6UvsCEIA@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WH735pgWl3BD4uG6X4Hn.OT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702125434.Horde.abbwKfYRo99Ts-L6UvsCEIA@webmail.aeiou.pt>
Sender: linux-raid-owner@vger.kernel.org
To: Pedro Teixeira <finas@aeiou.pt>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WH735pgWl3BD4uG6X4Hn.OT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 02 Jul 2014 12:54:34 +0100 Pedro Teixeira <finas@aeiou.pt> wrote:

> cpu is a phenom x6, 8gb ram. controller is LSI 9201-i16. hdd's are =20
> seagate sshd ST1000DX001.
>=20
> So I run the "dd if=3D/dev/md0 of=3D/dev/null=C2=A0 bs=3D4096" and it fai=
led on =20
> alot of places. I had to restart the command several times with the =20
> skip parameter set to a couple of blocks after the last block error. =20
> It run for about 1.5TB of the total 13TB of the volume.
> The md volume didn't drop any drive when running this.
>=20
> dmesg showed:
>=20
> [ 1678.478156] Buffer I/O error on device md0, logical block 196012546

I love numbers, thanks.
The logical block size is 4096, or 8 sectors (1 sector is defined as 512
bytes), so this is at=20
  196012546*8 =3D=3D 1568100368 sectors into the array.

The array has a chunksize of 512K, or 1024 sectors so
 196012546*8/1024 =3D 1531348.015625

gives us the chunk number, and the remaining fraction of a chunk.

The RAID6 has 16 devices, so there are 14 data chunks in each stripe, so to
find where the above chunk is stored we divide by 14

   1531348/14 =3D 109382.0000

So that is chunk 109382 on the first device (though with rotating data,
it might not be the very first).

Add back in the factional part, multiple by 1024 sectors per chunk, and add
the Data Offset,

  109382.01562500*1024+262144 =3D 112269328

So it seems that sector 112269328 on some device is bad.

> The command "mdadm --examine-badblocks /dev/sd[bcdefghijklmnopqr] >>  =20
> raid.b" before and after running the "dd" command returned no changes:
>=20

I didn't notice the fact that the bad block logs were not empty before, sor=
ry.
Anyway:...
>=20
> Bad-blocks on /dev/sdb:
>             112269328 for 512 sectors

Look at that - exactly the number I calculated.  I love it when that works
out.

So the problem is exactly that some blocks are thought by md to be bad.


Blocks get recorded as bad (for raid6) when:

 - a 'read' reported an error which could not be fixed, either
   because the array was degraded so the data could not be recovered,
   or because the attempt to write restored data failed
 - when recovering a spare, if the data to be written cannot be found (due =
to
   errors on other devices)
 - when a 'write' request to a device fails

When your array had three failed devices, some reads and writes would have
failed.  Maybe that caused the bad blocks to be recorded.
What sort of devices failures where they?  If the device became completely
inaccessible, then it would not have been possible to record the bad block
information.

Can you describe the sequence of events that lead to the three failures?
When you put the array back together, did you --create it, or --assemble
--force?

There isn't an easy way to remove the bad block list, as doing so is normal=
ly
asking for data corruption.
However it is probably justified in your case.
As it happens I included code in the kernel to make it possible to remove b=
ad
blocks from the list - it was intended for testing only but I never removed
it.
If you run
  sed 's/^/-/' /sys/block/md0/md/dev-sdq/bad_blocks |=20
  while read; do
     echo $a > /sys/block/md0/md/dev-sdq/bad_blocks
  done

then it should clear all of the bad blocks recorded  on sdq.
You should probably fail/remove the last two devices that you added to the
array before you do this, as they probably don't have properly uptodate
information and doing this will cause corruption.

I probably need to think about better ways to handle the bad block lists.

NeilBrown



--Sig_/WH735pgWl3BD4uG6X4Hn.OT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU7TCrjnsnt1WYoG5AQLAPBAAmlGxiLnT60HgJET6vovZiz09ZlC7qNBe
F5AxRRj9ZcGGCJMq/syqZ0BD5ZwBjfHKh5wJXi2RO0n4cXFSbX2GryGkOlUQbO3g
nCzrxcw+2dZJNX9ypz/RBziu5FU0jh8qyjafTUPvoSONTIg41aO4oWXpPqSqhuYj
dxBk9dU61sYhOt6U1Z6JTy+CXb03QBEo3M8MhqFwzlQI9DV+zEFiOlMdTxcmkV5Z
NoIZ9VOE4LEx7khn27z15GJFVFc6t2YfYLF5BQPFqrPgx1l8tbCkFxTuuPs7JGKZ
jshk6lwGBPHiBF9P+nLBmQE2scGJRidBz0YRRxXBsAV4P3Bq5p6P1n+f+sNF2eJA
JqHl/oUobJd+wy0h4M9X45utjDq6v2EFCToMSe4D0nQNAhnKb+ccKvRXXqyCAoIG
cs3D2H9cNmds2w98DEHuVLGuAQysMxwC810VNST/JTohCF6kBFz9xnmOuYSMbcrt
oxWWReNVFX8aAdrpCNmzQzywy7/g+CEGJK83M8JaSfbBr65IjJq3/nmWVdiQC99R
4grW2/YwpQXXOsRXjkH1Ik+ua7Ljv74dJWb/pdvxmrhPANM/s/WzUOpkVwdmfFUA
FLqKEjn9pCXwKNcKfOqsqhlymrr6yXikbhpoCZRjdGt9FM3mhQvTKt8bOqYGnW7n
bO3sKvScVQk=
=m4VW
-----END PGP SIGNATURE-----

--Sig_/WH735pgWl3BD4uG6X4Hn.OT--
