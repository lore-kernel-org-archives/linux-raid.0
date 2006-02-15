From: Neil Brown <neilb@suse.de>
Subject: Re: NVRAM support
Date: Thu, 16 Feb 2006 10:00:30 +1100
Message-ID: <17395.45710.99321.522482@cse.unsw.edu.au>
References: <43EC5655.1060504@web.de>
	<20060210124204.GC28676@harddisk-recovery.com>
	<43ECB4A4.6010005@tmr.com>
	<Pine.LNX.4.64.0602101700540.30925@twinlark.arctic.org>
	<20060213092204.GB3209@harddisk-recovery.nl>
	<43F2E526.9010409@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mirko Benz on Wednesday February 15
Sender: linux-raid-owner@vger.kernel.org
To: Mirko Benz <mirko.benz@web.de>
Cc: Erik Mouw <erik@harddisk-recovery.com>, dean gaudet <dean@arctic.org>, Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 15, mirko.benz@web.de wrote:
> Hi,
>=20
> My intention was not to use a NVRAM device for swap.
>=20
> Enterprise storage systems use NVRAM for better data protection/faste=
r=20
> recovery in case of a crash.
> Modern CPUs can do RAID calculation very fast. But Linux RAID is=20
> vulnerable when a crash during a write operation occurs.
> E.g. Data and parity write requests are issued in parallel but only o=
ne=20
> finishes. This will
> lead to inconsistent data. It will be undetected and can not be=20
> repaired. Right?

Wrong.  Well, maybe 5% right.

If the array is degraded, that the inconsistency cannot be detected.
If the array is fully functioning, then any inconsistency will be
corrected by a 'resync'.

>=20
> How can journaling be implemented within linux-raid?

With a fair bit of work. :-)

>=20
> I have seen a paper that tries this in cooperation with a file system=
:
> =84Journal-guided Resynchronization for Software RAID=93
> www.cs.wisc.edu/adsl/Publications

This is using the ext3 journal to make the 'resync' (mentioned above)
faster.  Write-intent bitmaps can achieve similar speedups with
different costs.

>=20
> But I would rather see a solution within md so that other file system=
s=20
> or LVM can be used on top of md.

Currently there is no solution to the "crash while writing and
degraded on restart means possible silent data corruption" problem.
However is it, in reality, a very small problem (unless you regularly
run with a degraded array - don't do that).

The only practical fix at the filesystem level is, as you suggest,
journalling to NVRAM.  There is work underway to restructure md/raid5
to be able to off-load the xor and raid6 calculations to dedicated
hardware.  This restructure would also make it a lot easier to journal
raid5 updates thus closing this hole (and also improving write
latency).

NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
