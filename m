From: Benjamin Davenport <ben@monkeysushi.net>
Subject: Re: PATA/SATA Disk Reliability paper
Date: Sun, 25 Feb 2007 16:46:31 -0600
Message-ID: <45E211C7.7020800@monkeysushi.net>
References: <45D89FF5.3020303@sauce.co.nz> <200702252057.22963.a1426z@gawab.com> <Pine.LNX.4.64.0702251256060.21918@coffee.psychology.mcmaster.ca> <200702260007.10205.a1426z@gawab.com> <Pine.LNX.4.64.0702251643250.21918@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702251643250.21918@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Mark Hahn wrote:
| if a discrete resistor has a 1e9 hour MTBF, 1k of them are 1e6

That's not actually true.  As a (contrived) example, consider two cases.

Case 1: failures occur at constant rate from hours 0 through 2e9.
Case 2: failures occur at constant rate from 1e9-10 hours through 1e9+10 hours.

Clearly in the former case, over 1000 components there will almost certainly be
a failure by 1e8 hours.  In the latter case, there will not be.  Yet both have
the same MTTF.


MTTF says nothing about the shape of the failure curve.  It indicates only where
its midpoint is.  To compute the MTTF of 1000 devices, you'll need to know the
probability distribution of failures over time of those 1000 devices, which can
be computed from the distribution of failures over time for a single device.
But, although MTTF is derived from this distribution, you cannot reconstruct the
distribution knowing only MTTF.  In fact, the recent papers on disk failure
indicate that common assumptions about the shape of that distribution (either a
bathtub curve, or increasing failures due to wear-out after 3ish years) do not hold.

- -Ben
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF4hHHcsocGMHJ2H8RCqPfAKCYYlcOTW3OKGyJlYdXIRq802US+ACfTaBG
ZzVJSUNyU/htda/JCxWvc4A=
=DouE
-----END PGP SIGNATURE-----
