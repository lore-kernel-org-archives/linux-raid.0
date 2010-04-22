From: Eric MSP Veith <eveith@wwweb-library.net>
Subject: Status of Linux MD RAID 10? (Or: Why is it still marked
 experimental?)
Date: Thu, 22 Apr 2010 11:17:51 +0000
Message-ID: <20100422111750.GB32053@hitomi.veith-m.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello list,

I'm using Linux' MD feature with two RAID 1 arrays and am pretty happy with it.
Since I'm planning to change my disk layout, I'd like to switch to RAID level
10. But when configuring current 2.6.33 stable kernel, I found RAID 10 marked
experimental.

Why is this that case?

I normally do not tend to ignore the "EXPERIMENTAL" warning; in fact, my
current "home server" kernel does not include any single item marked as
experimental.

I've googled around before bugging the ML and found several others asking
questions along the line "can I use MD RAID 10 right now?", with answers like
"it works for me so far." I, on the contrary, would like to know what issues
prevent RAID 10 from getting the "experimental" KConfig tag removed.

TIA!

            Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkvQMF4ACgkQhS0drJ3goJIOwQCffOtkGCs57p5dyYu6pcQdgpyp
KcsAn0MRkm9ShMFNwGKgAY4fe2hFuB0c
=08wl
-----END PGP SIGNATURE-----
