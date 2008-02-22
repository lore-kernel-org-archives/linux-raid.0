From: Pete/Piet Delaney <pete@bluelane.com>
Subject: Increased Reliability by using Raid
Date: Fri, 22 Feb 2008 13:49:40 -0800
Message-ID: <47BF4374.3060008@bluelane.com>
Reply-To: pete@bluelane.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, Piet Delaney <piet.delaney@gmail.com>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Andrew:

~  I have a quick question. Is software raid using mirror on two SATA
drives more reliable that just using a single SATA drive if
properly supported in the rc scripts?

~  My impression is that it's definitely better. The push back I'm
getting here is that our box after power outages is hanging during boot
and making the systems more unreliable. My feeling is that we just
need to modify the rc files to correctly handle the situation and
that the Linux From Scratch base may not have handled it and we
might be better off taking a recent Linux system like Fedora 8
and check out it's config files in a mirror raid configuration.
I suspect it's a easy fixed.

Our new box will have dual power supplies, ECC memory, and either
one or two hot pluggable SATA drives. My feeling is that this is
an fantastic opportunity to use raid. One of our other products
already uses raid with SCSI drives. I've see one problem where
the raid got out of sync during a power outage but it was trivial
to get the raid back in sync and think rc scripts could be easily
set up to do this.

Looks like a slam dunk to me to spend an extra $100 for a second drive
and save our having to RMA the box in the event of a drive starting
to fail. This afternoon I offered to make a $10k bet that it is as
well as doing a lab test with a pair of systems being powered up
and down every few minutes to verify my intuition. I got the ok
to get your opinion on the efficacy of mirror raid for a network
appliance running 2.6.16.

Looks like kgdb is still on track for 2.6.25, hope Jason gets in
back into your next mm patch and it goes mainstream.

- -piet
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHv0N0JICwm/rv3hoRAukIAKCIvhgsJp1KAWGNRFkHczNsk9ibUQCfd0Ku
kL9dqBpm6vUb1A1WZIW2544=
=bbNu
-----END PGP SIGNATURE-----
