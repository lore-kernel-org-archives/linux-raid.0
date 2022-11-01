Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BFFAC4332F
	for <linux-raid@archiver.kernel.org>; Tue,  1 Nov 2022 23:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiKAXzA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Nov 2022 19:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiKAXy6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Nov 2022 19:54:58 -0400
X-Greylist: delayed 314 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Nov 2022 16:54:56 PDT
Received: from titan.solsystem.syn-net.org (smtp.syn-net.org [178.63.156.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 801FC1A075
        for <linux-raid@vger.kernel.org>; Tue,  1 Nov 2022 16:54:56 -0700 (PDT)
Received: from [10.17.1.100] (213-47-44-84.cable.dynamic.surfer.at [213.47.44.84])
        by titan.solsystem.syn-net.org (Postfix) with ESMTPSA id A20E52095A
        for <linux-raid@vger.kernel.org>; Wed,  2 Nov 2022 00:49:40 +0100 (CET)
Message-ID: <46045b2b-2aa5-5e75-2616-d28bbcb66786@syn-net.org>
Date:   Wed, 2 Nov 2022 00:49:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-Language: en-US
To:     linux-raid@vger.kernel.org
References: <1z_MZ4Xqld_IRMUbGJE66v2VUhXkBhlHnWJEfLASWNcv5s3Wo3A1YeuQBJBuksxJtFPpmsPbg1_F8PC3Sj4HrzL6Go3aIanVihzcC-4ZHEQ=@protonmail.com>
 <87373og9z9.fsf@notabene.neil.brown.name>
 <XUhdgUHMsoit8A9Qw13P1q6NQUxsgqNZCsgx6us_8kHu50GPOvQoOBwP-ryQz54CBi6Js7J2xwC8jgKQ5geXi5AdVLT27YlucQ4tWH-8xlM=@protonmail.com>
 <87r2r8dk80.fsf@notabene.neil.brown.name>
 <f92IIdV_PSMtdilVnQDOaLSxzvpTkAa6D0nxpuplzzdnaP9km9JveoXfzOlygcXD5Y_HpN49Fh0x4nOZFhXPfv5VyPrT6CgFO-nsULq6wn0=@protonmail.com>
 <871sj5dsiv.fsf@notabene.neil.brown.name>
 <M1riU2VdgyXq3ozdVUjaSDLksJfD8z3lZEy7D8JWIMb9mJk8A6CFz7Q1_tA_wFkVGC1lyTI7yTMb8DXv7T6JDGvKzUFGHbY7mZ9vLNqlowo=@protonmail.com>
 <F_VxJAwrrEFTHG3fvMDQYPLKrS0w9yabmLk-nyrGRf3UQV-QxsnRSzojv6XQtCiKN7YMZ3sSOlbLduUL_apbYN25g7ouW-Th2S_fbMDgAEM=@protonmail.com>
From:   Darshaka Pathirana <dpat@syn-net.org>
Subject: Re: Troubleshooting "Buffer I/O error" on reading md device
In-Reply-To: <F_VxJAwrrEFTHG3fvMDQYPLKrS0w9yabmLk-nyrGRf3UQV-QxsnRSzojv6XQtCiKN7YMZ3sSOlbLduUL_apbYN25g7ouW-Th2S_fbMDgAEM=@protonmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0cENNGVdMTPUCgXU0oCpaJV8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0cENNGVdMTPUCgXU0oCpaJV8
Content-Type: multipart/mixed; boundary="------------2bVa0eu9M8B6RsyBHF6UAfca";
 protected-headers="v1"
From: Darshaka Pathirana <dpat@syn-net.org>
To: linux-raid@vger.kernel.org
Message-ID: <46045b2b-2aa5-5e75-2616-d28bbcb66786@syn-net.org>
Subject: Re: Troubleshooting "Buffer I/O error" on reading md device
References: <1z_MZ4Xqld_IRMUbGJE66v2VUhXkBhlHnWJEfLASWNcv5s3Wo3A1YeuQBJBuksxJtFPpmsPbg1_F8PC3Sj4HrzL6Go3aIanVihzcC-4ZHEQ=@protonmail.com>
 <87373og9z9.fsf@notabene.neil.brown.name>
 <XUhdgUHMsoit8A9Qw13P1q6NQUxsgqNZCsgx6us_8kHu50GPOvQoOBwP-ryQz54CBi6Js7J2xwC8jgKQ5geXi5AdVLT27YlucQ4tWH-8xlM=@protonmail.com>
 <87r2r8dk80.fsf@notabene.neil.brown.name>
 <f92IIdV_PSMtdilVnQDOaLSxzvpTkAa6D0nxpuplzzdnaP9km9JveoXfzOlygcXD5Y_HpN49Fh0x4nOZFhXPfv5VyPrT6CgFO-nsULq6wn0=@protonmail.com>
 <871sj5dsiv.fsf@notabene.neil.brown.name>
 <M1riU2VdgyXq3ozdVUjaSDLksJfD8z3lZEy7D8JWIMb9mJk8A6CFz7Q1_tA_wFkVGC1lyTI7yTMb8DXv7T6JDGvKzUFGHbY7mZ9vLNqlowo=@protonmail.com>
 <F_VxJAwrrEFTHG3fvMDQYPLKrS0w9yabmLk-nyrGRf3UQV-QxsnRSzojv6XQtCiKN7YMZ3sSOlbLduUL_apbYN25g7ouW-Th2S_fbMDgAEM=@protonmail.com>
In-Reply-To: <F_VxJAwrrEFTHG3fvMDQYPLKrS0w9yabmLk-nyrGRf3UQV-QxsnRSzojv6XQtCiKN7YMZ3sSOlbLduUL_apbYN25g7ouW-Th2S_fbMDgAEM=@protonmail.com>

--------------2bVa0eu9M8B6RsyBHF6UAfca
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I am capturing this thread, because I also stumbled over the same problem=
,
except I am running a RAID-1 setup.

The server is (still) running Debian/stretch with mdadm 3.4-4+b1.

Basically this is what happens:

Accessing the RAID fails:

  % sudo dd if=3D/dev/md0 of=3D/dev/null skip=3D3112437760 count=3D335544=
32
  dd: error reading '/dev/md0': Input/output error
  514936+0 records in
  514936+0 records out
  263647232 bytes (264 MB, 251 MiB) copied, 0.447983 s, 589 MB/s

dmesg output while trying to access the RAID:

  [Tue Nov  1 22:09:59 2022] Buffer I/O error on dev md0, logical block 3=
89119087, async page read
  [Tue Nov  1 22:22:01 2022] Buffer I/O error on dev md0, logical block 3=
89119087, async page read

Jumping to the 'logical block':

  % sudo blockdev --getbsz /dev/md0
  4096

  % sudo dd if=3D/dev/md0 of=3D/dev/null skip=3D389119087 bs=3D4096 count=
=3D33554432
  dd: error reading '/dev/md0': Input/output error
  0+0 records in
  0+0 records out
  0 bytes copied, 0.000129958 s, 0.0 kB/s

But the underlying disk seemed ok, which was strange:

  % sudo dd if=3D/dev/sdb1 skip=3D3112437760 count=3D33554432 of=3D/dev/n=
ull
  33554432+0 records in
  33554432+0 records out
  17179869184 bytes (17 GB, 16 GiB) copied, 112.802 s, 152 MB/s
  sudo dd if=3D/dev/sdb1 skip=3D3112437760 count=3D33554432 of=3D/dev/nul=
l  9.18s user 29.80s system 34% cpu 1:52.81 total

Note, through trial + error I found the offset of /dev/md0 to
/dev/sdb1 to be 262144 blocks (with block size 512). That's why skip is
not the same for both commands.

After a very long research I found this thread and yes, there is a bad
block log:

  % cat /sys/block/md0/md/rd*/bad_blocks
  3113214840 8

  % sudo mdadm -E /dev/sdb1 | grep Bad
    Bad Block Log : 512 entries available at offset 72 sectors - bad bloc=
ks present.

The other disk of that RAID has been removed, because the disk had
SMART errors and is about to be replaced. Only then I noticed the
input/output error.

I am not sure how to proceed from here. Do you have any advice?

On 2018-02-02 02:55, NeilBrown wrote:
>
> Short answer is that if you use
>   --assemble --force-no-bbl
> it will really truly get rid of the bad block log.  I really should add=

> that to the man page.

*friendly wave*

> Longer answer:
> If you assemble the array (without force-no-bbl) and
>
> [...]
>
> So this should be row 2 (counting from 0)
> D2 D3 P  D0 D1
>
> rd2 and rd2 are bad, so that is 'P' and 'D0'.
>
> So this confirms that it is just the first 4K block of that stripe whic=
h
> is bad.
> Writing should fix it... but it doesn't.  The write gets an IO error.
>
> Looking at the code I can see why.  The fix isn't completely
> trivial. I'll have think about it carefully.

I am curious: did you come up with a solution?

Best & thx for your help,
 - Darsha

P.s. I am not subscribed, please put me on CC.

--------------2bVa0eu9M8B6RsyBHF6UAfca--

--------------0cENNGVdMTPUCgXU0oCpaJV8
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEjfInGHHlfaVxTI7em7aYPd2Br+sFAmNhsIwFAwAAAAAACgkQm7aYPd2Br+tj
9g/+Oaj2XaGNoWF6xqS+OevX8RHs5CB3Dzd70UYezeKQyKcXaauyGxnxBTlMsRZ18t0rsqIq7Dp5
+sUcVck/yCP4ngK1zjYOfX8CuFJgeoFoKnIL60Ko5LgalK1w39rhDRfDe99ITAWN6QsGfvlevwUy
EVzdRWDE/seS8cov440EtTVyDc4xL8bZj9o/R/T1sPDqBgYYYuO8aXxjJJn4HDYPBZN4/PUscI6j
h8eITUu+4quWZvxDgxUhCSng/7MT9R508GbAGDavIyqtWuoTO8XNJ3bmtPdcV7bwLk/W78vWZboL
6+rTrq5mJFB95U6k6diRhpJzccqYoIVcYaRUN8g7d2Knwx4SOdGtiNndBP3qxLq2pKIEkJzmMkRK
8IwsrnKQ4moEnVWtn1807pTmdYKMvUiFIIqgRokoy0rI0kYoikluvH8dnkJLFEWHXCZhyIciSO8o
Lvh7DRklVNiaY8wakcFsoOK6OwhGc91gj1jt6kmRAalgFVmzhQHKGRr5JxpIs+M/c1pJniyQ6bCl
MoPLskvWXldi7m3BjqE186IIY9gY73eR5GoRee/OYo7Qi8laodqlyG6IcgUHCEcn4yjB4iX8/ffz
x3suKzkCe+hUl/BXADz4m+jbc6/yWUxb9NpqRrKzshkmqmjjyutCjETAxmlIQYtEuRI/uzjE20kC
OzQ=
=pgYP
-----END PGP SIGNATURE-----

--------------0cENNGVdMTPUCgXU0oCpaJV8--
