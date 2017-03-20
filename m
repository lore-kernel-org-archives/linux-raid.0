From: NeilBrown <neilb@suse.com>
Subject: Re: on assembly and recovery of a hardware RAID
Date: Mon, 20 Mar 2017 16:34:09 +1100
Message-ID: <87lgs0cy0e.fsf@notabene.neil.brown.name>
References: <CAAZLhTdaVM4fagN5=bqWpPx-DjyU6UZ69bJFf51FWMX7oeyJNw@mail.gmail.com> <87tw6weubu.fsf@notabene.neil.brown.name> <CAAZLhTcEhn2GezDSDJHOLv2VNSynzT-he0FRrVNbz1xtakLsMQ@mail.gmail.com> <87d1djdz8y.fsf@notabene.neil.brown.name> <CAAZLhTdn6xnB6Kuuhf8+VaSd5u6gekUSDSMnK+w5obZNxvNg8A@mail.gmail.com> <CAAZLhTcoU232uBs2zcK6TFj67Jru5oeNE_F0T2fQR6Un66OPXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAZLhTcoU232uBs2zcK6TFj67Jru5oeNE_F0T2fQR6Un66OPXA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alfred Matthews <asm13243546@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Mar 18 2017, Alfred Matthews wrote:

> I've switched to the backup drives which are clones of the first, now,
> so destructive operations are ok if necessary. Also signatures will
> have changed.
>
> 0. Hm. Evidently the system is JHFS instead of HFS+, per the output
> below. Unsure if there is separate tooling in Debian.
>
> 1. Mount via
>
> mdadm --build /dev/md0 --level=0 -n2 --chunk=512K /dev/sdc2 /dev/sdb2
>
> works just fine. Thanks!
>
> 2. I'm still sticking with the non-destructive, non-mount edits for
> now. So I can report the following:
>
> hpfsck -v /dev/md0 | cat >> hpfsck_output.txt
>
> yields some stuff probably more enlightening than prior.

This is promising until:


> *** Checking Backup Volume Header:
> Unexpected Volume signature '  ' expected 'H+'

Here the backup volume header, which is 2 blocks (blocks are 8K) from
the end of the device, looks wrong.
This probably means the chunk size is wrong.
I would suggest trying different chunksizes, starting at 4K and
doubling, until this message goes away.
That still might not be the correct chunk size, so I would continue up
to several megabytes and find all the chunksizes that seem to work.
Then look at what else hpfsck says on those.

BTW, this:
> Invalid total blocks 2BA8CC68, expected 0 Done ***
is not a real problem, just some odd code.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljPadEACgkQOeye3VZi
gblVohAAnWuOQK8dKS9i9t/k1/3NrLPFNJOPTE+1lUp88+zaT75bq/tGrJmv4bHB
T7fspEXAPj3PbyLwF6bAb3dMdA9GFH6riIOvneXgA5EIRrz36Zk2ZijvtWBb6g0n
E6L25lYt1pkGZjeYhHj6U6UjpxPsWk0nmZrEkThDIpuRYFMKKQFlneo5XZlWMTjQ
RgGpb8dBT3CF0ZuoWg31oeuVzVBTgsT6zRfOc7wETuqJuTY3WF2dMcUgTE0zjhmg
kNmDInHWqRQTS815pW6AdYVGOLP+aDx3TmYkczn0+Bzf2Xw0uljMWWlyucv+g3rN
9k5tCj2IOOqcnZKgW5ISA1LGk1gP+Y0VVQBw0H1TdEU+AMhmMRWkI1D+o2ZYaTBz
IbKtm0BtpZNvKhcYkvfiuSovpwhfkvgT8UzVT3HYylVZEpLrYoPPhHkzcMrgvuNl
M50rRGssZ9dInpg1tAoB52VLnN2oFlo+5vKPcs92p/h/Kh0CGcM/KK4xmgtaiqgI
quOCGGlr4Up+VjEyDvxDCIsn63rvhHAvZegLAVdqDCfneYHumFGQ5UBjvsyYzBgl
WoJOHuW7Yc1EhsnFW7Nbz6U4eEJ0RAUUG39s+f0UT1juxkAIV25SWt41scK+1q7V
Mjlq/bErp49dD9qCTNjygIQniw7HERm5MF7/0ITvRVfewCJ+tOY=
=Ri2g
-----END PGP SIGNATURE-----
--=-=-=--
