From: Sven Anders <anders@anduras.de>
Subject: Re: Linux 2.6.10 / RAID1 problem
Date: Thu, 06 Jan 2005 13:01:39 +0100
Message-ID: <41DD28A3.5090308@anduras.de>
References: <41DC515C.7030208@anduras.de> <16860.27580.73601.462427@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070104000803010102040203"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16860.27580.73601.462427@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070104000803010102040203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Neil Brown wrote:
| On Wednesday January 5, anders@anduras.de wrote:
|
|>-----BEGIN PGP SIGNED MESSAGE-----
|>Hash: SHA1
|>
|>Hello!
|>
|>I'm expirencing strange problems on my server running Software RAID1 (Mirroring) under
|>the Linux kernel 2.6.10. It works nicely under Linux 2.4.18!

(Correction: not 2.4.18, it's a 2.4.25 kernel!)

|
|
| Why do you think it is a raid problem rather than an ext3 problem?
|
| Are you able to run the same test on a single unraided drive?

Yes I've done it today and running on the same harddisk (one disk alone and both
in parallel) everything worked fine!

Then I created a RAID1 of this disks and tried the test again... Same error!

Maybe it's an problem with ext3 running on RAID1, but it's worked under 2.4.25!

|>Any special kernel compile options not to use when using RAID?
|
| No.

One difference between the kernels is, the 2.6.10 is optimized for the current
processor (Athlon) and the old 2.4.25 is optimized for AMD-K6/2 (the old processor).


What do you think??

Regards
~ Sven

- --
~ Sven Anders <anders@anduras.de>

~ ANDURAS service solutions AG
~ Innstraße 71 - 94036 Passau - Germany
~ Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55

Rechtsform: Aktiengesellschaft - Sitz: Passau - Amtsgericht Passau HRB 6032
Mitglieder des Vorstands: Sven Anders, Marcus Junker, Michael Schön
Vorsitzender des Aufsichtsrats: Dipl. Kfm. Karlheinz Antesberger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFB3Sij5lKZ7Feg4EcRAu3XAJ40M9WdVCZDdmFTuZny+vsrZKMD5ACgjskA
bltLWcobu2pliqojMHg4ZQQ=
=CJJC
-----END PGP SIGNATURE-----

--------------070104000803010102040203
Content-Type: text/x-vcard; charset=utf8;
 name="anders.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="anders.vcf"

begin:vcard
fn:Sven Anders
n:Anders;Sven
org:ANDURAS AG;Research and Development
adr;quoted-printable:;;Innstra=C3=9Fe 71;Passau;Bavaria;94036;Germany
email;internet:anders@anduras.de
title:Dipl. Inf.
tel;work:++49 (0)851 / 490 50 - 0
tel;fax:+49 (0)851 / 4 90 50 - 55
x-mozilla-html:FALSE
url:http://www.anduras.de
version:2.1
end:vcard


--------------070104000803010102040203--
