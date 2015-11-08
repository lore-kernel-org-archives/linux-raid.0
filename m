From: Francisco Parada <cisco@abitofthisabitofthat.com>
Subject: Re: RAID 6 Not Mounting (Block device is empty)
Date: Sun, 8 Nov 2015 09:48:37 -0500
Message-ID: <31D02BFE-239B-42BE-9176-10DF20A78A9C@abitofthisabitofthat.com>
References: <BD358508-33D4-4463-99AB-118019C2EB06@abitofthisabitofthat.com> <563E479E.50409@turmel.org> <6AC4B7C0-0AE8-4E0A-9B25-049025C386C3@abitofthisabitofthat.com> <563E685C.70208@turmel.org> <C57F2260-D20C-4688-93F6-CB3CE8CF9F30@abitofthisabitofthat.com> <563E843E.5060108@turmel.org> <251B709D-3310-433E-8817-E875194A69F9@abitofthisabitofthat.com> <563F5A1B.30506@turmel.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <563F5A1B.30506@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Apple Mail? Eeeewwww!  :-)
Hah! Jerk!  ;-) Just kidding

> Yeah, that's normal with partial successes.  Also, consider not using
> md127.  That's mdadm's "I don't know what number to use" default.
> (Followed by 126, then 125, as so on.)
Just want to clarify this bit.  Are you saying I should use a number as such to mount it now instead the 127 that it was called until the failure?  Or in the future?  For the two newer arrays, I had called them 500 and 400, just to be safe so there was no overlap.

[trim /]
> Consider upgrading your system when all is safe.
OK, I wasn't too sure how safe it was to upgrade the kernel to something that Canonical wasn't even using on 15.04 ... But I'll do some more research.

I'll use the recovery media option to give that a shot, and report back shortly. 

You're a rockstar!

Thank you,

Cisco--

