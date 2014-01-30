From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Thu, 30 Jan 2014 15:36:01 -0500
Message-ID: <52EAB7B1.8090007@ubuntu.com>
References: <20140122174854.GF26014@merlins.org> <52E051A3.3050103@hardwarefreak.com> <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E1F685.3050300@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/24/2014 12:13 AM, Stan Hoeppner wrote:
> The initial resync is read-only.  It won't modify anything unless 
> there's a discrepancy.  So the stripe cache isn't in play.  The
> larger stripe cache should indeed increase rebuild rate though.

What?  That makes no sense.  It doesn't really take any longer to
write the parity than to read it, and the odds are pretty good that it
is going to need to write it anyhow, so doing a read first would waste
a *lot* of time.  I think you are thinking of when you manually issue
a check_repair on the array after it is fully initialized.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS6rexAAoJEI5FoCIzSKrwm8sIAJ93OT39nxYau3//33skn0lW
XOT0z+EyBvAMBHMz4x36GJilHsd9gNwRLSETHu3sSTFve+0hkTWPRfLFt+OMkX2S
30hZnVWh+fd02enTE3uw6kaCcuU709hKDwCUOf1wQhm3bUeJGIOTRrkqnGtKpncR
9qxENIdhcRrMIkh1F1dmJOZvehlGc6doa1ddodM8QfSESlQtTu8N9nyxAbVtLf5S
lGebMF+dsf3DEK1UXn7RUus8IE28DifWQnMlfUPtI7u2A50cjADQh9mu1moJdDdo
HVgz/Y5sveYq5KfRMco4cNVGQiyR3t1LYmZQFTcAcCUqbQ6PctXp3pCEfogLYTw=
=zlqj
-----END PGP SIGNATURE-----
