From: David Greaves <david@dgreaves.com>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sun, 01 Aug 2004 20:28:04 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <410D4444.8000302@dgreaves.com>
References: <Pine.LNX.4.44.0408011723330.7382-100000@uplift.swm.pp.se> <1091383022.11789.17.camel@tinny.home.foo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1091383022.11789.17.camel@tinny.home.foo>
To: "Scott T. Smith" <scott@gelatinous.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Jim Buttafuoco <jim@contactbda.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Scott T. Smith wrote:
| On Sun, 2004-08-01 at 08:24, Mikael Abrahamsson wrote:
|
|>On Sun, 1 Aug 2004, Jim Buttafuoco wrote:
|>
|>
|>>I am switching all of my 3ware controllers over to Adaptec SATA raid
|>>controllers.  I am getting better performance with them.  Jim
|>
|>I am quite curious about the 16port SATA controller Adaptec has now. Do
|>you have any filesystem write figures for this controller under linux and
|>ext3?
|
|
| One main problem with the 16port controller, at least in JBOD mode, is
| that there is not enough PCI bandwidth to fill the disks if you do large
| writes.  Thus two separate 8port controllers, on separate PCI busses,
| should yield higher performance.
|
| OTOH, if you're doing small ops, or RAID1, it will probably be fine.
|
| (disclaimer -- I haven't tried the Adaptec boards yet, but they're on my
| list, along with Highpoint's)
|
| 	Scott

Highpoint have a multi port PCI-X card out (but no open drivers support it)
Are there any others multi-sata PCI-X cards?

I'm thinking about building a 2Tb SW RAID but will wait a few months
because I want PCI-X or similar to get the bandwidth to the gigabit card.

David
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFBDURE8LvjTle4P1gRApWbAJ0f5UHlMUsxkx36qSbk59Ak1Vj/cwCcD5hw
AruxO8CSNAM+4ixZioKYfQA=
=cYtx
-----END PGP SIGNATURE-----
