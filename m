From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Tue, 04 Feb 2014 13:55:17 -0500
Message-ID: <52F13795.50408@ubuntu.com>
References: <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com> <52EABA63.2060701@ubuntu.com> <52ED77A3.6020509@hardwarefreak.com> <52EE9445.2020202@ubuntu.com> <52EF3865.4000106@hardwarefreak.com> <52EFAACE.40906@ubuntu.com> <52F05ECD.5060804@hardwarefreak.com> <52F12A93.50408@SGI.com> <52F12CA0.1030803@ubuntu.com> <52F134D3.20704@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F134D3.20704@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, Larry Fenske <LFenske@SGI.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/4/2014 1:43 PM, Stan Hoeppner wrote:
> Everything we've been discussing has been about maximizing write 
> throughput.  The fact that you argue this at this point makes it
> crystal clear that you don't have no understanding of the
> differences in the read/write paths and how buffer cache affects
> each differently.  Further discussion is thus pointless.

I am intimately familiar with the two code paths, having written
several applications using them, studied the kernel code extensively,
and been one of the original strong advocates for the kernel to grow
direct aio apis in the first place, since it worked swimmingly well on
WinNT.

So I say again: switching to direct aio, while saving a decent chunk
of cpu time, makes very little difference in streaming write
throughput.  If it did, there would be something terribly broken with
the buffer cache if it couldn't keep the disk queues full.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS8TeVAAoJEI5FoCIzSKrwMJ0IAJB3+mGIVXJ+qMCHwSGjFI7G
dNJp8/0NFdy42Eww1Yu3EOBRPim4sDxmRE6bqRX9Ytbb5jqnlr22c/fjcUmqH3wr
fO7qqj2T6FiaFgrudFNukCAqRiCWTS3nkxzrAs5HV1PBukJtAXugQEBYEtHcVZ7l
EoeTu16N70RMnywK0vbHx7Gqx9AOps9xe6qyStN7KptgGbkX/b0OkDLRjSedLput
qQNyLA8/kuoGfVvswSzKqneK/CC0GAdbdQt0rP0hC3Icsh2qKQZLdsAwKgL3L0f6
zyALvUBvuRSD6ZQW8VdNI+i4BCyeYSCwZT/5pPXI5AtRZtIUkymQkZtW7cjNKpM=
=ILJS
-----END PGP SIGNATURE-----
