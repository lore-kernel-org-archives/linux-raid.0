From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Wed, 08 Oct 2014 13:56:51 -0400
Message-ID: <54357AE3.4010806@ubuntu.com>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com> <20140607075140.277c0880@natsu> <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com> <BLU436-SMTP1535675BF98253D9B967F17982E0@phx.gbl> <BBD6BB5F-9D33-413B-AD74-3DC3EA34D6AB@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BBD6BB5F-9D33-413B-AD74-3DC3EA34D6AB@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Wilson Jonathan <piercing_male@hotmail.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/9/2014 8:09 PM, Chris Murphy wrote:
> But what I'm reporting is an instance where an ATA Secure Erase 
> definitely did not fix up a single one of the bad sectors. Maybe 
> that's consistent with the spec, I don't know, but it's not what
> I'd expect seeing as every sector, those with an without LBA's
> assigned, are overwritten. Yet pending sectors were not remapped.
> Further, with all sectors overwritten by software (not merely the
> ATA Secure Erase command) yields no errors yet SMART reports there
> are still pending sectors, yet it's own extended test says there
> are none. I think that's bad behavior. But perhaps I don't
> understand the design and it's actually working as designed.

It sounds like what happened is the secure erase successfully rewrote
the sectors that were already flagged as pending, but did not
decrement the pending count.

FYI, rather than continuing to run a smart selftest to find one
sector, then use dd to fix it, and repeat, it would be much faster to
use the badblocks utility to read and rewrite the whole drive.  You
will want to make sure to use the correct sector size, and a
sufficiently large batch size for good performance.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUNXrjAAoJEI5FoCIzSKrw//cH/jgbli22/MmRpRXLOc0YJg8O
npSEI3fusBspMWhWS+a5SGRQQQjrfiK8mK8NkAC1VrX80zI8UcLkrBNVX1NQQ7eP
tgjJJJLN0BeQIk7RtAhO0rxajnZp19bBv7r8oRgWg9PRXrrxZHrXJNxHqUlANNsq
70blruORy3MbTqUk8QU4qXw/y5XduhRyJEX0SDogrQwI0xJqaUWPn5CQPQnKWydr
0q6evfdRVfLC2rg0AbQ1ksj+nRhTRkrUctXuNc/8GL4S6wR77bQwTXlyBn8E8Uec
T6lsCs5J43e2yyRtj3c0ZWcmyuZuwKbO4LHPAA4kYf9faHV/OEWPwlAHHVC1Ggo=
=2OuK
-----END PGP SIGNATURE-----
