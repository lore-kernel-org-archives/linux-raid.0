From: Sven Anders <anders@anduras.de>
Subject: Re: Linux 2.6.10 / RAID1 problem (SOLVED)
Date: Mon, 14 Feb 2005 21:02:04 +0100
Message-ID: <421103BC.8010200@anduras.de>
References: <41DC515C.7030208@anduras.de> <16860.27580.73601.462427@cse.unsw.edu.au> <41DD28A3.5090308@anduras.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080107040903030502010403"
In-Reply-To: <41DD28A3.5090308@anduras.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080107040903030502010403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sven Anders wrote:
| Neil Brown wrote:
| | On Wednesday January 5, anders@anduras.de wrote:
| |>
| |>I'm expirencing strange problems on my server running Software RAID1 (Mirroring) under
| |>the Linux kernel 2.6.10. It works nicely under Linux 2.4.25!
| |
| | Why do you think it is a raid problem rather than an ext3 problem?
| |
| | Are you able to run the same test on a single unraided drive?
|
| Yes I've done it today and running on the same harddisk (one disk alone and both
| in parallel) everything worked fine!
|
| Then I created a RAID1 of this disks and tried the test again... Same
| error!
|
| Maybe it's an problem with ext3 running on RAID1, but it's worked under
| 2.4.25!

Hi everybody!

I finally solved my problem. After some more test, I was finally able to reproduce the
problem under Linux 2.4 too. My Test had to run over 10 hours and many gigabytes of copied
data until the same disk corruption occured. It seemed that the Linux kernel 2.6 triggered
the problem faster, because it did more stress on the hardware.

After that, I tried RAID on this harddisks on an external IDE controller with a different
chipset with no success either. Finally I replaced my cheap mainboard (AsRock K7VT4A+) by
an expensive MSI mainboard and everthing works fine.


As somebody else on this list already stated:

~ NEVER buy cheap hardware, if you want to run RAID on it!


Linux RAID may have some bugs, but it seems to be stable, after all!
Never trust cheap hardware :-)


Thanks for all the help,
~ signing off...

~  Sven

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

iD8DBQFCEQO85lKZ7Feg4EcRAnduAJ9tM814MWuLVci40f4TJEtrqWco4gCfV/kP
ditSozEj/lfJgxNShZypdJA=
=PoJg
-----END PGP SIGNATURE-----

--------------080107040903030502010403
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


--------------080107040903030502010403--
