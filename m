From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: new raid system for home use
Date: Mon, 19 Apr 2004 18:16:57 +0900
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40839909.9080606@tequila.co.jp>
References: <Pine.LNX.4.44.0404181411130.21013-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0404181411130.21013-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Paul Phillips <paulp@improving.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Mark Hahn wrote:

| EVMS is afflicted by featuritis, IMO, compared to LVM.  but why do you
| think you need it?  volume managers are for people who want to divide
| their storage into little chunks, and then experience the bofhish
grandeur
| of requiring the lusers to beg for more space.

There is no need for any kind of LVM unless you start with a small set
of HDs and may need to extend it later without moving data around on
partitions etc.
for bofhish behavior there is quota ;)

|>  * I'm probably failing to consider the five most important factors...
|
|
| the only really important factor is that disks should be 3+ year
warrantee.
| hw raid is fine if you like that kind of thing, and want the security of
| paying more for slower performance, but the privilege of waiting on hold
| at a telephone support number.

it always depends WHAT kind of HW raid you are talking about. The thing
you get in HP/Compaq DL boxes or the "HW raid" you get with promise, etc
low level controllers. Of course if you want to get raid in that area
software raid is more easy and cheap and faster, but I think in the
upper area hardware raid has some other advantages, eg easy boot from
raid 5, transparency to the OS layer (no 5 mds because you want
partitions, no patches because you want to make md partitions, etc).
100% sure and easy hotswap ...

- --
Clemens Schwaighofer - IT Engineer & System Administration
==========================================================
TEQUILA\Japan, 6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN
Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343
http://www.tequila.co.jp
==========================================================
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAg5kIjBz/yQjBxz8RAsliAJ9NDA7i463cZFD8TTYNs/HrltLdcACfdehd
UmkB+VGTNInQqSiUSvPFUVc=
=Z312
-----END PGP SIGNATURE-----
