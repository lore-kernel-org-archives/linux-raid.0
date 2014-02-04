From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Tue, 04 Feb 2014 15:16:36 -0500
Message-ID: <52F14AA4.9020402@ubuntu.com>
References: <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com> <52EABA63.2060701@ubuntu.com> <52ED77A3.6020509@hardwarefreak.com> <52EE9445.2020202@ubuntu.com> <52EF3865.4000106@hardwarefreak.com> <52EFAACE.40906@ubuntu.com> <52F05ECD.5060804@hardwarefreak.com> <52F12A93.50408@SGI.com> <52F12CA0.1030803@ubuntu.com> <52F134D3.20704@hardwarefreak.com> <52F13795.50408@ubuntu.com> <52F13C66.9030200@hardw
 arefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F13C66.9030200@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, Larry Fenske <LFenske@SGI.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/4/2014 2:15 PM, Stan Hoeppner wrote:
> I never argued that the buffer cache path is slower.  It is in fact
> much faster in most cases.
> 
> I argued that accurately measuring the actual data throughput at
> the disks isn't possible when writing through buffer cache.  At
> least not in a straightforward manner as with O_DIRECT.  I've made
> the point in the last two or three replies.  Yet instead of
> directly addressing that, rebutting that, you keep making these
> tangential irrelevant arguments...

You originally said "To significantly increase single streaming
throughput you need AIO."  Now you appear to be saying otherwise.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS8UqkAAoJEI5FoCIzSKrwIMYH/AvTA9Z1+SGarMym9hy1DPis
czb3W4+MVeisH2QwyfTbMPkicOw4pffa3Hc9ZLLI0yvGnU8b6XbFvG+2sWYBtqhj
HQX1Osjy0ZP7GuVU5TtydbNNXba4f+iIm6FIpzX3eseAjZgBJeDeG2s0oePw8q/d
b+P0PAZSqA99CNNpqOw7GTnYZqh++SM9CYPmr7KC4LYFyaqklj3eS0XQPDT+rbej
K1ly2ZibE348Nol/A6gT63x6WnuMFj4jAUK40O//farqbjsDTJgWaz9x0aV58c6x
Uxsrzx9a92tZC5AL0BW6dqLeY0BMZ3j9hqF/51nz5MrGtzm7qninrsSp1hJJRuM=
=Ls3I
-----END PGP SIGNATURE-----
