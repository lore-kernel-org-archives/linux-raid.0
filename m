From: NeilBrown <neilb@suse.com>
Subject: Re: on assembly and recovery of a hardware RAID
Date: Fri, 12 May 2017 08:27:06 +1000
Message-ID: <87o9uzkp1h.fsf@notabene.neil.brown.name>
References: <CAAZLhTdaVM4fagN5=bqWpPx-DjyU6UZ69bJFf51FWMX7oeyJNw@mail.gmail.com> <87tw6weubu.fsf@notabene.neil.brown.name> <CAAZLhTcEhn2GezDSDJHOLv2VNSynzT-he0FRrVNbz1xtakLsMQ@mail.gmail.com> <87d1djdz8y.fsf@notabene.neil.brown.name> <CAAZLhTdn6xnB6Kuuhf8+VaSd5u6gekUSDSMnK+w5obZNxvNg8A@mail.gmail.com> <CAAZLhTcoU232uBs2zcK6TFj67Jru5oeNE_F0T2fQR6Un66OPXA@mail.gmail.com> <87lgs0cy0e.fsf@notabene.neil.brown.name> <CAAZLhTcNsjzLdEZyzG+kEuDhVye8pnuf6VhWzP=G0NL_aFX-5w@mail.gmail.com> <87a88fcq21.fsf@notabene.neil.brown.name> <CAAZLhTdobNxkYNmp6y3cOrLAdMfTYt3kodzM0+a7E-G=q1QGtw@mail.gmail.com> <CAAZLhTf=GHmSDcY8Eb9SzevofFbDD7f-N8DKZiFkq9j2XV4mQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAZLhTf=GHmSDcY8Eb9SzevofFbDD7f-N8DKZiFkq9j2XV4mQA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alfred Matthews <asm13243546@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, May 03 2017, Alfred Matthews wrote:

> Sorry to disappear for a bit.
>
> Of necessity I've migrated to another working system and I'm in Arch.
> Utility here is fsck.hfs as opposed to hpfsck. I'd like to post that
> output.

I wonder if they are the same thing, or completely different.

>
> mdadm --build /dev/md0 --level=0 -n2 --chunk=8K /dev/sdb2 /dev/sdc2
>
> works, then,
>
> fsck.hfs -v /dev/md0
> *** Checking volume MDB
>   drSigWord      = 0xffffffff
>   drCrDate       = Mon Feb  6 06:28:15 2040
>   drLsMod        = Mon Feb  6 06:28:15 2040
>   drAtrb         = BUSY | HLOCKED | UMOUNTED | BBSPARED | BVINCONSIS |
> COPYPROT | SLOCKED
>   drNmFls        = 65535
>   drVBMSt        = 65535
>   drAllocPtr     = 65535
>   drNmAlBlks     = 65535
>   drAlBlkSiz     = 4294967295
>   drClpSiz       = 4294967295
>   drAlBlSt       = 65535
>   drNxtCNID      = 4294967295
>   drFreeBks      = 65535
>   drVN           = ""
>   drVolBkUp      = Mon Feb  6 06:28:15 2040
>   drVSeqNum      = 4294967295
>   drWrCnt        = 4294967295
>   drXTClpSiz     = 4294967295
>   drCTClpSiz     = 4294967295
>   drNmRtDirs     = 65535
>   drFilCnt       = 4294967295
>   drDirCnt       = 4294967295
>   drEmbedSigWord = 0xffff
>   drEmbedExtent  = 65535[65535..131069]
>   drXTFlSize     = 4294967295
>   drXTExtRec     =
> 65535[65535..131069]+65535[65535..131069]+65535[65535..131069]
>   drCTFlSize     = 4294967295
>   drCTExtRec     =
> 65535[65535..131069]+65535[65535..131069]+65535[65535..131069]
> Bad volume signature (0xffffffff); should be 0x4244. Fix? y
> Volume creation date is in the future (Mon Feb  6 06:28:15 2040). Fix? y
> Volume last modify date is in the future (Mon Feb  6 06:28:15 2040). Fix? y
> Volume bitmap starts at unusual location (1), not 3. Fix? y
> *** Checking volume structure
> *** Checking extents overflow B*-tree
>
> It's possible that I was unwise in accepting the changes from fsck.

Definitely possible.

Given how many of the numbers listed above are 0xffff or 0xffffffff, it
is unlikely that the tool found anything useful.

>
>>>
>>> How is your C coding?  You could
>>>   apt-get source hfsplus
>>> and hack the code and try to build it yourself....
>>>
>
> Still fine. By now not clear if this is what's needed.

I don't think I can be of further help, sorry.

NeilBrown


>
> Al
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkU5ToACgkQOeye3VZi
gbllGBAAvdShgo142BB4Rau75IsJrmAeRDhPIDc5iXtZtrwSpdjUD/kLxTiWELiq
JmgAoWq41klCREnsg7AcNNM4XND0EAWo6IQYhV81BXz9AlGi+hVHAqb+gCPAtuXH
SRIfYis6Fv0liVmnfIivbmCvq0IZcdhzW+DxLPEtR/sclWwVO9xkR7+cE6AOUj5i
llPz5upZ8xa80oKDeBhXwlbuOBVvG66qz1NzoiTai3WzaYukTwBFlR/uJr10j8GY
0Zr0IKKeFd46Lb0zCENCaJTcFdJwc0qtxR8HEaRwLwkMJWugCeXsoL3KexwRgEUK
ObxvjDJ+aZjBQApIUMLV1MoGh0cZaFXLrDrKsN8ZQpw7EOk00edDY83EI7OuixjI
B0KpYoMc/nAMctZl2iV9lrmgtPpJhXgocVYP4TmX0cIQ/xlYZq3fp6FQv6GEb1d7
Flz2uAFsbrfThZRfpC2nTRE9uCXLPGkKUb7IelBfps3dgmXaTjk/lDo7ZqeldkVa
Q/5lk6Arpw+6U5XFb4dS6sGBqMig1FQaKVZ9FnWzOE29DKboSox4lq3aVAQ5bq4Z
O+3HPBxbfvaA2VYCvEHB2ks5Cgl19y7DaI7EniG2ebvXsI5bY/MB6XzhwP7z3xgL
ITDXvMhEokc22UrDZxLffEePnqHCW5/6Q+pyVI1N1RxLDTZ+ZE8=
=ucQG
-----END PGP SIGNATURE-----
--=-=-=--
