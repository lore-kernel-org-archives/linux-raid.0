From: Sven Anders <anders@anduras.de>
Subject: Re: RAID1 Corruption
Date: Mon, 17 Jan 2005 20:21:45 +0100
Message-ID: <41EC1049.8000209@anduras.de>
References: <41EBD827.80701@pipi.ma.cx> <200501171624.47645.andrew@walrond.org> <20050117165133.GC99565@caffreys.strugglers.net> <200501171704.10374.andrew@walrond.org> <41EC0371.9060106@infinia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040403080507010209050205"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41EC0371.9060106@infinia.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Markus Gehring <markus.gehring@infinia.de>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------040403080507010209050205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Markus Gehring wrote:
| Hi Folks!
|
| I have a reproducable problem with corrupted data read from a RAID1-array.
|
| Everything works fine with only one drive in the array. If the second is
| synced up read accesses return corrupted data.
|
| Interesting: If you remove again the second disk. The same files will be
|  read correctly again (no matter if written while only one disk is in
| the array or two are synced!)!
|
| Tests with differend disks (2x80GB Seagate and 2x160GB Samsung),
| different partition sizes (20, 40, 80, 160GB), different filesytems
| (ext3, ext2, reiser) showed the same results.
|
| If i use the drive without raid everything works fine.

It's seems to be the same problem I have (see my posting from 5.1.2005
on this mailing-list).

The problem was reproducable. I changed to ext2, but problem persists.
I tried several kernel configurations (with a special extra-small
configuration, which had only the absolute necessary turned on), but
it had no effect (It only took longer to reproduce the problem).
I tried the kernels 2.6.9 with and without the -ac patches, wth no
success at all.

Because I'm not at home till 29.01., I could not run any tests at the
moment, but the problem seem to be the same. The seems to be no problem
with the 2.4 kernel series.

Any ideas?

Regards
~ Sven

- --
~ Sven Anders <anders@anduras.de>                 () Ascii Ribbon Campaign
~                                                 /\ Support plain text e-mail
~ ANDURAS service solutions AG
~ Innstraße 71 - 94036 Passau - Germany
~ Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55

Rechtsform: Aktiengesellschaft - Sitz: Passau - Amtsgericht Passau HRB 6032
Mitglieder des Vorstands: Sven Anders, Marcus Junker, Michael Schön
Vorsitzender des Aufsichtsrats: Dipl. Kfm. Thomas Träger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFB7BBI5lKZ7Feg4EcRAukBAKCewS2zwYERnzfojr/W1K3F3Y7bAACfUuXP
ulBaaE5BGl9nKu16tpLCLm8=
=xh5T
-----END PGP SIGNATURE-----

--------------040403080507010209050205
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


--------------040403080507010209050205--
